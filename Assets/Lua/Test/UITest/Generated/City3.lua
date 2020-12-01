--由UITest自动生成的脚本

function UITestFunction_City3()
    --开始测试
    CS.LPCFramework.UITesterManager.StartTestCommandQueue()
    CS.LPCFramework.UITesterManager.EnterSection("City3")

    --等待1738毫秒后点击_n13.n8
    CS.LPCFramework.UITesterManager.AddInterval(1738)
    CS.LPCFramework.UITesterManager.AddClick("_n13.n8")

    --等待4581毫秒后点击_n13.n4
    CS.LPCFramework.UITesterManager.AddInterval(4581)
    CS.LPCFramework.UITesterManager.AddClick("_n13.n4")

    --等待8360毫秒
    CS.LPCFramework.UITesterManager.AddInterval(8360)

    --检查文本框_n295.n33.n21的文字是否是"[盟友]玩家名字7个字"
    CS.LPCFramework.UITesterManager.CheckText("_n295.n33.n21","[盟友]玩家名字7个字")

    --检查文本框_n295.n33.n19.n2的文字是否是"选择目标"
    CS.LPCFramework.UITesterManager.CheckText("_n295.n33.n19.n2","选择目标")

    --等待2341毫秒后点击_n887.n7
    CS.LPCFramework.UITesterManager.AddInterval(2341)
    CS.LPCFramework.UITesterManager.AddClick("_n887.n7")

    CS.LPCFramework.UITesterManager.FinishTestCommandQueue()

end
