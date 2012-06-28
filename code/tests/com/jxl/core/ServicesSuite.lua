module(..., package.seeall)

function test_saveFile()
	require "com.jxl.core.services.ReadFileContentsService"

	local saveFile = SaveFileService:new()
	local data = "moo"
	assert_true(saveFile:saveFile("test.txt", system.DocumentsDirectory, data), "Failed to save test.txt")
end

function test_readFile()
	require "com.jxl.core.services.ReadFileContentsService"
	require "com.jxl.core.services.SaveFileService"

	local saveFile = SaveFileService:new()
	local data = "moo"
	assert_true(saveFile:saveFile("test.txt", system.DocumentsDirectory, data), "Failed to save test.txt for use in reading.")

	local readFile = ReadFileContentsService:new()
	local contents = readFile:readFileContents("test.txt", system.DocumentsDirectory)
	assert_string(contents, "contents are not a string.")
	assert_equal(contents, data, "Data written to file does not match what we just read out of it.")
end

