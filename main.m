% Load lambda_extCORT and lambda_extSleep
DefLamECORT(hour,N,sample, Nbin,G, mu, sigma);
DefLamESleep(hour,N,sample, Nbin,G);


% Run the simulation over a grid of values of pS and pC
for i=1:n
    par=parameter(i,:);
    for pS=0:0.1:1.5
        for pC=0:0.1:1.5
            fhisto = strcat('results/histo_eeg_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(par(1)),'_alpha',num2str(par(2)),'_rS',num2str(par(3)),'_rC',num2str(par(4)),'_tau',num2str(tau),'_pS',num2str(pS),'_pC',num2str(pC),'.mat');
            if ~isfile(fhisto)
                parfor iter=1:sample
                    compute(par(1), par(2), net, par(3), par(4), Tdur, dt, N, beta,node, hour, tau,iter,pS,pC, Nbin, G);
                end
                distribution_histo(par, net,node,sample,tau,beta,pS,pC)
                fname = strcat('results/sim_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(par(1)),'_alpha',num2str(par(2)),'_rS',num2str(par(3)),'_rC',num2str(par(4)),'_tau',num2str(tau),'_',num2str(node),'_pS',num2str(pS),'_pC',num2str(pC),'_*.mat');
                delete(fname)
            end
        end
    end
end

delete(gcp('nocreate'))
