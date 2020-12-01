local HexMetrics = {}

HexMetrics.outerRadius = 1
HexMetrics.innerRadius = 0.866 --outerRadius * 0.866025

HexMetrics.corners = 
{
    [0] = CS.UnityEngine.Vector3(HexMetrics.outerRadius, 0, 0),
    [1] = CS.UnityEngine.Vector3(0.5 * HexMetrics.outerRadius, 0, -HexMetrics.innerRadius),
    [2] = CS.UnityEngine.Vector3(-0.5 * HexMetrics.outerRadius, 0, -HexMetrics.innerRadius),
    [3] = CS.UnityEngine.Vector3(-HexMetrics.outerRadius, 0, 0),
    [4] = CS.UnityEngine.Vector3(-0.5 * HexMetrics.outerRadius, 0, HexMetrics.innerRadius),
    [5] = CS.UnityEngine.Vector3(0.5 * HexMetrics.outerRadius, 0, HexMetrics.innerRadius),
    [6] = CS.UnityEngine.Vector3(HexMetrics.outerRadius, 0, 0),
}

return HexMetrics