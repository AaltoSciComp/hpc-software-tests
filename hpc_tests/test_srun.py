import os
import sys
import warnings
import pytest

with warnings.catch_warnings():
    warnings.filterwarnings("ignore",category=DeprecationWarning)
    from sh import srun, ErrorReturnCode

@pytest.fixture
def srun_script():
    # Fixture for the srun script name
    return None

@pytest.fixture
def srun_module():
    # Fixture for the srun module name
    return None

@pytest.fixture
def srun_requirements():
    # Fixture for the srun requirements
    return None

@pytest.fixture
def srun_skip():
    # Fixture for the srun requirements
    return None

def test_srun(srun_script, srun_module, srun_requirements, srun_skip):

    # Fail if any of the arguments is missing
    assert srun_script is not None
    assert srun_module is not None
    assert srun_requirements is not None
    assert srun_skip is not None

    # Get path to this file
    test_path =  os.path.dirname(os.path.realpath(__file__))

    # Get the path to the script relative to this file
    script_realpath = os.path.realpath(os.path.join(
        test_path, '..', srun_script))

    # Split the script folder and script name
    script_folder, script_name = os.path.split(script_realpath)

    print('Running script "%s" in folder "%s"' % (script_name, script_folder))

    # Determine command line arguments for srun
    args = []
    for key, value in srun_requirements.items():
        args.append('--%s=%s' % (key,value))
    args.extend(['bash', script_name, srun_module])

    print('Running command: "srun %s"' % (' '.join(args)))

    if not srun_skip:
        # Run script through Slurm, check that exit code is 0
        try:
            srun_output = srun(*args, _cwd=script_folder, _out=sys.stdout, _err=sys.stderr)
        except ErrorReturnCode as error:
            print('Error encountered during script run!')
            srun_output = error
        
        assert srun_output.exit_code == 0, \
            "Exit code was not zero'"

    else:
        pytest.skip('Skipping the test due to config')
