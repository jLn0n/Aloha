 
	task = require("@lune/task")
	require = function(req) error("require is disabled.") end
	getfenv = function() error("getfenv is disabled.") end
	setfenv = function() error("setfenv is disabled.") end

	print("T")
	