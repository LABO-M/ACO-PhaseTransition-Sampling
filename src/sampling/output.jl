using CSV, DataFrames

# Convert the numeric value to a string format with K, M, G, etc.
function int_to_SI_prefix(value::Int)
    if value % 1_000_000_000 == 0
        return string(value ÷ 1_000_000_000) * "G"
    elseif value % 1_000_000 == 0
        return string(value ÷ 1_000_000) * "M"
    elseif value % 1_000 == 0
        return string(value ÷ 1_000) * "K"
    else
        return string(value)
    end
end

# Convert the string format with K, M, G, etc. to a numeric value
function SI_prefix_to_int(s::String)
    if endswith(s, "G")
        return parse(Int, chop(s)) * 1_000_000_000
    elseif endswith(s, "M")
        return parse(Int, chop(s)) * 1_000_000
    elseif endswith(s, "K")
        return parse(Int, chop(s)) * 1_000
    else
        return parse(Int, s)
    end
end

# Function to save Z values to a CSV file with optional downsampling
function save_Z_to_csv(Z::Vector{Float64}, filename::String, interval::Int=1000)
    t_values = collect(1:interval:length(Z))
    Z_downsampled = Z[t_values]
    df = DataFrame(t=t_values, Z=Z_downsampled)
    CSV.write(filename, df)
    println("Saved Z values to $filename")
end
