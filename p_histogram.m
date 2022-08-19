%% Model VS IGE
 
colorplot1  = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0]./255;

if G==1
    pS = 1; pC = 0;
    Ndis_norm=sum(discharge_bin_norm(K1,:),1)./sum(sum(discharge_bin_norm(K1,:),1));
else
    pS = 0; pC = 1;
    Ndis_norm=sum(discharge_bin_norm(K2,:),1)./sum(sum(discharge_bin_norm(K2,:),1));
end

Ndis_smooth =smoothdata(Ndis_norm,'gaussian',5);

figure; set(gcf,'color','w');
hold on
fname = strcat('results/histo_eeg_network',num2str(net),'_B_',num2str(beta),'_lamB_',num2str(lamB),'_alpha',num2str(alpha),'_rS',num2str(rS),'_rC',num2str(rC),'_tau',num2str(tau),'_pS',num2str(pS),'_pC',num2str(pC),'.mat'); load(fname);
N_bin_norm=sum(N_bin_norm,2)./sum(sum(N_bin_norm,2));   N_smooth =smoothdata(N_bin_norm,'gaussian',5);
b11=bar(N_bin_norm,.9,'FaceColor',colorplot1(3,:),'EdgeColor',colorplot1(3,:));
b11.FaceAlpha = 0.6;
plot(N_smooth,'LineWidth',1,'Color',colorplot1(3,:))
b12=bar(Ndis_norm,.9,'FaceColor',colorplot1(2,:),'EdgeColor',colorplot1(2,:));
b12.FaceAlpha = 0.6;
plot(Ndis_smooth,'LineWidth',1,'Color',colorplot1(2,:))
ylabel('Normalised ED Rate','Interpreter','LaTeX');  ylim([0 .15]);
xlabel('Clock Time (hour)','Interpreter','LaTeX');
xlim([0.5 24.5]); xticks([0:3:24]+0.5);xticklabels(mod(16:3:16+24,24));
title(strcat('Group ', num2str(G)));
box on

set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(gca, 'FontName', 'Times')

legend([b11 b12], {'Model', 'IGE'},'Orientation','vertical','FontSize',7,'Interpreter','LaTeX','Box','off')
