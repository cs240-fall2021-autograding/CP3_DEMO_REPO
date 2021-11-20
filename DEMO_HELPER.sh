#!/usr/bin/env bash

if [ $# -ne 0 ]; then
    echo "bash DEMO_HELPER.sh"
    exit 1
fi

CLONED_REPO_DIRPATH="$PWD"
cd ..
STUDENT_MAIN_DIRPATH="$PWD"

execute_makeclean=$(make clean 2>&1);
execute_make=$(make 2>&1); 
student_executable=$(find . -maxdepth 1 -type f -executable 2>&1); 

printf "\nGENERATED at `date`\n\n\n" > "$CLONED_REPO_DIRPATH/TERMINAL_OUTPUTS.txt"

printf "********** student 'make clean' **********\n $execute_makeclean\n\n" >> "$CLONED_REPO_DIRPATH/TERMINAL_OUTPUTS.txt" ;
printf "********** student 'executable' **********\n $student_executable\n\n" >> "$CLONED_REPO_DIRPATH/TERMINAL_OUTPUTS.txt";
printf "********** student 'make' **********\n $execute_make\n\n" >> "$CLONED_REPO_DIRPATH/TERMINAL_OUTPUTS.txt" ;


cd "$CLONED_REPO_DIRPATH"

for DIR in * 
do
    if [[ "$DIR" =~ "COL" ]];
    then
        printf "\nExecuting for: $DIR"
        cd ./"$DIR";
        rm $student_executable 2>/dev/null
        rm -rf STUDENT_OUTPUT_DIR
        
        cp "$STUDENT_MAIN_DIRPATH/$student_executable" .;

        if [[ "$DIR" == "Memory_Leaks_COL" ]];
        then
            exec_run=$(valgrind $student_executable INPUT_DIR/venues.txt INPUT_DIR/users.txt INPUT_DIR/activities.txt INPUT_DIR/attendance.txt 2>&1);        
        else
            exec_run=$($student_executable INPUT_DIR/venues.txt INPUT_DIR/users.txt INPUT_DIR/activities.txt INPUT_DIR/attendance.txt 2>&1);        
        fi

        mkdir STUDENT_OUTPUT_DIR; 
        # There exists differences across students on how/where they output their files. 
        mv *txt* STUDENT_OUTPUT_DIR 2>/dev/null;
        mv INPUT_DIR/*cp3out* STUDENT_OUTPUT_DIR 2>/dev/null;

        printf "\n\n\n********** Terminal Output for: ' $DIR ' **********\n\n $exec_run\n\n\n" >> "$CLONED_REPO_DIRPATH/TERMINAL_OUTPUTS.txt" ;

        cd "$CLONED_REPO_DIRPATH";


    fi
done

printf "\n\n********** Generated 'TERMINAL_OUTPUTS.txt'. Refer to it for Grading. **********\n\n"

exit 0
