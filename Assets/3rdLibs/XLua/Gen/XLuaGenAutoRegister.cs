#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using System;
using System.Collections.Generic;
using System.Reflection;


namespace XLua.CSObjectWrap
{
    public class XLua_Gen_Initer_Register__
	{
	    static XLua_Gen_Initer_Register__()
        {
		    XLua.LuaEnv.AddIniter((luaenv, translator) => {
			    
				translator.DelayWrapLoader(typeof(object), SystemObjectWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Object), UnityEngineObjectWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Vector2), UnityEngineVector2Wrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Vector3), UnityEngineVector3Wrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Vector4), UnityEngineVector4Wrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Quaternion), UnityEngineQuaternionWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Color), UnityEngineColorWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Ray), UnityEngineRayWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Bounds), UnityEngineBoundsWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Ray2D), UnityEngineRay2DWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Time), UnityEngineTimeWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.GameObject), UnityEngineGameObjectWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Component), UnityEngineComponentWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Behaviour), UnityEngineBehaviourWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Transform), UnityEngineTransformWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Resources), UnityEngineResourcesWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.TextAsset), UnityEngineTextAssetWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Keyframe), UnityEngineKeyframeWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.AnimationCurve), UnityEngineAnimationCurveWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.AnimationClip), UnityEngineAnimationClipWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.MonoBehaviour), UnityEngineMonoBehaviourWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.ParticleSystem), UnityEngineParticleSystemWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.SkinnedMeshRenderer), UnityEngineSkinnedMeshRendererWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Renderer), UnityEngineRendererWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.WWW), UnityEngineWWWWrap.__Register);
				
				translator.DelayWrapLoader(typeof(System.Collections.Generic.List<int>), SystemCollectionsGenericList_1_SystemInt32_Wrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Debug), UnityEngineDebugWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Mesh), UnityEngineMeshWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Mathf), UnityEngineMathfWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.Animator), UnityEngineAnimatorWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.EventContext), FairyGUIEventContextWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.EventDispatcher), FairyGUIEventDispatcherWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.EventListener), FairyGUIEventListenerWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.InputEvent), FairyGUIInputEventWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.DisplayObject), FairyGUIDisplayObjectWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Container), FairyGUIContainerWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Stage), FairyGUIStageWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Controller), FairyGUIControllerWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GObject), FairyGUIGObjectWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GGraph), FairyGUIGGraphWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GGroup), FairyGUIGGroupWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GImage), FairyGUIGImageWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GLoader), FairyGUIGLoaderWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.PlayState), FairyGUIPlayStateWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GMovieClip), FairyGUIGMovieClipWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.TextFormat), FairyGUITextFormatWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GTextField), FairyGUIGTextFieldWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GRichTextField), FairyGUIGRichTextFieldWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GTextInput), FairyGUIGTextInputWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GComponent), FairyGUIGComponentWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GList), FairyGUIGListWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GRoot), FairyGUIGRootWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GLabel), FairyGUIGLabelWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GButton), FairyGUIGButtonWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GComboBox), FairyGUIGComboBoxWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GProgressBar), FairyGUIGProgressBarWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GSlider), FairyGUIGSliderWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.PopupMenu), FairyGUIPopupMenuWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.ScrollPane), FairyGUIScrollPaneWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Transition), FairyGUITransitionWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.UIConfig), FairyGUIUIConfigWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.UIPackage), FairyGUIUIPackageWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Window), FairyGUIWindowWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GObjectPool), FairyGUIGObjectPoolWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Relations), FairyGUIRelationsWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.RelationType), FairyGUIRelationTypeWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.Timers), FairyGUITimersWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.FontManager), FairyGUIFontManagerWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.GoWrapper), FairyGUIGoWrapperWrap.__Register);
				
				translator.DelayWrapLoader(typeof(FairyGUI.LongPressGesture), FairyGUILongPressGestureWrap.__Register);
				
				translator.DelayWrapLoader(typeof(UnityEngine.LineRenderer), UnityEngineLineRendererWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.LuaBehaviour), LPCFrameworkLuaBehaviourWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.SceneLoader), LPCFrameworkSceneLoaderWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.TerrainLuaDelegates), LPCFrameworkTerrainLuaDelegatesWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.ResourceVersionInfo), LPCFrameworkResourceVersionInfoWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.ResSetting), LPCFrameworkResSettingWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.LocalDataStorage), LPCFrameworkLocalDataStorageWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.ActorMaterialsController), LPCFrameworkActorMaterialsControllerWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.SimplifiedChinese), LPCFrameworkSimplifiedChineseWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.StringTools), LPCFrameworkStringToolsWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.GameObjectPool), LPCFrameworkGameObjectPoolWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.FileUtils), LPCFrameworkFileUtilsWrap.__Register);
				
				translator.DelayWrapLoader(typeof(LPCFramework.LogicUtils), LPCFrameworkLogicUtilsWrap.__Register);
				
				
				translator.AddInterfaceBridgeCreator(typeof(LPCFramework.CSharpCallLuaDelegates.ILuaGameManager), LPCFrameworkCSharpCallLuaDelegatesILuaGameManagerBridge.__Create);
				
				translator.AddInterfaceBridgeCreator(typeof(LPCFramework.CSharpCallLuaDelegates.ILuaNetwork), LPCFrameworkCSharpCallLuaDelegatesILuaNetworkBridge.__Create);
				
			});
		}
		
		
	}
	
}
namespace XLua
{
	public partial class ObjectTranslator
	{
		static XLua.CSObjectWrap.XLua_Gen_Initer_Register__ s_gen_reg_dumb_obj = new XLua.CSObjectWrap.XLua_Gen_Initer_Register__();
		static XLua.CSObjectWrap.XLua_Gen_Initer_Register__ gen_reg_dumb_obj {get{return s_gen_reg_dumb_obj;}}
	}
	
	public static partial class Utils
    {
	    
	    static Utils()
		{
		    extension_method_map = new Dictionary<Type, IEnumerable<MethodInfo>>()
			{
			    
			};
		}
	}
}
