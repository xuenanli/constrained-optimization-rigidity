# Prescribing self-stress ratios

Figure 5 assigns target self-stress ratios to a set of free edges. Each calculation optimizes a weighted sum of their squared lengths while holding the other bar lengths fixed. The weights specify the desired ratios up to an overall factor.

| Figure 5 panels | Framework | MATLAB entry point |
| --- | --- | --- |
| (a), (d) | Four stacked squares in the plane | [2D — `main_stress`](2D/) |
| (b), (e) | A ten-sphere packing with two target edges | [3D — `driver_3d_optimal`](3D/) |
| (c), (f) | An eleven-sphere packing with three target edges | [3D — `driver_3d_optimal`](3D/) |

Set the MATLAB current folder to the example you want to run. The two implementations use dimension-specific functions with the same names.
