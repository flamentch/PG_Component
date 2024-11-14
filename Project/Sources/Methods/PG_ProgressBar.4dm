//%attributes = {"shared":true}
#DECLARE($payload_ob : Object)->$result_ob : Object

If (False:C215)
	PG_ProgressBar
End if 

$result_ob:=New object:C1471

If (Count parameters:C259<1)
	$payload_ob:=New object:C1471
Else 
	$payload_ob:=$1
End if 

var $status_t : Text
$status_t:=$payload_ob.status

var $progressBarId_l : Integer
var $processId_l : Integer
var $isButtonEnabled_b : Boolean
var $message_t : Text
var $indice_l : Integer

Case of 
	: ($status_t="start")
		$progressBarId_l:=Progress New
		$result_ob.progressBarId:=$progressBarId_l
		
		PROCESS PROPERTIES:C336(Current process:C322; $procName_t; $procState_l; $procTime_l; $procMode_b; $uniqueID_l; $origin_l)
		
		//Add to progressBar info to the singleton PG_Singleton_Interprocess
		cs:C1710.PG_Singleton_Interprocess.me.progressBarsAdd(New object:C1471(\
			"progressBarId"; $progressBarId_l\
			; "processId"; Current process:C322\
			; "processName"; $procName_t\
			; "processUniqueId"; $uniqueID_l\
			; "processOrigin"; $origin_l\
			))
		
		Progress SET ON STOP METHOD($progressBarId_l; "PG_Progressbar_OnStopMethod")
		
		var $title_t : Text
		$title_t:=$payload_ob.title
		If ($title_t#"")
			Progress SET TITLE($progressBarId_l; $title_t)
		End if 
		
		$message_t:=$payload_ob.message
		If ($message_t#"")
			Progress SET MESSAGE($progressBarId_l; $message_t)
		End if 
		
		$isButtonEnabled_b:=$payload_ob.isButtonEnabled
		Progress SET BUTTON ENABLED($progressBarId_l; $isButtonEnabled_b)
		
	Else 
		
		$progressBarId_l:=$payload_ob.progressBarId
		$processId_l:=$payload_ob.processId
		
		If (($progressBarId_l#0) | (($status_t="quit") & ($processId_l#0)))
			Case of 
				: ($status_t="buttonEnabled")
					$isButtonEnabled_b:=$payload_ob.isButtonEnabled
					Progress SET BUTTON ENABLED($progressBarId_l; $isButtonEnabled_b)
					
				: ($status_t="checkStopped")
					$result_ob.isStopped:=Progress Stopped($progressBarId_l)
					
				: ($status_t="progress")
					var $ratio_r : Real
					$ratio_r:=$payload_ob.ratio
					$message_t:=$payload_ob.message
					Progress SET PROGRESS($progressBarId_l; $ratio_r; $message_t)
					
				: ($status_t="message")
					$message_t:=$payload_ob.message
					If ($message_t#"")
						Progress SET MESSAGE($progressBarId_l; $message_t)
					End if 
					
				: ($status_t="quit")
					var $progressBars_co : Collection
					
					
					If (($progressBarId_l=-1) | ($processId_l#0))
						// If progressBarId = -1 then quit all progress bars
						// If processId # 0 then quit all progress bars for that specific process
						$progressBars_co:=cs:C1710.PG_Singleton_Interprocess.me.progressBars.copy()
						If ($processId_l#0)
							$progressBars_co:=$progressBars_co.query("processId = :1"; $processId_l)
						End if 
						
					Else 
						// If progressBarId # -1 then quit only this one
						$progressBars_co:=New collection:C1472
						$progressBars_co.push(New object:C1471("progressBarId"; $progressBarId_l))
					End if 
					
					// Loop for all the progressBars to quit
					For each ($progressBar_ob; $progressBars_co)
						// Search if the $progressBarId_l already exist in the singleton PG_Singleton_Interprocess
						// If yes then remove it
						$progressBarId_l:=$progressBar_ob.progressBarId
						$indice_l:=cs:C1710.PG_Singleton_Interprocess.me.progressBars.findIndex(Formula:C1597($1.value.progressBarId=$2); $progressBarId_l)
						If ($indice_l#-1)
							Progress QUIT($progressBarId_l)
							// Remove the progressBar from the singleton PG_Singleton_Interprocess
							cs:C1710.PG_Singleton_Interprocess.me.progressBarsRemove(New object:C1471(\
								"progressBarId"; $progressBarId_l\
								))
						End if 
						
					End for each 
					
			End case 
		End if 
End case 
