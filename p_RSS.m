%% RSS values
 
colorplot1  = [228,26,28; 55,126,184; 77,175,74; 152,78,163; 255,127,0]./255;


fname = strcat('results/errors_network',num2str(net),'_lamB_',num2str(lamB),'_alpha',num2str(alpha),'_rS',num2str(rS),'_rC',num2str(rC),'_tau',num2str(tau),'_norm_diff_value_K',num2str(G),'.mat');
load(fname);


fig = figure; 
set(gcf,'color','w');

[fracS, fracC] = meshgrid(0:.01:1.5, 0:.01:1.5);

RSS = griddata(frac,frac,RSS,fracS,fracC);
s = surf(fracS, fracC, RSS');
s.EdgeColor = 'none';

xlabel('$p_{\rm S}$','Interpreter','LaTeX'); % xticks(frac);
ylabel('$p_{\rm C}$','Interpreter','LaTeX'); % yticks(frac);
zlabel('$RSS$','Interpreter','LaTeX');
title(strcat('Group ', num2str(G)));

xlim([-0.05 1.55]); ylim([-0.05 1.55]);	zlim([0 100])
v = [-2 1 1];
[caz,cel] = view(v);
set(gca, 'FontName', 'Times')
box on



set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(gca, 'FontName', 'Times')


h = axes(fig,'visible','off'); 
c = colorbar(h,'Position',[0.93 0.168 0.022 0.7]);  % attach colorbar to h
caxis([0,100]);             % set colorbar limits
c.FontSize = 7;
c.Label.String = '$RSS$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 7;
c.Label.Position = [2.3 50 0]; 

