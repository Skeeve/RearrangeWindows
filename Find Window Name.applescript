delay 5
tell application "System Events"
	name of first process whose frontmost is true
end tell
