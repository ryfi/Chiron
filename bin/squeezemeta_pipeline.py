#!/usr/bin/env python3

"""
Invoke a CWL Squeezemeta workflow
Code adapted from work originally done by Shaun Adkins (sadkins@som.umaryland.edu)

"""

import logging
import os
import subprocess
import sys
from argparse import ArgumentParser

import yaml

CWL_WORKFLOW = os.path.dirname(os.path.realpath(sys.path[0])) + "/pipelines/squeezemeta/squeezemeta_all_args_coassembly.cwl"
CWL_WORKFLOW_JOIN = os.path.dirname(os.path.realpath(sys.path[0])) + "/pipelines/squeezemeta/squeezemeta_all_args_coassembly.cwl"


########
# Main #
########

def main():
    # Set up options parser and help statement
    parser = ArgumentParser(description="Invoke a Squeezemeta pipeline using the Common Workflow Language")
    parser.add_argument("--input_file_list", "-i",
                        help="List file containing paths to input samples",
                        metavar="/path/to/test.samples",
                        required=True)
    parser.add_argument("--config_file", "-c",
                        help="YAML-based config file of parameters to add",
                        metavar="/path/to/config.yml",
                        required=True)
    parser.add_argument("--out_dir",
                        "-o",
                        help="Optional. Directory to stage output files.  Default is ./cwl_output",
                        metavar="/path/to/outdir",
                        default="./cwl_output")
    parser.add_argument("--debug", "-d",
                        help="Set the debug level",
                        default="ERROR",
                        metavar="DEBUG/INFO/WARNING/ERROR/CRITICAL")
    args = parser.parse_args()
    check_args(args)

    yaml_dict = read_config(args.config_file)
    inputs = read_in_list(args.input_file_list)
    add_input_files_to_yaml(yaml_dict, inputs)

    # Path for data output by Squeezemeta
    yaml_dict['input_dir'] = {'class': 'Directory', 'path': args.out_dir}

    # Write out YAML
    final_yaml = create_final_yaml_name(args.config_file)
    write_final_yaml(yaml_dict, final_yaml)

    # Invoke CWL with new YAML job input
    run_cwl_command(args.out_dir, final_yaml, CWL_WORKFLOW)


def check_args(args):
    """ Validate the passed arguments """
    log_level = args.debug.upper()
    num_level = getattr(logging, log_level)

    # Verify that our specified log_level has a numerical value associated
    if not isinstance(num_level, int):
        raise ValueError('Invalid log level: %s' % log_level)

    # Create the logger
    logging.basicConfig(level=num_level)


def read_config(yaml_in):
    """ Convert YAML config file into dictionary """
    with open(yaml_in) as f:
        return yaml.safe_load(f)


def read_in_list(list_in):
    """ Convert list file into list object """
    file_list = [line.rstrip('\n') for line in open(list_in)]
    return file_list


def add_input_files_to_yaml(yaml_dict, inputs):
    """ Join the list of input files into the existing YAML dictionary """
    yaml_dict['input_file'] = list()
    for i in inputs:
        # Add the sequence to the YAML dict
        input_dict = {'class': 'File', 'path': i}
        yaml_dict['input_file'].append(input_dict)


def create_final_yaml_name(orig_yaml_name):
    """ Use YAML template to create final file name """
    orig_file_base = os.path.basename(orig_yaml_name)
    name_root = os.path.splitext(orig_file_base)[0]
    final_yaml_name = name_root + ".final.yml"  # NOTE: Will write to current directory
    return final_yaml_name


def write_final_yaml(yaml_dict, out_yaml):
    """ Write out the final YAML """
    with open(out_yaml, "w") as f:
        yaml.dump(yaml_dict, f)


def run_cwl_command(outdir, job_input, workflow):
    """ Create and run the CWL-runner job """
    tmp_dir = get_tmpdir()
    cwl_cmd = "cwl-runner --tmp-outdir-prefix=tmp_out --tmpdir-prefix={3} --outdir={0} {1} {2}".format(outdir, workflow, job_input, tmp_dir)
    # https://stackoverflow.com/questions/4417546/constantly-print-subprocess-output-while-process-is-running
    with subprocess.Popen(cwl_cmd,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT,
                          shell=True) as p:
        for line in p.stdout:
            print(line.decode(), end='')
    if p.returncode != 0:
        raise subprocess.CalledProcessError(p.returncode, p.args)


def get_tmpdir():
    """ Determine where to write tmp files"""
    base_dir = "/opt"
    if not os.path.exists("/opt") or not os.access('/opt', os.W_OK):
        base_dir = "."
    tmp_dir = base_dir + "/tmp"
    return tmp_dir


if __name__ == '__main__':
    main()
    sys.exit(0)
