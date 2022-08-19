function DefLamESleep(hour,N,sample, Nbin,G)


t=0:N*hour; lamE_sleep1=[];

if sample>42
    if  G == 0
        s = [1:42 randperm(42,42) randperm(42,sample-2*42)]; % length(Scored)=42
    else
        s = [1:42 randperm(42,sample-42)]; % length(Scored)=42
    end
else
    s = randperm(42,sample); % length(Scored)=42
end

for i = 1:length(s)
    lamE_sleep=[];
    
    fn = strcat('data/sleep/Control_', num2str(s(i)), '.mat');
    load(fn);
    
    a=find(S<0,1); S=S(a:end); T=T(a:end)-T(a); % removing the initial W time. The sleep onset is not T=0 but T=a
    Tsec=60*T; % T is in min
    t_data = 0:1:Tsec(end); % t_data=interval of 1 sec
    S(S==-1)=0.5; % N1
    S(S==-2)=1; % N2
    S(S==-3)=1; % N3
    S(S==-4)=0; % R
    
    sleep = interp1(Tsec,S,t_data); %sec
    
    x_data=zeros(hour*60*60,1); x_data(1:length(sleep))=sleep;
    t_data1 = 0:length(x_data)-1; % sec in 24 hours
    t_data1=hour*N*t_data1./max(t_data1);
    
    l = interp1(t_data1,x_data,t);    l=l(:)';
    
    % shift l to match the sleep onset
    On_v(i) = On;     Off_v(i) = Off;
    
    if On>16
        x=find(abs(t./1e6-(24-On))<1e-3,1);
        l1 = [l((x+1):end) l(1:x) ];
    else
        x=find(abs(t./1e6-On)<1e-3,1);
        l1 = [l((end-x):end) l(1:(end-x-1)) ];
    end
    
    lamE_sleep = round(l1,3);
    
    idx = [16*N:24*N 1:16*N-1];
    lamE_sleep = lamE_sleep(idx);
    
    fname = strcat('Lambda/K',num2str(G),'_',num2str(Nbin),'/iteration_sleep/lamE_sleep_',num2str(i),'.mat');
    save(fname, 'lamE_sleep' , 'On_v','Off_v', '-v7.3');
    
    
end


end