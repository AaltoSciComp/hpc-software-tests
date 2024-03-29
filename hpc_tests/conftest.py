import os
import pytest
from yaml import load
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader

SCRIPT_PATH =  os.path.dirname(os.path.realpath(__file__))

def pytest_addoption(parser):
    parser.addoption(
        "--conf",
        action="store",
        default=os.path.join(SCRIPT_PATH,"aalto.yaml"),
        help="Configuration file to use")
    parser.addoption(
        "--tests",
        action="store",
        default=None,
        help="Tests to run")


def pytest_generate_tests(metafunc):
    # Read config
    conf_file = metafunc.config.getoption("conf")
    with open(conf_file, "r") as conf_stream:
        conf = load(conf_stream, Loader=Loader)

    # Check whether limited number of tests have been set
    run_all = False
    tests = metafunc.config.getoption("tests")

    if tests is None:
        run_all = True
        tests = ''

    # Split tests-argument
    test_categories = tests.split(',')

    # Read global section
    global_requirements = conf.get('global', {}).get('requirements', {})
    global_extra_modules = conf.get('global', {}).get('extra_modules', [])
    local_run = conf.get('global', {}).get('localrun', False)

    if "sbatch_script" in metafunc.fixturenames:
        if local_run:
            conf = pytest.skip("Skipping sbatch tests")
            metafunc.parametrize(conf)
        parameters = []
        ids = []
        for test_name, test_conf in conf["tests"].items():
            # Generate test category
            test_category = test_name.split("_")[0]

            # Deal with sbatch tests
            # Determine script
            sbatch_script = test_conf["script"]
            # Determine Slurm requirements
            sbatch_requirements = global_requirements.copy()
            sbatch_requirements.update(test_conf["requirements"])
            # Determine whether test should be skipped
            skip = test_conf.get("skip", False)
            if test_category not in test_categories and not run_all:
                skip = True
            # Determine extra modules
            extra_modules = test_conf.get("extra_modules", [])
            # Add global modules
            extra_modules = global_extra_modules + extra_modules
            # Determine extra environment variables
            environment = test_conf.get('environment', None)

            # Create parameters for each module we want to test
            parameters.extend([
                (sbatch_script,
                 module_name,
                 sbatch_requirements,
                 skip,
                 extra_modules,
                 environment) for module_name in test_conf["modules"]
            ])
            # Create id for each test
            ids.extend([
            '{0}-{1}'.format(test_name, module_name.replace('/', '_')) for module_name in test_conf["modules"]
            ])
        # Set test parameters and name
        metafunc.parametrize((
            "sbatch_script,"
            "sbatch_module,"
            "sbatch_requirements,"
            "sbatch_skip,"
            "sbatch_extra_modules,"
            "sbatch_environment"), parameters, ids=ids)

    if "local_script" in metafunc.fixturenames:
        if not local_run:
            conf = pytest.skip("Skipping local tests")
            metafunc.parametrize(conf)
        parameters = []
        ids = []
        for test_name, test_conf in conf["tests"].items():
            # Generate test category
            test_category = test_name.split("_")[0]

            # Deal with sbatch tests
            # Determine script
            local_script = test_conf["script"]
            # Determine whether test should be skipped
            local_skip = test_conf.get("skip", False)
            if test_category not in test_categories and not run_all:
                local_skip = True
            # Determine extra modules
            extra_modules = test_conf.get("extra_modules", [])
            # Add global modules
            extra_modules = global_extra_modules + extra_modules
            # Determine extra environment variables
            environment = test_conf.get('environment', None)

            # Create parameters for each module we want to test
            parameters.extend([
                (local_script,
                 module_name,
                 local_skip,
                 extra_modules,
                 environment) for module_name in test_conf["modules"]
            ])
            # Create id for each test
            ids.extend([
            '{0}-{1}'.format(test_name, module_name.replace('/', '_')) for module_name in test_conf["modules"]
            ])
        # Set test parameters and name
        metafunc.parametrize((
            "local_script,"
            "local_module,"
            "local_skip,"
            "local_extra_modules,"
            "local_environment"), parameters, ids=ids)
