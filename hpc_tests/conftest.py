import pytest
from yaml import load
try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader


def pytest_addoption(parser):
    parser.addoption("--conf", action="store", default="aalto.yaml", help="Configuration file to use")
    parser.addoption("--tests", action="store", default=None, help="Tests to run")


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

    if "sbatch_script" in metafunc.fixturenames:
        parameters = []
        ids = []
        for test_name, test_conf in conf["tests"].items():
            # Generate test category
            test_category = test_name.split("_")[0]

            # Deal with sbatch tests
            # Determine script
            sbatch_script = test_conf["script"]
            # Determine Slurm requirements
            sbatch_requirements = test_conf["requirements"]
            # Determine whether test should be skipped
            sbatch_skip = test_conf.get("skip", False)
            if test_category not in test_categories and not run_all:
                sbatch_skip = True
            # Determine extra modules
            sbatch_extra_modules = test_conf.get("extra_modules", None)

            # Create parameters for each module we want to test
            parameters.extend([
                (sbatch_script,
                 module_name,
                 sbatch_requirements,
                 sbatch_skip,
                 sbatch_extra_modules) for module_name in test_conf["modules"]
            ])
            # Create id for each test
            ids.extend([
            '{0}-{1}'.format(test_name, module_name.replace('/', '_')) for module_name in test_conf["modules"]
            ])
        # Set test parameters and name
        metafunc.parametrize("sbatch_script,sbatch_module,sbatch_requirements,sbatch_skip,sbatch_extra_modules", parameters, ids=ids)
