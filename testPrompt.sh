#!/bin/bash -ex


# we loop over the files with a step of 20, s.t. the output file is not too big

for i in {0..19}; do
    FILEINPUT_TEMPLATE=$(awk -v iter="$i" 'NR % 20 == iter' fileList_509.txt | tr -d '\r' | tr '\n' ',' | sed 's/,$//')


# downloads the trigger menu from confDB and creates a config python file

    hltGetConfiguration /dev/CMSSW_14_1_0/GRun \
       --globaltag 141X_dataRun3_Prompt_v3 \
       --data \
       --unprescale \
       --output minimal \
       --max-events -1 \
       --eras Run3_2024 --l1-emulator uGT --l1 L1Menu_Collisions2024_v1_3_0_xml \
       --input "$FILEINPUT_TEMPLATE" \
       > hltData_Prompt_${i}.py


# this part defines which objects we want to keep (correlates w what DQM clients wants as an input)
    cat <<@EOF >> hltData_Prompt_${i}.py

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

process.hltOnlineBeamSpotESProducer.timeThreshold = 0

# set number of concurrent threads and events (CMSSW streams)
process.options.numberOfThreads = 96
process.options.numberOfStreams = 96

del process.MessageLogger
process.load('FWCore.MessageLogger.MessageLogger_cfi')
@EOF

# running HLT with the config file we created above

    cmsRun hltData_Prompt_${i}.py >& hltData_Prompt_${i}.log
    mv output.root output_Prompt_${i}.root 

done

