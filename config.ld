project = "Triumphus"
title = "Triumphus documentation"
description = "Triumphus is a territory conquest game for ROBLOX."
format = "discount"
colon = true
all = true
topics = {
	"source/info/00-introduction.md";
	"source/info/01-game_objects.md"
}
not_luadoc = true

-- Support for [[pagename]] and [[pagename|displayed text]] links to the ROBLOX wiki.
custom_see_handler('%[%[([%w_]+)%]%]', function(name)
	return name, "http://wiki.roblox.com/index.php/" .. name
end)
custom_see_handler('%[%[([%w_]+)|([%w_]+)%]%]', function(name, displayed_text)
	return displayed_text, "http://wiki.roblox.com/index.php/" .. name
end)