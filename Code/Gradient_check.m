clear;
clc;


script_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(script_dir);
fc_dir = fullfile(project_dir, 'Functional_connectivity');

rotation_data = load(fullfile(fc_dir, 'FC_rotation.mat'), 'Z');
t_mats = rotation_data.Z;

control_data = load(fullfile(fc_dir, 'FC_control.mat'), 'Z');
c_mats = control_data.Z;

rest_data = load(fullfile(fc_dir, 'FC_rest.mat'), 'Z');
r_mats = rest_data.Z;

t_mats(find(isnan(t_mats)==1)) = 0; 
c_mats(find(isnan(c_mats)==1)) = 0;
r_mats(find(isnan(r_mats)==1)) = 0; 


t_temp = mean(t_mats,3); 
c_temp = mean(c_mats,3); 
r_temp = mean(r_mats,3); 

temp_all = (r_temp + t_temp + c_temp)./3;

for sub = 1 : 62
    t_sub{sub} = t_mats(:,:,sub);
    r_sub{sub} = r_mats(:,:,sub);
    c_sub{sub} = c_mats(:,:,sub);
end

sparsity = 90;
gm_ref = GradientMaps('kernel','na','approach','dm','alignment','pa','random_state',42,'n_components',10);
gm_ref = gm_ref.fit(temp_all,'sparsity',sparsity,'alpha',0.5,'diffusion_time',0,'niterations',10);

gm_rest = GradientMaps('kernel','na','approach','dm','alignment','pa','random_state',42,'n_components',10);
gm_rest = gm_rest.fit(r_sub,'sparsity',sparsity,'alpha',0.5,'diffusion_time',0,'niterations',10,'reference',gm_ref.gradients{1});

gm_ctrl = GradientMaps('kernel','na','approach','dm', 'alignment','pa','random_state',42,'n_components',10);
gm_ctrl = gm_ctrl.fit(c_sub,'sparsity',sparsity,'alpha',0.5,'diffusion_time',0,'niterations',10,'reference',gm_ref.gradients{1});

gm_task = GradientMaps('kernel','na','approach','dm','alignment','pa','random_state',42,'n_components',10);
gm_task = gm_task.fit(t_sub,'sparsity',sparsity,'alpha',0.5,'diffusion_time',0,'niterations',10,'reference',gm_ref.gradients{1});

save(fullfile(script_dir, 'Gradient_0828.mat'), 'gm_rest', 'gm_task', 'gm_ctrl', 'gm_ref');