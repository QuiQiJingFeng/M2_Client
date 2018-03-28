
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

local g_tGameDDZ =
{
    intGameId = "DDZ",
    intGamePlayer = 3,
    tDDZFastInfo = {
        "快点啊,都等的我花儿都谢了！",
        "别吵了,专心玩游戏！",
        "你是妹妹还是哥哥啊？",
        "大家好,很高兴见到各位！",
        "又断线了,网络怎么这么差！",
        "和你合作真是太愉快了。",
        "下次再玩吧,我要走了。",
        "不要走,决战到天亮。",
        "我们交个朋友吧,告诉我你的联系方法。",
        "各位,真不好意思,我要离开会。",
        "你的牌打的太好了！",
        "再见了,我会想念大家的！",
    },
    tGamesRule = {
        -- 支付
        pay = {
            "房主出资",
            "玩家平摊",
            "大赢家出资",
        },
        -- 圈数信息
        round = {
            {
                "6局",
                30,--房主付费
                6,
                10,--玩家平摊
            },
            {
                "12局",
                60,--房主付费
                12,
                20,--玩家平摊
            },
            {
                "20局",
                90,--房主付费
                20,
                30,--玩家平摊
            }
        },   
        -- 底分
        baseScore = {1,2,3,4,5},
        -- 规则信息
        winRule = {
                {"3炸",1},         
                {"4炸",0}, 
                {"5炸",0},      
            },
        -- 规则信息
        playRule = {   
                {"经典斗地主",1},         
                {"欢乐斗地主",0}, 
                -- {"癞子斗地主",0},
            },
        -- 默认选项
        tStartRule = {1,0,0,1,0,0,0,0,0,1},
     },
}

return g_tGameDDZ