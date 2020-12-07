# Notes for running SqueezeMeta CWL Workflows

## Invoking a CWL workflow
```
cwl-runner <cwl workflow script> <input parameter yml/json>
```
The first parameter is a valid cwl tool or workflow script.  In this directory, these have the extension __.cwl__.

The second parameter is YAML or JSON file consisting of input parameters for the CWL script.
In this directory, YAML examples are provided and are listed with the extension __.yml__.

Any additional command-line options must be provided before the "cwl tool/workflow script"
