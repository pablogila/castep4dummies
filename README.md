# CASTEP

[CASTEP](http://www.castep.org/) is a [[DFT]] software.
The developers work in [[SCARF]], so it is usually updated there.
To use it in [[Atlas]] we have to send an email to support asking them to install it, saying that our group has a license (It is convenient to put Pelayo from CC in that mail, who was the one who gave them the license). We would have to send them in the same mail the installation files, which are in the group Shared.

CASTEP has two main ways of calculating the phonon frequencies/modes: **Density-Functional Perturbation Theory (DFPT)** and **Finite-Displacement (FD)**.
There are different strategies depending on the problem:
- Primitive cell FD at Γ point
- Supercell FD for any Q (using traditional, like phonopy, or non-diagonal with Fourier interpolation schemes)
- DFPT on MP grid of Q with Fourier interpolation to arbitrary fine set of Q 

CASTEP takes advantage of the space-group symmetries of the crystal to compute:
- ONLY symmetry-independent elements of the dynamical matrix
- Q-points needed in the 1st Brillouin zone for interpolation
- Electronic k-points...

Keywords that are GENERALLY reasonable:
``` castep
grid_scale :   1.75
fine_grid_scale :    4.0
finite_basis_corr :   2
mixing_scheme : Pulay
mix_charge_amp :        0.500000000000000
mix_charge_gmax :        1.500000000000000
mix_history_length :       20
relativistic_treatment : Koelling-Harmon
fixed_npw : false
WRITE_CELL_STRUCTURE : true  # Outputs a cell file with optimized geometry, to avoid copying it from geom...
WRITE_CIF_STRUCTURE : true
```

GEOMETRY OPTIMIZATION: 
A high-precision geometry optimization is required.
If coordinates are not converged with forces close to zero, phonons will have imaginary frequencies.
The above requires a high level of convergence of the following quantities:
    1. Plane wave cutoff (usually the larger the better, but can be worth to check)
    2. SCF convergence (elec_energy_tol in the geo opt should be at least phonon_energy_tol^2 [Kacper/Pelayo: 1e-12 and 1e-6 respectively and max_scf_cycles 100]. CRITICAL IN DFPT)
    3. Brillouin-zone sampling (under-convergence gives poor acoustic mode dispersion as q->0; user finer grids for FD method)
    4. Free energy per atom (Kacper/Pelayo: 1e-10 eV/atom)
    5. Ionic forces (Kacper/Pelayo: 1e-5 eV/A)
    6. Ionic displacement (Kacper/Pelayo: 5e-6 A)
    7. Stress (Kacper/Pelayo: 2.5e-3 GPa)
The convergence of each parameter must be determined by systematically variating each quantity. 
The values of Kacper/Pelayo are optimal for perovskites, but other systems may require further job.
Helpful Keywords:
geom_max_iter :  9999
geom_method :  lbfgs


PHONON CALCULATIONS:
    - DFPT (in .param): 
    task = phonon
    phonon_method = dfpt    (DEFAULT VALUE) 
    phonon_max_cycles = ....    ()   
    Fourier interpolation (in .param): 
        phonon_fine_method = interpolate
        phonon_kpoint_mp_grid p q r
        ALWAYS INCLUDE Γ: phonon_fine_kpoint_mp_offset 1/2p 1/2q 1/2r    for even phonon_kpoint_mp_grid parameters
        phonon_fine_kpoint_path        to specify Q-path in the .cell file 
        [alternative to choosing specific set of Q] kpoints_mp_spacing ....    to specify the density of Brillouin-zone sampling 
        phonon_force_constant_cutoff      lower than max-box-dimension/2
    - FD (in .param):
    phonon_method = finite_displacement
    phonon_fine_method = interpolation
    phonon_kpoint_mp_grid p q r (CASTEP WILL PRODUCE THE SUPERCELL, NO NEED TO PROVIDE IT FOR GEO OPT)
    phonon_force_constant_cutoff   < min(p*L1,q*L2,r*L3), where Lx are the lengths of the simulation box specified in .cell
    - FD SUPERCELL (in .param):
    phonon_method = finite_displacement
    phonon_fine_method : supercell
    - FD SUPERCELL (in .cell):
    supercell_kpoint_list
Helpful Keywords:
calculate_stress : true
popn_calculate : false    #population analysis on the final ground state
phonon_sum_rule_method : reciprocal  #check that the acoustic sum rule for phonons is valid
phonon_calc_lo_to_splitting : true
born_charge_sum_rule : true
phonon_energy_tol : sqrt(elec_energy_tol of geomopt)
efield_max_cycles : 250
phonon_max_cycles : 100
bs_max_iter : 250       #Max iterations to compute band-structure
bs_max_cg_steps : 25     #Number of conjugate gradient steps taken for each electronic band in the electronic minimizer before resetting to the steepest descent direction, during a band structure calculation
bs_eigenvalue_tol : 1.0e-9
[add to .cell the following] 
%BLOCK EXTERNAL_PRESSURE
    0.0001013000    0.0000000000    0.0000000000
                    0.0001013000    0.0000000000
                                    0.0001013000
%ENDBLOCK EXTERNAL_PRESSURE


ALWAYS SAVE PARTIAL CALCULATIONS IN .check BY SETTING IN .param:
num_backup_iter n     (backup every n Q-vectors)
backup_interval t     (backup every t seconds)







## CASTEP inputs
[CASTEP cell keywords and data blocks](https://www.tcm.phy.cam.ac.uk/castep/documentation/WebHelp/content/modules/castep/keywords/k_main_structure.htm)
[The CASTEP Pseudopotential Library](https://www.ccpnc.ac.uk/pspot-site/)

### CELL file
- `SPECIES_LCAO_STATES`: If Iodine is (Kr) 4d10 5s2 5p5 then it has value 3, etc.


## Workflow

module load gcc
venv
pip install cif2cell


TEST
af
s

fsadgadjhvhkgdfsahgv
l
