clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
materials_dir = fullfile(script_dir,'materials');

load(fullfile(script_dir,'Gradient_0828.mat'));
modular = load(fullfile(materials_dir,'network7_1000parcel.txt'));
index = modular(:,2);
% 1£¬DAN;2,FPN;3,DMN;4,VN;5,LN;6,SMN;7,SN

for sub = 1 : 62
    for grad = 1 : 3
        t_grad(sub,:,grad) = gm_task.aligned{sub}(:,grad);
        c_grad(sub,:,grad) = gm_ctrl.aligned{sub}(:,grad);
        r_grad(sub,:,grad) = gm_rest.aligned{sub}(:,grad);
    end
end

for sub = 1 : 62
    for nn = 1 : 7
        NC_rest(nn,:) = reshape(mean(r_grad(sub,find(index==nn),:)),[1,3]);
        NC_ctrl(nn,:) = reshape(mean(c_grad(sub,find(index==nn),:)),[1,3]);
        NC_task(nn,:) = reshape(mean(t_grad(sub,find(index==nn),:)),[1,3]);

    end
    for ii = 1 : length(index)
        WD_restpre(sub,ii) = pdist2(reshape(r_grad(sub,ii,:),[1,3]),NC_rest(index(ii),:),'euclidean');
        WD_ctrlpre(sub,ii) = pdist2(reshape(c_grad(sub,ii,:),[1,3]),NC_ctrl(index(ii),:),'euclidean');
        WD_taskpre(sub,ii) = pdist2(reshape(t_grad(sub,ii,:),[1,3]),NC_task(index(ii),:),'euclidean');
    end

    for nn = 1 : length(unique(index))
        WD_rest(sub,nn) = mean(WD_restpre(sub,find(index == nn)));
        WD_ctrl(sub,nn) = mean(WD_ctrlpre(sub,find(index == nn)));
        WD_task(sub,nn) = mean(WD_taskpre(sub,find(index == nn)));
    end
end

save(fullfile(script_dir,'WD0828.mat'),'WD_rest','WD_ctrl','WD_task');