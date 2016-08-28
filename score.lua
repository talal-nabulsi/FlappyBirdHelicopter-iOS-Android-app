-- Score Module
--

local M = {} -- create our local M = {}
M.score = 0

function M.init( options )
	local customOptions = options or {}
	local opt = {}
	opt.fontSize = customOptions.fontSize or 24
	opt.font = customOptions.font or native.systemFontBold
	opt.x = customOptions.x or display.contentCenterX
	opt.y = customOptions.y or opt.fontSize * 0.5
	opt.maxDigits = customOptions.maxDigits or 6
	opt.leadingZeros = customOptions.leadingZeros or false
	M.filename = customOptions.filename or "scorefile.txt"

	local prefix = ""
	if opt.leadingZeros then 
		prefix = "0"
	end
	M.format = "%" .. prefix .. opt.maxDigits .. "d"

	M.scoreText = display.newText(string.format(M.format, 0), opt.x, opt.y, opt.font, opt.fontSize)
	return M.scoreText
end

function M.set( value )
	M.score = value
	M.scoreText.text = string.format(M.format, M.score)

end

function M.get()
	return M.score
end

function M.add( amount )
	M.score = M.score + amount
	M.scoreText.text = string.format(M.format, M.score)
end

function M.save()
	local path = system.pathForFile( M.filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = tostring( M.score )
        file:write( contents )
        io.close( file )
        return true
    else
    	print("Error: could not read ", M.filename, ".")
        return false
    end
end

function M.load()
    local path = system.pathForFile( M.filename, system.DocumentsDirectory)
    local contents = ""
    local file = io.open( path, "r" )
    if file then
         -- read all contents of file into a string
         local contents = file:read( "*a" )
         local score = tonumber(contents);
         io.close( file )
         return score
    end
    print("Could not read scores from ", M.filename, ".")
    return nil
end

return M
