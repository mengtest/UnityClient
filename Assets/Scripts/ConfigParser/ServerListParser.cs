using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace LPCFramework
{
    /// <summary>
    /// 服务器列表配置与解析
    /// 此文件为C#层配置文件解析的范例
    /// </summary>
    public class ServerListParser : ConfigParserSingleton<ServerListParser>
    {
        /// <summary>
        /// key: server Id, value: config
        /// </summary>
        public Dictionary<string, ServerConfig> ServerList = new Dictionary<string, ServerConfig>();
        /// <summary>
        /// 当前选中的server
        /// </summary>
        public ServerConfig CurrentChosenServer { get; private set; }

        
        /// <summary>
        /// 获取所有serverConfig
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, ServerConfig> GetAllServerConfigs()
        {
            return ServerList;
        }
        /// <summary>
        /// 根据Id获取ServerConfig
        /// </summary>
        /// <param name="serverId"></param>
        /// <returns></returns>
        public ServerConfig GetServerConfig(string serverId)
        {
            if (string.IsNullOrEmpty(serverId) || ServerList == null || ServerList.Count <= 0)
                return null;

            ServerConfig config = null;
            ServerList.TryGetValue(serverId, out config);

            return config;
        }
        /// <summary>
        /// 设置当前选中的server
        /// </summary>
        /// <param name="serverId"></param>
        public ServerConfig SetCurrentChosenServer(string serverId)
        {
            CurrentChosenServer = GetServerConfig(serverId);
            return CurrentChosenServer;
        }


        /// <summary>
        /// 服务器配置
        /// </summary>
        public class ServerConfig
        {
            public string Id { get; set; }
            public string Name { get; set; }
            public string Ip { get; set; }
            public string Port { get; set; }
            public string Version { get; set; }

        }
    }
}