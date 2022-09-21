export
    initialise_model

"""
    initialise_model(;
        microbes,
        timestep,
        extent, spacing = extent/20, periodic = true,
        random_positions = true,
        model_properties = Dict()
    )
Initialise an `AgentBasedModel` from population `microbes`.
Requires the integration `timestep` and the `extent` of the simulation box.

When `random_positions = true` the positions assigned to `microbes` are
ignored and new ones, extracted randomly in the simulation box, are assigned;
if `random_positions = false` the original positions in `microbes` are kept.

Any extra property can be assigned to the model via the `model_properties`
dictionary.
"""
function initialise_model(;
    microbes,
    timestep,
    extent, spacing = minimum(extent)/20, periodic = true,
    random_positions = true,
    model_properties = Dict(),
)
    properties = Dict(
        :timestep => timestep,
        model_properties...
    )

    space_dim = length(microbes[1].pos)
    if typeof(extent) <: Real
        domain = Tuple(fill(extent, space_dim))
    else
        if length(extent) ≠ space_dim
            error("Space extent and microbes must have the same dimensionality.")
        end # if
        domain = extent
    end # if
    space = ContinuousSpace(
        domain,
        spacing = spacing,
        periodic = periodic
    )

    MicrobeType = eltype(microbes)

    model = ABM(
        MicrobeType, space;
        properties,
        scheduler = Schedulers.fastest,
    )

    for microbe in microbes
        if random_positions
            add_agent!(microbe, model)
        else
            add_agent!(microbe, microbe.pos, model)
        end # if
    end # for

    return model
end # function

"""
    initialise_ode(ode_step!, u₀, p; alg=Tsit5(), kwargs...)
Initialise an OrdinaryDiffEq integrator, using the in-place stepping algorithm
`ode_step!`, initial conditions `u₀` and parameters `p`.
Default integration algorithm is `Tsit5` (others can be accessed by importing
OrdinaryDiffEq).
Any extra parameter can be passed over to the integrator via kwargs.
"""
function initialise_ode(ode_step!, u₀, p; alg=Tsit5(), kwargs...)
    prob = ODEProblem(ode_step!, u₀, (0.0, Inf), p)
    integrator = init(prob, alg; kwargs...)
    return integrator
end # function