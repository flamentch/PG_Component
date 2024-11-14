shared singleton Class constructor()
	
	//This.myNumber:=12345
	//This.mytext:="abcde"
	
	This:C1470.progressBars:=New shared collection:C1527
	
	var $progressBarId_l : Integer
	var $indice_l : Integer
	var $payload_ob : Object
	
Function progressBarsAdd($payload_ob : Object)
	// Search if the $progressBarId_l already exist in the singleton
	// If not then create it
	// If already exists then remove it and create it - this should not have happened
	$progressBarId_l:=$payload_ob.progressBarId
	$indice_l:=This:C1470.progressBars.findIndex(Formula:C1597($1.value.progressBarId=$2); $progressBarId_l)
	If ($indice_l#-1)
		Use (This:C1470)
			This:C1470.progressBars.remove($indice_l)
		End use 
		$indice_l:=-1
	End if 
	If ($indice_l=-1)
		$payload_ob:=New shared object:C1526(\
			"progressBarId"; $progressBarId_l\
			; "processId"; $payload_ob.processId\
			; "processName"; $payload_ob.processName\
			; "processUniqueId"; $payload_ob.processUniqueId\
			; "processOrigin"; $payload_ob.processOrigin\
			)
		Use (This:C1470)
			This:C1470.progressBars.push($payload_ob)
		End use 
	End if 
	
Function progressBarsRemove($payload_ob : Object)
	// Search if the $progressBarId_l already exist in the singleton
	// If yes then remove it
	$progressBarId_l:=$payload_ob.progressBarId
	$indice_l:=This:C1470.progressBars.findIndex(Formula:C1597($1.value.progressBarId=$2); $progressBarId_l)
	If ($indice_l#-1)
		Use (This:C1470)
			This:C1470.progressBars.remove($indice_l)
		End use 
	End if 
	