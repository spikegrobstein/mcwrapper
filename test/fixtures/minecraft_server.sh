#! /bin/bash -

echo "Staring up a faux Minecraft Server!"

INPUT=""

while [[ "$INPUT" != 'stop' ]]; do
  read -p '> ' INPUT

  echo You typed: $INPUT
done

echo -n Exiting...

sleep 3

echo "Bye!"

