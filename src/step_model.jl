export model_step!, encounters!, reinsert!

"""
    model_step!(model; update_model! = (model) -> nothing)
Update model properties through the `update_model!` function
(defaults to nothing).
If `model` contains an OrdinaryDiffEq integrator among its
properties (`model.properties.integrator`), also perform an integration step.
"""
function model_step!(model;
    update_model!::Function = (model) -> nothing
)
    # if a diffeq integrator is provided, integrate over a timestep
    if haskey(model.properties, :integrator)
        step!(model.integrator, model.timestep, true)
    end # if
    # increase step count
    model.t += 1
    # update model properties
    update_model!(model)
    return nothing
end # function

"""
    encounters!(model::ABM;
        bodies::Symbol = :bodies, key::Symbol = :encounters,
        encounter_affect!::Function = reinsert!
    )
Evaluate encounters between all microbes in the `model` and a collection
of bodies stored in `model.properties[bodies]`.
Occurrence of an encounter is determined by the `is_encounter` function,
with signature `(microbe, body, model)`.
For certain `body` types, `is_encounter` is already defined by `Bactos.jl`;
if you need extra or different functionality overload `Bactos.is_encounter`.

Whenever an encounter occurs, `model.properties[key]` is increased by 1.
Then the `encounter_affect!` function is applied, which determines what
happens after the encounter (e.g. the microbe can be reinserted).

`encounters!` should be passed to `model_step!` through `update_model!`.
"""
function encounters!(model::ABM;
    bodies::Symbol = :bodies, key::Symbol = :encounters,
    encounter_affect!::Function = reinsert!
)
    for microbe in allagents(model)
        for body in model.properties[bodies]
            if is_encounter(microbe, body, model)
                model.properties[key] += 1
                encounter_affect!(microbe, model, bodies::Symbol)
                break # move to the next microbe
            end
        end
    end
end

"""
    reinsert!(microbe::AbstractMicrobe, model::ABM, bodies::Symbol;
        avoid_bodies::Bool = true
    )
Reinsert `microbe` in a random position.
If `avoid_bodies` is set to `true`, only positions which don't trigger
a new encounter with any body in `model.properties[bodies]` are accepted.
"""
function reinsert!(
    microbe::AbstractMicrobe, model::ABM, bodies::Symbol;
    avoid_bodies::Bool = true
)
    # move to a new position at random until an encounter is not triggered
    while true
        any_overlap = false
        move_agent!(microbe, model)
        # don't perform any check if avoid_bodies==false
        (~avoid_bodies) && break
        for body in model.properties[bodies]
            if is_encounter(microbe, body, model)
                # break if position is not valid
                any_overlap = true
                break
            end
            any_overlap && break # extract a new position
        end
        # break out of while loop if position is valid
        (~any_overlap) && break
    end
end