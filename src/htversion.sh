#!/usr/bin/sh

if [ -z $HTVERSION_OUTPUT_DIR ] || [ -z $HTVERSION_PROJECT_NAME ] || [ -z $HTVERSION_RULES_LIST ]; then 
    htversion_error_exit "initial config not set";
fi 

htversion_error_exit() {
    echo "$1" >&2   
    exit "${2:-1}"  
}
export -f htversion_error_exit

htversion_git_task(){
    # change to project parent directory
    cd $HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME

    FILES_ALL=$(git status -s | wc -l)
    FILES_CHANGED=$(git status -s | egrep "^.M " | wc -l)
    FILES_DELETED=$(git status -s | egrep "^.D " | wc -l)
    FILES_NEW=$(git status -s | egrep "^\?\? " | wc -l)
    
    msg=`echo "$FILES_ALL total files. $FILES_NEW new file(s). $FILES_CHANGED modified file(s). $FILES_DELETED deleted file(s)."`
    echo "$msg"
    git status -s

    if [ "$FILES_NEW" != "0" ]; then
        git add --verbose .
    fi
    git commit --verbose -m $msg
}
export -f htversion_git_task

htversion_test_completed(){
    incomplete=$(ls -lR $HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME | grep -e "\(\.tmp\|\.delayed\)" | wc -l)
    if [[ "$incomplete" != "0" ]]; then
        htversion_error_exit "$incomplete files were not processed"
    fi
}
export -f htversion_test_completed

htversion_clean_query(){
    read -n 1 -r -p "Clear previous $HTVERSION_PROJECT_NAME directory first?" 
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # do dangerous stuff
        printf "\nDeleting $HTVERSION_PROJECT_NAME ...\n"
        rm -Rf $HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME
        rm -Rf "$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME.cache"
        printf "$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME Deleted!\n"
    fi

    mkdir -p $HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME
    mkdir -p "$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME.cache"
}
export -f htversion_clean_query

htversion_init_counter(){
    #store counter for jobs actually completed in tmp file
    export TEMPFILE="/tmp/htversion-`date +%s`.tmp"
    echo 0 > $TEMPFILE
}
export -f htversion_init_counter

htversion_increment_counter(){
    COUNTER=$[$(cat $TEMPFILE) + 1];
    echo $COUNTER > $TEMPFILE;
}
export -f htversion_increment_counter

htversion_dispose_counter(){
    unlink $TEMPFILE;
}
export -f htversion_dispose_counter

htversion_run_task(){
    CRAWLER_NAME="htversion"
    IFS=$' '
    FOOTER="$(echo "<!-- Mirrored from %s%s -->")"
    OPTIONS=(
        -%S "$HTVERSION_RULES_LIST"
        -I0         # don't create indexes
        -o0         # don't generate error pages
        -a          # stay on the same address
        -A0         # unlimited transfer rate
        -%k         # keep alive
        -%!         # be not really that naughty
        -s0         # what is robots.txt?
        -p7         # html files first
        -c4        # no. of sockets 
        -%c4       # no. of conns/sec
        -q          # no questions
        -T30        # timeout (secs)
        -J100      # min b/s
        -R5         # retries
        -m0,0       # max non-html/html length
        -N0         # default build structure
        -f2         # log in one file
        -%P        # parse all links
        #-%D0        # wait for type check
        -B          # spider up and down
        -%l "en"    # lang
        -%s         # update hacks
        -%u         # url hacks
        -K4         # original uri
        -%T         #  to UTF-8
        -%F "$FOOTER"      
        -%v         # show 'UI'
        -Z          # debug
        -F "$CRAWLER_NAME"
        -V "parse_pdf.py \$0"
    )
    url="$1"
    hostname=$(echo "$url" | sed -e 's|^[^/]*//||' -e 's|/.*$||')

    mkdir -p "$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME.cache/$hostname";
    httrack "$1" -O "$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME,$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME.cache/$hostname" "${OPTIONS[@]}";
    htversion_increment_counter;
}
export -f htversion_run_task


mkdir -p $HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME
mkdir -p "$HTVERSION_OUTPUT_DIR/$HTVERSION_PROJECT_NAME.cache"
