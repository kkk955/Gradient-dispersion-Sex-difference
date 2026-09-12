# Functional Connectivity Gradient and Dispersion Analyses

## Overview

This repository contains de-identified, participant-level derived data, MATLAB analysis scripts, and precomputed support vector machine (SVM) outputs for analyses of functional connectivity gradients and dispersion across rest, control, and mental-rotation conditions.

The shared package contains data from 62 participants. Participant identifiers are de-identified study codes and are not accompanied by an identity lookup table. The package does not contain raw MRI or DICOM data.

## Repository structure

```text
.
|-- Behavior_data/
|   `-- Behavior_data.xlsx
|-- Code/
|   |-- Gradient_check.m
|   |-- Explained_variance_plot_gradients.m
|   |-- Global_dispersion.m
|   |-- Within_network_dispersion.m
|   |-- Between_network_dispersion.m
|   `-- materials/
|-- Dispersion matrices/
|-- Functional_connectivity/
|-- SVM/
|-- README.md
`-- .gitignore
```

## Data

### Behavioral data

`Behavior_data/Behavior_data.xlsx` contains one row per participant and includes:

- de-identified subject code;
- sex and age;
- accuracy, reaction time, and performance measures for the control and rotation conditions;
- intelligence and animal-span measures.

### Functional connectivity

`Functional_connectivity/` contains three MATLAB files:

- `FC_rest.mat`
- `FC_control.mat`
- `FC_rotation.mat`

Each file contains a double-precision variable named `Z` with dimensions `1000 x 1000 x 62` (parcel x parcel x participant). `network7_1000parcel.txt` provides the seven-network assignment of the 1,000 parcels.

### Dispersion matrices

`Dispersion matrices/` contains participant-level derived measures:

- `Global_dispersion.xlsx`
- `Within_network_dispersion.xlsx`
- `Between_network_dispersion.xlsx`
- `Between_network_pair_dispersion.xlsx`

Network abbreviations are DAN (dorsal attention), FPN (frontoparietal), DMN (default mode), VN (visual), LN (limbic), SMN (somatomotor), and SN (salience).

### SVM data and results

`SVM/` contains five analyses:

- `Rest`
- `Control`
- `Rotation`
- `Change_rest_control`
- `Change_rest_rotation`

Each analysis directory contains the feature, label, fold, mask, participant-level MAT files, and precomputed output files under `Result/`. Standalone MVPANI configuration files are included where supplied; `SVM/Rotation` does not include a standalone `SVM_rotation.mat` configuration file.

Where present, the saved MVPANI configuration files and the `MvpaResults.mat` files retain historical absolute paths beginning with `D:\student\...`. These paths are provenance from the computer on which the analyses were originally run; they are not credentials or participant information. They do not alter the stored numerical results, but the configurations are not directly portable. To rerun an SVM analysis on another computer, create or open a compatible configuration in MVPANI, select the local participant inputs, `Fold.xlsx`, `Label.xlsx`, `mask.mat`, and output directory, and then save a new local configuration.

## MATLAB code

The scripts in `Code/` locate their inputs relative to the script location, so MATLAB's current working directory does not need to be the repository root.

- `Gradient_check.m` loads the three functional-connectivity matrices, constructs the group reference gradient, aligns participant-level gradients, and saves `Code/Gradient_0828.mat`.
- `Explained_variance_plot_gradients.m` reads `Gradient_0828.mat` and plots the first three group-level gradients on the supplied cortical surfaces.
- `Global_dispersion.m` calculates participant-level global dispersion and saves `Code/GlobDisp0828.mat`.
- `Within_network_dispersion.m` calculates within-network dispersion and saves `Code/WD0828.mat`.
- `Between_network_dispersion.m` calculates between-network dispersion and saves `Code/BD0828.mat`.

The generated MAT files above are local intermediate outputs and are excluded by `.gitignore` to avoid duplicating derived results accidentally. The corresponding participant-level dispersion tables are included under `Dispersion matrices/`.

## Dependencies

The gradient and dispersion scripts require:

- MATLAB;
- BrainSpace for MATLAB (`GradientMaps`, surface conversion, and cortical plotting functions);
- MATLAB Statistics and Machine Learning Toolbox (`pdist2` and related statistical functions);
- a MATLAB installation providing `sumsqr` for the explained-variance calculation (commonly supplied by Deep Learning Toolbox, depending on MATLAB release).

The SVM workflow additionally requires:

- MVPANI;
- LIBSVM and any other dependencies required by the installed MVPANI release.

Exact MATLAB and toolbox versions used for the original analysis were not recorded in this package. Add the required toolboxes to the MATLAB path before running the scripts.

## Analysis workflow

1. Clone or download the complete repository, including the Git LFS files described below.
2. Add BrainSpace and the required MATLAB toolboxes to the MATLAB path.
3. Run `Code/Gradient_check.m` to generate `Code/Gradient_0828.mat`.
4. Run the dispersion scripts as needed:
   - `Code/Global_dispersion.m`
   - `Code/Within_network_dispersion.m`
   - `Code/Between_network_dispersion.m`
5. Run `Code/Explained_variance_plot_gradients.m` to visualize the first three group gradients.
6. For SVM reproduction, follow the local-path instructions in the SVM section above and run the analyses through MVPANI.

The gradient analysis uses `random_state = 42`. The scripts analyze 62 participants and retain the original analysis parameters.

## Large files and Git LFS

Each functional-connectivity MAT file is approximately 450 MB and exceeds GitHub's 100 MB limit for ordinary Git objects. These files must be committed with [Git Large File Storage (Git LFS)](https://git-lfs.com/) or hosted in an external research-data repository.

Before the first commit, the repository owner should run:

```bash
git lfs install
git lfs track "Functional_connectivity/*.mat"
git add .gitattributes
```

Then add and commit the remaining repository files normally. Do not use GitHub's browser uploader for this package, because the large MAT files exceed its upload limits.

## Reproduction notes

- The included functional-connectivity matrices and tabular data are derived data; raw neuroimaging data are not included.
- The MATLAB scripts use paths relative to their own location.
- Precomputed SVM outputs are included, but exact SVM reruns require updating the historical MVPANI paths and using compatible MVPANI/LIBSVM versions.
- No statistical model, participant-inclusion rule, analysis threshold, or data value was changed during repository preparation.

## Data availability

The repository includes the de-identified derived data needed for the analyses represented here. The study codes are fully separated from participant identities, and no re-identification key is included.

## Code availability

MATLAB source code for the gradient, visualization, and dispersion analyses is included under `Code/`. SVM conversion scripts, configurations, inputs, and precomputed outputs are included under `SVM/`.

## Citation

If you use these data or scripts, please cite the associated manuscript. The complete citation should be added here when the manuscript bibliographic information is finalized.

## License

No explicit reuse license is currently included. In the absence of a license, default copyright applies; please contact the copyright holder before copying, modifying, or redistributing the code or data.
