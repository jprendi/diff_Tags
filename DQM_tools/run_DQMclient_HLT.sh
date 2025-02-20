#!/bin/bash -ex

INPUT_FILES=$(find diff_Tags -type f -name '/eos/user/j/jprendi/test_out/output_HLT*.root' | paste -sd, -)

# Run the cmsRun command with the constructed inputFiles list
cmsRun DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=$INPUT_FILES >& dqmclient_HLT.log
