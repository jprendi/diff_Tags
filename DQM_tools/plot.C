#include <TFile.h>
#include <TDirectory.h>
#include <TH1F.h>
#include <TCanvas.h>
#include <TPaveStats.h>
#include <TLegend.h>

void plot() {
    // Create a canvas
    TCanvas *c1 = new TCanvas("c1", "Di-Electron Mass Comparison", 800, 600);

    // Open the first ROOT file and get the histogram
    TFile *HLT = TFile::Open("DQM_V0001_HLT_R000386509_HLT-100.root");
    TDirectory *MS_HLT = (TDirectory*) HLT->Get("DQMData/Run 386509/HLT/Run summary/ObjectMonitor/MainShifter");
    TH1F *hist_HLT = (TH1F*) MS_HLT->Get("di-Electron_Mass");

    hist_HLT->SetLineColor(kRed);
    hist_HLT->SetLineWidth(1);
    hist_HLT->Draw();

    // Modify stats box for HLT
    TPaveStats *stats = (TPaveStats*)hist_HLT->GetListOfFunctions()->FindObject("stats");
    if (stats) {
        stats->SetX1NDC(0.7);
        stats->SetY1NDC(0.7);
        stats->SetX2NDC(0.9);
        stats->SetY2NDC(0.9);
    }

    hist_HLT->SetName("HLT Tag");

    // Open the second ROOT file and get the histogram
    TFile *Prompt = TFile::Open("DQM_V0001_HLT_R000386509_Prompt-100.root");
    TDirectory *MS_Prompt = (TDirectory*) Prompt->Get("DQMData/Run 386509/HLT/Run summary/ObjectMonitor/MainShifter");
    TH1F *hist_Prompt = (TH1F*) MS_Prompt->Get("di-Electron_Mass");

    hist_Prompt->SetLineColor(kBlue);
    hist_Prompt->SetLineWidth(1);
    hist_Prompt->Draw("SAME"); // Draw on the same canvas

    // Modify stats box for Prompt
    TPaveStats *stats_P = (TPaveStats*)hist_Prompt->GetListOfFunctions()->FindObject("stats");
    if (stats_P) {
        stats_P->SetX1NDC(0.7);
        stats_P->SetY1NDC(0.5);
        stats_P->SetX2NDC(0.9);
        stats_P->SetY2NDC(0.65);
    }

    hist_Prompt->SetName("Prompt Tag");

    // Add a legend
    TLegend *leg = new TLegend(0.1, 0.8, 0.3, 0.9);
    leg->AddEntry(hist_HLT, "HLT", "l");
    leg->AddEntry(hist_Prompt, "Prompt", "l");
    leg->Draw();

    // Update the canvas and save the plot
    c1->Modified();
    c1->Update();
    c1->SaveAs("oodi-Electron_Mass.png");
}

