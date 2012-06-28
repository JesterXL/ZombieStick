module(..., package.seeall)

function setup()
   local result, err = os.remove(system.pathForFile("test.txt", system.DocumentsDirectory))
   return result
end

function teardown()
   local result, err = os.remove(system.pathForFile("test.txt", system.DocumentsDirectory))
   return result
end

function test_readAndSaveFileServices()
	require "com.jxl.core.services.ReadFileContentsService"
	require "com.jxl.core.services.SaveFileService"

	local saveFile = SaveFileService:new()
	local data = "moo"
	assert_true(saveFile:saveFile("test.txt", system.DocumentsDirectory, data), "Failed to save test.txt")

	local readFile = ReadFileContentsService:new()
	local contents = readFile:readFileContents("test.txt", system.DocumentsDirectory)
	assert_equal(contents, data, "Contents doesn't equal data.")
end
