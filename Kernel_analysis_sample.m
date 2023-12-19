%% kernel regression

% convert time
Glu_v = reshape(M_Plot',1,[]);
TS_new = [];
for i = 1:size(DeltaF,1)
    TS_new(i) = 3001 + 12000*(i-1);
end

cd('/Users/data/Glu_inputs')
load('opto', 'DA_mean', 'Glu_mean'); %Load DS/Glu response to optogenetic activation

figure
plot(DA_mean)
hold on
plot(Glu_mean)
legend('DA','Glu')
title('optogenetic')

down = 20; 
kI = 200; % between kernel

basic = Glu_mean(1000:4500); 
basic_down = basic(1:down:end);
% figure
% plot(down*(0:(kW/down)),basic)
% hold on
% plot(down*(0:(kW/down))+kI,basic)
% plot(down*(0:(kW/down))+2*kI,basic)
% xlabel('ms')

%odor2 to odor1 to water
%odor4 to odor1 to water
%odor4 to odor3 to nothing
%odor5 to odor3 to nothing
%odor1 to water
%odor3 to nothing
%free water 

Glu_v_down = Glu_v(1:down:end);

TS_all = TS_new; %all trial start
TS_all = ceil(TS_all/down);

Trial_number_cum = cumsum(Trial_number);

TS_odor1_odorA_water = TS_all(1:7:end);
TS_odor2_odorA_water = TS_all(2:7:end);
TS_odor2_odorB_nothing = TS_all(3:7:end);
TS_odor3_odorB_nothing = TS_all(4:7:end);
TS_noOdor_odorA_water = TS_all(5:7:end);
TS_noOdor_odorB_nothing = TS_all(6:7:end);
TS_predicted_water = TS_all([1:7:end,2:7:end,5:7:end]);
TS_free_water = TS_all(7:7:end);

X_odor1_odorA_water = [];
N_odor1_odorA_water = 5000/kI; % number to tile the window(ms)
for i = 1:N_odor1_odorA_water
% for i = 1:2
t_odor1_odorA_water = zeros(size(Glu_v_down));
t_odor1_odorA_water(TS_odor1_odorA_water+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor1_odorA_water,basic_down);
X_odor1_odorA_water(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_odor2_odorA_water = [];
N_odor2_odorA_water = 5000/kI; % number to tile the window(ms)
for i = 1:N_odor1_odorA_water
% for i = 1:2
t_odor2_odorA_water = zeros(size(Glu_v_down));
t_odor2_odorA_water(TS_odor2_odorA_water+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor2_odorA_water,basic_down);
X_odor2_odorA_water(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_odor2_odorB_nothing = [];
N_odor2_odorB_nothing = 5000/kI; % number to tile the window(ms)
for i = 1:N_odor2_odorB_nothing
% for i = 1:2
t_odor2_odorB_nothing = zeros(size(Glu_v_down));
t_odor2_odorB_nothing(TS_odor2_odorB_nothing+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor2_odorB_nothing,basic_down);
X_odor2_odorB_nothing(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_odor3_odorB_nothing = [];
N_odor3_odorB_nothing = 5000/kI; % number to tile the window(ms)
for i = 1:N_odor3_odorB_nothing
% for i = 1:2
t_odor3_odorB_nothing = zeros(size(Glu_v_down));
t_odor3_odorB_nothing(TS_odor3_odorB_nothing+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor3_odorB_nothing,basic_down);
X_odor3_odorB_nothing(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_noOdor_odorA_water = [];
N_noOdor_odorA_water = 2000/kI; % number to tile the window(ms)
for i = 1:N_noOdor_odorA_water
% for i = 1:2
t_noOdor_odorA_water = zeros(size(Glu_v_down));
t_noOdor_odorA_water(TS_noOdor_odorA_water+3000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_noOdor_odorA_water,basic_down);
X_noOdor_odorA_water(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_noOdor_odorB_nothing = [];
N_noOdor_odorB_nothing = 2000/kI; % number to tile the window(ms)
for i = 1:N_noOdor_odorA_water
% for i = 1:2
t_noOdor_odorB_nothing = zeros(size(Glu_v_down));
t_noOdor_odorB_nothing(TS_noOdor_odorB_nothing+3000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_noOdor_odorB_nothing,basic_down);
X_noOdor_odorB_nothing(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_predicted_water = [];
N_predicted_water = 4000/kI; % number to tile the window(ms)
for i = 1:N_predicted_water
% for i = 1:2
t_predicted_water = zeros(size(Glu_v_down));
t_predicted_water(TS_predicted_water+5000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_predicted_water,basic_down);
X_predicted_water(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_free_water = [];
N_free_water = 4000/kI; % number to tile the window(ms)
for i = 1:N_free_water
% for i = 1:2
t_free_water = zeros(size(Glu_v_down));
t_free_water(TS_free_water+5000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_free_water,basic_down);
X_free_water(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_combined = [];

X_combined = [X_odor1_odorA_water',X_odor2_odorA_water',X_odor2_odorB_nothing',...
    X_odor3_odorB_nothing',X_noOdor_odorA_water',X_noOdor_odorB_nothing',X_free_water']; 


%% fitting
   
delete(gcp('nocreate'))   
[B,FitInfo] = lasso(X_combined,Glu_v_down,'alpha',0.75,'cv',10,'Options',statset('UseParallel',true),'Intercept',false); %cross validation 10
idxLambda1SE = FitInfo.Index1SE;
coef = B(:,idxLambda1SE);
% coef0 = FitInfo.Intercept(idxLambda1SE);
% beta = [coef0;coef] %%%

%% plot regression results

% GCaMP_predict = beta'.*[ones(size(X_combined,1),1),X_combined];
GCaMP_predict = coef'.* X_combined;
GCaMP_predict_sum = sum(GCaMP_predict');

null_dev = var(Glu_v_down);
residual_dev = var(Glu_v_down - GCaMP_predict_sum);
explained_dev = 100 - 100*residual_dev/null_dev;

Glu_down = reshape(Glu_v_down,[],size(M_Plot,1));
Glu_down = Glu_down';
Mean_Glu_odor1_odorA_water = mean(Glu_down(1:6:end,1:450));

h(1)=figure;
subplot(1,2,1)
plot(Mean_Glu_odor1_odorA_water,'r')
hold on
plot(GCaMP_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'b')
ylabel(explained_dev)
legend('actual Glu','Glu fitting')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,2,2)
plot(GCaMP_predict((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350),:))
hold on
plot(GCaMP_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'k')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

cd(animalfolder);
savefig(h(1),'Glu_kernels')

h(2)=figure;
subplot(1,3,1)
plot(GCaMP_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'b')
hold on
plot(GCaMP_predict_sum((TS_odor2_odorA_water(1)-100):(TS_odor2_odorA_water(1)+350)),'c')
plot(GCaMP_predict_sum((TS_odor3_odorB_nothing(1)-100):(TS_odor3_odorB_nothing(1)+350)),'r')
legend('100% water cue','50% water cue','nothing cue')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
plot(GCaMP_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'b')
hold on
plot(GCaMP_predict_sum((TS_odor2_odorA_water(1)-100):(TS_odor2_odorA_water(1)+350)),'c')
plot(GCaMP_predict_sum((TS_noOdor_odorA_water(1)-100):(TS_noOdor_odorA_water(1)+350)),'g')
legend('100% predicted odorA','50% predicted odorA','unpredicted odorA')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
plot(GCaMP_predict_sum((TS_odor2_odorB_nothing(1)-100):(TS_odor2_odorB_nothing(1)+350)),'b')
hold on
plot(GCaMP_predict_sum((TS_odor3_odorB_nothing(1)-100):(TS_odor3_odorB_nothing(1)+350)),'c')
legend('50% predicted odorB','100% predicted odorB')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

savefig(h(2),'Glu fitting')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% translate into dopamine signals from glu kernels

DA_kernel = DA_mean(1000:4500);
DA_kernel_down = DA_kernel(1:down:end);

X_odor1_odorA_water_DA = [];
for i = 1:N_odor1_odorA_water
t_odor1_odorA_water = zeros(size(Glu_v_down));
t_odor1_odorA_water(TS_odor1_odorA_water+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor1_odorA_water,DA_kernel_down);
X_odor1_odorA_water_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_odor2_odorA_water_DA = [];
for i = 1:N_odor1_odorA_water
t_odor2_odorA_water = zeros(size(Glu_v_down));
t_odor2_odorA_water(TS_odor2_odorA_water+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor2_odorA_water,DA_kernel_down);
X_odor2_odorA_water_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_odor2_odorB_nothing_DA = [];
for i = 1:N_odor2_odorB_nothing
t_odor2_odorB_nothing = zeros(size(Glu_v_down));
t_odor2_odorB_nothing(TS_odor2_odorB_nothing+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor2_odorB_nothing,DA_kernel_down);
X_odor2_odorB_nothing_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_odor3_odorB_nothing_DA = [];
for i = 1:N_odor3_odorB_nothing
t_odor3_odorB_nothing = zeros(size(Glu_v_down));
t_odor3_odorB_nothing(TS_odor3_odorB_nothing+(i-1)*kI/down)=1;
X_odor_this = conv(t_odor3_odorB_nothing,DA_kernel_down);
X_odor3_odorB_nothing_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_noOdor_odorA_water_DA = [];
for i = 1:N_noOdor_odorA_water
t_noOdor_odorA_water = zeros(size(Glu_v_down));
t_noOdor_odorA_water(TS_noOdor_odorA_water+3000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_noOdor_odorA_water,DA_kernel_down);
X_noOdor_odorA_water_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_noOdor_odorB_nothing_DA = [];
for i = 1:N_noOdor_odorA_water
t_noOdor_odorB_nothing = zeros(size(Glu_v_down));
t_noOdor_odorB_nothing(TS_noOdor_odorB_nothing+3000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_noOdor_odorB_nothing,DA_kernel_down);
X_noOdor_odorB_nothing_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_free_water_DA = [];
for i = 1:N_free_water
t_free_water = zeros(size(Glu_v_down));
t_free_water(TS_free_water+5000/down+(i-1)*kI/down)=1;
X_odor_this = conv(t_free_water,DA_kernel_down);
X_free_water_DA(i,:) = X_odor_this(1:length(Glu_v_down));
end

X_combined_DA = [];

X_combined_DA = [X_odor1_odorA_water_DA',X_odor2_odorA_water_DA',X_odor2_odorB_nothing_DA',...
    X_odor3_odorB_nothing_DA',X_noOdor_odorA_water_DA',X_noOdor_odorB_nothing_DA',X_free_water_DA']; 

DA_predict = coef'.* X_combined_DA;
DA_predict_sum = sum(DA_predict');
DA_predict_free_water = sum(DA_predict(:,(end-N_free_water+1):end)'); 

h(3)=figure;
plot(DA_predict((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350),:))
hold on
plot(DA_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'k')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

savefig(h(3),'DA_kernels')

h(4)=figure;
subplot(1,3,1)
plot(DA_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'b')
hold on
plot(DA_predict_sum((TS_odor2_odorA_water(1)-100):(TS_odor2_odorA_water(1)+350)),'c')
plot(DA_predict_sum((TS_odor3_odorB_nothing(1)-100):(TS_odor3_odorB_nothing(1)+350)),'r')
legend('100% water cue','50% water cue','nothing cue')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
plot(DA_predict_sum((TS_odor1_odorA_water(1)-100):(TS_odor1_odorA_water(1)+350)),'b')
hold on
plot(DA_predict_sum((TS_odor2_odorA_water(1)-100):(TS_odor2_odorA_water(1)+350)),'c')
plot(DA_predict_sum((TS_noOdor_odorA_water(1)-100):(TS_noOdor_odorA_water(1)+350)),'g')
legend('100% predicted odorA','50% predicted odorA','unpredicted odorA')
title('DA prediction by Glu')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
plot(DA_predict_sum((TS_odor2_odorB_nothing(1)-100):(TS_odor2_odorB_nothing(1)+350)),'b')
hold on
plot(DA_predict_sum((TS_odor3_odorB_nothing(1)-100):(TS_odor3_odorB_nothing(1)+350)),'c')
legend('50% predicted odorB','100% predicted odorB')
title('DA prediction by Glu')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

savefig(h(4),'Glu contribution')

%% make matrix of DA sensor minus Glu sensor data

DA_v = reshape(M_Plot_DA',1,[]);
DA_v_down = DA_v(1:down:end);

% p2 = glmfit(DA_predict_sum,DA_v_down,'normal','Constant','off');
p2 = glmfit(DA_predict_free_water,DA_v_down,'normal','Constant','off'); %fitting with free water responses
y2 = p2*DA_predict_sum;
diff_DA_Glu = DA_v_down - y2;

null_dev = var(DA_v_down);
residual_dev = var(diff_DA_Glu');
explained_dev = 100 - 100*residual_dev/null_dev;

DA_down = reshape(DA_v_down,[],size(M_Plot_DA,1));
DA_down = DA_down';
y2_predict = reshape(y2,[],size(M_Plot_DA,1));
y2_predict = y2_predict';
diff_DA_Glu = reshape(diff_DA_Glu,[],size(M_Plot_DA,1));
diff_DA_Glu = diff_DA_Glu';

Mean_DA_odor1_odorA_water = mean(DA_down(1:7:end,1:450));

Mean_predict_odor1_odorA_water = mean(y2_predict(1:7:end,1:450));

Mean_diff_odor1_odorA_water = mean(diff_DA_Glu(1:7:end,1:450));
Mean_diff_odor2_odorA_water = mean(diff_DA_Glu(2:7:end,1:450));
Mean_diff_odor2_odorB_nothing = mean(diff_DA_Glu(3:7:end,1:450));
Mean_diff_odor3_odorB_nothing = mean(diff_DA_Glu(4:7:end,1:450));
Mean_diff_noOdor_odorA_water = mean(diff_DA_Glu(5:7:end,1:450));
Mean_diff_noOdodr_odorB_nothing = mean(diff_DA_Glu(6:7:end,1:450));
Mean_diff_free_water = mean(diff_DA_Glu(7:7:end,1:450));

h(5)=figure;
plot(Mean_DA_odor1_odorA_water,'b')
hold on
plot(Mean_predict_odor1_odorA_water,'k')
ylabel(explained_dev)
legend('actual DA','DA prediction with Glu')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

savefig(h(5),'DA_actual_predicted')

h(6)=figure;
subplot(1,3,1)
plot(Mean_diff_odor1_odorA_water,'b')
hold on
plot(Mean_diff_odor2_odorA_water,'c')
plot(Mean_diff_odor3_odorB_nothing,'r')
legend('100% water cue','50% water cue','nothing cue')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
plot(Mean_diff_odor1_odorA_water,'b')
hold on
plot(Mean_diff_odor2_odorA_water,'c')
plot(Mean_diff_noOdor_odorA_water,'g')
legend('100% predicted odorA','50% predicted odorA','unpredicted odorA')
title('residual')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
plot(Mean_diff_odor2_odorB_nothing,'b')
hold on
plot(Mean_diff_odor3_odorB_nothing,'c')
legend('50% predicted odorB','100% predicted odorB')
title('residual')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

savefig(h(6),'diff_Glu_DA')

% save('Glu_DA_kernel_221011','Glu_v_down','DA_v_down','coef','DA_predict_sum','GCaMP_predict_sum','diff_DA_Glu','explained_dev') %kernel 1-4.5
