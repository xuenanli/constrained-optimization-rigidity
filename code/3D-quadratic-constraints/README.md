# 3D frameworks with fixed bar lengths

Figure 3 optimizes one bar length in each of two sphere packings. The remaining bars retain their lengths, and three vertices forming a triangle are pinned. `driver_3d_optimal.m` takes a gradient step in the squared length of the free bar, then uses a Newton iteration to restore the constraints.

| Figure | Packing | Free bar | Objective | Row of `E` in the driver |
| --- | --- | --- | --- | --- |
| 3(a–c) | 9 spheres, case 1 | Vertices 3 and 7 | Maximize | 7 |
| 3(d–f) | 10 spheres, case 6 | Vertices 1 and 3 | Minimize | 1 |

## Read the initial packings

Use MATLAB with this folder as your current folder. Download the **N=6–10** archive under **All coordinates**, extract `n9.txt` and `n10.txt`, and place them in the current folder. Each row is one packing. The data are from Miranda Holmes-Cerfon, *Enumerating rigid sphere packings* (2016). [Sphere packing data](https://personal.math.ubc.ca/~holmescerfon/packings.html)

```matlab
framework9 = spacking_9(1);
framework10 = spacking_10(6);
```

The constructors recover bar connectivity from unit-distance contacts. The perturbed constructors retain those contacts and move only the unpinned vertices.

## Run an optimization

The driver requires Symbolic Math Toolbox, figure windows, and MATLAB's MPEG-4 video writer. Set `packing_size` at the top of `driver_3d_optimal.m` to `9` (default) or `10`, then run the driver.

```matlab
driver_3d_optimal
```

For the selected case, the driver sets the free bar, optimization direction, and output names from the table above. If the current folder contains `init-framework-9-1.mat` or `init-framework-10-6.mat` for that case, it uses the saved `framework` variable. Otherwise, it reads the catalog and saves a new initial state using a Gaussian perturbation with standard deviation 0.2 and random seed 0. The exact Figure 3 initial states are archived separately. A new perturbation can converge to different coordinates.

The driver writes the final framework, selected edge, and MP4 animation to the current folder. It preserves the saved initial state. Repeating a case replaces that case’s final MAT files and MP4. At convergence, the driver reports numerical stress diagnostics if it detects one self-stress. For ten spheres, the reported range samples the stress on 1,000 unit flex directions.

## Inspect the results

`data_analyaze_9.m` (original spelling) and `data_analyze_10.m` inspect the original packing, then load the corresponding initial and final snapshots. The scripts plot the geometry, report rigidity-matrix singular values, and check for coplanar quadruples. Run the first section alone to inspect the original packing using just its text input.

`formconstraints_bonds.m` builds the full rigidity matrix. `formconstraints_bonds_fix.m` builds the pinned matrix and the edge list used by the optimizer. `inf_rotation_3D.m` and `stress_test3d.m` support the infinitesimal-flex and stress calculations. The visualization routine `plotcluster2b.m` includes a cylinder helper credited in the source to Luigi Barone and Per Sundqvist.
