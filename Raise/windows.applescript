--set needle to do shell script "echo \"su\" | sed 's/./&.*/g'"

on run argv
	set needle to item 1 of argv
	set rec_windows to {}
	tell application "System Events"
		set the_processes to get application processes whose background only is false
		repeat with p in (items in the_processes)
			set the_windows to get windows of p
			repeat with w in (items in the_windows)
				set haystack to (name of p) & " | " & (name of w)
				set match to do shell script "echo \""& haystack &"\" | grep -i '"& needle &"'; exit 0"
				if match is not equal to "" then
					set end of rec_windows to {wname:(name of w), pname:(name of p), pid:(id of p), pfile:(application file of p)}
				end if
			end repeat
		end repeat
	end tell

	set xml_items to {}
	repeat with pwin in (items in rec_windows)
		set pname to (pname of pwin)
		set icon_path to (POSIX path of (pfile of pwin) &"Contents/Resources/"& pname &".icns")
		if (do shell script "[ -e " & quoted form of icon_path & " ] && echo false || echo true") as boolean
			set icon_path to (POSIX path of (pfile of pwin) &"Contents/Resources/app.icns")
		end if
		set end of xml_items to "<item arg=\""& (pid of pwin) & "|" & (wname of pwin) &"\"><title>"& (wname of pwin) &"</title><subtitle>"& pname &"</subtitle><icon type=\"\">"& icon_path &"</icon></item>"
	end repeat

	--set AppleScript's text item delimiters to "\n"
	return "<?xml version=\"1.0\"?>" & "<items>" & xml_items as text & "</items>"
end run
