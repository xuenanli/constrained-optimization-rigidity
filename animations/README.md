# Animations

## Figure 2(a–b) · Hexagon

| Regular hexagon · Unperturbed | Figure 2(a) · Perturbed initial condition | Figure 2(b) · Final state |
| --- | --- | --- |
| <img src="figure-2-regular-hexagon-self-stress.png" alt="Regular hexagon with three red diagonals in tension, six blue perimeter bars in compression, and two pinned vertices" width="220"> | <img src="figure-2a-perturbed-hexagon.png" alt="Perturbed hexagon with the free diagonal dashed in red" width="220"> | <img src="figure-2b-optimized-hexagon.png" alt="Optimized hexagon with self-stress colors and pinned flex arrows" width="220"> |

In the self-stress shown on the regular hexagon, all three diagonals are in tension (red) and the six perimeter bars are in compression (blue). The animation starts from the perturbed hexagon in Figure 2(a). Maximizing the length of the diagonal between vertices 1 and 4 while keeping the other bar lengths fixed gives the prestress-stable framework in Figure 2(b). [Watch the MATLAB animation (MP4)](figure-2a-to-2b-matlab.mp4)

**Maximization · Squared length of edge 1–4**

<img src="figure-2a-to-2b-objective.png" alt="The squared length of edge 1–4 increases with optimization iteration and levels off" width="500">

## Figure 2(c–d) · Connected triangles

| Figure 2(c) · Initial condition | Figure 2(d) · Final state |
| --- | --- |
| <img src="figure-2c-initial-triangles.png" alt="Two connected triangles with the free bar dashed in red" width="220"> | <img src="figure-2d-optimized-triangles.png" alt="Optimized triangles with self-stress colors and pinned flex arrows" width="220"> |

Minimizing the length of the bar between vertices 5 and 6 in Figure 2(c) while keeping the other bar lengths fixed gives the prestress-stable framework in Figure 2(d). [Watch the MATLAB animation (MP4)](figure-2c-to-2d-matlab.mp4)

**Minimization · Squared length of edge 5–6**

<img src="figure-2c-to-2d-objective.png" alt="The squared length of edge 5–6 decreases with optimization iteration and levels off" width="500">

In the Figure 2 final panels, red bars are in tension and blue bars are in compression. Crosses mark pinned vertices, and arrows show the pinned infinitesimal flex.

## Figure 3(a–c) · Nine-sphere framework

| Figure 3(a) · Unperturbed | Figure 3(b) · Perturbed initial condition | Figure 3(c) · Final state |
| --- | --- | --- |
| <img src="figure-3a-unperturbed.png" alt="Unperturbed framework from the nine-sphere packing" width="220"> | <img src="figure-3b-perturbed.png" alt="Perturbed nine-sphere framework at the start of optimization" width="220"> | <img src="figure-3c-optimized.png" alt="Prestress-stable nine-sphere framework after optimization" width="220"> |

The original framework is case 1 from the nine-sphere packing dataset. The video starts at the perturbed framework in Figure 3(b) and shows the first 200 steps toward Figure 3(c). Maximizing the length of the bar between vertices 3 and 7 while keeping the other bar lengths fixed gives a prestress-stable framework with one independent self-stress. [Watch the MATLAB animation (MP4)](figure-3b-to-3c-matlab.mp4)

**Maximization · Squared length of edge 3–7**

<img src="figure-3b-to-3c-objective.png" alt="The squared length of edge 3–7 increases over the first 200 optimization iterations" width="500">

## Figure 3(d–f) · Ten-sphere framework

| Figure 3(d) · Unperturbed | Figure 3(e) · Initial condition | Figure 3(f) · Final state |
| --- | --- | --- |
| <img src="figure-3d-unperturbed.png" alt="Unperturbed framework from the ten-sphere packing" width="220"> | <img src="figure-3e-perturbed.png" alt="Perturbed framework at the start of the optimization" width="220"> | <img src="figure-3f-optimized.png" alt="Prestress-stable framework after optimization" width="220"> |

- **Figure 3(d).** The original framework is case 6 from the ten-sphere packing dataset.
- **Figure 3(e).** Perturbing the vertex positions gives the initial condition for the optimization. This framework is not prestress stable.
- **Figure 3(f).** Minimizing the length of the bar between vertices 1 and 3 while keeping all other bar lengths fixed gives a prestress-stable framework with one independent self-stress.

[Watch or download the MATLAB animation (MP4)](figure-3e-to-3f-matlab.mp4)

The video begins at Figure 3(e) and shows the first 200 optimization steps toward Figure 3(f).

**Minimization · Squared length of edge 1–3**

<img src="figure-3e-to-3f-objective.png" alt="The squared length of edge 1–3 decreases over the first 200 optimization iterations and levels off" width="500">

## Figure 4(a–b) · Midpoint constraints

| Unperturbed · Concentric squares | Figure 4(a) · Perturbed initial condition | Figure 4(b) · Final state |
| --- | --- | --- |
| <img src="figure-4-unperturbed-squares.png" alt="Concentric squares with the inner square rotated 45 degrees and connecting bars perpendicular to the outer sides" width="220"> | <img src="figure-4a-midpoint-initial.png" alt="Flexible midpoint-constrained framework with the free bar between vertices 5 and 9 dashed in red" width="220"> | <img src="figure-4b-midpoint-optimized.png" alt="Prestress-stable midpoint-constrained framework after optimization" width="220"> |

In the unperturbed framework, the inner and outer squares share a center, and the inner square is rotated 45° relative to the outer square. Each connecting bar meets the corresponding outer side at its midpoint and at a right angle. The animation starts from the perturbed inner quadrilateral in Figure 4(a) and shortens the bar between vertices 5 and 9 while preserving the other bar lengths and the four midpoint constraints. The final framework is prestress stable. [Watch the MATLAB animation (MP4)](figure-4a-to-4b-matlab.mp4)

**Minimization · Squared length of edge 5–9**

<img src="figure-4a-to-4b-objective.png" alt="The squared length of edge 5–9 decreases with optimization iteration" width="500">

## Figure 5(a, d) · Stress design for stacked squares

| Figure 5(a) · Initial condition | Figure 5(d) · Final state |
| --- | --- |
| <img src="figure-5a-stacked-squares-initial.png" alt="Four stacked squares with eight target edges dashed in red" width="220"> | <img src="figure-5d-stacked-squares-optimized.png" alt="Optimized stacked-square framework colored by self-stress" width="220"> |

The final framework admits a self-stress with the target ratio **8:4:2:1:8:4:2:1** on edges AC, BD, CE, DF, EG, FH, GI, and HJ, in that order. [Watch the MATLAB animation (MP4)](figure-5a-to-5d-matlab.mp4)

**Minimization · Weighted sum of the eight target edges’ squared lengths**

<img src="figure-5a-to-5d-objective.png" alt="The weighted sum of the eight target edges’ squared lengths decreases during optimization" width="500">

## Figure 5(b, e) · Stress design for a ten-sphere framework

| Figure 5(b) · Initial condition | Figure 5(e) · Final state |
| --- | --- |
| <img src="figure-5b-ten-sphere-initial.png" alt="Initial ten-sphere framework from packing case 4" width="220"> | <img src="figure-5e-ten-sphere-optimized.png" alt="Optimized ten-sphere framework colored by self-stress" width="220"> |

The optimization changes the self-stress ratio on edges 2–4 and 3–6 from **1:1** to **1:2**. [Watch the MATLAB animation (MP4)](figure-5b-to-5e-matlab.mp4)

**Minimization · Weighted sum of the two target edges’ squared lengths**

<img src="figure-5b-to-5e-objective.png" alt="The weighted sum of the squared lengths of edges 2–4 and 3–6 decreases during optimization" width="500">

## Figure 5(c, f) · Stress design for an eleven-sphere framework

| Figure 5(c) · Initial condition | Figure 5(f) · Final state |
| --- | --- |
| <img src="figure-5c-eleven-sphere-initial.png" alt="Initial eleven-sphere framework from packing case 34" width="220"> | <img src="figure-5f-eleven-sphere-optimized.png" alt="Optimized eleven-sphere framework colored by self-stress" width="220"> |

The final framework admits a self-stress with the target ratio **2:3:2** on edges 3–5, 2–6, and 3–6, in that order. [Watch the MATLAB animation (MP4)](figure-5c-to-5f-matlab.mp4)

**Minimization · Weighted sum of the three target edges’ squared lengths**

<img src="figure-5c-to-5f-objective.png" alt="The weighted sum of the squared lengths of edges 3–5, 2–6, and 3–6 decreases during optimization" width="500">
