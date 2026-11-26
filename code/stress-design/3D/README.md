# Stress design on sphere-packing frameworks

The driver builds a framework from a sphere packing, fixes three vertices, and optimizes a weighted sum of squared lengths on selected edges. A Newton iteration restores the remaining bar lengths after each descent step. The final check fits the target weights to self-stresses of the optimized framework.

## Run in MATLAB

Use MATLAB with Symbolic Math Toolbox, graphics, and MPEG-4 recording. Set this directory as the current folder. Under **All coordinates** on Miranda Holmes-Cerfon's data page, download the `N=6-10` archive for the ten-sphere case or the `N=11` archive for the eleven-sphere case. Extract the specified text file into this directory. [Sphere-packing data](https://personal.math.ubc.ca/~holmescerfon/packings.html)

Set `packing_size` at the top of `driver_3d_optimal.m`, then run `driver_3d_optimal`.

| Figure 5 panels | `packing_size` | Input file and packing index | Target edges | Target ratio |
| --- | --- | --- | --- | --- |
| (b), (e) | `10` (default) | `n10.txt`, case 4 | 2–4, 3–6 | 1:2 |
| (c), (f) | `11` | `n11.txt`, case 34 | 3–5, 2–6, 3–6 | 2:3:2 |

`spacking_10` and `spacking_11` read the particle coordinates and recover bars from contacts at unit distance. The driver plots the configurations, records the optimization, and writes `stress-design-<case>.mp4`, `init-framework-<case>.mat`, `final-framework-<case>.mat`, and `min-edge-<case>.mat`. The case suffix is `10-4` or `11-34`.

After running the driver, use `data_analyze_10` or `data_analyze_11` in the same working directory to inspect the corresponding final configuration. The eleven-sphere analysis also evaluates a second-order stress test on its nontrivial infinitesimal flex by sampling combinations of three self-stresses.
