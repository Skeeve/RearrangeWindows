use scripting additions
use framework "Foundation"

on saveFolderName()
	return "RearrangeWindows"
end saveFolderName

on run
	set action to button returned of (display dialog "What would you like to do?" buttons {"Cancel", "Restore", "Save"} default button "Restore" with title (name of me))
	if action is "Save" then
		saveWindowPositions()
	else if action is "Restore" then
		restoreWindowPositions()
	end if
end run

on saveWindowPositions()
	set NSJSONWritingPrettyPrinted to a reference to 1
	set NSJSONSerialization to a reference to current application's NSJSONSerialization
	set processNames to createSaveFolderAndConfig()
	set positionList to {}

	set userName to text returned of (display dialog "Enter a name for this position (e.g., 'Home', 'Work'):" default answer "Home" with title (name of me))

	tell application "System Events"
		repeat with proc in processNames
			try
				tell process proc
					if exists window 1 then
						set pos to position of window 1 as list
						set sze to size of window 1 as list
						set newPos to {|name|:proc, |position|:{(item 1 of pos) as integer, (item 2 of pos) as integer}, |size|:{(item 1 of sze) as integer, (item 2 of sze) as integer}}
						set end of positionList to newPos
					end if
				end tell
			end try
		end repeat
	end tell

	set saveFolder to (path to application support from user domain as text) & saveFolderName() & ":"
	do shell script "mkdir -p " & quoted form of POSIX path of saveFolder

	set savePath to saveFolder & userName & ".json"

	set theJSONData to NSJSONSerialization's dataWithJSONObject:positionList options:NSJSONWritingPrettyPrinted |error|:(missing value)
	theJSONData's writeToFile:(POSIX path of savePath) atomically:true

	tell application "System Events"
		set frontmost of process (name of me) to true
	end tell

	display dialog "Window positions for '" & userName & "' successfully saved!" buttons {"OK"} default button "OK" with title (name of me)
end saveWindowPositions

on restoreWindowPositions()
	set saveFolder to (path to application support from user domain as text) & saveFolderName() & ":"

	try
		do shell script "test -d " & quoted form of POSIX path of saveFolder
	on error
		set folderName to saveFolderName()
		display dialog "There is no '" & folderName & "' folder. No saved window positions found." buttons {"OK"} default button "OK" with title (name of me)
		return
	end try

	set fileToRestore to choose file with prompt "Select the file with the saved window positions:" default location (saveFolder as alias) of type {"public.json"}

	set ca to current application
	set filePath to ca's NSString's stringWithString:(POSIX path of fileToRestore)
	set rawData to ca's NSString's stringWithContentsOfFile:filePath encoding:(ca's NSUTF8StringEncoding) |error|:(missing value)
	if rawData is missing value then
		display alert (name of me) message "Error: Could not read file." buttons {"OK"} default button "OK"
		return
	end if

	set theJSON to readJSON(rawData as text)

	tell application "System Events"
		repeat with itm in theJSON
			set procName to (itm's objectForKey:"name") as text
			set posList to (itm's objectForKey:"position") as list
			set sizeList to (itm's objectForKey:"size") as list
			set posX to item 1 of posList as integer
			set posY to item 2 of posList as integer
			set sizeW to item 1 of sizeList as integer
			set sizeH to item 2 of sizeList as integer
			try
				tell process procName
					if exists window 1 then
						set position of window 1 to {posX, posY}
						set size of window 1 to {sizeW, sizeH}
					else
						display alert (name of me) message "Window of " & procName & " not found." buttons {"OK"} default button "OK"
					end if
				end tell
			on error errMsg
				display alert (name of me) message "Error restoring " & procName & ": " & errMsg buttons {"OK"} default button "OK"
			end try
		end repeat
	end tell
end restoreWindowPositions

on readJSON(strJSON)
	set ca to current application
	set {x, e} to ca's NSJSONSerialization's JSONObjectWithData:((ca's NSString's stringWithString:strJSON)'s dataUsingEncoding:(ca's NSUTF8StringEncoding)) options:0 |error|:(reference)
	if x is missing value then
		error e's localizedDescription() as text
	else
		return x
	end if
end readJSON

on createSaveFolderAndConfig()
	set saveFolder to (path to application support from user domain as text) & saveFolderName() & ":"
	set qFolder to quoted form of POSIX path of saveFolder
	set qConf to quoted form of (saveFolderName() & ".conf")
	set commands to "mkdir -p " & qFolder & " && cd " & qFolder & " && [[ ! -r " & qConf & " ]] && cat <<CONF>> " & qConf & linefeed & "Calendar" & return & linefeed & "Mail" & return & linefeed & "CONF" & linefeed & "cat " & qConf
	return paragraphs of (do shell script commands)
end createSaveFolderAndConfig
