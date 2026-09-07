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


for sub = 1: 62
 for nn = 1 : 7 
        NC_rest(nn,:) = mean(r_grad(sub,find(index==nn),:));
        NC_ctrl(nn,:) = mean(c_grad(sub,find(index==nn),:));
        NC_task(nn,:) = mean(t_grad(sub,find(index==nn),:));
 end 
 
        for mm = 1 : length(unique(index))
            for nn = 1 : length(unique(index))
                if mm ~= nn
                    BD_restpre(sub,mm,nn) = pdist2(NC_rest(mm,:),NC_rest(nn,:),'euclidean');
                    BD_ctrlpre(sub,mm,nn) = pdist2(NC_ctrl(mm,:),NC_ctrl(nn,:),'euclidean');
                    BD_taskpre(sub,mm,nn) = pdist2(NC_task(mm,:),NC_task(nn,:),'euclidean');
                else
                    BD_restpre(sub,mm,nn) = 0;
                    BD_ctrlpre(sub,mm,nn) = 0;
                    BD_taskpre(sub,mm,nn) = 0;
                end
            end
        BD_rest(sub,mm) =sum(BD_restpre(sub,mm,:))/6;
        BD_ctrl(sub,mm) =sum(BD_ctrlpre(sub,mm,:))/6;
        BD_task(sub,mm) =sum(BD_taskpre(sub,mm,:))/6;
        end  
end
save(fullfile(script_dir,'BD0828.mat'),'BD_restpre','BD_ctrlpre','BD_taskpre','BD_rest','BD_ctrl','BD_task');