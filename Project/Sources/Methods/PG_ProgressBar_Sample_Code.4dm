//%attributes = {}

//Start the progress bar and get a reference to it with an id

// You can set the status of the "Stop" button with "isButtonEnabled"
// https://doc.4d.com/4Dv20R6/4D/20-R6/Progress-SET-BUTTON-ENABLED.301-7183779.en.html

var $progBarId_l : Integer
$progBarId_l:=PG_ProgressBar(New object:C1471(\
"status"; "start"\
; "title"; "Sales Report"\
; "isButtonEnabled"; False:C215\
)).progressBarId


//==========

// Changes the message shown in the progress bar
// https://doc.4d.com/4Dv20R6/4D/20-R6/Progress-SET-MESSAGE.301-7183764.en.html

$result_ob:=PG_ProgressBar(New object:C1471(\
"status"; "message"\
; "message"; "Loading Theatrical..."\
; "progressBarId"; $progBarId_l\
))


//==========

//Loop an entity selection or a collection or an array

var $counter_l : Integer
$counter_l:=0
For each ($myObject_ob; $myCollection_co)
	$counter_l:=$counter_l+1
	
	// Check if the user clicked on the stop button with Progress Stopped
	// https://doc.4d.com/4Dv20R6/4D/20-R6/Progress-Stopped.301-7183776.en.html
	
	var $isStopped_b : Boolean
	$isStopped_b:=PG_ProgressBar(New object:C1471(\
		"status"; "checkStopped"\
		; "progressBarId"; $progBarId_l\
		)).isStopped
	
	
	If ($isStopped_b)
		//If the user clicked on the stop button then break out of the loop
		break
	Else 
		
		// Show a progress bar with an updated message with Progress SET PROGRESS
		// https://doc.4d.com/4Dv20R6/4D/20-R6/Progress-SET-PROGRESS.301-7183771.en.html
		
		// The ratio is the counter vs the length of the collection or the entity selection or the size of the array
		
		$ratio_r:=($counter_l/$myCollection_co.length)
		$result_ob:=PG_ProgressBar(New object:C1471(\
			"status"; "progress"\
			; "progressBarId"; $progBarId_l\
			; "ratio"; $ratio_r\
			; "message"; "What ever message about the item parsed in the loop"\
			; "isShowInTheForeground"; False:C215\
			))
		
	End if 
	
End for each 

//==========

// Close the progress bar with Progress QUIT
// https://doc.4d.com/4Dv20R6/4D/20-R6/Progress-QUIT.301-7183769.en.html

$result_ob:=PG_ProgressBar(New object:C1471(\
"status"; "quit"\
; "progressBarId"; $progBarId_l\
))

// You can also close all the progress bars by passing progressBarId = -1

$result_ob:=PG_ProgressBar(New object:C1471(\
"status"; "quit"\
; "progressBarId"; -1\
))

// You can also close all the progress bars for a specific process by passing processId

$result_ob:=PG_ProgressBar(New object:C1471(\
"status"; "quit"\
; "processId"; 23\
))
