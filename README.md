# DeepMD Workflow Test for Li–O Oxide Systems

This directory contains a small end-to-end workflow test for generating and deploying a DeepMD interatomic potential using short QE AIMD trajectories.

## Tested structures

To reduce computational cost and quickly validate the workflow, three small oxide structures were used instead of LLZO:

- `Li2O_mp-1960.poscar`
- `Li2O_mp-13725.poscar`
- `Li3PO4.poscar`

The original LLZO AIMD calculations were found to be too computationally expensive for rapid testing because the system contains 192 atoms and each AIMD step requires a full DFT SCF calculation.

---

# Important folders

## `structure/`

Contains initial crystal structures downloaded from Materials Project.

## `qe_inputs_by_structure/`

Automatically generated QE AIMD input files for each structure and its perturbed configurations.

## `deepmd_dataset/`

Converted DeepMD training dataset generated from QE AIMD trajectories.

Each subfolder corresponds to one system.

## `checkpoint/`

Saved DeepMD training checkpoints.

## `tmp/`

Temporary QE output directory.

---

# Important files

## `input.json`

DeepMD training input file.

Defines:

- descriptor type (`se_e2_a`)
- cutoff radius
- neural-network size
- learning-rate schedule
- training systems

## `frozen_model.pb`

Final frozen DeepMD model used for LAMMPS deployment.

## `lcurve.out`

Training-loss history generated during DeepMD training.

Used to monitor model convergence.

## `detail.e.out`

Detailed DFT vs DeepMD energy predictions from `dp test`.

## `detail.f.out`

Detailed DFT vs DeepMD force predictions from `dp test`.

Used for parity plots.

## `md_test.in`

LAMMPS input script for testing the DeepMD model.

## `traj_li2o_300K.lammpstrj`

LAMMPS trajectory generated during the 2 ps NVT simulation.

## `log.lammps`

LAMMPS simulation log file containing thermo output.

## `aimd_workflow.ipynb`

Notebook containing:

- dataset extraction
- DeepMD training analysis
- parity plots
- LAMMPS result visualisation

---

# Workflow summary

The workflow used in this test is:

```text
Materials Project structures
→ QE short AIMD
→ frame extraction
→ DeepMD dataset generation
→ DeepMD training
→ dp test
→ LAMMPS deployment
→ short MD simulation