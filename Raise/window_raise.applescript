on run argv
	set args to splitString(item 1 of argv, "|")
	set the_id to item 1 of args
	set the_title to item 2 of args
	tell application "System Events"
		set the_processes to get application processes whose background only is false
		repeat with p in (items in the_processes)
			if (id of p) as text is the_id then
				set the_windows to get windows of p
				repeat with w in (items in the_windows)
					if (name of w) is the_title then
						tell p
							set frontmost to true
							perform action "AXRaise" of w
						end tell
					end if
				end repeat
			end if
		end repeat
	end tell
end run

to splitString(aString, delimiter)
	set retVal to {}
	set prevDelimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {delimiter}
	set retVal to every text item of aString
	set AppleScript's text item delimiters to prevDelimiter
	return retVal
end splitString
