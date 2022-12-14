# Bactos.jl

Agent-based modelling of bacterial motility and chemotaxis in Julia.

## Features
- Built on [Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/)
- Bacterial motility in 1, 2 and 3 dimensions with customizable motile patterns.
- Chemotaxis with different tunable models (Brown-Berg, Brumley, Celani, Xie).
- Integration of differential equations in parallel with agent stepping via [DifferentialEquations.jl](https://diffeq.sciml.ai/stable/), using finite differences.
- Easy evaluation of quantities of interest (mean-squared displacement, autocorrelation functions...).

### Limitations
- The length of the integration timestep also sets the sensing timescale in chemotaxis models (i.e. the time over which a microbe integrates environmental signals).
- Reorientations are always assumed to be instantaneous.
- No hydrodynamic interactions.



## Future directions
- Swimming in flow fields.
- More behavioral strategies (chemokinesis, infotaxis...).
- Extended set of core functionalities (encounters, interactions...).
- Complex environments (non-spherical obstacles).
- Steric interactions and non-spherical microbes.



## Citation
If you use this package in work that leads to a publication, please cite the GitHub repository:
```
@misc{Foffi2022,
    author = {Foffi, R.},
    title = {Bactos.jl},
    year = {2022},
    publisher = {GitHub},
    journal = {GitHub repository},
    howpublished = {\url{https://github.com/mastrof/Bactos.jl}}
}
```


## Acknowledgements
This project has received funding from the European Union's Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No 955910.