#!/bin/bash -ex

# Read the file list, remove trailing commas, and join into a comma-separated string
#FILEINPUT_TEMPLATE=$(tr -d '\r' < fileList.txt | tr '\n' ',' | sed 's/,$//')
FILEINPUT_TEMPLATE=$(awk 'NR % 20 == 0' fileList.txt | tr -d '\r' | tr '\n' ',' | sed 's/,$//')


hltGetConfiguration /dev/CMSSW_14_1_0/GRun \
   --globaltag 141X_dataRun3_Prompt_v3 \
   --data \
   --unprescale \
   --output minimal \
   --max-events 1000 \
   --eras Run3_2024 --l1-emulator uGT --l1 L1Menu_Collisions2024_v1_3_0_xml \
   --input "$FILEINPUT_TEMPLATE" \
   > hltData_Prompt_0.py


cat <<@EOF >> hltData_Prompt_0.py

## put here the output commands of the 
process.hltOutputMinimal.outputCommands = [
    'drop *',
    'keep *_hltDoubletRecoveryPFlowTrackSelectionHighPurity_*_*',
    'keep *_hltEcalRecHit_*_*',
    'keep *_hltEgammaCandidates_*_*',
    'keep *_hltEgammaGsfTracks_*_*',
    'keep *_hltGlbTrkMuonCandsNoVtx_*_*',
    'keep *_hltHbhereco_*_*',
    'keep *_hltHfreco_*_*',
    'keep *_hltHoreco_*_*',
    'keep *_hltIter0PFlowCtfWithMaterialTracks_*_*',
    'keep *_hltIter0PFlowTrackSelectionHighPurity_*_*',
    'keep *_hltL3NoFiltersNoVtxMuonCandidates_*_*',
    'keep *_hltMergedTracks_*_*',
    'keep *_hltPFMuonMerging_*_*',
    'keep *_hltOnlineBeamSpot_*_*',
    'keep *_hltPixelTracks_*_*',
    'keep *_hltPixelVertices_*_*',
    'keep *_hltSiPixelClusters_*_*',
    'keep *_hltSiStripRawToClustersFacility_*_*',
    'keep *_hltTrimmedPixelVertices_*_*',
    'keep *_hltVerticesPFFilter_*_*',
    'keep FEDRawDataCollection_rawDataCollector_*_*',
    'keep GlobalObjectMapRecord_hltGtStage2ObjectMap_*_HLTX',
    'keep edmTriggerResults_*_*_HLTX',
    'keep triggerTriggerEvent_*_*_HLTX' 
]

# set number of concurrent threads and events (CMSSW streams)
process.options.numberOfThreads = 96
process.options.numberOfStreams = 96

del process.MessageLogger
process.load('FWCore.MessageLogger.MessageLogger_cfi')
@EOF

cmsRun hltData_Prompt_0.py >& hltData_Prompt_0.log
mv output.root output_Prompt_0.root 
