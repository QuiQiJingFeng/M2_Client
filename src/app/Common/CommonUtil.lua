
-- 通用接口集合
local CommonUtil = {}

local floor = math.floor
local ceil  = math.ceil
local abs   = math.abs
local min   = math.min
local max   = math.max

function CommonUtil.print(...)
    if DEBUG_LOG then
        print(...)
    end
end

function CommonUtil.printf(...)
    if DEBUG_LOG then
        printf(...)
    end
end

function CommonUtil.printTable(t, indent)
    local pre = string.rep("\t", indent)
    for k,v in pairs(t) do
        if type(v) == "table" then
            if type(k) == "number" then
                lt.CommonUtil.print(pre .. "[" .. k .. "]" .. " = {")
                self:printTable(v, indent + 1)
                lt.CommonUtil.print(pre .. "},")
            elseif type(k) == "string" then
                if tonumber(k) then
                    lt.CommonUtil.print(pre .. "[\"" .. k .. "\"] = {")
                elseif (tonumber(string.sub(k, 1, 1))) then
                    lt.CommonUtil.print(pre .. "[\"" .. k .. "\"] = {")
                else
                    lt.CommonUtil.print(pre .. k .. " = {")
                end
                self:printTable(v, indent + 1)
                lt.CommonUtil.print(pre .. "},")
            end
        elseif type(v) == "number" then
            if type(k) == "number" then
                lt.CommonUtil.print(pre .. "[" .. k .. "]" .. " = " .. v .. ",")
            elseif type(k) == "string" then
                if tonumber(k) then
                    lt.CommonUtil.print(pre .. "[\"" .. k .. "\"] = " .. v .. ",")
                elseif (tonumber(string.sub(k, 1, 1))) then
                    lt.CommonUtil.print(pre .. "[\"" .. k .. "\"] = " .. v .. ",")
                else
                    lt.CommonUtil.print(pre .. k .. " = " .. v .. ",")
                end
            end
        elseif type(v) == "string" then
            local text = string.gsub(v, "[\n]", "")
            text = string.gsub(text, "\"", "\\\"")
            if type(k) == "number" then
                lt.CommonUtil.print(pre .. "[" .. k .. "]" .. " = \"" .. text .. "\",")
            elseif type(k) == "string" then
                if tonumber(k) then
                    lt.CommonUtil.print(pre .. "[\"" .. k .. "\"] = \"" .. text .. "\",")
                elseif (tonumber(string.sub(k, 1, 1))) then
                    lt.CommonUtil.print(pre .. "[\"" .. k .. "\"] = \"" .. text .. "\",")
                else
                    lt.CommonUtil.print(pre .. k .. " = \"" .. text .. "\",")
                end
            end
        end
    end
end

function CommonUtil:composeMessageEventName(messageId)
    return "MESSAGE_" .. messageId
end

function CommonUtil:toInt(value)
    if value >= 0 then
        return floor(value)
    end

    if value < 0 then
        return floor(value) + 1
    end
end

-- 将值限定在一个范围内
function CommonUtil:fixValue(value, min, max)
    if value < min then
        value = min
    end

    if value > max then
        value = max
    end

    return value
end

-- 判断方向是否上下
function CommonUtil:isUpDown(direction)
    return direction == lt.Constants.DIRECTION.UP or direction == lt.Constants.DIRECTION.DOWN
end

-- 判断方向是否左右
function CommonUtil:isLeftRight(direction)
    return direction == lt.Constants.DIRECTION.RIGHT or direction == lt.Constants.DIRECTION.LEFT
end

-- 交换左右方向
function CommonUtil:changeLeftRight(direction)
    if direction == lt.Constants.DIRECTION.LEFT then
        return lt.Constants.DIRECTION.RIGHT
    elseif direction == lt.Constants.DIRECTION.RIGHT then
        return lt.Constants.DIRECTION.LEFT
    else
        return direction
    end
end

-- 根据方向(左右)设置scaleX
function CommonUtil:setScaleX(target, direction)
    if direction == lt.Constants.DIRECTION.RIGHT then
        target:setScaleX(abs(target:getScaleX()))
    elseif direction == lt.Constants.DIRECTION.LEFT then
        target:setScaleX(-abs(target:getScaleX()))
    end
end

-- 根据方向(左右)设置speedX
function CommonUtil:setSpeedX(target, direction, speedX)
    if direction == lt.Constants.DIRECTION.RIGHT then
        target:setSpeedX(speedX)
    elseif direction == lt.Constants.DIRECTION.LEFT then
        target:setSpeedX(-speedX)
    else
        target:setSpeedX(0)
    end
end

function CommonUtil:grayNode(node, isGray)
    if isGray then
        node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgram:createWithFilenames("shader/normalTexture.vsh","shader/gray.fsh")))
    else
        node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
    end
end

--[[
    判断线段和矩形框是否有交点

    line = {cc.p, cc.p}
    rect = cc.rect

    返回 true 相交中点
        false
    ]]
function CommonUtil:isLineIntersectRect(line, rect)
    local lp1 = line[1]
    local lp2 = line[2]

    if lp1.x == lp2.x then
        -- 与Y轴平行(计算xy坐标大小)
        local lpx = lp1.x
        if lpx < rect.x or lpx > rect.x + rect.width then
            return false
        else
            local minly = min(lp1.y, lp2.y)
            local maxly = max(lp1.y, lp2.y)

            if minly > rect.y + rect.height or maxly < rect.y then
                return false
            else
                -- 相交
                local maxiy = min(maxly, rect.y + rect.height)
                local miniy = max(minly, rect.y)

                local iy = (maxiy + miniy) / 2

                return true, cc.p(lpx, iy)
            end
        end
    else
        if lp1.y == lp2.y then
            -- 与X轴平行(计算xy坐标大小)
            local lpy = lp1.y
            if lpy < rect.y or lpy > rect.y + rect.height then
                return false
            else
                local minlx = min(lp1.x, lp2.x)
                local maxlx = max(lp1.x, lp2.x)

                if minlx > rect.x + rect.width or maxlx < rect.x then
                    return false
                else
                    -- 相交
                    local maxix = min(maxlx, rect.x + rect.width)
                    local minix = max(minlx, rect.x)

                    local ix = (maxix + minix) / 2

                    return true, cc.p(ix, lpy)
                end
            end
        else
            -- 不与Y轴平行(计算直线交点是否在区域内)
            local interPointArray = {}

            -- 计算直线函数
            local lA = (lp1.y - lp2.y) / (lp1.x - lp2.x)
            local lB = lp1.y - lA * lp1.x

            -- 区域范围
            local minrx = rect.x
            local maxrx = rect.x + rect.width
            local minry = rect.y
            local maxry = rect.y + rect.height

            -- 线段范围
            local minlx = min(lp1.x, lp2.x)
            local maxlx = max(lp1.x, lp2.x)
            local minly = min(lp1.y, lp2.y)
            local maxly = max(lp1.y, lp2.y)

            -- 左交点
            local ix1 = rect.x
            if ix1 > minlx and ix1 < maxlx then
                local iy1 = lA * ix1 + lB
                if iy1 < maxry and iy1 > minry then
                    interPointArray[#interPointArray + 1] = cc.p(ix1, iy1)
                end
            end

            -- 右交点
            local ix2 = rect.x + rect.width
            if ix2 > minlx and ix2 < maxlx then
                local iy2 = lA * ix2 + lB
                if iy2 < maxry and iy2 > minry then
                    interPointArray[#interPointArray + 1] = cc.p(ix2, iy2)
                end
            end

            -- 下交点
            local iy3 = rect.y
            if iy3 > minly and iy3 < maxly then
                local ix3 = (iy3 - lB) / lA
                if ix3 < maxrx and ix3 > minrx then
                    interPointArray[#interPointArray + 1] = cc.p(ix3, iy3)
                end
            end

            -- 上交点
            local iy4 = rect.y + rect.height
            if iy4 > minly and iy4 < maxly then
                local ix4 = (iy4 - lB) / lA
                if ix4 < maxrx and ix4 > minrx then
                    interPointArray[#interPointArray + 1] = cc.p(ix4, iy4)
                end
            end

            if #interPointArray >= 1 then
                if #interPointArray == 2 then
                    -- 有交点
                    local ip1 = interPointArray[1]
                    local ip2 = interPointArray[2]

                    return true, cc.p((ip1.x + ip2.x) / 2, (ip1.y + ip2.y) / 2)
                elseif #interPointArray == 1 then
                    local ip1 = interPointArray[1]

                    return true, ip1
                end
            else
                return false
            end
        end
    end

    return false
end

-- 获取2个rect交汇矩形中点
function CommonUtil:rectCenterPoint(rect1, rect2)
    -- 计算被击中点
    local xTable = {}
    xTable[#xTable + 1] = rect1.x
    xTable[#xTable + 1] = rect1.x + rect1.width
    xTable[#xTable + 1] = rect2.x
    xTable[#xTable + 1] = rect2.x + rect2.width

    table.sort(xTable, function(x1, x2)
        return x1 > x2
    end)

    local yTable = {}
    yTable[#yTable + 1] = rect1.y
    yTable[#yTable + 1] = rect1.y + rect1.height
    yTable[#yTable + 1] = rect2.y
    yTable[#yTable + 1] = rect2.y + rect2.height

    table.sort(yTable, function(y1, y2)
        return y1 > y2
    end)

    return cc.p((xTable[2] + xTable[3]) / 2, (yTable[2] + yTable[3]) / 2)
end

function CommonUtil:rectIntersectsCircle(rect, circleCenter, circleRadius)
    local circleRect = cc.rect(circleCenter.x - circleRadius, circleCenter.y - circleRadius, circleRadius * 2, circleRadius * 2)
    if cc.rectIntersectsRect(rect, circleRect) then
        -- 矩形相关再具体运算
        local rectCenter = cc.p(rect.x  + rect.width / 2, rect.y + rect.height / 2)
        local p1, p2 = nil, nil

        if circleCenter.x == rectCenter.x then
            if circleCenter.y == rectCenter.y then
                return true
            end

            p1 = cc.p(circleCenter.x, rect.y)
            p2 = cc.p(circleCenter.x, rect.y + rect.height)
        elseif circleCenter.y == rectCenter.y then
            if circleCenter.x == rectCenter.x then
                return true
            end

            p1 = cc.p(rect.x, circleCenter.y)
            p2 = cc.p(rect.x + rect.width, circleCenter.y)
        else
            local a = (circleCenter.y - rectCenter.y) / (circleCenter.x - rectCenter.x)
            local b = rectCenter.y - a * rectCenter.x

            local tpArray = {}
            local tp1 = cc.p(rect.x, a * rect.x + b)
            if tp1.y > rect.y and tp1.y < rect.y + rect.height then
                tpArray[#tpArray + 1] = tp1
            end
            local tp2 = cc.p(rect.x + rect.width, a * (rect.x + rect.width) + b)
            if tp2.y > rect.y and tp2.y < rect.y + rect.height then
                tpArray[#tpArray + 1] = tp2
            end
            local tp3 = cc.p((rect.y - b) / a, rect.y)
            if tp3.x > rect.x and tp3.x < rect.x + rect.width then
                tpArray[#tpArray + 1] = tp3
            end
            local tp4 = cc.p(((rect.y + rect.height) - b) / a, rect.y + rect.height)
            if tp4.x > rect.x and tp4.x < rect.x + rect.width then
                tpArray[#tpArray + 1] = tp4
            end

            if #tpArray < 2 then
                return false
            end

            p1 = tpArray[1]
            p2 = tpArray[2]
        end

        local circleRadiusSQ = circleRadius * circleRadius
        local calRadiusSQ1 = (p1.x - circleCenter.x) * (p1.x - circleCenter.x) + (p1.y - circleCenter.y) * (p1.y - circleCenter.y)
        local calRadiusSQ2 = (p2.x - circleCenter.x) * (p2.x - circleCenter.x) + (p2.y - circleCenter.y) * (p2.y - circleCenter.y)
        
        if calRadiusSQ1 < circleRadiusSQ or calRadiusSQ2 < circleRadiusSQ then
            return true
        else
            return false
        end
    else
        return false
    end
end

--[[
    获取比较均匀的技能分布(自身范围内 间隔)
    count       数量
    distance    自身为中点距离
    origin      初始点             默认(0,0)
    spacing     间距              默认150
    ]] 
function CommonUtil:getUniformPos(count, distance, origin, spacing)
    local targetPosArray = {}
    origin = origin or cc.p(0, 0)
    spacing = spacing or 150

    local deltaArray = {}
    for i=1,count do
        local delta = 0
        local whileTimes = 0
        while true do
            delta = math.random(-distance, distance)

            if whileTimes > 20 then
                break
            end
            whileTimes = whileTimes + 1

            -- 判断是否数值接近
            local near = false
            for _,dt in ipairs(deltaArray) do
                if abs(delta - dt) < spacing then
                    near = true
                end
            end

            if not near then
                break
            end
        end

        deltaArray[#deltaArray + 1] = delta

        targetPosArray[#targetPosArray + 1] = cc.p(origin.x + delta, origin.y)
    end

    return targetPosArray
end

-- ################################################## Hash表相关 ##################################################
function CommonUtil:getArrayFromTable(theTable)
    local theArray = {}
    for _,v in pairs(theTable) do
        theArray[#theArray + 1] = v
    end

    return theArray
end

function CommonUtil:calcHashTableLength(theTable)
    local length = 0
    for _, _ in pairs(theTable) do
        length = length + 1
    end

    return length
end

function CommonUtil:isTableEmpty(theTable)
    if not theTable then
        return true
    end

    return next(theTable) == nil
end

-- 从1开始
function CommonUtil:getCellAtIndexInHashTable(theTable, idx)
    local i = 0
    for _, var in pairs(theTable) do
        i = i + 1

        if i == idx then
            return var
        end
    end

    return nil
end

function CommonUtil:shuffleArray(theArray)
    if not theArray then
        return
    end

    local arrayCount = #theArray
    for i=1,arrayCount do
        local j = math.random(i, arrayCount)
        theArray[i], theArray[j] = theArray[j], theArray[i]
    end
end

-- ################################################## 字符串相关 ##################################################
function CommonUtil.utf8sub(str, num)
    if not str then
        return ""
    end

    local ucharArray = {}
    local rString = ""
    for uchar in string.gfind(str, '[%z\1-\127\194-\244][\128-\191]*') do
        ucharArray[#ucharArray+1] = uchar
    end

    for i=1,num do
        local uchar = ucharArray[i]
        if uchar == nil then
            break
        end

        rString = rString..uchar
    end 

    return rString
end

function CommonUtil.utf8Chinesesub(str, num)
    if not str then
        return ""
    end

    local ucharArray = {}
    local rString = ""
    for uchar in string.gfind(str, '[\228-\233][\128-\191]*') do
        ucharArray[#ucharArray+1] = uchar
    end

    local count = #ucharArray
    local sum = 0
    for i=1,count do
        local uchar = ucharArray[i]
        if uchar == nil then
            break
        end

        if #uchar > 1 then
            rString = rString..uchar
            sum = sum + 1
        end

        if sum >= num then
            break
        end
    end 

    return rString
end

function CommonUtil.utf8ChineseCheck(str)
    if not str then
        return false
    end

    local ucharArray = {}
    local count = 0
    for uchar in string.gfind(str, '[%z\1-\127\194-\244][\128-\191]*') do
        if string.byte(uchar) < 228 or string.byte(uchar) > 233 or string.byte(uchar, 2) < 128 or string.byte(uchar, 2) > 191 then
            return false
        end

        count = count + 1
    end

    return true, count
end

-- ################################################## 时间相关 ##################################################
-- 当前时间
function CommonUtil:getCurrentClock()
    return cc.net.SocketTCP:getTime()
end
-- 当前时间
CommonUtil._delayTime  = 0 -- 与服务器时间延迟
CommonUtil._delayOver  = 0 -- 服务器时间延迟超限次数
CommonUtil._deltaTime  = 0 -- 网络波动
CommonUtil._deltaOver  = 0 -- 服务器偏差大的次数

function CommonUtil:setServerTime(serverTime)
    local osTime = self:getOSTime()
    local delayTime = serverTime - osTime
    self._deltaTime = self._delayTime - delayTime -- 最新波动
    self._delayTime = delayTime

    if self._deltaTime > lt.Constants.SERVER_DELTA_RANGE then
        self._deltaOver = self._deltaOver + 1

        if self._deltaOver > lt.Constants.SERVER_DELTA_TIME then
            -- 网络波动较大
            lt.Game:sadNetworkReset()
            return
        end
    else
        -- 重置警报
        self._deltaOver = 0
    end
end

function CommonUtil:setServerDelta(serverDelta)
    self._deltaTime = self._delayTime - serverDelta
    self._delayTime = serverDelta

    if self._deltaTime > lt.Constants.SERVER_DELTA_RANGE then
        self._deltaOver = self._deltaOver + 1

        if self._deltaOver > lt.Constants.SERVER_DELTA_TIME then
            -- 网络波动较大
            lt.Game:sadNetworkReset()
            return
        end
    else
        -- 重置警报
        self._deltaOver = 0
    end
end

function CommonUtil:getOSTime(tm)
    return os.time(tm)
end

-- 当前时间(服务器误差取四舍五入)
function CommonUtil:getCurrentTime()
    return self:getOSTime() + math.round(self._delayTime)
end

function CommonUtil:getServerDelayTime()
    return math.round(self._delayTime)
end

-- 原点时间(作为刷新起点 如 Boss刷新)
CommonUtil._originalTime = nil
function CommonUtil:getOriginalTime()
    if not self._originalTime then
        self._originalTime = lt.CommonUtil:getOSTime({year = 2015, month = 1, day = 1, hour = 0})
    end

    return self._originalTime
end

-- 移动到设定时区的固定小时 / 如果设有dayTime则日期规范到对应日期
function CommonUtil:getFormatTime(hour, dayTime)
    if not hour then hour = 0 end

    local utcTime = self:getCurrentTime() --UTC

    local tm = os.date("*t", utcTime)

    if dayTime then
        local ttm = os.date("*t", dayTime)

        tm.day   = ttm.day
        tm.month = ttm.month
        tm.year  = ttm.year
    end

    tm.hour = hour
    tm.min  = 0
    tm.sec  = 0

    local isdst,gmtoff = nil
    utcTime, isdst, gmtoff = self:getOSTime(tm)
    if isdst > 0 then t = t - 3600 end -- 夏令时
    -- utcTime = utcTime + gmtoff -- 恢复到UTC+8
    return utcTime;
end

-- 判断是否超过一天
function CommonUtil:overDay(tm1, tm2)
    if not tm1 or not tm2 then
        return false
    end

    local year1 = tm1.year or 0
    local year2 = tm2.year or 0

    if year1 > year2 then
        return true
    elseif year1 == year2 then
        local yday1 = tm1.yday or 0
        local yday2 = tm2.yday or 0
        if yday1 > yday2 then
            return true
        end
    end

    return false
end

function CommonUtil:getTM(utcTime)
    if not utcTime then
        utcTime = self:getCurrentTime()
    end

    local tm = os.date("*t", utcTime)

    return tm
end

function CommonUtil:getFormatDay(utcTime, type)
    if not utcTime then
        utcTime = self:getCurrentTime()
    end

    local tm = self:getTM(utcTime)

    if type == 1 then -- year/month/day
        return string.format(lt.StringManager:getString("STRING_TIME_F_1"), tm.year, tm.month, tm.day)
    elseif type == 2 then -- year年month月day日 hour:min
        return string.format(lt.StringManager:getString("STRING_TIME_F_2"), tm.year, tm.month, tm.day, tm.hour, tm.min)
    elseif type == 3 then -- month-day hour:min (邮件)
        return string.format(lt.StringManager:getString("STRING_TIME_F_3"), tm.month, tm.day, tm.hour, tm.min)
    elseif type == 4 then -- %d月%d日
        return string.format(lt.StringManager:getString("STRING_TIME_F_4"), tm.month, tm.day)
    elseif type == 5 then -- year-month-day
        return string.format(lt.StringManager:getString("STRING_TIME_F_5"), tm.year, tm.month, tm.day)
    elseif type == 6 then
        return string.format(lt.StringManager:getString("STRING_TIME_F_6"), tm.day)
    elseif type == 7 then
        return string.format(lt.StringManager:getString("STRING_TIME_F_7"), tm.hour,tm.min,tm.sec)
    elseif type == 11 then -- hour:min
        return string.format(lt.StringManager:getString("STRING_TIME_F_11"), tm.hour, tm.min)
    elseif type == 12 then -- hour:min:s
        return string.format(lt.StringManager:getString("STRING_TIME_F_10"), tm.hour, tm.min, tm.sec)
    elseif type == 1100 then -- hour:min(min四舍五入 针对活动重置时间专用)
        local hour = tm.hour
        local min  = tm.min

        if min < 15 then
            min = 0
        elseif min < 45 then
            min = 30
        else
            min = 0
            hour = hour + 1

            if hour >= 24 then
                hour = 0
            end
        end

        return string.format(lt.StringManager:getString("STRING_TIME_F_11"), hour, min), hour, min
    else -- year-month-day hour:min:sec
        return string.format(lt.StringManager:getString("STRING_TIME_F_0"), tm.year, tm.month, tm.day, tm.hour, tm.min, tm.sec)
    end
end

function CommonUtil:getFormatCountDown(countdown, type)

    local tm = os.date("!*t", countdown)
    if type == 1 then -- h:m:s
        return string.format(lt.StringManager:getString("STRING_TIME_F_10"), tm.hour, tm.min, tm.sec)
    elseif type == 2 then -- m:s
        return string.format(lt.StringManager:getString("STRING_TIME_F_11"), tm.min, tm.sec)
    elseif type == 10 then
        -- 中文格式时间
        if countdown >= 3600 then -- 一小时以上
            if tm.min == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9100"), tm.hour)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9110"), tm.hour, tm.min)
            end
        elseif countdown >= 60 then -- 一分钟以上
            if tm.sec == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9010"), tm.min)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9011"), tm.min, tm.sec)
            end
        else
            return string.format(lt.StringManager:getString("STRING_TIME_F_9001"), tm.sec)
        end
    elseif type == 11 then
        -- 中文格式时间
        if countdown >= 3600 then -- 一小时以上
            if tm.min == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9100"), tm.hour)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9110"), tm.hour, tm.min)
            end
        elseif countdown >= 60 then -- 一分钟以上
            if tm.sec == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9010"), tm.min)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9011"), tm.min, tm.sec)
            end
        else
            return lt.StringManager:getString("STRING_TIME_F_901l")
        end
    elseif type == 12 then
        -- 中文格式时间
        if countdown >= 3600 then -- 一小时以上
            return string.format(lt.StringManager:getString("STRING_TIME_F_9100"), tm.hour)
        elseif countdown >= 60 then -- 一分钟以上
            return string.format(lt.StringManager:getString("STRING_TIME_F_9010"), tm.min)
        else
            return lt.StringManager:getString("STRING_TIME_F_901l")
        end
    elseif type == 19 then
        -- 中文格式
        if countdown >= 86400 then
            local day = ceil(countdown / 86400)

            return string.format(lt.StringManager:getString("STRING_TIME_F_10000"), day)
        elseif countdown >= 3600 then
            if tm.min == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9100"), tm.hour)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9110"), tm.hour, tm.min)
            end
        elseif countdown >= 60 then -- 一分钟以上
            if tm.sec == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9010"), tm.min)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9011"), tm.min, tm.sec)
            end
        else
            return lt.StringManager:getString("STRING_TIME_F_901l")
        end
    elseif type == 20 then
        -- 中文格式
        if countdown >= 86400 then
            local day = ceil(countdown / 86400)

            return string.format(lt.StringManager:getString("STRING_TIME_F_10000"), day)
        elseif countdown >= 3600 then
            if tm.min == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9100"), tm.hour)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9110"), tm.hour, tm.min)
            end
        elseif countdown >= 60 then -- 一分钟以上
            if tm.sec == 0 then
                return string.format(lt.StringManager:getString("STRING_TIME_F_9010"), tm.min)
            else
                return string.format(lt.StringManager:getString("STRING_TIME_F_9011"), tm.min, tm.sec)
            end
        else
            return string.format(lt.StringManager:getString("STRING_TIME_F_9001"), tm.sec)
        end
    end
end

function CommonUtil:setFileMd5(filePath, md5)
end

function CommonUtil:fileCheckMd5(filePath)
    local fullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath)
    if not io.exists(fullPath) then
        return ""
    end

    local md51 = crypto.md5file(fullPath)
    local md52 = crypto.md5(md51..lt.Constants.EXTRA_MD5)

    return md52
end

-- 获得设备Id(唯一标示符)
function CommonUtil:getDeviceId()
    do return device.getOpenUDID() end

    if device.platform == "ios" then
        -- idfa?
        return "xxx"
    elseif device.platform == "mac" then
        return device.getOpenUDID()
    elseif device.platform == "android" then
        -- mac 地址
    end
end

function CommonUtil:formatTimeToNow(pTime)
    local currTime = self:getCurrentTime()
    local diff = currTime - pTime
    if diff > 86400 then
        local day = floor(diff/86400)
        return lt.StringManager:getString("STRING_FRIEND_STATUS_0")..day..lt.StringManager:getString("STRING_TIME_D")
    end

    if diff > 3600 then
        local hour = floor(diff/3600)
        return lt.StringManager:getString("STRING_FRIEND_STATUS_0")..hour..lt.StringManager:getString("STRING_TIME_H")
    end

    if diff > 60 then
        local min = floor(diff/60)
        return lt.StringManager:getString("STRING_FRIEND_STATUS_0")..min..lt.StringManager:getString("STRING_TIME_M_2")
    end

    return lt.StringManager:getString("STRING_FRIEND_STATUS_0").."1"..lt.StringManager:getString("STRING_TIME_M_2")
end

function CommonUtil:formatTimeToDay(pTime)
    local currTime = self:getCurrentTime()
    local diff = currTime - pTime
    local day = ceil(diff/86400)
    return day..lt.StringManager:getString("STRING_TIME_D")
end

function CommonUtil:propertyRestraint(fromProperty, targetProperty)
    if fromProperty == lt.Constants.PROPERTY.NIL then
        return false
    elseif fromProperty == lt.Constants.PROPERTY.FIRE then
        return targetProperty == lt.Constants.PROPERTY.WIND
    elseif fromProperty == lt.Constants.PROPERTY.WATER then
        return targetProperty == lt.Constants.PROPERTY.FIRE
    elseif fromProperty == lt.Constants.PROPERTY.WIND then
        return targetProperty == lt.Constants.PROPERTY.WATER
    elseif fromProperty == lt.Constants.PROPERTY.LIGHT then
        return targetProperty == lt.Constants.PROPERTY.DARK
    elseif fromProperty == lt.Constants.PROPERTY.DARK then
        return targetProperty == lt.Constants.PROPERTY.LIGHT
    end

    return false
end

function CommonUtil:subString(input,length)
    local len  = string.len(input)
    local left = len
    local nLen  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 and length ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                nLen = nLen + i
                break
            end
            i = i - 1
        end
        length = length - 1
    end
    return string.sub(input,1,nLen)
end

--获取当前星期几
function CommonUtil:getCurrentWeekDay()
    local time = self:getCurrentTime()

    local tm = os.date("!*t", time)

    local wday = tm.wday

    local day = wday - 1 
    if day == 0 then
        day = 7
    end

    return day
end

--不管是英文字符还是中文字符都当作一个字符来计算index
--截取中英混合的UTF8字符串，endIndex可缺省
function CommonUtil:SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = CommonUtil:SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = CommonUtil:SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, CommonUtil:SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, CommonUtil:SubStringGetTrueIndex(str, startIndex), CommonUtil:SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

--获取中英混合UTF8字符串的真实字符数量
function CommonUtil:SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = CommonUtil:SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function CommonUtil:SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = CommonUtil:SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

--返回当前字符实际占用的字符数
function CommonUtil:SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end

-- 返回IphoneX刘海所在的位置 0 无效/未知 1 刘海在左边 2 刘海在右边
function CommonUtil:getStatusBarOrientation()
    -- do return 1 end

    if device.platform == "ios" then
        local statusBarOrientation = cpp.ExtraAPI:getStatusBarOrientation()
        return statusBarOrientation
    else
        return 0
    end
end

function CommonUtil:isDeviceIphoneX()
    if device.platform == "ios" then
        local deviceModel = cpp.ExtraAPI:getDeviceModel()
        if deviceModel == "iPhone10,3" or deviceModel == "iPhone10,6" then
            return true
        else
            return false
        end
    else
        return false
    end
end

function CommonUtil:rectArrayUnion(rectArray)
    if not rectArray then
        return cc.rect(0, 0, 0, 0)
    end

    -- local unionRect = 
    local minX = nil
    local minY = nil
    local maxX = nil
    local maxY = nil
    for _,rect in ipairs(rectArray) do
        if not minX then
            minX = rect.x
        else
            minX = min(minX, rect.x)
        end

        if not minY then
            minY = rect.y
        else
            minY = min(minY, rect.y)
        end

        if not maxX then
            maxX = rect.x + rect.width
        else
            maxX = max(maxX, rect.x + rect.width)
        end

        if not maxY then
            maxY = rect.y + rect.height
        else
            maxY = max(maxY, rect.y + rect.height)
        end
    end

    return cc.rect(minX, minY, maxX - minX, maxY - minY)
end

function CommonUtil:positionArrayUnion(positionArray)
    if not positionArray then
        return cc.rect(0, 0, 0, 0)
    end

    local minX = nil
    local minY = nil
    local maxX = nil
    local maxY = nil
    for _,position in ipairs(positionArray) do
        if not minX then
            minX = position.x
        else
            minX = min(minX, position.x)
        end

        if not minY then
            minY = position.y
        else
            minY = min(minY, position.y)
        end

        if not maxX then
            maxX = position.x
        else
            maxX = max(maxX, position.x)
        end

        if not maxY then
            maxY = position.y
        else
            maxY = max(maxY, position.y)
        end
    end

    return cc.rect(minX, minY, maxX - minX, maxY - minY)
end

-- 复制文本到剪切板
function CommonUtil:copyToClipboard(message)
    if cpp.ExtraAPI.copyToClipboard then
        cpp.ExtraAPI:copyToClipboard(message)
    end
end

function CommonUtil:addNodeClickEvent(node, callBack)
    local oldScale = 1
    local newScale = oldScale
    node:setTouchEnabled(true)
   -- TOUCH_EVENT_BEGAN                      = ccui.TouchEventType.began
   -- TOUCH_EVENT_MOVED                      = ccui.TouchEventType.moved
   -- TOUCH_EVENT_ENDED                      = ccui.TouchEventType.ended
   -- TOUCH_EVENT_CANCELED                   = ccui.TouchEventType.canceled
   --local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))

    -- local action1 = cc.ScaleTo:create(0.08, 1.1)
    -- local action2 = cc.ScaleTo:create(0.04, 1)

    node:addTouchEventListener(function(widget, event_type)
        if event_type == ccui.TouchEventType.began then
                        -- 缩放
            node:setScale(0.9)
        elseif event_type == ccui.TouchEventType.ended then
            node:setScale(1)
            if callBack then
                callBack(node)
            end
        elseif event_type == ccui.TouchEventType.canceled then   
            node:setScale(1)
        end
    end)
end

return CommonUtil
