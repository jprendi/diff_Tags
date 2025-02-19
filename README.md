# NGT-Task-3.4
Script to see how changing using the Global Tag at the HLT Tag affects EGamma datasets
## Provisional recipe
```
scram project -n diff_Tags CMSSW_14_2_2
cd diff_Tags/src
cmsenv
git cms-addpkg DQM/Integration
git cms-addpkg Configuration/StandardSequences
git clone git@github.com:jprendi/diff_Tags.git 
cd diff_Tags
dasgoclient -query='file site=T2_CH_CERN dataset=/EGamma1/Run2024I-ZElectron-PromptReco-v1/RAW-RECO' >& fileList.txt  # this is to get all the available files
```
