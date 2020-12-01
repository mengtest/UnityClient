/*
* ==============================================================================
* 
* Created: 2017-3-3
* Author: Panda
* Company: LightPaw
* 
* ==============================================================================
*/

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LPCFramework
{
    /// <summary>
    /// 常量定义
    /// </summary>
    public class ConstDefines
    {

        public const bool DebugMode = true;                         //调试模式-用于内部测试

        /// <summary>
        /// 如果开启更新模式，需要自己将StreamingAssets里面的所有内容
        /// 复制到Webserver上面，并修改下面的AssetServerUrl。
        /// </summary>
        public const bool UpdateMode = false;                       //更新模式-默认关闭 
        public const bool EncryptLua = false;                       //是否加密Lua-默认关闭 
        public const bool LuaBundleMode = false;                    //Lua代码AssetBundle模式

        public const int EncryptLen = 256;                          //资源加密解密常量定义
        public const string EncryptKey = "this is source encryption key, please custom this key string";       // 加密字符串

        public const int GameFrameRate = 30;                        //游戏帧频

        public const string GameManagerObj = "GameManager";         //游戏管理器对象名称
        public const string AppName = "male7";                      //应用程序名称
        public const string SourceFileName = "data.zip";            //资源包名称
        public const string ExtName = ".unity3d";                   //素材扩展名
        public const string FileList = "files.txt";                 //文件列表名，内包含本次更新的所有文件和其MD5信息
        public const string ServerList = "ServerList.txt";          //服务器列表文件名
        public const string LuaFolderName = "Lua/";                 //Lua脚本存放目录名称
        public const string LuaExt = ".lua";                        //Lua脚本后缀
        public const string AssetServerUrl = "http://localhost/UnityHotFixTestFolder/Update/";             //资源更新地址
        public const string ServerListFileUrl = "http://localhost/UnityHotFixTestFolder/ServerList.txt";   //服务器列表地址

        public static string ClientVersion = "0.0.0.1";             //当前客户端版本号

    }
}