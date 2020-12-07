#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: Squeezemeta - Run Squeezemeta tool
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: umigs/chiron-humann2

inputs:
  mode:
    label: Either sequential, coassembly, or merged (REQUIRED)
    inputBinding:
      prefix: -m
    type: string
  project:
    label: Project name, (REQUIRED for coassembly and merged modes)
    inputBinding:
      prefix: -p
    type: string
  samples_file:
    label: Samples file listing all file names expected as input (REQUIRED) It has the format: <Sample> <filename> <pair1|pair2>. A fourth optional column can take the noassembly value, indicating that these sample must not be assembled with the rest (but will be mapped against the assembly to get abundances).
    inputBinding:
      prefix: -s
    type: File
  sequence_file_path:
    label: Path to directory containing FASTQ files (REQUIRED)
    inputBinding:
      prefix: -f
    type: string


baseCommand: ["squeezemeta"]
