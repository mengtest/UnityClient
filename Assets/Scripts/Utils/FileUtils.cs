using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;
using System.Text;
using System.IO;
using ICSharpCode.SharpZipLib.Zip;
using System.Security.Cryptography;

namespace LPCFramework
{
    [LuaCallCSharp]
    public class FileUtils
    {
        /// <summary>
        /// 读取文件，以string格式返回
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string ReadFileToString(string path)
        {
            if (!File.Exists(path))
            {
                Debug.Log("[warning] 文件不存在: " + path);
                return string.Empty;
            }

            string text = string.Empty;
            try
            {
                StreamReader sr = new StreamReader(path);
                text = sr.ReadToEnd();
                sr.Close();
                sr.Dispose();
            }
            catch (Exception e)
            {
                Debug.LogError("[error] 读取文件错误: " + e);
                return string.Empty;
            }

            return text;
        }
        /// <summary>
        /// 读取文件，以bytes格式返回
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static byte[] ReadFileToBytes(string path)
        {
            if(!File.Exists(path))
            {
                Debug.Log("[warning] 文件不存在: " + path);
                return null;
            }

            string text = string.Empty;
            
            try
            {
                StreamReader sr = new StreamReader(path);
                text = sr.ReadToEnd();
                sr.Close();
                sr.Dispose();
            }
            catch (Exception e)
            {
                Debug.LogError("[error] 读取文件错误: " + e);
                return null;
            }

            return UTF8Encoding.UTF8.GetBytes(text);
        }
        /// <summary>
        /// 以覆盖的形式写文件
        /// </summary>
        /// <param name="path"></param>
        /// <param name="content"></param>
        public static bool WriteFile(string path, byte[] content)
        {
            try
            {
                FileStream fs = new FileStream(path, FileMode.OpenOrCreate);
                fs.Write(content, 0, content.Length);

                fs.Close();
                fs.Dispose();
            }
            catch (Exception e)
            {
                //路径与名称未找到文件则直接返回空
                Debug.LogError("[error] 写入文件错误: " + e);
                return false;
            }

            return true;
        }

        public static T DeserializeProto<T>(string filePath) where T : class
        {
            byte[] content = ReadFileToBytes(filePath);
            if (null == content)
                return null;

            using (System.IO.MemoryStream stream = new System.IO.MemoryStream(content))
            {
                T info = ProtoBuf.Serializer.Deserialize<T>(stream);
                return info;
            }
        }

        public static bool SerializeProto<T>(T info, string folder, string fileName) where T : class
        {
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            string filePath = Path.Combine(folder, fileName);

            using (System.IO.MemoryStream stream = new System.IO.MemoryStream())
            {
                ProtoBuf.Serializer.Serialize<T>(stream, info);
                if (stream.Length > 0)
                {
                    return FileUtils.WriteFile(filePath, stream.ToArray());
                }
            }

            return false;
        }

        /// <summary>
        /// 获取文件名(有后缀无路径)或者文件夹
        /// </summary>
        /// <param name="path"></param>
        /// <param name="separator"></param>
        /// <returns></returns>
        public static string GetFileName(string path, char separator = '/')
        {
            if (!path.Contains("/")) return path;
            return path.Substring(path.LastIndexOf(separator) + 1);
        }
        /// <summary>
        /// 获取文件名(无后缀无路径)
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="separator"></param>
        /// <returns></returns>
        public static string GetFileNameWithoutExtention(string fileName, char separator = '/')
        {
            if (!fileName.Contains("/")) return fileName;
            return GetFileNamePathWithoutExtention(GetFileName(fileName, separator));
        }
        /// <summary>
        /// 获取文件路径
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string GetFilePath(string path)
        {
            if (!path.Contains("/")) return path;
            return path.Substring(0, path.LastIndexOf('/'));
        }
        /// <summary>
        /// 获取包含不带后缀的文件名路径
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string GetFileNamePathWithoutExtention(string fileName)
        {
            if (!fileName.Contains(".")) return fileName;
            return fileName.Substring(0, fileName.LastIndexOf('.'));
        }
        /// <summary>
        /// 获取文件的上一级文件夹名称
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static string GetFileParentFolder(string filename)
        {
            if (!filename.Contains("/")) return filename;
            string filepath = GetFilePath(filename);

            if (!filepath.Contains("/")) return filepath;

            string parentfolder = filepath.Substring(filepath.LastIndexOf('/'), (filepath.Length - filepath.LastIndexOf('/'))).Replace("/", "");
            return parentfolder;
        }

        public static void ZipFile(string filename, string sourcedirectory, FastZipEvents zipevent = null)
        {
            try
            {
                if (File.Exists(filename))
                    File.Delete(filename);
                FastZip fz;
                if (zipevent != null) fz = new FastZip(zipevent);
                else fz = new FastZip();
                fz.CreateEmptyDirectories = true;
                fz.CreateZip(filename, sourcedirectory, true, "");
                fz = null;
            }
            catch (Exception e)
            {
                Debug.LogError(e.Message + "  " + e.StackTrace);
            }
        }

        public static bool UnZipFiles(string file, string dir,System.Action<float> process = null)
        {
            try
            {                
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                long byteunzip = 0;
                long byteall = 0;

                FileStream fs = File.OpenRead(file);
                ZipInputStream s = new ZipInputStream(fs);
                fs.Close();
                //byteall = s.Length;// todo  crash here
                ZipConstants.DefaultCodePage = 65001;
                ZipEntry theEntry;
                while ((theEntry = s.GetNextEntry()) != null)
                {
                    string directoryName = Path.GetDirectoryName(theEntry.Name);
                    string fileName = Path.GetFileName(theEntry.Name);

                    if (directoryName != String.Empty)
                        Directory.CreateDirectory(dir + directoryName);

                    if (fileName != String.Empty)
                    {
                        FileStream streamWriter = File.Create(dir + theEntry.Name);

                        int size = 2048;
                        byte[] data = new byte[2048];
                        while (true)
                        {
                            size = s.Read(data, 0, data.Length);
                            if (size > 0)
                            {
                                streamWriter.Write(data, 0, size);
                                byteunzip += size;
                                //if(process != null)
                                //{
                                //    float p = (float)byteunzip / byteall;
                                //    process(p);
                                //}
                            }
                            else
                            {
                                break;
                            }
                        }

                        streamWriter.Close();
                    }
                }
                s.Close();
                return true;
            }
            catch (Exception e)
            {
                Debug.LogError(e.Message);                
                return false;
                throw;
            }
        }

        /// <summary>
        /// HashToMD5Hex
        /// </summary>
        public static string HashToMD5Hex(string sourceStr)
        {
            byte[] Bytes = Encoding.UTF8.GetBytes(sourceStr);
            using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider())
            {
                byte[] result = md5.ComputeHash(Bytes);
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < result.Length; i++)
                    builder.Append(result[i].ToString("x2"));
                return builder.ToString();
            }
        }

        /// <summary>
        /// 计算字符串的MD5值
        /// </summary>
        public static string GetMD5ForString(string source)
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
            byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
            md5.Clear();

            string destString = "";
            for (int i = 0; i < md5Data.Length; i++)
            {
                destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
            }
            destString = destString.PadLeft(32, '0');
            return destString;
        }

        /// <summary>
        /// 计算文件的MD5值
        /// </summary>
        public static string GetMD5ForFile(string file)
        {
            try
            {
                FileStream fs = new FileStream(file, FileMode.Open);
                System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
                byte[] retVal = md5.ComputeHash(fs);
                fs.Close();

                // Loop through each byte of the hashed data 
                // and format each one as a hexadecimal string.
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < retVal.Length; i++)
                {
                    sb.Append(retVal[i].ToString("x2"));
                }
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("md5file() fail, error:" + ex.Message);
            }
        }


        /// <summary>
        /// 局部加密解密
        /// </summary>
        /// <param name="input"></param>
        public static void Encrypt(ref byte[] input)
        {
            if (input.Length > ConstDefines.EncryptLen)
            {
                byte[] tmp = new byte[ConstDefines.EncryptLen];
                System.Array.Copy(input, 0, tmp, 0, ConstDefines.EncryptLen);
                byte[] de = RC4(tmp, ConstDefines.EncryptKey);
                for (int i = 0; i < ConstDefines.EncryptLen; i++)
                {
                    input[i] = de[i];
                }
            }
        }

        /// <summary>
        /// 整个文件加密
        /// </summary>
        /// <param name="input"></param>
        public static void EncryptAll(ref byte[] input)
        {
            byte[] tmp = new byte[input.LongLength];
            System.Array.Copy(input, 0, tmp, 0, ConstDefines.EncryptLen);
            byte[] de = RC4(tmp, ConstDefines.EncryptKey);
            System.Array.Copy(de, 0, input, 0, ConstDefines.EncryptLen);
            tmp = null;
            de = null;
        }

        /// <summary>
        /// RC4 字符串
        /// </summary>
        /// <param name="str"></param>
        /// <param name="pass"></param>
        /// <returns></returns>
        public static string RC4(string str, String pass)
        {
            Byte[] data = System.Text.Encoding.UTF8.GetBytes(str);
            Byte[] bt = RC4(data, pass);
            return System.Text.Encoding.UTF8.GetString(bt);
        }

        public static Byte[] RC4(Byte[] data, String pass)
        {
            if (data == null || pass == null) return null;
            Byte[] output = new Byte[data.Length];
            Int64 i = 0;
            Int64 j = 0;
            Byte[] mBox = GetKey(System.Text.Encoding.UTF8.GetBytes(pass), 256);

            // 加密
            for (Int64 offset = 0; offset < data.Length; offset++)
            {
                i = (i + 1) % mBox.Length;
                j = (j + mBox[i]) % mBox.Length;
                Byte temp = mBox[i];
                mBox[i] = mBox[j];
                mBox[j] = temp;
                Byte a = data[offset];
                //Byte b = mBox[(mBox[i] + mBox[j] % mBox.Length) % mBox.Length];
                // mBox[j] 一定比 mBox.Length 小，不需要在取模
                Byte b = mBox[(mBox[i] + mBox[j]) % mBox.Length];
                output[offset] = (Byte)((Int32)a ^ (Int32)b);
            }

            data = output;

            return output;
        }
        static private Byte[] GetKey(Byte[] pass, Int32 kLen)
        {
            Byte[] mBox = new Byte[kLen];

            for (Int64 i = 0; i < kLen; i++)
            {
                mBox[i] = (Byte)i;
            }
            Int64 j = 0;
            for (Int64 i = 0; i < kLen; i++)
            {
                j = (j + mBox[i] + pass[i % pass.Length]) % kLen;
                Byte temp = mBox[i];
                mBox[i] = mBox[j];
                mBox[j] = temp;
            }
            return mBox;
        }
    }
}
