# set variable order
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# get current time and store it
start=$SECONDS

# run query
for i in $(seq $num_reps); do
    duckdb "$db_file" "$query" > /dev/null 2>&1
done

# get current time and store it
end=$SECONDS

# calculate elapsed and average time
elapsed=$((end-start))
avg=$(echo "scale=7; $elapsed / $num_reps" | bc)

# write the output
echo "$label,$avg" >> "$csv_file"