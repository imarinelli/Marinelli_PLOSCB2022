function DefLamECORT(hour,N,sample, Nbin,G, mu, sigma)

l = []; X = [];
y=NaN.*ones(sample, 145);
t=0:N*hour;


KNN = 3;

for sub=1:6
    f_name = strcat('data/CORT/','sub',num2str(sub),'_data.mat'); load(f_name);
    y(sub,:) =  x_data;
    
    l = [l; x_data'];
end


X = smote(l, 1.5, KNN);
X = X(7:end,:);

while  size(X,1)<sample
    X1 = smote(l, 1.5, KNN);
    X = [X; X1(7:end,:)];
end

s = randperm(size(X,1),sample-6);
X = [l; X(s,:)];


t1=hour*N*t_data./max(t_data);

lamE_CORT=NaN.*ones(sample, length(t));


for i=1:sample
    
    lamE_CORT(i,:) = interp1(t1,X(i,:),t);
    lamE_cort = round(lamE_CORT(i,:),3);
    
    delay = round(normrnd(mu,sigma)/60*1e6);
    lamE_cort = lamE_cort([end-delay:end 1:end-delay-1]);
    
    fname1 = strcat('Lambda/K',num2str(G),'_',num2str(Nbin),'/iteration_CORT/lamE_CORT_',num2str(i),'.mat');
    save(fname1, 'lamE_cort' , 'X', '-v7.3');
end


