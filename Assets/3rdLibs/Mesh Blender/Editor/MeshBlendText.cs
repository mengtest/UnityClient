using UnityEngine;
using System.Collections;

public static class MeshBlendText
{                        
        
    public static readonly string MeshRequired = "Valid mesh is required to modify";
    public static readonly string MaterialRequired = "Valid material is required to modify";

    public static readonly string Modify = "Modify";
    public static readonly string ModifyTooltip = "Enters Blend Weight Painting Mode";
    public static readonly string ModifyUnavailableTooltip = "Modifying blend weights requires saving a copy of your mesh. Click the Modify New Instance button to proceed.";
     
    public static readonly string ModifyExisting ="Modify New Mesh Instance";
    public static readonly string ModifyExistingTooltip = "Enters Blend Weight Painting Mode and copies the current mesh, saving it as a new asset. This avoids changes to the blending of existing objects in the scene.";

    public static readonly string ResetMat = "Reset to Old Object Material";
    public static readonly string ResetMatTooltip = "By Click This ,You will reset the material to old one ,if it is a meshblend material it will not reset .";

    public static readonly string Strength = "Strength (A)";
    public static readonly string StrengthTooltip = "Changes the strength/opacity of the paint brush in the Scene View.\nPress A, click in the scene and slide the mouse horizontally to quickly change values.";
    public static readonly string MaxRadius = "Max:";
    public static readonly string MaxRadiusTooltip = "The maximum radius for the paint brush in the Scene View.";
    public static readonly string Radius = "Radius (B)";
    public static readonly string RadiusTooltip = "Changes the Radius of the paint brush in the Scene View.\nPress B, click in the scene and slide the mouse horizontally to quickly change values.";
    public static readonly string StopModifying = "Stop Modifying (Esc)";
    public static readonly string StopModifyingTooltip = "Exit Paint Mode";
    public static readonly string ShowWindow = "Show Window";
    public static readonly string ShowWindowTooltip = "Shows a separate settings window.";                        
}