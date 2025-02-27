#!/bin/bash



hltGetConfiguration /dev/CMSSW_14_1_0/GRun \
--globaltag 141X_dataRun3_HLT_v2 \
--input file:/eos/cms/store/data/Run2024I/EphemeralHLTPhysics6/RAW/v1/000/386/804/00000/a60c771e-6075-4452-8dae-d09bd2c146f9.root  \
--max-events 1000 \
--output none \
--eras Run3_2024 \
--l1-emulator uGT --l1 L1Menu_Collisions2024_v1_3_0_xml \
--paths ScoutingPFOutput,\
DST_PFScouting_*,\
Dataset_ScoutingPFRun3 \
> reHLT_HLT_Tag.py


cat <<@EOF >> reHLT_HLT_Tag.py
process.GlobalTag.JsonDumpFileName =cms.untracked.string("CondDBESSource.json")
@EOF

cmsRun reHLT_HLT_Tag.py >& reHLT_HLT.log

mv DQMIO.root DQMIO_HLTTag.root
mv outputScoutingPF.root outputScoutingPF_HLTTag.root
mv CondDBESSource.json CondDBESSource_HLTTag.json





hltGetConfiguration /dev/CMSSW_14_1_0/GRun \
--globaltag 140X_dataRun3_Prompt_v4 \
--input file:/eos/cms/store/data/Run2024I/EphemeralHLTPhysics6/RAW/v1/000/386/804/00000/a60c771e-6075-4452-8dae-d09bd2c146f9.root  \
--max-events 1000 \
--output none \
--eras Run3_2024 \
--l1-emulator uGT --l1 L1Menu_Collisions2024_v1_3_0_xml \
--paths ScoutingPFOutput,\
DST_PFScouting_*,\
Dataset_ScoutingPFRun3 \
> reHLT_Prompt_Tag.py


cat <<@EOF >> reHLT_Prompt_Tag.py
process.GlobalTag.JsonDumpFileName =cms.untracked.string("CondDBESSource.json")
@EOF

cmsRun reHLT_Prompt_Tag.py >& reHLT_Prompt.log

mv DQMIO.root DQMIO_PromptTag.root
mv outputScoutingPF.root outputScoutingPF_PromptTag.root
mv CondDBESSource.json CondDBESSource_PromptTag.json
