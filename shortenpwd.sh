MAX_PWD_LENGTH=30
function shorten_pwd
{
    # This function ensures that the PWD string does not exceed $MAX_PWD_LENGTH characters
    PWD=$(pwd)

    # determine part of path within HOME, or entire path if not in HOME
    RESIDUAL=${PWD#$HOME}

    # compare RESIDUAL with PWD to determine whether we are in HOME or not
    if [ X"$RESIDUAL" != X"$PWD" ]
    then
        PREFIX="~"
    fi

    # check if residual path needs truncating to keep total length below MAX_PWD_LENGTH
    NORMAL=${PREFIX}${RESIDUAL}
    if [ ${#NORMAL} -ge $(($MAX_PWD_LENGTH)) ]
    then
        newPWD=${PREFIX}
        OIFS=$IFS
        IFS='/'
        bits=$RESIDUAL
        for x in $bits
        do
            if [ ${#x} -ge 3 ]
            then
                NEXT="/${x:0:1}"
            else
                NEXT="$x"
            fi
            newPWD="$newPWD$NEXT"
        done

        IFS=$OIFS
    else
        newPWD=${PREFIX}${RESIDUAL}
    fi

    # return to caller
    echo $newPWD
}

$(shorten_pwd)
