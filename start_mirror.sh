#!/usr/bin/sh
export HTVERSION_PROJECT_NAME="malaysia"
export HTVERSION_OUTPUT_DIR="projects"
export HTVERSION_RULES_LIST="rules/rules.txt"

. src/htversion.sh

#htversion_clean_query
htversion_init_counter

parallel -j5 --tmux --verbose htversion_run_task {} ::: $(cat "sites/sites.txt")

printf "\nMirroring complete. "$(cat $TEMPFILE)" sites updated.\n"
htversion_dispose_counter
