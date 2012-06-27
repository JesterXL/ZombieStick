
function test_readAndSaveFileServices()
	require "com.jxl.core.services.ReadFileContentsService"
	require "com.jxl.core.services.SaveFileService"

	local saveFile = SaveFileService:new()
	local data = "moo"
	assert(saveFile:saveFile("test.txt", system.DocumentsDirectory, data), "Failed to save test.txt")

	local readFile = ReadFileContentsService:new()
	local contents = readFile:readFileContents("test.txt", system.DocumentsDirectory)
	print("contents: ", contents)
end