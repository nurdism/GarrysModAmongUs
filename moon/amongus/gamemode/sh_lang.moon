entryMeta = {
	__call: (...) => @.__entry ...
	__tostring: =>
		str = tostring @.__entry!
		return if "string" == type str
			str
		else
			type str

	__concat: (a, b) -> tostring(a) .. tostring(b)
}

GM.Lang or= {
	Get: (lang) =>
		@__database[lang] or= {}
		return @__database[lang]

	GetEntryFunc: (entry, lang = "en") ->
		@ = GAMEMODE.Lang

		if @__entryCache[lang] and @__entryCache[lang][entry]
			return @__entryCache[lang][entry]

		entry = (@__database[lang] and @__database[lang][entry]) or
			(lang ~= "en" and @__database["en"] and @__database["en"][entry]) or entry

		result = switch type entry
			when "function"
				entry
			else
				(...) ->
					string.format tostring(entry), ...

		result = { __entry: result }
		setmetatable result, entryMeta

		@__entryCache[lang] or= {}
		@__entryCache[lang][entry] = result

		return result

	Initialize: =>
		@__database = {}
		@__entryCache = {}

		dir = GM.FolderName or "amongus"
		files = file.Find(dir .. "/gamemode/lang/*.lua", "LUA" )

		exported = true
		for _, fileName in ipairs files
			path = "lang/" .. fileName

			if "lua" == string.sub fileName, -3, -1
				AddCSLuaFile path
				include path

				print "included #{path}"
}

GM.Lang\Initialize!
