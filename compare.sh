#!/bin/bash

# ./compare 061
# ./compare 735

N=${1}

if [ "${N}" == "061" ]; then
  ORIGIN=0
else
  if [ "${N}" == "735" ]; then
    ORIGIN=0100000
  else
    echo "??? " ${N}
  fi
fi

top=../faults
tu=${top}/src/tapeUtils/
as8=${top}/src/as8+/

# Preprocess
${as8}/as8pp < pas.${N}.alm > pas.${N}.s.tmp

# Assemble
${as8}/as8+ pas.${N}.s.tmp -o pas.${N}.oct

# Pack
${tu}/pack pas.${N}.oct pas.${N}.pck.tmp

# Compare original pack
cmp pas.${N} pas.${N}.pck.tmp

[ "$?" != "0" ] && ( \
${tu}/unpack $ORIGIN pas.${N} pas.${N}.oct.tmp; \
${tu}/unpack $ORIGIN pas.${N}.pck.tmp pas.${N}.pck.oct.tmp; \
xxdiff pas.${N}.oct.tmp pas.${N}.pck.oct.tmp \
)
