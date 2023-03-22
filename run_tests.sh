#!/bin/bash -l
#
# Run all hpc-software-tests in Aalto Triton cluster
#

CONF=hpc_tests/aalto.yaml

usage(){
  cat << EOF
usage: run_tests.sh [options]

general:
  -c, --conf            Use a specific configuration YAML.
  -d, --dev             Use development tests instead of
                        production ones.
  -l, --list            List available tests.
  -k, --keyword         Run tests based on keyword.
                        E.g. "-k anaconda_2022-01".
  -t, --test            Run a specific test suite.
  -h, --help            
EOF
  exit 0
}

for ARG in "$@"
do
case $ARG in
  -c|--conf)
  CONF=$2
  shift
  shift
  ;;
  -d|--dev)
  CONF=hpc_tests/aalto_dev.yaml
  shift
  ;;
  -h|--help)
  usage
  shift
  ;;
  -l|--list)
  LIST_TESTS=1
  shift
  ;;
  -k|--keyword)
  KEYWORD_ARG="-k $2"
  shift
  shift
  ;;
  -t|--test)
  TEST_ARG="--tests=$2"
  shift
  shift
  ;;
esac
done

module load anaconda

if [[ ! -z "$LIST_TESTS" ]]; then
  pytest --collect-only --conf $CONF 
  exit $?
fi

OUTPUTFILE=aalto-$(date -Iminutes).out

echo "Running tests with the following command:" |& tee $OUTPUTFILE
echo "pytest --color=yes --tb=line -v -s --conf $CONF $KEYWORD_ARG $TEST_ARG" |& tee -a aalto-$(date -Iminutes).out
pytest -s --color=yes --tb=line -v --conf $CONF $KEYWORD_ARG $TEST_ARG |& tee -a aalto-$(date -Iminutes).out
