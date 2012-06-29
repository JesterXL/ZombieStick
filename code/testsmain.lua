function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end

pcall(require, "luacov")    --measure code coverage, if luacov is present
require "lunatest"


lunatest.suite("tests.com.jxl.core.ServicesSuite")
lunatest.suite("tests.com.jxl.core.services.ReadFileContentsServiceSuite")
-- TODO: put this in the proper repo
lunatest.suite("tests.com.jxl.core.statemachine.StateMachineSuite")
--lunatest.suite("basictests")
lunatest.suite("tests.com.jxl.zombiestick.services.LoadLevelServiceTest")


print("-------------------------------")
lunatest.run()