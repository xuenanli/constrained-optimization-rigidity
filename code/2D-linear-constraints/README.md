# Planar framework with midpoint constraints

Figure 4 uses a twelve-vertex framework with an outer square, an inner quadrilateral, and four bars connecting them. Each connecting bar starts at a point constrained to remain the midpoint of an outer edge. The driver varies the length of the bar joining vertices 5 and 9 while preserving the other bar lengths, the four midpoint relationships, and the two pinned vertices.

## Run the example

Open this folder as the MATLAB current folder and run `driver_opt_finite`. The driver uses Symbolic Math Toolbox, figure graphics, and `VideoWriter` with the MPEG-4 profile. The geometry is constructed in MATLAB.

The default `square_linear_pert_inner.m` fixes the initial outer square and randomly perturbs the four inner vertices. Set the random seed before running for repeatable initial coordinates, for example with `rng(1)`. To select a different starting geometry in the driver, use `square_linear.m` for a symmetric inner square or `square_linear_pert.m` to perturb both the outer and inner geometry.

The driver minimizes the squared length of edge 4 with all four midpoint weights set to one half, as in Figure 4. To start from the geometry in panel (a), replace the four random inner-vertex assignments in `square_linear_pert_inner.m` with the following initial coordinates, in vertex order.

```matlab
inner = [2.308842379100790  1.017186226635085
         2.701681937872478  1.851539632548029
         1.787683653336003  3.470091444800409
         0.876879623706621  2.149615356740797];
x(17:24) = reshape(inner.', [], 1);
```

## Helpers and local outputs

`formconstraints_bonds.m` assembles the bar constraints. `rigidity_matrix_linear.m` adds two scalar rows for each midpoint relationship. The driver uses singular value decomposition to compute flexes and a self-stress, draws the two nontrivial flex directions with `plot_null_vec_framework.m`, and samples the stress quadratic form over combinations of those directions. The driver draws a basis orthogonal to rigid-body motions. Figure 4(c–d) draws a basis with the first two vertices pinned, so the arrows can differ.

The driver writes `square-midpoint-min.mp4`, `init-framework.mat`, and `final-framework.mat` in the MATLAB current folder. It also displays the configurations and objective history.
