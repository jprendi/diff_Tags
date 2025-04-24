#!/bin/bash -ex


# we loop over the files with a step of 10, s.t. the output file is not too big

for i in {0..0}; do
    FILEINPUT_TEMPLATE=$(awk -v iter="$i" 'NR % 10 == iter' fileList_509.txt | tr -d '\r' | tr '\n' ',' | sed 's/,$//')


    hltGetConfiguration /dev/CMSSW_14_1_0/GRun \
       --globaltag 141X_dataRun3_HLT_v2 \
       --data \
       --unprescale \
       --output minimal \
       --max-events 10000 \
       --eras Run3_2024 --l1-emulator uGT --l1 L1Menu_Collisions2024_v1_3_0_xml \
       --input "$FILEINPUT_TEMPLATE" \
       > hltData_PedLC_${i}.py

    cat <<@EOF >> hltData_PedLC_${i}.py

process.GlobalTag.toGet = cms.VPSet(
  cms.PSet(record = cms.string("EcalPedestalsRcd"),
           tag = cms.string("EcalPedestals_prompt"),
           connect = cms.string("frontier://FrontierProd/CMS_CONDITIONS")
          )
)
process.GlobalTag.toGet = cms.VPSet(
  cms.PSet(record = cms.string("EcalLaserAPDPNRatiosRcd"),
           tag = cms.string("EcalLaserAPDPNRatios_prompt_v3"),
           connect = cms.string("frontier://FrontierProd/CMS_CONDITIONS")
          )
)

process.hltOutputMinimal.outputCommands = [
    'drop *',
    'keep GlobalObjectMapRecord_hltGtStage2ObjectMap_*_HLTX',
    'keep edmTriggerResults_*_*_HLTX',
    'keep triggerTriggerEvent_*_*_HLTX' 
]


process.options.numberOfThreads = 96
process.options.numberOfStreams = 96
@EOF

    cmsRun hltData_PedLC_${i}.py >& hltData_PedLC_${i}.log

done

