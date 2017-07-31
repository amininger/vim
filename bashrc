# Expecting you to define the following environment variable:
# $MY_VIM_DIR

export VIMRC="$MY_VIM_DIR/.vimrc"
export PYTHONPATH=$PYTHONPATH:$MY_VIM_DIR/soar_plugin/pylib

alias vim="vim -u $VIMRC"


