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

# Sample custom env. var., defined in standingbear.prologue.sh :
#Environment=( "${Environment[@]}" GIT_PROJECTS_ROOT )

## Sybase ASE 15.x :
#SYBASE=${SYBASE:-/opt/sybase}
#SYBASE_OCS=${SYBASE_OCS:-OCS-15_0}
#DSQUERY=${DSQUERY:-}

# From time to time I have to set it for dl to resolve Sybase libsyb*64.so, e.g. :
#    « Cannot load /opt/php-5.3.23/lib/libphp5.so into server:
#        libsybunic64.so: cannot open shared object file: No such file or directory »
#pathprepend "$SYBASE/$SYBASE_OCS/lib" LD_LIBRARY_PATH

#Environment=( "${Environment[@]}" SYBASE SYBASE_OCS DSQUERY )

