
--牌面层
local GamePlayCardsPanel = class("GamePlayCardsPanel", lt.BaseLayer)

GamePlayCardsPanel.POSITION_TYPE = {
	XI = 1, 
	NAN = 2,
	DONG = 3,
	BEI = 4,
}

function GamePlayCardsPanel:ctor(deleget)
	GamePlayCardsPanel.super.ctor(self)
	self._deleget = deleget

    local gameInfo = lt.DataManager:getGameRoomInfo()
    self._playerNum = 2
    if gameInfo and gameInfo.room_setting and gameInfo.room_setting.seat_num then
        self._playerNum = gameInfo.room_setting.seat_num
    end

	if self._playerNum == 2 then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/2p/MjCardsPanel2p.csb")
	elseif self._playerNum == 3 then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/3p/MjCardsPanel3p.csb")
	elseif self._playerNum == 4 then
		self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/green/MjCardsPanel.csb")
	end
	
	self._pleaseOutCardTips = self._rootNode:getChildByName("Sprite_OutCardTips")--请出牌

	self._curOutCardArrow = self._rootNode:getChildByName("Node_CurOutCardArrow")--

	self._surCardsNum = lt.CommonUtil:getChildByNames(self._rootNode, "Node_CardNum", "Text_Num")--剩余牌数

	self._surRoomCount = lt.CommonUtil:getChildByNames(self._rootNode, "Node_OtherNum", "Text_Num")--剩余局数

	self:addChild(self._rootNode)

	self:initGame()
end

function GamePlayCardsPanel:updateMjInfo()   

	local currentGameDirections = nil

	if self._playerNum == 2 then--二人麻将
		currentGameDirections = {2, 4}
	elseif self._playerNum == 3 then
		currentGameDirections = {1, 2, 3}
	elseif self._playerNum == 4 then
		currentGameDirections = {1, 2, 3, 4}
	end

	if not currentGameDirections then
		return
	end

	--self._rootNode = cc.CSLoader:createNode("game/mjcomm/csb/mjui/2p/MjCardsPanel2p.csb")
	

	local nodeClock = lt.CommonUtil:getChildByNames(self._rootNode, "Node_Clock")--中间方向盘
	
	self._spriteDnxb = nodeClock:getChildByName("Sprite_Dnxb")--方向旋转

	self._nodeLight = {}--红绿状态的节点

	self._nodeDXNB = {}--东西南北的节点  


	for i=1,4 do
		nodeClock:getChildByName("Node_Light_"..i):setVisible(false)
		nodeClock:getChildByName("Node_DNXB_"..i):setVisible(false)
	end

	for i,direction in ipairs(currentGameDirections) do
		nodeClock:getChildByName("Node_Light_"..i):setVisible(false)
		nodeClock:getChildByName("Node_DNXB_"..i):setVisible(true)
		self._nodeLight[i] = nodeClock:getChildByName("Node_Light_"..i)--:getChildByName("Sprite_Light") getChildByName("Sprite_LightRed")
		self._nodeDXNB[i] = nodeClock:getChildByName("Node_DNXB_"..i)--   

		self._nodeDXNB[i]:getChildByName("Sprite_Dong"):setVisible(false)
		self._nodeDXNB[i]:getChildByName("Sprite_Nan"):setVisible(false)
		self._nodeDXNB[i]:getChildByName("Sprite_Xi"):setVisible(false)
		self._nodeDXNB[i]:getChildByName("Sprite_Bei"):setVisible(false)

	end

	local panelOutCard = self._rootNode:getChildByName("Panel_OutCard")--出牌

	local panelVertical = self._rootNode:getChildByName("Panel_Vertical")--手牌

	self._allPlayerOutCards = {}
	self._allPlayerHandCardsNode = {}
	self._allPlayerCpgCardsNode = {}

	for index=1, self._playerNum do

		--出的牌
		local direction = self.POSITION_TYPE.NAN

		if self._playerNum == 2 then
			if index == 1 then--北方
				direction = self.POSITION_TYPE.BEI
			else
				direction = self.POSITION_TYPE.NAN
			end
		else
			direction = index
		end

		self._allPlayerOutCards[direction] = {}
		local node = panelOutCard:getChildByName("Node_OutCards_"..index)
		if node then
			for i=1,59 do
				table.insert(self._allPlayerOutCards[direction], node:getChildByName("MJ_Out_"..i))
			end
		end

		--手牌
		self._allPlayerHandCardsNode[direction] = {}
		local node = panelVertical:getChildByName("Node_HandCards_"..index)
		if node then
			for i=1,14 do
				table.insert(self._allPlayerHandCardsNode[direction], node:getChildByName("MJ_Stand_"..i))
			end
		end

		--吃椪杠
		self._allPlayerCpgCardsNode[direction] = {}
		local node = panelVertical:getChildByName("Node_CpgCards_"..index)
		if node then
			for i=1,5 do
				table.insert(self._allPlayerCpgCardsNode[direction], node:getChildByName("Layer_Cpg_"..i))
			end
		end
	end

end

function GamePlayCardsPanel:configCards()
	for k,cards in pairs(self._allPlayerOutCards) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
		end
	end

	for direction,cards in pairs(self._allPlayerHandCardsNode) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
			if direction == self.POSITION_TYPE.NAN then
				v:getChildByName("Node_Mj"):getChildByName("Image_MaskRed"):setVisible(false)
				v:getChildByName("Node_Mj"):getChildByName("Image_Mask"):setVisible(false)
				v:getChildByName("Node_Mj"):getChildByName("Sprite_TingArrow"):setVisible(false)

				lt.CommonUtil:addNodeClickEvent(v:getChildByName("Node_Mj"):getChildByName("Image_Bg"), handler(self, self.onClickCard))
			end
		end
	end

	for direction, cards in pairs(self._allPlayerCpgCardsNode) do
		for i,v in ipairs(cards) do
			v:setVisible(false)
		end
	end
end

function GamePlayCardsPanel:initGame() --每局结束牌桌清桌 

	self:updateMjInfo()

	self:configCards()

	if not self._allLieFaceCardNode then
		self._allLieFaceCardNode = {}
	end

	if self._allLieFaceCardNode then
		for i,v in ipairs(self._allLieFaceCardNode) do
			v:removeFromParent()
		end
		self._allLieFaceCardNode = {}
	end
	
	self._allPlayerHandCards = {}--所有方位的手牌

	self._allPlayerOutInitCards = {}--所有方位的已经出过的  初始化过的牌

	self._allPlayerCpgCards = {}--所有方位的吃椪杠
end

function GamePlayCardsPanel:configSendCards() --游戏刚开始的发牌

	--_allPlayerCpgCardsNode
	local sendDealFinish = false
	for direction,cards in pairs(self._allPlayerHandCardsNode) do--发牌发13张
		local time = 0.1
		for i=1,13 do
			time = time + 0.1
			if cards[i] then

				if direction == self.POSITION_TYPE.NAN then

					local value = self._allPlayerHandCards[direction][i]--手牌值
					local node = cards[i]:getChildByName("Node_Mj")
					local face = node:getChildByName("Sprite_Face")

					if node and face then
						local cardType = math.floor(value / 10) + 1
						local cardValue = value % 10
						face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
						node:getChildByName("Image_Bg"):setTag(value)
						node:getChildByName("Image_Bg")["CardIndex"] = i
					end
				end

				local func = function( )
					cards[i]:setVisible(true)

					if i == 13 and not sendDealFinish then
						sendDealFinish = true
						local arg = {command = "DEAL_FINISH"}
						lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
					end
				end
				local delay = cc.DelayTime:create(time)

				local func1 = cc.CallFunc:create(func)
				local sequence = cc.Sequence:create(delay, func1)
				cards[i]:runAction(sequence)
			end
		end
	end

end

function GamePlayCardsPanel:onClickCard(event) 

	if self._deleget._gameActionBtnsPanel.m_objCommonUi.m_nodeActionBtns:isVisible() then
		print("碰杠胡了不能点牌了")
		return
	end

	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", event:getTag(), event.CardIndex)

	--[[
	出牌处理

	在进入房间的时候记录一下14张牌的原始位置 originpos = {}

	出牌的时候将要出的牌的ui，从手牌里面抽出移动到桌面上该放的位置，
	放完之后再将这张ui的位置设置到originpos[index]对应的位置并隐藏 记录出去牌 outindex


	如果出的这张牌是最后一张则不用挪动其他牌的位置
	如果出的不是最后一张 便利所有手牌ui   

	当 value > getvalue的 indexs

	outindex < index   --这之间的牌统一向左移动一个牌位

	index < outindex --这之间的牌统一向右移动一个牌位
	将摸得牌放到index位置
	这些动作完成之后 将当前手牌排序 然后便利14个手牌ui将手牌值初始化
	]]


	local cardNode = self._allPlayerHandCardsNode[self.POSITION_TYPE.NAN][event.CardIndex]
	if not cardNode then
		return
	end
	local value = event:getTag()
	if self._currentOutPutPlayerPos == lt.DataManager:getMyselfPositionInfo().user_pos then
		print("出牌", value)

		-- local node =  self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]
		-- local face = node:getChildByName("Sprite_Face")

		-- local cardType = math.floor(event:getTag() / 10) + 1
		-- local cardValue = event:getTag() % 10
		-- face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
		-- node:setVisible(true)
		-- node:setTag(event:getTag())
		-- table.remove(self._allPlayerOutCards[self.POSITION_TYPE.NAN], 1)
		-- table.insert(self._allPlayerOutInitCards[self.POSITION_TYPE.NAN], node)

		-- for k,card in pairs(self._mySelfHandCards) do  self._allPlayerHandCards[direction]
		-- 	if card == value then
		-- 		table.remove(self._mySelfHandCards, k)
		-- 		break
		-- 	end
		-- end

		-- self:configAllPlayerCards(pos)
		print("___________________________", value)
		local arg = {command = "PLAY_CARD", card = value}
		lt.NetWork:sendTo(lt.GameEventManager.EVENT.GAME_CMD, arg)
	end

	-- if not event.statu or event.statu == 0 then
	-- 	if self._currentMoveCard then
	-- 		local move = cc.MoveBy:create(0.5, cc.p(0, -event:getContentSize().height / 4))
	-- 		self._currentMoveCard:runAction(move)
	-- 		self._currentMoveCard.statu = 0 --静牌
	-- 	end

	-- 	local move = cc.MoveBy:create(0.5, cc.p(0, 40))
	-- 	cardNode:runAction(move)
	-- 	event.statu = 1--待出
	-- 	self._currentMoveCard = event
	-- 	print("________________=====================______________________________________")
	-- elseif event.statu == 1 then--再次点击出牌
	-- 	print("_________________------------------------_____________________________________")
	-- 	local moveBack = cc.MoveBy:create(0.5, cc.p(0, -event:getContentSize().height / 4))


	-- 	local move = cc.MoveTo:create(0.5, ccp(self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]:getPositionX(), self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]:getPositionY()))
	-- 	local scale = cc.ScaleTo:create(0.5, 0.52, 0.52)
	-- 	local spawn = cc.Spawn:create(move, scale)

	-- 	local func = cc.CallFunc:create(
	-- 		function ( )
	-- 			self._currentMoveCard = nil

	-- 			local node =  self._allPlayerOutCards[self.POSITION_TYPE.NAN][1]
	-- 			local face = node:getChildByName("Sprite_Face")

	-- 			local cardType = math.floor(event:getTag() / 10) + 1
	-- 			local cardValue = event:getTag() % 10
	-- 			face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
	-- 			node:setVisible(true)
	-- 			node:setTag(event:getTag())
	-- 			table.remove(self._allPlayerOutCards[self.POSITION_TYPE.NAN], 1)
	-- 			if not self._allPlayerOutInitCards[self.POSITION_TYPE.NAN] then
	-- 				self._allPlayerOutInitCards[self.POSITION_TYPE.NAN] = {}
	-- 			end

	-- 			table.insert(self._allPlayerOutInitCards[self.POSITION_TYPE.NAN], node)
	-- 		end
	-- 		)

	-- 	local seque = cc.Sequence:create(moveBack, spawn, func)
	-- 	cardNode:runAction(seque)
	-- end
end

function GamePlayCardsPanel:checkMyHandStatu() --检测吃椪杠
    local tObjCpghObj = {
        tObjChi = nil,
        tObjPeng = nil,
        tObjGang = nil,
        tObjHu = nil--抢杠胡  自摸
    }
    --检测杠
	local tempHandCards = {}

	for k,v in pairs(self._allPlayerHandCards[self.POSITION_TYPE.NAN]) do
		table.insert(tempHandCards, v)
	end

	local anGangCards = lt.CommonUtil:getCanAnGangCards(tempHandCards) 
	dump(anGangCards)

	local pengGang = lt.CommonUtil:getCanPengGangCards(self._allPlayerCpgCards[self.POSITION_TYPE.NAN], tempHandCards)
	dump(pengGang)

	if #anGangCards > 0 or #pengGang > 0 then
		tObjCpghObj.tObjGang = {}
	end

	for i,v in ipairs(anGangCards) do
		table.insert(tObjCpghObj.tObjGang, v)
	end

	for i,v in ipairs(pengGang) do
		table.insert(tObjCpghObj.tObjGang, v)
	end

	--检测胡
	print("______fsdfsdf胡牌——————————————————————————", tostring(tempHandCards))
	if lt.CommonUtil:checkIsHu(tempHandCards, true) then
		print("自摸了###########################################")
		tObjCpghObj.tObjHu = {}
	else
		print("没有自摸###########################################")
	end

    --显示吃碰杠胡控件
    self._deleget:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
	self._deleget:viewActionButtons(tObjCpghObj, false)
end

function GamePlayCardsPanel:configAllPlayerCards(direction)--吃椪杠 手牌

	if not self._allPlayerCpgCardsNode[direction] then
		return
	end

	local chiPengCount = 0
	local gangCount = 0
	self._allPlayerCpgCards[direction] = self._allPlayerCpgCards[direction] or {}
	for index,CpgNode in ipairs(self._allPlayerCpgCardsNode[direction]) do
		local cardInfo = self._allPlayerCpgCards[direction][index]
		print("666666666666666666666666666666666666")
		dump(tostring(cardInfo))
		if cardInfo then
			local value = cardInfo.value
			local gang_type = cardInfo.gang_type--1 暗杠 2 明杠 3 碰杠
			local from = cardInfo.from
			local type = cardInfo.type--1 碰 2 杠 3 吃

			local formDirection = self._deleget:getPlayerDirectionByPos(cardInfo.from) 

			local cardType = math.floor(value / 10) + 1
			local cardValue = value % 10

			local visibleType = 1 --1 碰 2 碰杠 3 明杠 4 暗杠 5 吃

			if type == 2 then
				gangCount = gangCount + 1
				if gang_type == 1 then--暗杠
					visibleType = 4
				elseif gang_type == 2 then--明杠
					visibleType = 3
				elseif gang_type == 3 then--碰杠
					visibleType = 2
				end
			else
				visibleType = 1
				chiPengCount = chiPengCount + 1
			end
			CpgNode:setVisible(true)
			for i=1,5 do
				CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
				CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Image_MaskRed"):setVisible(false)

				local arrow = CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Arrow")
				arrow:setVisible(false)
				local du = (self.POSITION_TYPE.NAN - formDirection) * 90
				arrow:setRotation(du)

				local face = CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Face")
				face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
				
				local initIndex = nil

				if visibleType == 1 then
					initIndex = 3
				elseif visibleType == 2 or visibleType == 3 then
					initIndex = 4
				elseif visibleType == 4 then
					initIndex = 4
					if i <= 4 then
						CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(true)
						if i == 4 and direction == self.POSITION_TYPE.NAN then
							CpgNode:getChildByName("MJ_Cpg_"..i):getChildByName("Sprite_Back"):setVisible(false)
						end
					end
				end
				if initIndex then

					if i <= initIndex then
						CpgNode:getChildByName("MJ_Cpg_"..i):setVisible(true)
						if i == initIndex and visibleType ~= 4 then
							arrow:setVisible(true)
						end
					else
						CpgNode:getChildByName("MJ_Cpg_"..i):setVisible(false)
					end
				end
			end 
		else
			CpgNode:setVisible(false)
		end
	end

	if not self._allPlayerHandCardsNode[direction] then
		return
	end
	self._allPlayerHandCards[direction] = self._allPlayerHandCards[direction] or {}


	--local CpgCount = #self._allPlayerCpgCards)[direction]--吃椪杠的个数

	local startIndex = chiPengCount * 3 + gangCount * 3
	print("吃椪杠的个数", chiPengCount, gangCount, startIndex)
	local initIndex = 1
	for i=1,14 do
		if direction ~= self.POSITION_TYPE.NAN then--不是自己
			if i <= startIndex then
				self._allPlayerHandCardsNode[direction][i]:setVisible(false)
			else
				self._allPlayerHandCardsNode[direction][i]:setVisible(true)
			end
		else
			if i <= startIndex then
				self._allPlayerHandCardsNode[direction][i]:setVisible(false)
			else
				local card = self._allPlayerHandCardsNode[direction][i]
				
				if self._allPlayerHandCards[direction][initIndex] and card then
					card:setVisible(true)
					local value = self._allPlayerHandCards[direction][initIndex]--手牌值
					local node = card:getChildByName("Node_Mj")
					local face = node:getChildByName("Sprite_Face")

					if node and face then
						local cardType = math.floor(value / 10) + 1
						local cardValue = value % 10
						face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
						node:getChildByName("Image_Bg"):setTag(value)
						node:getChildByName("Image_Bg")["CardIndex"] = i
					end
					initIndex = initIndex + 1
				else
					if card then
						card:setVisible(face)
					end
				end
			end
		end
	end
end


function GamePlayCardsPanel:createLieFaceItemByDirection(direction)

	local path = nil
	local mj = nil
	if direction == self.POSITION_TYPE.BEI then
		path = "game/mjcomm/csb/mjui/green/MjLieUpFaceItem.csb"
	elseif direction == self.POSITION_TYPE.XI then
		path = "game/mjcomm/csb/mjui/green/MjLieLeftFaceItem.csb"
	elseif direction == self.POSITION_TYPE.DONG then
		path = "game/mjcomm/csb/mjui/green/MjLieRightFaceItem.csb"
	end
	if path then
		mj = cc.CSLoader:createNode(path)
	end
    return mj
end

function GamePlayCardsPanel:onDealDown(msg)   --发牌13张手牌

	self._allPlayerHandCards[self.POSITION_TYPE.NAN] = {}

	self._zhuangPos = msg.zpos

	-- --显示庄家
	-- self._zhuangDirection = self._deleget:getPlayerDirectionByPos(self._zhuangPos)

	-- if self._zhuangDirection and self._currentPlayerLogArray[self._zhuangDirection] then
	-- 	self._currentPlayerLogArray[self._zhuangDirection]:getChildByName("Sprite_Zhuang"):setVisible(true)
	-- end

	for i,card in ipairs(msg.cards) do
		table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], card)

	end
	local sortFun = function(a, b)
		return a < b
	end

	table.sort(self._allPlayerHandCards[self.POSITION_TYPE.NAN], sortFun)

	--播放筛子动画
	local action_node = cc.CSLoader:createNode("game/mjcomm/csb/base/ShaiZiAni.csb")
	self:addChild(action_node)
	local tlAct = cc.CSLoader:createTimeline("game/mjcomm/csb/base/ShaiZiAni.csb")
	action_node:getChildByName("pointNum_1"):setVisible(false)
	action_node:getChildByName("pointNum_2"):setVisible(false)

	local func = function ( frame )
		local event = frame:getEvent()
		if event == "END" then
			local random1 = math.random(1,6)
			local random2 = math.random(1,6)

			local num1 = "game/mjcomm/animation/aniShaiZi/aniShaiZi_"..random1..".png"
			local num2 = "game/mjcomm/animation/aniShaiZi/aniShaiZi_"..random2..".png"
			action_node:getChildByName("action_1"):setVisible(false)
			action_node:getChildByName("action_2"):setVisible(false)
			action_node:getChildByName("pointNum_1"):setVisible(true)
			action_node:getChildByName("pointNum_2"):setVisible(true)
			action_node:getChildByName("pointNum_1"):setSpriteFrame(num1)
			action_node:getChildByName("pointNum_2"):setSpriteFrame(num2)


    		local delay = cc.DelayTime:create(0.5)

    		local removeShaiZi = function( )
    			action_node:removeFromParent()
    		end


    		local func1 = cc.CallFunc:create(removeShaiZi)

    		local func2 = cc.CallFunc:create(handler(self, self.configSendCards))--发牌


      		local sequence = cc.Sequence:create(delay, func1, func2)
      		self:runAction(sequence)

		end
	end
	
 	action_node:runAction(tlAct)
	tlAct:gotoFrameAndPlay(0, false)
    tlAct:clearFrameEventCallFunc() 
    tlAct:setFrameEventCallFunc(func)
end

function GamePlayCardsPanel:onPushDrawCard(msg)   --通知其他人有人摸牌 

	--检测是否胡牌

	if lt.DataManager:getMyselfPositionInfo().user_pos == msg.user_pos then 

		--检测自己的手牌情况  --吃椪杠胡
		--self:checkMyHandStatu()
		self._ischeckMyHandStatu = true
	end

	-- local value = msg.card
	-- print("!!!!!!!!!!!!!!!!!",  msg.user_pos)
	-- if lt.DataManager:getMyselfPositionInfo().user_pos == msg.user_pos then

	-- else
	-- 	local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos)
	-- 	if direction and self._allPlayerHandCardsNode[direction] then
	-- 		self._allPlayerHandCardsNode[direction][14]:setVisible(true)
	-- 	end

	-- end
end

function GamePlayCardsPanel:onPushPlayCard(msg)   --通知玩家该出牌了 
	self._currentOutPutPlayerPos = msg.user_pos

	msg.card_list = msg.card_list or {}
	msg.peng_list = msg.peng_list or {}
	msg.gang_list = msg.gang_list or {}

	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己

		self._allPlayerHandCards[self.POSITION_TYPE.NAN] = {}

		self._allPlayerCpgCards[self.POSITION_TYPE.NAN] = {}

		--摸牌 ->出牌
		local newCard = nil

		if msg.operator == 2 then--     还有没有摸牌不能胡牌
			print("碰出牌")
			self._ischeckMyHandStatu = false
			for i,card in ipairs(msg.card_list) do
				table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], card)
			end
		else
			self._ischeckMyHandStatu = true
			newCard = msg.card_list[#msg.card_list]--摸到的牌
			for i,card in ipairs(msg.card_list) do
				if i ~= #msg.card_list then
					table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], card)
				end
			end
		end

		if msg.card_stack then
			for i,cardInfo in ipairs(msg.card_stack) do--吃椪杠

				local info = {}
				info["value"] = cardInfo.value
				info["gang_type"] = cardInfo.gang_type
				info["from"] = cardInfo.from
				info["type"] = cardInfo.type

				table.insert(self._allPlayerCpgCards[self.POSITION_TYPE.NAN], info)
			end
		end

		local sortFun = function(a, b)
			return a < b
		end

		table.sort( self._allPlayerHandCards[self.POSITION_TYPE.NAN], sortFun)
		if newCard then
			table.insert(self._allPlayerHandCards[self.POSITION_TYPE.NAN], newCard)--将新摸得牌放到最后14号位
		end
		print("________________________________________")
		self:configAllPlayerCards(self.POSITION_TYPE.NAN)

		if self._ischeckMyHandStatu then--杠地开花
			self:checkMyHandStatu()
			self._ischeckMyHandStatu = false
		end

	else--不是本人
		if msg.operator == 1 then--     还有没有摸牌不能胡牌
			local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos)
			if direction and self._allPlayerHandCardsNode[direction] then
				self._allPlayerHandCardsNode[direction][14]:setVisible(true)
			end
		end
	end
end

function GamePlayCardsPanel:onNoticePlayCard(msg)   --通知其他人有人出牌 

	local value = msg.card
	local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos) 
	if not direction then
		return 
	end

	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己

		self._allPlayerHandCards[direction] = self._allPlayerHandCards[direction] or {}

		for index,card in pairs(self._allPlayerHandCards[direction]) do
			if card == value then
				table.remove(self._allPlayerHandCards[direction], index)
				break
			end
		end

		self:configAllPlayerCards(self.POSITION_TYPE.NAN)
	else
		local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos)
		if direction and self._allPlayerHandCardsNode[direction] then
			self._allPlayerHandCardsNode[direction][14]:setVisible(false)
		end
		
	end
	
	if self._allPlayerOutCards[direction] then
		local node =  self._allPlayerOutCards[direction][1]
		local face = node:getChildByName("Sprite_Face")

		local cardType = math.floor(value / 10) + 1
		local cardValue = value % 10
		face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")
		node:setVisible(true)
		node:setTag(value)
		table.remove(self._allPlayerOutCards[direction], 1)

		if not self._allPlayerOutInitCards[direction] then
			self._allPlayerOutInitCards[direction] = {}
		end

		table.insert(self._allPlayerOutInitCards[direction], node)
	end

end

function GamePlayCardsPanel:onNoticePengCard(msg)   --通知其他人有人碰牌 

	local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos) 
	if not direction then
		return
	end

	local info = nil
	if msg.item then
		info = {}
		info["value"] = msg.item["value"]
		info["gang_type"] = msg.item["gang_type"]
		info["from"] = msg.item["from"]
		info["type"] = msg.item["type"]

	end

	if not self._allPlayerCpgCards[direction] then
		self._allPlayerCpgCards[direction] = {}
	end
	if info then
		table.insert(self._allPlayerCpgCards[direction], info)

		self:configAllPlayerCards(direction)
	end
end

function GamePlayCardsPanel:onNoticeGangCard(msg)   --通知其他人有人杠牌 
	local direction = self._deleget:getPlayerDirectionByPos(msg.user_pos) 
	if not direction then
		return
	end

	local info = nil
	if msg.item then
		info = {}
		info["value"] = msg.item["value"]
		info["gang_type"] = msg.item["gang_type"]
		info["from"] = msg.item["from"]
		info["type"] = msg.item["type"]

	end

	if not self._allPlayerCpgCards[direction] then
		self._allPlayerCpgCards[direction] = {}
	end

	if info then
		local change = false
		for k,v in pairs(self._allPlayerCpgCards[direction]) do
			if v.value == info.value then--之前是碰  变成了回头杠
				change = true
				self._allPlayerCpgCards[direction][k] = info
				break
			end
		end

		if not change then
			table.insert(self._allPlayerCpgCards[direction], info)
		end

		self:configAllPlayerCards(direction)
	end
end

function GamePlayCardsPanel:onPushPlayerOperatorState(msg)   --通知客户端当前 碰/杠 状态

	if msg.user_pos ==  lt.DataManager:getMyselfPositionInfo().user_pos then--自己


		-- if msg.card then--要吃椪杠的牌
		-- 	tabel.insert(data, msg.card)
		-- end

		--我的吃碰杠通知
        local tObjCpghObj = {
            tObjChi = nil,
            tObjPeng = nil,
            tObjGang = nil,
            tObjHu = nil--抢杠胡
        }
        if msg.operator_list then
	        for k,state in pairs(msg.operator_list) do

	        	if state == "PENG" then
	        		tObjCpghObj.tObjPeng = {}

	        		--table.insert(tObjCpghObj.tObjPeng, msg.card)
	        	elseif state == "GANG" then
	        		if msg.card then
	        			tObjCpghObj.tObjGang = {}
	        			table.insert(tObjCpghObj.tObjGang, msg.card)
	        		end
	        	elseif state == "HU" then--抢杠胡
	        		tObjCpghObj.tObjHu = {}

	        	end
	        end
        end

        --显示吃碰杠胡控件
        self._deleget:resetActionButtonsData(tObjCpghObj)--将牌的数据绑定到按钮上
        self._deleget:viewActionButtons(tObjCpghObj, true)
	end
end

function GamePlayCardsPanel:onRefreshGameOver()   --通知客户端 本局结束 带结算
	-- msg.over_type-- 1 正常结束 2 流局 3 房间解散会发送一个结算
	
	-- msg.award_list
	local gameOverInfo = lt.DataManager:getGameOverInfo()

	local winner_pos = gameOverInfo.winner_pos
	local winner_type = gameOverInfo.winner_type or 1 --自摸 1 抢杠 2
	local last_round = gameOverInfo.last_round

	if gameOverInfo.players then
		for k,v in ipairs(gameOverInfo.players) do
			local direction = self._deleget:getPlayerDirectionByPos(v.user_pos)

			--推到手牌
			if direction ~= self.POSITION_TYPE.NAN and self._allPlayerHandCardsNode[direction] then--手牌
				local index = 1
				for i,node in ipairs(self._allPlayerHandCardsNode[direction]) do
					if node:isVisible() then

						local lieFaceNode = self:createLieFaceItemByDirection(direction)
						if lieFaceNode then 
							local face = lieFaceNode:getChildByName("Sprite_Face")
							local Sprite_Back = lieFaceNode:getChildByName("Sprite_Back")
							Sprite_Back:setVisible(false)

							local value = nil
							if v.card_list[index] then
								value = v.card_list[index]
								local cardType = math.floor(value / 10) + 1
								local cardValue = value % 10
								face:setSpriteFrame("game/mjcomm/cards/card_"..cardType.."_"..cardValue..".png")

								local tempNode = node:getChildByName("Node_PosRight")
								if direction == self.POSITION_TYPE.XI then
									tempNode = node:getChildByName("Node_PosLeftGap")

								elseif direction == self.POSITION_TYPE.DONG then
									tempNode = node:getChildByName("Node_PosRightGap")
								end
								--local root = node:getParent()

								tempNode:addChild(lieFaceNode)
								table.insert(self._allLieFaceCardNode, lieFaceNode)
								index = index + 1
							end
						end
						--node:setVisible(false)
					end
				end
			end
		end
	end
end

function GamePlayCardsPanel:onEnter()   
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.DEAL_DOWN, handler(self, self.onDealDown), "GamePlayCardsPanel.onDealDown")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, handler(self, self.onPushDrawCard), "GamePlayCardsPanel.onPushDrawCard")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, handler(self, self.onPushPlayCard), "GamePlayCardsPanel.onPushPlayCard")
	lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PLAY_CARD, handler(self, self.onNoticePlayCard), "GamePlayCardsPanel.onNoticePlayCard")

    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_PENG_CARD, handler(self, self.onNoticePengCard), "GamePlayCardsPanel.onNoticePengCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.NOTICE_GANG_CARD, handler(self, self.onNoticeGangCard), "GamePlayCardsPanel.onNoticeGangCard")
    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.PUSH_PLAYER_OPERATOR_STATE, handler(self, self.onPushPlayerOperatorState), "GamePlayCardsPanel.onPushPlayerOperatorState")


    lt.GameEventManager:addListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, handler(self, self.onRefreshGameOver), "GamePlayCardsPanel.onRefreshGameOver")

end

function GamePlayCardsPanel:onExit()
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.DEAL_DOWN, "GamePlayCardsPanel:onDealDown")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_DRAW_CARD, "GamePlayCardsPanel:onPushDrawCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAY_CARD, "GamePlayCardsPanel:onPushPlayCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PLAY_CARD, "GamePlayCardsPanel:onNoticePlayCard")
	lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_PENG_CARD, "GamePlayCardsPanel:onNoticePengCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.NOTICE_GANG_CARD, "GamePlayCardsPanel:onNoticeGangCard")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.PUSH_PLAYER_OPERATOR_STATE, "GamePlayCardsPanel:onPushPlayerOperatorState")
    lt.GameEventManager:removeListener(lt.GameEventManager.EVENT.Game_OVER_REFRESH, "GamePlayCardsPanel:onRefreshGameOver")
end

return GamePlayCardsPanel