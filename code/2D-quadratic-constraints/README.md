# Planar frameworks with fixed bar lengths

Figure 2 optimizes the length of one edge in each of two planar frameworks. The drivers take a gradient step on the squared length, then use a Newton iteration to restore the other bar lengths and the pinned coordinates. They compute a self-stress and evaluate its quadratic form on an infinitesimal flex at the final configuration.

## Run the Figure 2 examples

Open this folder as the MATLAB current folder. Both drivers require Symbolic Math Toolbox, figure graphics, and support for `VideoWriter` with the MPEG-4 profile. The constructors define all input geometry in MATLAB.

| Panels | MATLAB command | Calculation |
| --- | --- | --- |
| 2(a–b), hexagon | `driver_polygon_finite` | Constructs the hexagon with `framework_hexagon` and maximizes the squared length of the diagonal joining vertices 1 and 4 (edge 3). |
| 2(c–d), connected triangles | `driver_opt_finite` | Constructs the triangles with `framework_two_triangle` and minimizes the squared length of the bar joining vertices 5 and 6 (edge 8). |

## Helpers and local outputs

`edge_info.m` lists vertex pairs and initial bar lengths. `formconstraints_bonds.m` builds the rigidity matrix from those pairs, and `plot_null_vec_framework.m` draws the flex vectors. The drivers display the optimization history and report singular values and a stress test in the Command Window.

Running the hexagon or triangle driver writes `hexagon-max.mp4` or `two-triangles-min.mp4`, respectively, in the MATLAB current folder. Each driver sets the filename in `video_name`.
