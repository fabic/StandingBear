#
# standingbear.prologue.sh
#
# This file is sourced *late* by standingbear.sh, further
# environment configuration may be done here, such as adding
# custom environment variable names to the $Environment bash array that
# depend on processing done by standingbear.sh
#
# Note that the best place for defining environment is still standingbear.prologue.sh
# so that customization be mainly kept in one place.
#

## Sample custom env. var. defined here :
#My_Late_Custom_Var=`php --version|head -n1|tr ' ' _ `
## That env. var. may eventually be passed to Apache by adding it to the Environment
## bash array :
#Environment=( "${Environment[@]}" My_Late_Custom_Var )



