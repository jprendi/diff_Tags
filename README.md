# Running HLT using the prompt tag and assessing physics performance
Basic scripts on running the HLT with the offline "prompt" tag to see how it affects physics performance. Here specifically using EGamma1 files and looking at the dielectron mass spectrum. In this case, make sure you have at least 500 GB of storage per HLT rerun for the specific files I extracted here. In total at least around 1 TB. To reduce this, one has to adapt the `process.hltOutputMinimsl.outputCommands` when running the HLT via `testPrompt.sh`. 
 If you are running on your personal eos or plan to write the files there, make sure the files created are less than 50 GB at the time, as [eos doesn't allow this](https://cernbox.docs.cern.ch/web/quota/). But let's start in the beginning. I am using one of the openlab machines here with 96 CPUs.

## Rerunning the HLT and running it with the prompt tag
We start by setting up our environment and getting all the files we need:
```
scram project -n diff_Tags CMSSW_14_2_2
cd diff_Tags/src
cmsenv
git cms-addpkg DQM/Integration
git cms-addpkg DQM/HLTEvF
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
Small comments on what is being ran here can be found within the `testPrompt.sh' file. After all of this ran, you will have many output files that are now to be analyzed through the DQM HLT sourceclient.

## Physics performance via DQM client
Now that we have all the output files, we can process them with `hlt_dqm_sourceclient-live_cfg.py`. But unfortunately if we just run it like this, it will not actually run the with the new prompt tag but resort back to HLT decisions and the HLT tag. So we need to change the code in two places:
1. `DQM/Integration/python/clients/hlt_dqm_sourceclient-live_cfg.py`
2. `DQM/Integration/python/config/FrontierCondition_GT_cfi.py`


Within the first file, we need to add two lines to the file, right before the last line, namely:
```
process.hltObjectsMonitor4all.processName  = cms.string("HLTX")
process.hltObjectMonitor.processName = cms.string("HLTX")
```
as this ensures that the Tag we chose actually gets used and not the HLT one. As for the second file,upon opening one sees in the fourth line `GlobalTag.globaltag = autoCond['run3_hlt']`. This also has to be changed, as it will take the hlt tag. So you have to change it to whatever tag you need it to be:
```
GlobalTag.globaltag = '140X_dataRun3_Prompt_v4'
``` 

For reference, I also uploaded the above mentioned and adapted file and they can be found within the `diff_Tags/src/diff_Tags/DQM_tools` directory!
Now we can run the DQM client with the Prompt Tag. Make sure you are in the `/src` folder and do the following:
```
mkdir upload
mv diff_Tags/DQM_tools/*.sh .
./run_DQMclient_Prompt.sh
``` 
Now this takes very long! So maybe run it in `tmux`. :)

Once this is done, you can find it in the `/upload` folder and plot it! **Make sure that if you want to run the DQM client with another output that was created with another tag to change it!!!!**

The default setting is for the histograms to have a bin size of 50. If you want to change it any other bin size, one has to change it in the following file:
```
vim diff_Tags/src/DQM/HLTEvF/python/HLTObjectMonitor_cfi.py
```
In my case, I am interested in the dielectron mass, so we search for `diElecMass`in the file and set `NbinsX = cms.int32(100)`.

In the `upload` directory, we can find the DQM root files from which we can plot from. I made a small script to get the invariant dielectron mass spectrum of the two different tags:
```
mv diff_Tags/DQM_tools/plot.C upload/
root
.x plot.C
```
The plot could look something like this: ![Di-Electron Mass Plot](https://raw.githubusercontent.com/jprendi/diff_Tags/main/di-Electron_Mass.png).


# Resources
These scripts are heavily based on the following [Getting and Running the HLT](https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideGlobalHLT) and  [Marco's repo](https://github.com/mmusich/NGT-Task-3.4).

