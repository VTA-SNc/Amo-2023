%%regression for each individual

%average the response in 1 sec time window    
RwRes_40_ind =mean(type_11_GCaMP2(4201:5200,:),1);
RwRes_80_ind =mean(type_9_GCaMP2(4201:5200,:),1);
RwRes_0_ind =mean(type_14_GCaMP2(4201:5200,:),1);
RwRes_free_ind =mean(type_1_GCaMP2(1201:2200,:),1);
RwRes_free_ind_mean = mean(RwRes_free_ind);

RwOd_40_ind =mean(type_C_GCaMP2(1001:2000,:),1);
RwOd_80_ind =mean(type_A_GCaMP2(1001:2000,:),1);
RwOd_0_ind =mean(type_14_GCaMP2(1001:2000,:),1);
RwOd_80_ind_mean = mean(RwOd_80_ind);

temp1=ones(1,length(RwRes_80_ind));
temp2=ones(1,length(RwRes_40_ind));
temp3=ones(1,length(RwRes_0_ind));
temp4=ones(1,length(RwRes_free_ind));

temp7=ones(1,length(RwOd_80_ind));
temp8=ones(1,length(RwOd_40_ind));
temp9=ones(1,length(RwOd_0_ind));


figure('Color', [1 1 1]);
subplot(1,2,1)
%Reward response 
x = [80*temp1 40*temp2 0*temp4];     
y = [RwRes_80_ind/RwRes_free_ind_mean RwRes_40_ind/RwRes_free_ind_mean RwRes_free_ind/RwRes_free_ind_mean]; % normalized responses
[beta_a,dev_a,stats_a] = glmfit(x,y)

% Plot the fitted line
X = [80 40 0];
Y = glmval(beta_a,X,'identity');
C=[0.7 0.7 0.7];

plot(X,Y,'Color',C, 'LineWidth', 4); hold on
h=plot(x,y,'o','Color',C,'MarkerSize',4,'LineWidth', 1); hold on
h=gca;
h.XTick = 0:40:80;
h.XTickLabel = {['0%'];['40%']; ['80%']};
xlim([-5 85])
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))

xlabel('Reward expectation')
ylabel('Normalized response')
set(gca,'FontSize',20)
set(gcf,'color','w')


subplot(1,2,2)
%Reward predicting odor response 
x = [0*temp9 40*temp8 80*temp7];     
y = [RwOd_0_ind/RwOd_80_ind_mean RwOd_40_ind/RwOd_80_ind_mean RwOd_80_ind/RwOd_80_ind_mean]; % peak from odor onset
%beta = nlinfit(x,y,@exponentialf,beta0);
[beta_a,dev_a,stats_a] = glmfit(x,y)

% Plot the fitted line
X = [0 40 80];
Y = glmval(beta_a,X,'identity');
C=[0.7 0.7 0.7];

plot(X,Y,'Color',C, 'LineWidth', 4); hold on
h=plot(x,y,'o','Color',C,'MarkerSize',4,'LineWidth', 1); hold on
h=gca;
h.XTick = 0:40:80;
h.XTickLabel = {['0%'];['40%']; ['80%']};
xlim([-5 85])
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))

xlabel('Reward expectation')
ylabel('Normalized response')
set(gca,'FontSize',20)
set(gcf,'color','w')
