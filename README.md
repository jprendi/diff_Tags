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
./prepareConfiguration.sh
```
