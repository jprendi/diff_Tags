#!/bin/bash -ex

hltGetConfiguration /dev/CMSSW_14_1_0/GRun \
   --globaltag GLOBALTAG_TEMPLATE \
   --data \
   --output minimal \
   --max-events -1 \
   --eras Run3_2024 --l1-emulator uGT --l1 L1Menu_Collisions2024_v1_3_0_xml \
   --input FILEINPUT_TEMPLATE  > hltData.py

cat <<@EOF >> hltData.py

## put here the output commands of the OnlineMonitor PD
process.hltOutputMinimal.outputCommands = [
    'drop *',
    'keep GlobalObjectMapRecord_hltGtStage2ObjectMap_*_*',
    'keep edmTriggerResults_*_*_*',
    'keep triggerTriggerEvent_*_*_*' 
]

# set the process parameters
process.options.numberOfConcurrentLuminosityBlocks = 2      # default: 2
process.options.numberOfStreams = 96                       
process.options.numberOfThreads = 96                        

@EOF

edmConfigDump hltData.py > config.py

