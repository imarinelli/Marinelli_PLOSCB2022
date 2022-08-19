if G == 1
    Ndis=sum(discharge_bin_norm(K1,:),1);
else
    Ndis=sum(discharge_bin_norm(K2,:),1);
end

Ndis_smooth=smoothdata(Ndis,'gaussian',5);
frac=0:0.1:1.5;

Nfrac=length(frac);


for i=1:n
    par=parameter(i,:);

    err_name = strcat('results/errors_network',num2str(net),'_lamB_',num2str(par(1)),'_alpha',num2str(par(2)),'_rS',num2str(par(3)),'_rC',num2str(par(4)),'_tau',num2str(tau),'_norm_diff_value_K',num2str(G),'.mat');

    R2 = NaN.*ones(Nfrac,Nfrac);
    RSS = NaN.*ones(Nfrac,Nfrac);
    error = NaN.*ones(Nfrac,Nfrac);
    error_L2 = NaN.*ones(Nfrac,Nfrac);


    for jS=1:Nfrac
        pS = frac(jS);
        for jC=1:Nfrac
            pC = frac(jC);

            fname = strcat('results/histo_eeg_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(par(1)),'_alpha',num2str(par(2)),'_rS',num2str(par(3)),'_rC',num2str(par(4)),'_tau',num2str(tau),'_pS',num2str(pS),'_pC',num2str(pC),'.mat');
            if exist(fname, 'file')
                load(fname)

                N_bin_norm=sum(N_bin_norm,2);
                N_bin_norm_smooth =smoothdata(N_bin_norm,'gaussian',5);


                diff=Ndis_smooth'-N_bin_norm_smooth;   error(jS,jC)=sqrt(sum(diff.^2));
                diff_L2=Ndis'-N_bin_norm;              error_L2(jS,jC)=sqrt(sum(diff_L2.^2));

                estimations = N_bin_norm_smooth;         observations = Ndis_smooth';
                RSS(jS,jC)= sum((observations-estimations).^2);

                ybar = sum(observations)/length(observations);
                TSS =  sum((observations-ybar).^2);
                R2(jS,jC) = 1-RSS(jS,jC)./TSS;

                gridC(jS,jC) = frac(jC); gridS(jS,jC) = frac(jS);
            end
        end
    end
    save(err_name, 'error','error_L2', 'RSS', 'R2', 'frac', 'gridS', 'gridC');

end
