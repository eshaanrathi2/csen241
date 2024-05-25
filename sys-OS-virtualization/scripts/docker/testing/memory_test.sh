#!/bin/bash

# Define the output file variable
output_file="memory_test_results.txt"

# Clear the contents of the text file
echo -n > "$output_file"

# Number of runs
num_runs=5

# Memory block sizes for the two tests
block_size_1=2K
block_size_2=4K
total_memory_size=15G

##################################################################
######################    Test 1 #################################
##################################################################

echo "Sysbench Memory test with memory-block-size=$block_size_1 and memory-total-size=$total_memory_size"
# Arrays to store results
declare -a results_array=()

# Run the Sysbench Memory test multiple times
for ((i=1; i<=$num_runs; i++))
do
    echo "Run $i"
    
    # Run the test and extract total events and toal time
    sysbench_output=$(sysbench memory --memory-block-size=$block_size_1 --memory-total-size=$total_memory_size run)
    total_events=$(grep "total number of events:" <<< "$sysbench_output" | awk '{print $5}')
    total_time=$(grep "total time:" <<< "$sysbench_output" | awk '{print $3}' | sed 's/s$//')
    result=$(echo "scale=2; $total_events / $total_time" | bc)
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
    sum_squared_diff=$(echo "$sum_squared_diff + $squared_diff" | bc -l)
done
# Corrected standard deviation formula
std_dev=$(echo "scale=2; sqrt($sum_squared_diff / ($num_runs - 1))" | bc -l)

# Display results on the terminal
# cat "$output_file"

printf "Storing results in $output_file file\n\n"

# Redirect output to the specified file
echo -e "\nResults for $num_runs runs of Sysbench Memory test with memory-block-size=$block_size_1 and memory-total-size=$total_memory_size:" >> "$output_file"
echo "Average: $average events per second" >> "$output_file"
echo "Minimum: $min events per second" >> "$output_file"
echo "Maximum: $max events per second" >> "$output_file"
echo "Standard Deviation: $std_dev events per second" >> "$output_file"

##################################################################
##################################################################
######################    Test 2 #################################
##################################################################

echo "Sysbench Memory test with memory-block-size=$block_size_1 and memory-total-size=$total_memory_size"
# Arrays to store results
declare -a results_array=()

# Run the Sysbench Memory test multiple times
for ((i=1; i<=$num_runs; i++))
do
    echo "Run $i"
    # Run the test and extract total events and toal time
    sysbench_output=$(sysbench memory --memory-block-size=$block_size_2 --memory-total-size=$total_memory_size run)
    total_events=$(grep "total number of events:" <<< "$sysbench_output" | awk '{print $5}')

    total_time=$(grep "total time:" <<< "$sysbench_output" | awk '{print $3}' | sed 's/s$//')
     
    result=$(echo "scale=2; $total_events / $total_time" | bc)
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
    sum_squared_diff=$(echo "$sum_squared_diff + $squared_diff" | bc -l)
done
# Corrected standard deviation formula
std_dev=$(echo "scale=2; sqrt($sum_squared_diff / ($num_runs - 1))" | bc -l)


printf "Storing results in $output_file file\n\n"

# Redirect output to the specified file
echo -e "\nResults for $num_runs runs of Sysbench Memory test with memory-block-size=$block_size_2 and memory-total-size=$total_memory_size:" >> "$output_file"
echo "Average: $average events per second" >> "$output_file"
echo "Minimum: $min events per second" >> "$output_file"
echo "Maximum: $max events per second" >> "$output_file"
echo "Standard Deviation: $std_dev events per second" >> "$output_file"


echo "Summary of results of both the tests:"
# Display results on the terminal
cat "$output_file"

