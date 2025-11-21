#!/bin/bash
start_time=$(date +%s)
total_steps=$(<total.txt)
current_step=$(<count.txt)
old_step=$(<count.txt)
until [[ $current_step -eq $total_steps ]]
do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  estimated_time=$((elapsed_time * total_steps / current_step - elapsed_time))
  let filled_slots=current_step*20/total_steps
  bar=""
  for ((i=0; i<$filled_slots; i++)); do
    bar="${bar}#"
  done
  echo -ne "\r[${bar}] [$current_step/$total_steps] - ETA: ${estimated_time}s"
  until [[ $current_step != $old_step ]]
  do 
    sleep 10
    current_step=$(<count.txt)
  done
  old_step=$(<count.txt)
done
echo # Newline

