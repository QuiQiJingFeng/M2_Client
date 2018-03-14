<GameFile>
  <PropertyGroup Name="bjRuleListLayer" Type="Layer" ID="fe46bda1-831f-485d-b5be-0e58dfd5842b" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="3904" ctype="GameLayerObjectData">
        <Size X="900.0000" Y="546.0000" />
        <Children>
          <AbstractNodeData Name="RuleList" ActionTag="1949781716" Tag="3905" IconVisible="False" PositionPercentYEnabled="True" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
            <Size X="900.0000" Y="546.0000" />
            <Children>
              <AbstractNodeData Name="Text_1" ActionTag="1027513037" Tag="3906" IconVisible="False" RightMargin="-10.0000" FontSize="26" LabelText="比鸡&#xA;&#xA;比鸡玩法&#xA;&#xA;人数：游戏支持2-6名玩家共同游戏，房主创建房间时选择几人玩法，玩家进&#xA;入房间需点准备方可进行游戏，未准备情况下可申请退出房间；&#xA;&#xA;牌数：不勾选大小王玩法一副牌去掉大小王，共52张。勾选大小王玩法时加&#xA;入大小王（大小王为癞子）共54张，六人游戏必定带大小王，但大小王不算&#xA;点数（不能和其他牌构成对子、顺子、三条、四条），大王记为红桃或方块，&#xA;小王记为黑桃或梅花；&#xA;注：大小王两张可成对，且为最大对&#xA;&#xA;发牌：每人9张牌，第一局随机1个玩家发，第二局开始从上局赢得第三道（尾&#xA;道）的玩家的下家开始发牌，逆时针方向。&#xA;&#xA;配牌：将9张手牌配成头道、中道、尾道，每道3张牌，分别放入游戏界面的3个&#xA;放牌框中。其中头道&lt;中道&lt;尾道；&#xA;&#xA;比牌：所有玩家组好牌后，开始比牌。按照头道、中道、尾道顺序依次亮牌进&#xA;行比牌；&#xA;&#xA;通关：比牌结束后，其中一位玩家三道都大于其他玩家，则为通关。通关有额&#xA;外奖励分，不赢弃牌者通关分；&#xA;&#xA;喜牌：当配置的9张牌达成指定条件后，会获得喜牌奖励，奖励为其他玩家支付&#xA;给拥有喜牌玩家的指定分数，喜牌不管输赢都有奖励。如果有多种，按照最大&#xA;的奖励积分，多种类型喜牌分可累积，其中不赢弃牌者喜牌分；&#xA;&#xA;弃牌：如玩家的手牌很差，则可以选择弃牌。弃牌后只输牌分（自己也无奖励&#xA;分），不输喜牌和通关分。弃牌玩家每一道固定输（玩家数-1）*1底分；&#xA;注意点：&#xA;     A：弃牌的玩家每一道输分输给该道最大牌者；&#xA;     B：如果当局玩家全部弃牌，则玩家输赢分都为0，没有输赢，全部结算分&#xA;均是0；&#xA;&#xA;炸弹：双炸弹为默认喜牌，如增加其他喜牌奖励，创建房间时需勾选喜牌奖励，&#xA;勾选后则带所有喜牌牌型分。&#xA;&#xA;比牌规则&#xA;首选比较牌型：三条&gt;同花顺&gt;同花&gt;顺子&gt;对子&gt;单张（乌龙）；&#xA;其次比较点数：A&gt;K&gt;Q&gt;J&gt;10&gt;9&gt;8&gt;7&gt;6&gt;5&gt;4&gt;3&gt;2&gt;大王&gt;小王;&#xA;最后比较花色：黑桃&gt;红桃&gt;梅花&gt;方块。&#xA;&#xA;牌型&#xA;三条：三张点数相同的牌，如AAA&#xA;同花顺：三张同花色连续的牌，A23是最小同花顺，AKQ为最大同花顺&#xA;同花：三张相同花色且不连续的牌，如黑桃KJ5&#xA;顺子：三张牌点数连续的组合，如A23为最小顺子，AKQ为最大顺子&#xA;对子：两张点数相同的牌组成，若遇到点数相同对子则比较单张点数大小，若&#xA;单张点数也相同则比较对子的花色&#xA;单张：组不出以上任何牌型的牌，若遇到3张点数一样的牌型，则比最大牌的花&#xA;色&#xA;&#xA;积分结算&#xA;首先比较每一道的积分（基础分）：&#xA;2人模式下，每道牌赢家得1*底分，输家扣1*底分；&#xA;3人模式下，每道牌最大的玩家为赢家，其他为输家，赢家得3*底分，第二大扣&#xA;1*底分，最小扣2*底分；&#xA;4人模式下，每道牌最大的玩家为赢家，其他为输家，赢家得6*底分，第二大扣&#xA;1*底分，第三大扣2*底分，最小3*底分；&#xA;5人模式下，每道牌最大的玩家为赢家，其他为输家，赢家得10*底分，第二大&#xA;扣1*底分，第三大扣2*底分，第四大扣3*底分，最小扣4*底分。&#xA;6人模式下，每道牌最大的玩家为赢家，其他为输家，赢家得15*底分，第二大&#xA;扣1*底分，第三大扣2*底分，第四大扣3*底分，第五大扣4*底分，最小扣5*底&#xA;分。&#xA;&#xA;三道分数累加后，随后看是否有通关（通关分）：&#xA;通关奖励分为其他玩家每人贡献1/2/3/4/5*底分（对应2/3/4/5/6人）。例如3&#xA;人模式，奖励分为2*底分，其他玩家每人输2*底分，共获得4*底分。&#xA;最后显示是否有喜牌（喜牌分）：&#xA;1-6种喜牌奖励分结算方式与通关奖励类似，其他玩家每人贡1/2/3/4*底分（对&#xA;应2/3/4/5人玩法），7-12种喜牌为每人贡献固定奖励分&#xA;玩家最终积分=基础积分+通关分+喜牌奖励分&#xA;&#xA;喜牌说明：&#xA;全黑:9张牌全是黑桃或者梅花组成；&#xA;全红:9张牌全是红桃或者方块组成；&#xA;三顺子：头道、中道、尾道都是顺子；&#xA;双同花顺：中道、尾道牌为同花顺；&#xA;双三条：中道、尾道牌为三条；&#xA;三清：三道牌全为同花；&#xA;三同花顺：三道牌全是同花顺，固定奖励6*底分；(不叠加算双同花顺)&#xA;炸弹：手上牌有四个一样的牌，固定奖励6*底分（必须配出1个三条才有奖励）&#xA;全三条：三道牌全是三条，固定奖励8*底分；(不叠加算双三条的分)&#xA;九连顺：9张牌是连续的顺子，固定奖励8*底分；(不叠加算三顺子的分)&#xA;九连同花顺：9张牌是连续的顺子且花色相同，固定奖励10*底分(不叠加算九&#xA;连顺、三同花顺、双同花顺、三顺子、三清的分)；&#xA;双炸弹：手上有2副四张一样的牌，固定奖励10*底分（必须配出两个三条才有&#xA;奖励）。(不叠加算单个炸弹、双三条的分)" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="910.0000" Y="2340.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="455.0000" Y="1170.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="116" G="61" B="0" />
                <PrePosition X="0.5056" Y="0.5000" />
                <PreSize X="1.0111" Y="1.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="1.0000" />
            <Position Y="546.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition Y="1.0000" />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="150" B="255" />
            <FirstColor A="255" R="150" G="150" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>