# it-tools

A collection of IT utility tools.

## Environment Variables Tool

### printenv.sh

This script executes the `printenv` command in bash to display all environment variables in your system and saves them to a text file.

#### Usage

```bash
./printenv.sh
```

#### Description

The script will:
- Display all environment variables from your current environment to the console
- Save all environment variables to `environment_variables.txt`
- Show a count of total environment variables
- Format the output with clear headers and footers
- Include a timestamp in the saved file

#### Requirements

- Bash shell
- Execute permissions (the script is already executable)

#### Example Output

```
===================================
Environment Variables
===================================

SHELL=/bin/bash
USER=runner
PATH=/usr/local/bin:/usr/bin:/bin
...

===================================
Total environment variables: 144
===================================
```