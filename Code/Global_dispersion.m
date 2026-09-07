clear;
clc;

script_dir = fileparts(mfilename('fullpath'));

load(fullfile(script_dir,'Gradient_0828.mat'));

for sub = 1 : 62
    for grad = 1 : 3
        t_grad(sub,:,grad) = gm_task.aligned{sub}(:,grad);
        c_grad(sub,:,grad) = gm_ctrl.aligned{sub}(:,grad);
        r_grad(sub,:,grad) = gm_rest.aligned{sub}(:,grad);
    end
end

for sub = 1 : 62
    for grad = 1 : 3
        glob_center_rest(1,grad) = mean(r_grad(sub,:,grad));
        glob_center_ctrl(1,grad) = mean(c_grad(sub,:,grad));
        glob_center_task(1,grad) = mean(t_grad(sub,:,grad));
    end
    for regions = 1 : 1000
        GD_rest(sub,regions) = pdist2(reshape(r_grad(sub,regions,:),[1,3]),glob_center_rest,'euclidean');
        GD_ctrl(sub,regions) = pdist2(reshape(c_grad(sub,regions,:),[1,3]),glob_center_ctrl,'euclidean');
        GD_task(sub,regions) = pdist2(reshape(t_grad(sub,regions,:),[1,3]),glob_center_task,'euclidean');
    end
    
    GD_allrest(sub,:) = mean(GD_rest(sub,:));
    GD_allctrl(sub,:) = mean(GD_ctrl(sub,:));
    GD_alltask(sub,:) = mean(GD_task(sub,:));
end
save(fullfile(script_dir,'GlobDisp0828.mat'),'GD_allrest','GD_allctrl','GD_alltask');