local GameConf = {}
-- 采用配置
local hzmjConf = require("app.Scene.GameScene.HZMJconfig")
local ddzConf = require("app.Scene.GameScene.ddz.ddzConf")



--[[
    item 参数：
    1.gameID
    2.选中态按钮文字
    3.未选中态按钮文字
    4.是否显示新游戏图标（0:不显示  1:显示）
    5.是否显示免费图标（0:不显示  1:显示）
    6.房间规则配置表
    -- 7.字体缩放
    -- 8.未开启
    -- 9.列表ID
    -- 10.默认规则
    11.打折
]]

GameConf.GameIDList = {
    HZMJ = {"HZMJ", "ImageText0", "ImageText2", false, false, hzmjConf},
	DDZ = {"DDZ", "ImageText120", "ImageText119", false, false, ddzConf},
    DDZ = {"HZMJ", "ImageText120", "ImageText119", false, false, hzmjConf},
}

return GameConf