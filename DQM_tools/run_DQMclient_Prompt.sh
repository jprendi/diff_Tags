#!/bin/bash -ex

INPUT_FILES=$(find diff_Tags -type f -name 'diff_Tags/output_Prompt*.root' | paste -sd, -)

# Run the cmsRun command with the constructed inputFiles list
cmsRun DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=$INPUT_FILES >& dqmclient_Prompt.log
