# Find-TaskServiceUser
Finding Tasks, Services on remote/local computer with specific user

Examples:
	Find-TaskServiceUser -Computer computerA -User UserA -Service -Task
    Find-TaskServiceUser -Computer computerB -User UserB -Task -Log 
    "comp1","comp2" | Find-TaskServiceUser -Service -Task
    "comp3" | Find-TaskServiceUser -Service
