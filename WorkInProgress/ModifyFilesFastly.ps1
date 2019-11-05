Workflow Test-Workflow {
    $SourceFolder = "C:\temp\Root"
    $Files = [System.IO.Directory]::EnumerateFiles($SourceFolder, '*.*', 'AllDirectories')
    $ArrayCount = $Files| Measure-Object | Select-Object Count

  Do {

      $NewArray = $Files | Select-Object -First 20
      $Files = $Files | Where-Object { $NewArray -notcontains $_ }
      $ArrayCount = $Files| Measure-Object | Select-Object Count

      ForEach -Parallel ($it in $NewArray)
          {

              $Name = Get-Random
              $Filepath = "C:\temp\test\"+"$Name"+".txt"
              $it | Out-File -FilePath $Filepath

          }
  } Until ($ArrayCount.Count -eq 0)

}


