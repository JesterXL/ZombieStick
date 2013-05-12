-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

local M = {}

function M.physicsData(scale)
	local physics = { data =
	{ 
		
		["level1-a"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-a1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   408, 582.5  ,  -392, 584.5  ,  -273, 383.5  ,  410, 382.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-a1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -391, -190.5  ,  -273, -190.5  ,  -273, 383.5  ,  -392, 584.5  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "level1-a2", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -23, -186.5  ,  -22, 278.5  ,  -41, 278.5  ,  -45, -186.5  }
                    }
                    
                    
                    
		}
		
		, 
		["level1-b"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-b1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -520, 20  ,  520, 20  ,  519, 223  ,  -520, 224  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "level1-b3", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -357, -223  ,  509, -221  ,  509, -188  ,  -358, -187  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "level1-b2", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   148, 21  ,  130, -84  ,  299, -189  ,  321, -188  ,  322, 22  }
                    }
                    
                    
                    
		}
		
		, 
		["level1-c"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-c1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   52, -29.5  ,  52, 45.5  ,  -252, 176.5  ,  -250, -29.5  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-c1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   253, 175.5  ,  -252, 176.5  ,  52, 45.5  ,  253, 43.5  }
                    }
                    
                    
                    
                     ,
                    
                    
                    {
                    pe_fixture_id = "level1-c2", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -206, -169.5  ,  -119, -171.5  ,  -120, -29.5  ,  -208, -28.5  }
                    }
                    
                    
                    
		}
		
		, 
		["level1-d"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-d1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   644, 66.5  ,  -642, 66.5  ,  -641, -68.5  ,  645, -68.5  }
                    }
                    
                    
                    
		}
		
		, 
		["level1-e"] = {
                    
                    
                    
                    
                    {
                    pe_fixture_id = "level1-e1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   50.5, -5  ,  140.5, 185  ,  -18.5, 53  ,  -6.5, 2  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-e1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   140.5, 185  ,  50.5, -5  ,  103.5, -151  ,  318.5, -189  }
                    }
                     ,
                    {
                    pe_fixture_id = "level1-e1", density = 2, friction = 0, bounce = 0, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -18.5, 53  ,  140.5, 185  ,  -313.5, 187  ,  -312.5, 52  }
                    }
                    
                    
                    
		}
		
	} }

        -- apply scale factor
        local s = scale or 1.0
        for bi,body in pairs(physics.data) do
                for fi,fixture in ipairs(body) do
                    if(fixture.shape) then
                        for ci,coordinate in ipairs(fixture.shape) do
                            fixture.shape[ci] = s * coordinate
                        end
                    else
                        fixture.radius = s * fixture.radius
                    end
                end
        end
	
	function physics:get(name)
		return unpack(self.data[name])
	end

	function physics:getFixtureId(name, index)
                return self.data[name][index].pe_fixture_id
	end
	
	return physics;
end

return M
