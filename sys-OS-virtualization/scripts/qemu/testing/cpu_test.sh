#!/bin/bash

# Define the output file variable
output_file="cpu_test_results.txt"

# Clear the contents of the text file
echo -n > "$output_file"

# Number of runs
num_runs=5

# Number of events for each run
events=10000

echo "Running Sysbench CPU test with $events events."
# Arrays to store results
declare -a results_array=()

# Run the Sysbench CPU test multiple times
for ((i=1; i<=$num_runs; i++))
do
    echo "Run $i"
    
    result=$(sysbench cpu --events=$events run | awk '/events per second:/ {print $4}')
    results_array+=($result)
done

# Calculate average, min, max, and standard deviation
sum=0
min=${results_array[0]}
max=${results_array[0]}

# Loop through the results to calculate sum, min, and max
for result in "${results_array[@]}"; do
    # Remove any non-numeric characters
    result=$(echo "$result" | tr -cd '[:digit:].')
    
    # Perform calculation
    sum=$(echo "$sum + $result" | bc)

    # Use arithmetic comparison for min and max
    if (( $(echo "$result < $min" | bc -l) )); then
        min=$result
    fi

    if (( $(echo "$result > $max" | bc -l) )); then
        max=$result
    fi
done

# Calculate average
average=$(echo "scale=2; $sum / $num_runs" | bc -l)

# Calculate standard deviation
sum_squared_diff=0
for result in "${results_array[@]}"; do
    result=$(echo "$result" | tr -cd '[:digit:].')
    squared_diff=$(echo "($result - $average)^2" | bc -l)
    # echo "squared_diff=$squared_diff"
    sum_squared_diff=$(echo "$sum_squared_diff + $squared_diff" | bc -l)
    # echo "sum_squared_diff=$sum_squared_diff"
done
# Corrected standard deviation formula
std_dev=$(echo "scale=2; sqrt($sum_squared_diff / ($num_runs - 1))" | bc -l)

printf "Storing results in $output_file file \n"

# Redirect output to the specified file
echo "Results for $events runs of test Sysbench CPU:" >> "$output_file"
echo "Average: $average events per second" >> "$output_file"
echo "Minimum: $min events per second" >> "$output_file"
echo "Maximum: $max events per second" >> "$output_file"
echo "Standard Deviation: $std_dev events per second" >> "$output_file"
echo "" >> "$output_file"

##################################################################
##################################################################
######################    Test 2 #################################
##################################################################




#!/bin/bash

# Define the output file variable
# output_file="cpu_test_results.txt"

# Number of runs
# num_runs=5

# Number of events for each run
events=15000

printf "\nRunning Sysbench CPU test with $events events.\n"
# Arrays to store results
declare -a results_array=()

# Run the Sysbench CPU test multiple times
for ((i=1; i<=$num_runs; i++))
do
    echo "Run $i"
    
    result=$(sysbench cpu --events=$events run | awk '/events per second:/ {print $4}')
    results_array+=($result)
done

# Calculate average, min, max, and standard deviation
sum=0
min=${results_array[0]}
max=${results_array[0]}

# Loop through the results to calculate sum, min, and max
for result in "${results_array[@]}"; do
    # Remove any non-numeric characters
    result=$(echo "$result" | tr -cd '[:digit:].')
    
    # Perform calculation
    sum=$(echo "$sum + $result" | bc)

    # Use arithmetic comparison for min and max
    if (( $(echo "$result < $min" | bc -l) )); then
        min=$result
    fi

    if (( $(echo "$result > $max" | bc -l) )); then
        max=$result
    fi
done

# Calculate average
average=$(echo "scale=2; $sum / $num_runs" | bc -l)

# Calculate standard deviation
sum_squared_diff=0
for result in "${results_array[@]}"; do
    result=$(echo "$result" | tr -cd '[:digit:].')
    squared_diff=$(echo "($result - $average)^2" | bc -l)
    # echo "squared_diff=$squared_diff"
    sum_squared_diff=$(echo "$sum_squared_diff + $squared_diff" | bc -l)
    # echo "sum_squared_diff=$sum_squared_diff"
done
# Corrected standard deviation formula
std_dev=$(echo "scale=2; sqrt($sum_squared_diff / ($num_runs - 1))" | bc -l)


printf "Storing results in $output_file file\n"
printf "\n"

# Redirect output to the specified file
echo "Results for $events runs of test Sysbench CPU:" >> "$output_file"
echo "Average: $average events per second" >> "$output_file"
echo "Minimum: $min events per second" >> "$output_file"
echo "Maximum: $max events per second" >> "$output_file"
echo "Standard Deviation: $std_dev events per second" >> "$output_file"


printf "Results of both the experiments:\n"
printf "\n"
# Display results on the terminal
cat "$output_file"
