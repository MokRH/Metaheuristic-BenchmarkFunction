# Metaheuristic-Benchmark

**MSFA, CMSFA and WOA on the 23 standard benchmark functions (F1–F23)**

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023b-orange)](https://www.mathworks.com/products/matlab.html)
[![DOI](https://img.shields.io/badge/MSFA%20paper-10.1016%2Fj.jestch.2022.101264-blue)](https://doi.org/10.1016/j.jestch.2022.101264)

MATLAB code for a comparative study of how well three metaheuristics find the global minimum of the classical test functions F1–F23:

- **MSFA**: Memorizable Smoothed Functional Algorithm, introduced in [Mok & Ahmad (2022)](https://doi.org/10.1016/j.jestch.2022.101264).
- **CMSFA**: a variant of MSFA that also lets the two perturbed evaluation points compete for the stored best solution.
- **WOA**: Whale Optimization Algorithm ([Mirjalili & Lewis, 2016](https://doi.org/10.1016/j.advengsoft.2016.01.008)), used as a reference method.

The same SFA-family tuners are applied to FOPID control of an AVR system in the companion repository [Metaheuristic-AVR](https://github.com/MokRH/Metaheuristic-AVR).

---

## Methods

| Method | Type | Evaluations per iteration | Evaluations per run (default settings) |
|---|---|---|---|
| MSFA | single-point, gradient estimate from perturbed evaluations | 3 | 601 |
| CMSFA | single-point, gradient estimate from perturbed evaluations | 3 | 601 |
| WOA | population-based | number of search agents | 201 (1 agent) |

**MSFA and CMSFA.** At iteration $k$ a random direction $\eta \in \{-1,+1\}^{d}$ is drawn and two points around the best solution so far, $\bar P$, are evaluated:

$$P^{\pm} = \bar P \pm b_k \eta, \qquad \hat g = \frac{J(P^{+}) - J(P^{-})}{2 b_k}\,\eta, \qquad P_{k+1} = \bar P - a_k \hat g$$

with $a_k = 1/(k+1)$ and $b_k = 0.1/(k+1)$. The new point $P_{k+1}$ is evaluated as well, which gives three function evaluations per iteration. The two methods differ only in what may update the stored best solution $\bar P$:

| | Candidates for the stored best |
|---|---|
| MSFA | $P_{k+1}$ |
| CMSFA | $P^{+}$, $P^{-}$ and $P_{k+1}$ |

**WOA.** Standard implementation by S. Mirjalili, unchanged (encircling prey, bubble-net spiral and random search, with the search agents clipped to the bounds).

---

## Test functions

Definitions, bounds and dimensions are those in [`benchmark/Get_Functions_details.m`](benchmark/Get_Functions_details.m). The last column gives the known global minimum from the literature.

| ID | Function | Dim | Range | f<sub>min</sub> |
|---|---|---|---|---|
| **Unimodal** | | | | |
| F1 | Sphere | 10 | [−100, 100] | 0 |
| F2 | Schwefel 2.22 | 10 | [−10, 10] | 0 |
| F3 | Schwefel 1.2 | 10 | [−100, 100] | 0 |
| F4 | Schwefel 2.21 | 10 | [−100, 100] | 0 |
| F5 | Rosenbrock | 10 | [−30, 30] | 0 |
| F6 | Step (implemented as a shifted sphere, Σ(x<sub>i</sub>+0.5)²) | 10 | [−100, 100] | 0 |
| F7 | Quartic with noise | 10 | [−1.28, 1.28] | 0 |
| **Multimodal** | | | | |
| F8 | Schwefel 2.26 | 10 | [−500, 500] | −418.9829 × dim ≈ −4189.83 |
| F9 | Rastrigin | 10 | [−5.12, 5.12] | 0 |
| F10 | Ackley | 10 | [−32, 32] | 0 |
| F11 | Griewank | 10 | [−600, 600] | 0 |
| F12 | Penalized 1 | 10 | [−50, 50] | 0 |
| F13 | Penalized 2 | 10 | [−50, 50] | 0 |
| **Fixed-dimension multimodal** | | | | |
| F14 | Shekel's Foxholes | 2 | [−65.536, 65.536] | ≈ 0.998 |
| F15 | Kowalik | 10 (uses 4) | [−5, 5] | ≈ 0.0003075 |
| F16 | Six-Hump Camel | 2 | [−5, 5] | ≈ −1.0316 |
| F17 | Branin | 2 | x<sub>1</sub> ∈ [−5, 10], x<sub>2</sub> ∈ [0, 15] | ≈ 0.3979 |
| F18 | Goldstein-Price | 2 | [−2, 2] | 3 |
| F19 | Hartman 3 | 3 | [0, 1] | ≈ −3.8628 |
| F20 | Hartman 6 | 6 | [0, 1] | ≈ −3.3224 |
| F21 | Shekel 5 | 4 | [0, 10] | ≈ −10.1532 |
| F22 | Shekel 7 | 4 | [0, 10] | ≈ −10.4029 |
| F23 | Shekel 10 | 4 | [0, 10] | ≈ −10.5364 |

---

## Repository layout

```
Metaheuristic-Benchmark/
├── main.m                       entry point: batch runs, plots, summary table
├── algorithms/
│   ├── MSFA.m                   Memorizable SFA
│   ├── CMSFA.m                  CMSFA
│   └── WOA.m                    Whale Optimization Algorithm (S. Mirjalili)
├── benchmark/
│   ├── Get_Functions_details.m  F1-F23: bounds, dimension, function handles
│   ├── func_plot.m              3-D surface of a test function
│   └── initialization.m         random initial population
├── results/                     outputs written by main.m
├── CITATION.cff
└── README.md
```

Every algorithm has the same interface:

```matlab
[Best_score, Best_pos, Convergence_curve] = Method(SearchAgents_no, Max_iter, lb, ub, dim, fobj)
```

---

## Requirements

- MATLAB. The result files were generated with R2023b. No toolboxes are needed.

---

## Quick start

1. Open MATLAB in the repository folder.
2. Edit the **Settings** block at the top of `main.m`:

   | Setting | Default | Meaning |
   |---|---|---|
   | `Methods` | `{'MSFA','CMSFA','WOA'}` | methods to run |
   | `Functions` | `{'F1','F6'}` | test functions (any of F1–F23) |
   | `Runs` | `1` | independent runs per function and method |
   | `SearchAgents_no` | `1` | population size (MSFA/CMSFA always use one point) |
   | `Max_iteration` | `201` | iterations per run |
   | `doPlot` | `true` | search-space surface and convergence curves |
   | `saveResults` | `true` | write `.mat`, `.csv` and `.png` files to `results/` |
   | `verbose` | `false` | show the per-iteration output printed by the algorithms |

3. Run it:

   ```matlab
   >> main
   ```

To call a single method directly:

```matlab
addpath algorithms benchmark
[lb,ub,dim,fobj] = Get_Functions_details('F1');
[score,pos,curve] = MSFA(1,201,lb,ub,dim,fobj);
```

---

## Output files

For each function `Fx` and method, `main.m` writes to `results/`:

| File | Content |
|---|---|
| `Fx_<Method>.mat` | `Best_score`, `Best_pos`, `cg_curves` (one convergence curve per run), `best`, `avg`, `worst`, `sd`, and the run settings |
| `Fx.png` | search-space surface and convergence curves of all methods |
| `summary.csv` | one row per function and method: best, mean, worst and standard deviation over the runs |

---

## Reproducibility

`rng default` is called before each function–method block, so run 1 of every block should match a single run of the original demo script (same MATLAB release and default settings assumed). Additional runs continue the same random stream. Set `Runs` to a larger value (for example 25) to obtain statistics over independent runs.

---

## Implementation notes

These are properties of the current code that matter when reading the results:

- **Evaluation budget.** With the default settings MSFA and CMSFA use 601 function evaluations per run and WOA uses 201, so convergence curves are plotted per iteration, not per evaluation.
- **Bounds.** WOA clips its agents to `[lb, ub]`. MSFA and CMSFA do not clip, so their candidates and best position can leave the search space.
- **Acceptance test.** MSFA and CMSFA compare `abs(J)` with `abs(Jbar)`. For functions whose cost is non-negative this is the same as comparing `J` with `Jbar`. For functions with a negative global minimum (F8, F16, F19–F23) it favours values closer to zero, so results on those functions should not be interpreted until the test is changed to `J < Jbar`.
- **Single agent.** The default `SearchAgents_no = 1` makes WOA a single-point search.
- **Side effects.** MSFA and CMSFA print `[k Leader_score]` every iteration and open a debug plot in figure 11. `main.m` suppresses the printout (unless `verbose = true`) and closes figure 11 after each run.
- **Dimension.** F1–F13 use 10 variables. F15 is defined for 4 variables; the details file sets `dim = 10` and the extra variables are ignored.

---

## Credits

| Files | Author |
|---|---|
| `algorithms/MSFA.m`, `algorithms/CMSFA.m` | Mok Ren Hao |
| `algorithms/WOA.m`, `benchmark/*.m` | Seyedali Mirjalili, from the WOA source package ([paper](https://doi.org/10.1016/j.advengsoft.2016.01.008)) |

Third-party files keep their original headers. Please cite the original WOA paper if you use them.

---

## Citation

If you use this code, please cite:

```bibtex
@article{mok2022fast,
  title   = {Fast and optimal tuning of fractional order {PID} controller for {AVR} system based on memorizable-smoothed functional algorithm},
  author  = {Mok, Ren Hao and Ahmad, Mohd Ashraf},
  journal = {Engineering Science and Technology, an International Journal},
  volume  = {35},
  pages   = {101264},
  year    = {2022},
  doi     = {10.1016/j.jestch.2022.101264}
}
```

---

## License

MIT License

Copyright (c) 2022 RenHao Mok, Mohd Ashraf Ahmad
