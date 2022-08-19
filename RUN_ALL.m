close all; clear all; clc;

% Load the model parametes and create a table
def_parameter
parameter=WriteTable(lamB, alpha,rS, rC); n=size(parameter,1);


% Load data
load(strcat('data/EEG/Discharges_', num2str(Nbin), '.mat'));
load(strcat('data/EEG/clusters_', num2str(Nbin), '.mat'));
idx = [17:24 1:16]; discharge_bin_norm = discharge_bin_norm(:,idx);


% Select the group
G = 2;

if G==1
    sample=length(K1);
else
    sample=length(K2);
end


% Model simulation for group G
main


% Compute RSS and R2
compute_err


% Plots
p_histogram
p_RSS




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         Functions                                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function parameter=WriteTable(lamB, alpha, ampS, ampC)

nlamB=length(lamB); nalpha=length(alpha);	nampS=length(ampS); nampC=length(ampC);
parameter=zeros(nlamB*nalpha*nampS*nampC,4);

aux1=[]; aux2=[]; aux3=[];

parameter(:,4)=repmat(ampC,1,nlamB*nalpha*nampS);

for i=1:nampS
    aux1=[aux1 repmat(ampS(i),1,nampC)];
end
parameter(:,3)=repmat(aux1,1,nalpha*nlamB);

for i=1:nalpha
    aux2=[aux2 repmat(alpha(i),1,nampS*nampC)];
end
parameter(:,2)=repmat(aux2,1,nlamB);

for i=1:nlamB
    aux3=[aux3 repmat(lamB(i),1,nalpha*nampS*nampC)];
end
parameter(:,1)=aux3;

end


