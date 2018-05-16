#!/usr/bin/sh
export HTVERSION_PROJECT_NAME="test"
export HTVERSION_OUTPUT_DIR="projects"
export HTVERSION_RULES_LIST="rules/rules.debug.txt"

set -e

. src/htversion.sh

htversion_clean_query
htversion_init_counter

parallel -j5 --verbose --tmux htversion_run_task {} ::: $(cat sites/sites.test.txt)

printf "\nMirroring complete. "$(cat $TEMPFILE)" sites updated.\n"

htversion_dispose_counter

# check for incomplete files aka errors
htversion_test_completed

