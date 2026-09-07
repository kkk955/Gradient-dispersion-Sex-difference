clear;
clc;

script_dir = fileparts(mfilename('fullpath'));
materials_dir = fullfile(script_dir,'materials');

% group template
load(fullfile(script_dir, 'Gradient_0828.mat'), 'gm_ref');
curr = gm_ref.lambda{1,1};
for i = 1: length(curr)
    a3(i,1) = curr(i)*curr(i) / sumsqr(curr);
end

%plot


surf_lh = convert_surface(fullfile(materials_dir,'lh.pial'));
surf_rh = convert_surface(fullfile(materials_dir,'rh.pial')); 

lab_lh = load(fullfile(materials_dir,'labeling_lh.txt'));
label_lh = lab_lh(:,2);
lab_rh = load(fullfile(materials_dir,'labeling_rh.txt'));
label_rh = lab_rh(:,2);
label_rh(label_rh > 0) = label_rh(label_rh > 0) + 500;
labeling = cat(1,label_lh,label_rh);

plot_hemispheres(zscore((-1)*gm_ref.gradients{1}(:,1)), {surf_lh,surf_rh}, ...
'parcellation',labeling);
plot_hemispheres(zscore((-1)*gm_ref.gradients{1}(:,2)), {surf_lh,surf_rh}, ...
'parcellation',labeling);
plot_hemispheres(zscore(gm_ref.gradients{1}(:,3)), {surf_lh,surf_rh}, ...
'parcellation',labeling);