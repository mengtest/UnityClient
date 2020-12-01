-- audioId                          string                           音乐ID(与资源名一致)
-- audioType                        int                              音乐类型（1：loop音乐，2：音效）
-- volume                           float                            音量
-- channel                          int                              频道（只对音乐类型loop类有作用）

return {
	["BGM_Login"] = {
		audioId = "BGM_Login",
		audioType = 1,
		volume = 1,
		channel = 0,
	},
	["BGM_City01"] = {
		audioId = "BGM_City01",
		audioType = 1,
		volume = 1,
		channel = 0,
	},
	["BGM_Field01"] = {
		audioId = "BGM_Field01",
		audioType = 1,
		volume = 1,
		channel = 0,
	},
	["BGM_Battle01"] = {
		audioId = "BGM_Battle01",
		audioType = 1,
		volume = 1,
		channel = 0,
	},
	["UI_Battle_Win"] = {
		audioId = "UI_Battle_Win",
		audioType = 2,
		volume = 0.8,
		channel = 0,
	},
	["UI_Battle_Fail"] = {
		audioId = "UI_Battle_Fail",
		audioType = 2,
		volume = 0.8,
		channel = 0,
	},
}
