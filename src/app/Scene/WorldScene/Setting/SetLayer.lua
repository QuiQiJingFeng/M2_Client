
local SetLayer = class("SetLayer", function()
    return cc.CSLoader:createNode("hallcomm/lobby/FriendLayer.csb")
end)

function SetLayer:ctor()

end

function SetLayer:show()
    self:setVisible(true)
end

return SetLayer