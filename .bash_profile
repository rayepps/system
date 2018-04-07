#
#    .bash_profile is run when a user initally logs into a bash shell session.
#    On MacOS we don't see this becuase the login is done automatically for us
#    but anytime you start the Terminal app for first time or use cmd+n to spawn
#    a new instance, MacOS logs you in. Each time this script will be run. When
#    opening a new tab (cmd+t) this script will not be run (you are already logged
#    in) only .bashrc will be run.
#

export PS1="\[\033[01;32m\]\u@\[\033[01;33m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')\e[m\e[m \[\033[1;36m\]\w\e[0m $ "

# Add java shit...i hate java...
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
export JAVA_HOME
export PATH=$PATH:$JAVA_HOME/bin
export PATH=/usr/local/bin:$PATH
export BOOST_ROOT=/usr/local/boost_1_58_0

# Add go bin for executing go packages in cli
export PATH=$PATH:/Users/raykrow/go/bin

# Add UtilityScripts to PATH
export PATH=$PATH:/Users/raykrow/UtilityScripts

function aliasi() {
    alias | sed 's/alias //g'
}

function funci() {
    cat ~/.bash_profile | grep '^function ' | sed 's/function //g' | sed 's/() {//g'
}

# Alias's (Aliasi?)
alias ls='ls -GalFh'
alias activate='source venv/bin/activate'
alias py='python'
alias dc='docker-compose' # NOTE: This overrides a built in `dc` command...its a little useless tho so who cares

# Docker alias's (Aliasi?)
alias dock-stop='docker stop $(docker ps -a -q)'
alias dock-rmc='docker rm $(docker ps -a -q)'
alias dock-rmi="docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi"
alias dock-rmv='docker volume prune'
alias dock-clean='dock-stop && dock-rmc && dock-rmi && dock-rmv'
alias dock-count='docker images >> /tmp/docker_images.txt && wc -l /tmp/docker_images.txt'
alias dock-port='echo "<host port>:<container port>"' # Becuase this is hard as fuck to remember...

# Setup bash completion package
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi

# bind history search to the arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Ensure ssh keys are added to agent
function ssh-add-all() {
  ssh-add -K ~/.ssh/zenimax/github_id_rsa
  ssh-add -K ~/.ssh/oakudo/oak_main.pem
}

function zip-pass() {
    FOLDER="${1}"
    zip -er "$FOLDER.zip" $FOLDER
}

function dock-exec() {
  DOCKER_CONTAINER_NAME_FILTER="_${1}_1"
  DOCKER_CONTAINER_ID=`docker ps -f "name=$DOCKER_CONTAINER_NAME_FILTER" -q`
  if [ "$DOCKER_CONTAINER_ID" == "" ]; then
    echo "No docker container with name containing ${1} found"
    return 1
  fi
  docker exec -it $DOCKER_CONTAINER_ID bash
}

function load_auto_env() {
  if test -f $PWD/appsettings.auto.env
  then
    echo "Loading appsettings.auto.env..."
    source $PWD/appsettings.auto.env
  fi
}

# Override `cd` command
function cd() {
  builtin cd "$@";
  load_auto_env
}

# Title shortcut function for naming terminal windows
function title() {
  echo -e "\033]0;${1:?please specify a title}\007" ;
}

# gtp: Go To Projects {{ project }} quickly cd to
# the project you want
function gtp() {

  DIR_ARG="${1}"
  PROJ_DIR=/Users/raykrow/Projects

  if [ "$DIR_ARG" == "" ]; then
    cd $PROJ_DIR
    return 1
  fi

  case $DIR_ARG in
	z)
		cd "$PROJ_DIR/Zenimax"
		;;
	v)
		cd "$PROJ_DIR/Verys"
		;;
  k)
		cd "$PROJ_DIR/Krow"
		;;
  o)
		cd "$PROJ_DIR/Oakudo"
		;;
	*)
		echo "Don't try that shit again! -_-"
		;;
  esac
}



function aws-use() {
  AWS_ACCOUNT="${1}"

  if [ "$AWS_ACCOUNT" == "" ]; then
    echo "ERROR: Must specify an account"
    return 1
  fi

  case $AWS_ACCOUNT in
  zenimax)
    cp ~/.aws/zenimax/credentials ~/.aws/credentials
    cp ~/.aws/zenimax/config ~/.aws/config
    ;;
  oakudo)
    cp ~/.aws/oakudo/credentials ~/.aws/credentials
    cp ~/.aws/oakudo/config ~/.aws/config
    ;;
  raykrow)
    cp ~/.aws/raykrow/credentials ~/.aws/credentials
    cp ~/.aws/raykrow/config ~/.aws/config
    ;;
  *)
    echo "Don't try that shit again! -_-"
    ;;
  esac

}


function aws-docker-login() {
  aws-account
  read -p "Continue (y/n):" should_continue
  if [ "$should_continue" = "y" ]; then
    echo "Logging in..."
    $(aws ecr get-login --no-include-email)
  fi
}


function aws-account() {
  echo `head -n 1 ~/.aws/credentials`
}

function aws-ssh() {

  AWS_ADDRESS="${1}"

  if [ "$AWS_ADDRESS" == "" ]; then
    echo "ERROR: Need an address to connect to"
    return 1
  fi

  AWS_ACCOUNT=`head -n 1 ~/.aws/credentials`
  AWS_KEY_PAIR=""
  AWS_USERNAME=""

  if [[ $AWS_ACCOUNT = *"raykrow"* ]]; then
    AWS_USERNAME="ec2-user"
    AWS_KEY_PAIR="oakudo_ecs_kp"
  elif [[ $AWS_ACCOUNT = *"zenimax"* ]]; then
    AWS_USERNAME="ray.krow"
    AWS_KEY_PAIR="zenimax_bastion_id_rsa"
  fi

  if [ "$AWS_KEY_PAIR" == "" ]; then
    echo "ERROR: Unknown account"
    return 1
  fi

  ssh -i ~/.ssh/$AWS_KEY_PAIR.pem $AWS_USERNAME@$AWS_ADDRESS

}


# Load .bashrc if it exists
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi



















# End
