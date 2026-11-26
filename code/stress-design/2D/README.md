# Stress design on four stacked squares

This example constructs the ten-vertex framework in Figure 5(a) and optimizes its vertical edges to obtain the self-stress ratios shown in Figure 5(d). `stressed_framework_square(1,4)` fixes the two bottom vertices. The remaining bars retain their initial lengths while the eight vertical edges can change length.

## Run in MATLAB

Set this directory as the current folder and run `main_stress`. The initial configuration and target are defined in the source. The script uses MATLAB graphics, frame capture, and MPEG-4 recording.

| Target edges, in the paper's vertex labels | AC | BD | CE | DF | EG | FH | GI | HJ |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Relative stress | 8 | 4 | 2 | 1 | 8 | 4 | 2 | 1 |

`optimization_stress` uses finite-difference gradients to update the free coordinates. `newton_iter_a` projects each step onto the fixed-length constraints. The final check restores the bar between the two pinned vertices and reports the residual when the target weights are fitted to the selected rows of the four-dimensional self-stress basis.

Running the example creates `bar-framework.mp4` and `final-framework1-4.mat` in the working directory. The MAT file contains the optimized framework in `framework_cur`.
