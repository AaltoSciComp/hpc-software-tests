import os
import sys
import time
import socket
import warnings
import pytest

with warnings.catch_warnings():
    warnings.filterwarnings("ignore",category=DeprecationWarning)
    import sh
    from packaging.version import Version
    if Version(sh.__version__) >= Version('2.0.0'):
        sh = sh.bake(_return_cmd=True)

@pytest.fixture
def local_script():
    # Fixture for the script name
    return None

@pytest.fixture
def local_module():
    # Fixture for the module name
    return None

@pytest.fixture
def local_skip():
    # Fixture for the test skip
    return None

@pytest.fixture
def local_environment():
    # Fixture for the environment variables
    return None

@pytest.fixture
def local_extra_modules():
    # Fixture for the extra modules
    return None

def test_local(local_script,
               local_module,
               local_skip,
               local_extra_modules,
               local_environment):

    # Fail if any of the arguments is missing
    assert local_script is not None
    assert local_module is not None
    assert local_skip is not None

    # Get path to this file
    test_path =  os.path.dirname(os.path.realpath(__file__))

    # Get the path to the script relative to this file
    script_realpath = os.path.realpath(os.path.join(
        test_path, '..', local_script))

    # Split the script folder and script name
    script_folder, script_name = os.path.split(script_realpath)

    timestamp = time.strftime("%Y-%m-%d_%H:%M:%S")
    hostname = socket.gethostname().split('.')[0]
    output_file = os.path.join(script_folder, f"{hostname}_{timestamp}.out")

    print('Running script "%s" in folder "%s"' % (script_name, script_folder))

    # Determine command line arguments for local
    args = []

    args.append(script_name)
    if local_extra_modules is not None:
        args.extend(local_extra_modules)
    args.append(local_module)

    print('Running command: "bash %s"' % (' '.join(args)))

    env = os.environ.copy()

    if local_environment is not None:
        env.update(local_environment)

    if not local_skip:
        # Run script through bash, check that exit code is 0
        try:
            with warnings.catch_warnings():
                warnings.filterwarnings("ignore",category=DeprecationWarning)
                cmd_output = sh.bash(*args,
                                     _cwd=script_folder,
                                     _env=env,
                                     _out=output_file,
                                     _err_to_out=True)
        except sh.ErrorReturnCode as error:
            print('Error encountered during script run!')
            with open(output_file, 'r') as local_output:
                print(local_output.read())
            raise AssertionError("Exit code was not zero'")

        print('Output:')
        with open(output_file, 'r') as local_output:
            print(local_output.read())

    else:
        pytest.skip('Skipping the test due to config.')
