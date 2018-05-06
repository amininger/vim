let $PYTHONPATH.=":".$MY_VIM_DIR."/soar_plugin/pylib:".$SOAR_HOME

" Contains general soar utility functions
so $MY_VIM_DIR/soar_plugin/util.vim

" Contains functions for parsing soar rules
so $MY_VIM_DIR/soar_plugin/parsing.vim

" Contains functions for inserting rule templates
so $MY_VIM_DIR/soar_plugin/templates.vim

" Contains functions for running a soar agent within vim
so $MY_VIM_DIR/soar_plugin/debugger.vim

" Contains rosie-specific functionality
so $MY_VIM_DIR/soar_plugin/rosie.vim

" Contains key mappings for soar functions
so $MY_VIM_DIR/soar_plugin/mappings.vim

