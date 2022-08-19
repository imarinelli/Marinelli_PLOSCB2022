function compute(lamB, alpha, net, rS, rC,Tdur,dt, N, beta,node, hour,tau,iteration, pS, pC, Nbin, G)

fname = strcat('results/sim_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(lamB),'_alpha',num2str(alpha),'_rS',num2str(rS),'_rC',num2str(rC),'_tau',num2str(tau),'_',num2str(node),'_pS',num2str(pS),'_pC',num2str(pC),'_',num2str(iteration),'.mat');
load(strcat('Lambda/K',num2str(G),'_',num2str(Nbin),'/iteration_CORT/lamE_CORT_',num2str(iteration),'.mat')); 
load(strcat('Lambda/K',num2str(G),'_',num2str(Nbin),'/iteration_sleep/lamE_sleep_',num2str(iteration),'.mat')); 



iter=0; T=0; X=[]; E1=[]; E2=[]; dXdT=[];
A=network_def(net);
n = length(A);
% rng('default'); rng(50);

x0              = 0.001*rand(3*n,1);        % Initial state (3*n: x [n] real parts, y [n] imag parts, lam [n] parts
x0(2*n+1:end)   = x0(2*n+1:end)+lamB;       % Initial condition for lambda
t0              = 0;                        % Initial starting time
lamE_sleep = pS*rS.*lamE_sleep;
lamE_cort = pC*rC*lamE_cort;


while iter<hour
    lamE_sleep_part=lamE_sleep(iter*N+1:iter*N+N); lamE_cort_part=lamE_cort(iter*N+1:iter*N+N);
    [T1,X1,E1B, E2B, dW,dXdT1] = ben(A,alpha,x0,t0,lamB,dt,Tdur,beta,lamE_cort_part,lamE_sleep_part,node,tau);            % Run simulation (solve SDEs) for given adjacency matrix and parameters
    x0=X1(end,:)'; T=[T; T1+T(end)]; X=[X; X1]; dXdT=[dXdT; dXdT1]; E1=[E1; E1B]; E2=[E2; E2B];
    iter=iter+1;
end

x      = X(:,1:n);                      % all real parts
y      = X(:,n+1:2*n);                  % all imaginary parts
r      = x.^2+y.^2;

[pks, dis1] = findpeaks(r(:,1),'MinPeakProminence',0.5,'MinPeakDistance',1e4);
[pks, dis2] = findpeaks(r(:,2),'MinPeakProminence',0.5,'MinPeakDistance',1e4);
[pks, dis3] = findpeaks(r(:,3),'MinPeakProminence',0.5,'MinPeakDistance',1e4);
[pks, dis4] = findpeaks(r(:,4),'MinPeakProminence',0.5,'MinPeakDistance',1e4);


T=T(1:size(X,1));
save(fname,'A','T','X','E1','E2','alpha','lamB','dis1','dis2','dis3','dis4', 'dXdT', '-v7.3');
clear X T E