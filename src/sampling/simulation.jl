module Simulation

using Random, ProgressMeter, Statistics, Distributed, SharedArrays

const DEFAULT_EPSILON = 0.01  # Define epsilon as a constant at the top of the code

# Decision function f(z)
function decision_function(z::Float64, alpha::Float64, epsilon::Float64)
    return (1 - epsilon) * ((z^alpha) / (z^alpha + (1 - z)^alpha)) + 0.5 * epsilon
end

# Discount factor D(t) for finite tau
function discount_factor(t::Vector{Int}, tau::Int, N::Int)::Vector{Float64}
    return N .* (1.0 .- exp.(-t ./ tau)) ./ (1.0 - exp(-1/tau))
end

# Discount factor D(t) for infinite tau
function discount_factor(t::Vector{Int}, N::Int)::Vector{Float64}
    return N .* t
end

# Initialize the simulation up to the initial time t0.
function initialize_simulation(N::Int, X::Vector{Int}, S::Vector{Float64}, Sm::Vector{Float64}, t0::Int)
    for t in 1:t0
        X .= rand(0:1, N)
        TP = sum(X)
        S[t] = (t == 1 ? TP : S[t-1] + TP)
        Sm .+= X .* TP
    end
end

function initialize_simulation(N::Int, X::Vector{Int}, S::Vector{Float64}, Sm::Vector{Float64}, t0::Int, exp_val::Float64)
    for t in 1:t0
        X .= rand(0:1, N)
        TP = sum(X)
        S[t] = (t == 1 ? TP : S[t-1] * exp_val + TP)
        Sm .= (t == 1 ? X .* TP : Sm * exp_val .+ X .* TP)
    end
end

# Main simulation function
function simulate_ants(N::Int, T::Int, t0::Int, alpha::Float64)
    X = zeros(Int, N)
    Sm = zeros(Float64, N)
    S = zeros(Float64, T + t0)

    # Initialization
    initialize_simulation(N, X, S, Sm, t0)

    # Main simulation loop
    for t in (t0 + 1):(t0 + T)
        Zm = Sm ./ S[t-1]
        prob = decision_function.(Zm, alpha, DEFAULT_EPSILON)

        X .= rand(Float64, N) .< prob
        TP = sum(X)
        S[t] = S[t-1] + TP
        Sm .+= X .* TP
    end

    # Compute z(t) values for the entire duration
    time_range = 1:(t0 + T)
    Z = S[time_range] ./ discount_factor(collect(time_range), N)
    return Z
end

function simulate_ants(N::Int, T::Int, t0::Int, alpha::Float64, tau::Int)
    X = zeros(Int, N)
    Sm = zeros(Float64, N)
    S = zeros(Float64, T + t0)
    exp_val = exp(-1 / tau)

    # Initialization
    initialize_simulation(N, X, S, Sm, t0, exp_val)

    # Main simulation loop
    for t in (t0 + 1):(t0 + T)
        Zm = Sm ./ S[t-1]
        prob = decision_function.(Zm, alpha, DEFAULT_EPSILON)
        X .= rand(Float64, N) .< prob
        TP = sum(X)
        S[t] = S[t-1] * exp_val + TP
        Sm .= Sm * exp_val .+ X .* TP
    end

    # Compute z(t) values for the entire duration
    time_range = 1:(t0 + T)
    Z = S[time_range] ./ discount_factor(collect(time_range), tau, N)
    return Z
end

# Function to sample Z values
function sample_ants(N::Int, T::Int, t0::Int, alpha::Float64, tau::Int, samples::Int)::Tuple{Vector{Float64}, Vector{Float64}}
    Z_samples = SharedArray{Float64}((T + t0), samples)

    progressBar = Progress(samples * T, 1, "Samples: ")
    ProgressMeter.update!(progressBar, 0)

    @sync @distributed for i in 1:samples
        if tau == -1
            Z_samples[:, i] = simulate_ants(N, T, t0, alpha)
        else
            Z_samples[:, i] = simulate_ants(N, T, t0, alpha, tau)
        end
    end

    println("Finished simulation")

    # Calculate mean and standard deviation values
    Z_mean = mean(Z_samples, dims=2)
    Z_std = std(Z_samples, dims=2)

    return vec(Z_mean), vec(Z_std)
end

end
