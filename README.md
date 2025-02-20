# Running HLT using the prompt tag and assessing physics performance
Basic scripts on running the HLT with the offline "prompt" tag to see how it affects physics performance. Here specifically using EGamma1 files and looking at the dielectron mass spectrum. In this case, make sure you have at least 500 GB of storage per HLT rerun and the specific files I extracted here. In total at least 1 TB. If you are running on your personal eos or plan to write the files there, make sure the files created are less than 50 GB at the time, as it otherwise caused issues for me. But let's start in the beginning. I am using one of the openlab machines here with 96 CPUs.

## Rerunning the HLT and running it with the prompt tag
We start by setting up our environment and getting all the files we need:
```
scram project -n diff_Tags CMSSW_14_2_2
cd diff_Tags/src
cmsenv
git cms-addpkg DQM/Integration
git cms-addpkg Configuration/StandardSequences
scram b -j 96
git clone git@github.com:jprendi/diff_Tags.git
cd diff_Tags
```
The `fileList.txt` list was extraced by using the `dasgoclient` and setting the proper site will make sure you have access to the files without extra steps. This gives us a long list of available files but for now, I only want to run this on one Run, in this case run 386509, which we can easily extract.
```
voms-proxy-init --voms cms --valid 168:00
dasgoclient -query='file site=T2_CH_CERN dataset=/EGamma1/Run2024I-ZElectron-PromptReco-v1/RAW-RECO' >& fileList.txt 
grep '/000/386/509/' fileList.txt > fileList_509.tx
```
Now that we know on which files we want to rerun the HLT on, it's time to actually run the HLT and we start with simply rerunning the HLT. For this, we run
```
./testHLT.sh
```
This file loops over 10 partitions of the files. The reason for it is because otherwise the output files would be too large. For each iteration, a config file of the HLT is created and HLT is run. This will create the output files, that we later on want to assess. For running the HLT with a prompt tag, one can simply change the `--globaltag` and it suprisingly works. So you also run:
```
./testPrompt.sh
```
After all of this ran (~5-6 hours), you will have many output files that are now to be analyzed through the DQM HLT sourceclient.


