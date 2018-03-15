    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "..\incoming\"
    $watcher.Filter = "*.*"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true  

    $action = { $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                $date = Get-Date -Format d.M.yyyy
                
				$dateiname = (Get-Item $path).BaseName
				$output = "..\output\"+$dateiname+".html"
               
				If ( $dateiname.startswith("brief_") ) {
					#Add-content "..\log.txt" -value $dateiname
					pandoc $path -o $output --template=../templates/template_brief.htm --metadata date=$date
				}	
              }   

    Register-ObjectEvent $watcher "Created" -Action $action
    Register-ObjectEvent $watcher "Changed" -Action $action
    Register-ObjectEvent $watcher "Renamed" -Action $action
    while ($true) {sleep 1}
	PAUSE