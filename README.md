# Lintorix

**Lintorix** is a powerful and easy-to-use batch script for performing static analysis on Python files using Pylint, Flake8, and mypy. This script simplifies the process of analyzing Python code, whether you need to analyze all files in a directory or just a few selected files through drag-and-drop.

## Purpose

Lintorix is designed to support AI-aided coding, particularly in refactoring processes involving complex files and larger Python projects. By generating detailed lint reports, Lintorix helps developers maintain code quality and identify potential issues early, enabling more efficient and reliable AI-driven code refactoring.

## Features

### 1. Double-Click Mode
- **Functionality:** Analyze all Python files in the current directory.
- **Output:** The results are saved in a single file named `TIMESTAMP_FOLDERNAME_lintresults.txt`.
- **Example:** If the script is run in a folder named `MyProject` on August 17, 2024, at 21:45:35, the output file will be named `20240817214535_MyProject_lintresults.txt`.

### 2. Drag-and-Drop Mode
- **Functionality:** Analyze individual Python files by dragging them onto the script.
- **Output:** Each file is analyzed separately, and the results are saved in files named `FILENAME_TIMESTAMP_lintresults.txt`.
- **Example:** Dragging a file named `example.py` onto the script on August 17, 2024, at 21:45:35, will create an output file named `example.py_20240817214535_lintresults.txt`.

## Getting Started

### Prerequisites
Ensure you have Python installed with the following packages:
- `pylint`
- `flake8`
- `mypy`

You can install these packages via pip:

```bash
pip install pylint flake8 mypy
