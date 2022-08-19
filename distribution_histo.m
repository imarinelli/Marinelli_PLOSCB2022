function [] = distribution_histo(par, net,node,iter,tau,beta,pS, pC)


m=length(par);
dis_matrix=nan(m+4+2,iter);
dis_bin=[]; dis_bin_G=[]; dis_bin_F=[];
N_bin_norm = ones(24, iter);
N_bin = ones(24, iter);

D_matrix=[]; % iter, time, node1, node2, node3, node4

file_name = strcat('results/histo_eeg_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(par(1)),'_alpha',num2str(par(2)),'_rS',num2str(par(3)),'_rC',num2str(par(4)),'_tau',num2str(tau),'_pS',num2str(pS),'_pC',num2str(pC),'.mat');

for j=1:iter

    fname = strcat('results/sim_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(par(1)),'_alpha',num2str(par(2)),'_rS',num2str(par(3)),'_rC',num2str(par(4)),'_tau',num2str(tau),'_',num2str(node),'_pS',num2str(pS),'_pC',num2str(pC),'_',num2str(j),'.mat');
    load(fname)

    dis1=dis1./1e5; dis2=dis2./1e5; dis3=dis3./1e5; dis4=dis4./1e5;
    [No,loc]=max([length(dis1) length(dis2) length(dis3) length(dis4)]); % # max of discharges and which node: check whether they are suizure (G or F)


    node_sel = ['dis',num2str(loc)]; node_sel=eval(node_sel); nodes=1:4; nodes(loc)=[];
    D=ones(length(node_sel),4);

    for ix=1:length(node_sel) % checking each discharge in node_sel
        for ix_n=nodes
            nodes_aux = ['dis',num2str(ix_n)]; nodes_aux=eval(nodes_aux);

            In = find(abs(node_sel(ix).*ones(length(nodes_aux),1)-nodes_aux)<0.05);
            if isempty(In) % there is no close event in nodes_aux at the same time as in nodes_sel
                D(ix,ix_n)=0;
            end
        end

    end
    D_G=find(sum(D,2)==4); % generalized seizures
    D_F=find(sum(D,2)>=2 & sum(D,2)<4); % focal seizures

    x1=floor(node_sel);


    for k=0:23
        dis_matrix(1:m,j)=[par(1) par(2) par(3) par(4)];
        dis_matrix(m+1:m+4,j)=[length(dis1) length(dis2) length(dis3) length(dis4)];
        dis_matrix(m+4+1+k,j)= sum(x1(D_G)==k); dis_matrix(m+4+2+k,j)= sum(x1(D_F)==k);
    end
    dis_bin=[dis_bin; x1]; dis_bin_G=[dis_bin_G; x1(D_G)]; dis_bin_F=[dis_bin_F; x1(D_F)];
    D_matrix=[D_matrix; [j*ones(length(node_sel),1), node_sel, D]];

    for h=1:24
        a=length(find(x1==h-1));
        N_bin_norm(h,j) = a./length(x1);
        N_bin(h,j) = a;
    end

    save(file_name,'dis_matrix','dis_bin','dis_bin_G','dis_bin_F','D_matrix', 'N_bin_norm',  'N_bin', 'T','E1','E2','-v7.3');

end

end
