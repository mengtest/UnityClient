using System;
using UnityEngine;
using XLua;


namespace LPCFramework
{
    [LuaCallCSharp]
    public class StringTools
    {
        static SimplifiedChinese charset = new SimplifiedChinese();
        static string pattern = @"^[a-zA-Z0-9]*$";

        public static bool CalculateChineseWord(string str)
        {
            for (int i = 0; i < str.Length; i++)
            {
                if (!IsSimplifiedChinese(str[i]))
                {
                    return false;
                }
            }
            return true;
        }

        public static bool IsSimplifiedChinese(char ch)
        {
            uint c = (uint)ch;
            if (Array.IndexOf(charset.UnicodeSc, c) != -1 || System.Text.RegularExpressions.Regex.IsMatch(ch.ToString(), pattern))
                return true;
            return false;
        }
    }
}