# Function definitions.

# functions will only output names that start with function.
functions()
{
  grep -w function ~/.bash_functions | awk '{print substr($0, 1, length($0)-2)}' | awk '{if (NR!=1 && NR!=2) {print $2}}' | sort
}

function =()
{
  calc="$@"
  echo -ne "$calc\n quit" | gcalccmd | sed 's:^> ::g'
}

function mkalias()
{ 
  echo "$*"
  alias "$*"
  alias > ~/.bash_aliases
}

function rmalias()
{ 
  unalias "$*"
  alias > ~/.bash_aliases
}

function findreplace()
{
  old=$1;
  new=$2;
  file=$3;
  
  old=${old/&/\\&}
  new=${new/&/\\&}
  
  mygrep -rl $old | xargs sed -i "s/$old/$new/g" $file
}

function artprint()
{ 
  cat ~/.art/"$@" | lolcat
}

function multiprint()
{
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "$FUNCNAME needs 2 arguments"
    echo
    echo "Example"
    echo "'$FUNCNAME ? 3' returns"
    $FUNCNAME ? 3
    return 1
  elif [ -z `echo "$2" | grep -E ^\-?[0-9]?\.?[0-9]+$` ]; then 
    echo "$FUNCNAME needs a positive number for its second argument" 
    return 2
  fi
  
  printf `echo -n "%$2""s"` | sed "s/ /$1/g"; echo 
}

function cd()
{
  if [[ $# -ne 1 ]] ; then
      builtin cd "$@"
  elif [ "$1" = "-" ]; then
      builtin cd - >/dev/null
  else
      builtin cd "$( readlink -f "$1" )"
  fi
}

function banner1()
{
  if [ -z "$1" ]; then
    echo "$FUNCNAME needs at least 1 argument"
    return 1
  elif [ -n "$3" ] && [ -z `echo "$3" | grep -E ^\-?[0-9]?\.?[0-9]+$` ]; then 
    echo "$FUNCNAME needs a positive number for its third argument" 
    return 2
  fi
  
  line=${2:-'='}
  times=${3:-$COLUMNS}
  
  multiprint $line $times
  figlet -f standard -t $1
  multiprint $line $times
}

function banner2()
{
  if [ -z "$1" ]; then
    echo "$FUNCNAME needs at least 1 argument"
    return 1
  elif [ -n "$3" ] && [ -z `echo "$3" | grep -E ^\-?[0-9]?\.?[0-9]+$` ]; then 
    echo "$FUNCNAME needs a positive number for its third argument" 
    return 2
  fi
  
  readarray -t input <<< "$1"
  line=${2:-'='}
  times=${3:-$COLUMNS}
  half=$((times / 2))

  for i in "${input[@]}"; do
    banner=`multiprint $line $half`` echo "${i}" | tr -d "\n"``multiprint $line $half`
    while [ ${#banner} -ne $times ] && [ ${#banner} -ne $(($times+1)) ]; do
      banner=`echo "${banner:1:${#banner}-2}"`
    done
    if [ ${#banner} -eq $(($times+1)) ]; then
      banner=${banner::-1}
    fi
    echo "$banner"
  done
}

function banner3()
{
  if [ -z "$1" ]; then
    echo "$FUNCNAME needs at least 1 argument"
    return 1
  elif [ -n "$3" ] && [ -z `echo "$3" | grep -E ^\-?[0-9]?\.?[0-9]+$` ]; then 
    echo "$FUNCNAME needs a positive number for its third argument" 
    return 2
  fi
  
  input="$1"
  line=${2:-'='}
  times=${3:-$COLUMNS}

  banner2 "`banner1 \"$input\" $line $times`" $line $times
}

function launch()
{
  ( ( "$@" ) & disown ) >/dev/null 2>&1
}

function bashwatch()
{
  if [ `echo $1 | cut -c1-2` = '-n' ]; then
    num=${1:2}
    data="${*:2}"
  else
    num=
    data="$*";
  fi
  seconds=${num:-'1'}

  watch -n$seconds -d bash -ic \"$data\"
}
