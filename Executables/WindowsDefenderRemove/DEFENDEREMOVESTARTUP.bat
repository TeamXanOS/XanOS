:: Registry Remove of Windows Defender
FOR /R %%f IN (GalleryInc.MelodyScript.DefenderRemover.DisablerScript\*.reg Remove_defender\*.reg GalleryInc.MelodyScript.DefenderRemover.Extras\*.reg) DO regedit.exe /s "%%f"
FOR /R %%f IN (GalleryInc.MelodyScript.DefenderRemover.DisablerScript\*.reg Remove_defender\*.reg GalleryInc.MelodyScript.DefenderRemover.Extras\*.reg) DO PowerRun.exe regedit.exe /s "%%f"
start /B /wait PowerRun.exe "DEFENDEREMOVE.bat"
exit