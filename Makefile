project:
	tuist clean
	tuist fetch
	tuist generate --no-open && pod install &&  open Setlist.xcworkspace
