from setuptools import setup, find_packages

import dabdemo

setup(
  name = "dabdemo",
  version = dabdemo.__version__,
  author = dabdemo.__author__,
  url = "https://github.com/panfilenok-epam/azure-databricks-dp",
  author_email = "alexander_panfilenok@epam.com",
  description = "Sample Databricks project",
  packages = find_packages(include = ["dabdemo"]),
  entry_points={"my_entry_point": "run=dabdemo.__main__:main"},
  install_requires = ["setuptools"]
)