# notes

This folder is mainly for testing the QE AIMD → DeepMD → LAMMPS workflow.

I first tried to use LLZO, but `Li7La3Zr2O12` has 192 atoms, so QE AIMD was too slow for quick testing. To save time, I used three smaller structures instead:

- `structure/Li2O_mp-1960.poscar`
- `structure/Li2O_mp-13725.poscar`
- `structure/Li3PO4.poscar`

`qe_inputs_by_structure/` contains the QE AIMD input files generated from these structures, including the original and perturbed structures.

`deepmd_dataset/` contains the converted DeepMD datasets.

`input.json` is the DeepMD training input.

`lcurve.out` is the DeepMD training loss file.

`frozen_model.pb` is the final frozen DeepMD model.

`detail.e.out` and `detail.f.out` are from `dp test`, used for energy and force parity plots.

`md_test.in` is the LAMMPS test input.

`Li2O_mp-1960.data` is the LAMMPS data file converted from the POSCAR.

`log.lammps` is the LAMMPS output log.

`traj_li2o_300K.lammpstrj` is the short LAMMPS trajectory from the DeepMD test run.

`aimd_workflow.ipynb` contains the main notebook for checking the workflow and plotting results.

This is only a quick workflow test, not a final production DeepMD potential.
