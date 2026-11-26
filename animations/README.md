# Animations

## Figure 2(a–b) · Hexagon

| Regular hexagon · Unperturbed | Figure 2(a) · Perturbed initial condition | Figure 2(b) · Final state |
| --- | --- | --- |
| <img src="figure-2-regular-hexagon.png" alt="Regular hexagon with three diagonals and two pinned vertices" width="220"> | <img src="figure-2a-perturbed-hexagon.png" alt="Perturbed hexagon with the free diagonal dashed in red" width="220"> | <img src="figure-2b-optimized-hexagon.png" alt="Optimized hexagon with self-stress colors and pinned flex arrows" width="220"> |

The regular hexagon has the same bar connections as Figure 2(a). The animation starts from the perturbed hexagon in Figure 2(a). Maximizing the length of the diagonal between vertices 1 and 4 while keeping the other bar lengths fixed gives the prestress-stable framework in Figure 2(b). [Watch the MATLAB animation (MP4)](figure-2a-to-2b-matlab.mp4)

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
