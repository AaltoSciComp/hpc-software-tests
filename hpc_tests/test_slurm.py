import os
import sys
import warnings
import pytest

with warnings.catch_warnings():
    warnings.filterwarnings("ignore",category=DeprecationWarning)
    from sh import sbatch, ErrorReturnCode

@pytest.fixture
def sbatch_script():
    # Fixture for the sbatch script name
    return None

@pytest.fixture
def sbatch_module():
    # Fixture for the sbatch module name
    return None

@pytest.fixture
def sbatch_requirements():
    # Fixture for the sbatch requirements
    return None

@pytest.fixture
def sbatch_skip():
    # Fixture for the sbatch skip
    return None

@pytest.fixture
def sbatch_environment():
    # Fixture for the sbatch environment variables
    return None

@pytest.fixture
def sbatch_extra_args():
    # Fixture for the sbatch extra args
    return None

@pytest.fixture
def sbatch_extra_modules():
    # Fixture for the sbatch extra modules
    return None

def test_sbatch(sbatch_script,
                sbatch_module,
                sbatch_requirements,
                sbatch_skip,
                sbatch_extra_modules,
                sbatch_extra_args,
                sbatch_environment):

    # Fail if any of the arguments is missing
    assert sbatch_script is not None
    assert sbatch_requirements is not None
    assert sbatch_module is not None
    assert sbatch_skip is not None

    # Get path to this file
    test_path =  os.path.dirname(os.path.realpath(__file__))

    # Get the path to the script relative to this file
    script_realpath = os.path.realpath(os.path.join(
        test_path, '..', sbatch_script))

    # Split the script folder and script name
    script_folder, script_name = os.path.split(script_realpath)

    print('Running script "%s" in folder "%s"' % (script_name, script_folder))

    # Determine command line arguments for sbatch
    args = ['--wait', '--output=%j.out', '--parsable']
    for key, value in sbatch_requirements.items():
        args.append('--%s=%s' % (key,value))

    if sbatch_extra_args:
        extra_args = sbatch_extra_args.split(' ')
        args.extend(extra_args)

    args.append(script_name)
    if sbatch_extra_modules is not None:
        args.extend(sbatch_extra_modules)
    args.append(sbatch_module)

    print('Running command: "sbatch %s"' % (' '.join(args)))

    env = os.environ.copy()

    if sbatch_environment is not None:
        env.update(sbatch_environment)

    if not sbatch_skip:
        # Run script through Slurm, check that exit code is 0
        try:
            sbatch_output = sbatch(*args, _cwd=script_folder, _env=env)
        except ErrorReturnCode as error:
            print('Error encountered during script run!')
            sbatch_output = error
        
        assert sbatch_output.exit_code == 0, \
            "Exit code was not zero'"

        print('Output:')
        output_file = os.path.join(script_folder, '%s.out' % str(sbatch_output.splitlines()[0]))
        with open(output_file, 'r') as sbatch_output:
            print(sbatch_output.read())

    else:
        pytest.skip('Skipping the test due to config.')
