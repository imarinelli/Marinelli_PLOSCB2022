function [T,X,E1, E2, dW,dXdT] = ben(A,alpha,x0,t0,lamB,dt,Tdur,beta,lamE_cort,lamE_sleep,node,tau)

coder.inline('never')

n        = length(A);                                                       % Number of nodes A: Adjacency Matrix
Tsample  = 10;                                                              % Number of samples you write away
N        = Tdur/dt;                                                         % Number of time-steps
aux      = 1;                                                               % Counter for solution vector
dW       = sqrt(dt)*randn(N,3*n);                                        % Brownian increments
Nsol     = N/Tsample;                                                       % Number of solutions you will write away
X        = nan(Nsol,length(x0));                                            % Preallocate solution vector
T        = nan(Nsol,1);                                                     % Preallocate time vector
E1        = nan(Nsol,1);                                                     % Preallocate kick vector
E2        = nan(Nsol,1);
dXdT     = nan(Nsol,3*n);

for j=1:N
    [dxdt]     = ben_sde(A,x0,beta,lamB,lamE_cort(j), lamE_sleep(j),node,tau);                         % Approximation of differences in timestep
    x0         = x0 + dt.*dxdt + alpha.*dW(j,:)';                           % Approximation of solution to differential equations
    t0         = t0 + dt;                                                   % Update time
    if(mod(j,Tsample) == 0)                                                 % Only save value in vector if matches Tsample
        X(aux,:) = x0;                                                      % Fill arrays of the final solution vector
        T(aux)   = t0;                                                      % Match time-vector
        E1(aux)   = lamE_cort(j);                                                    % Match kick-vector
        E2(aux)   = lamE_sleep(j);
        dXdT(aux,:) = dxdt';
        aux      = aux+1;                                                   % Update vector-counter

    end
end
end