#!/bin/bash -ex



EOS_DIR="/eos/user/j/jprendi/test_out"

# List files matching the pattern and construct the inputFiles argument
INPUT_FILES=$(ls "$EOS_DIR"/output_HLT_*.root | awk '{print "file:"$0}' | paste -sd, -)


cmsRun DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py inputFiles=$INPUT_FILES >& dqmclient_HLT.log
