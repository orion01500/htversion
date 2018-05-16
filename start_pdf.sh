#!/usr/bin/sh
export HTVERSION_PROJECT_NAME="ocr"
export HTVERSION_OUTPUT_DIR="projects"
export HTVERSION_RULES_LIST="rules/rules.docs.txt"

set -e

. src/htversion.sh

htversion_clean_query
htversion_init_counter

parallel -j10 --tmux --verbose htversion_run_task {} ::: $(cat "sites/sites.gazette.txt")

printf "\nMirroring complete. "$(cat $TEMPFILE)" sites updated.\n"

htversion_dispose_counter

htversion_test_completed

htversion_git_task
