--!strict
--[[
	Cutscene.luau
	Author: @MLMML
	October 12, 2024
	Version: 1.0
	
	links:
	- https://realethanplayzdev.github.io/DeviceInfo/About/
	- https://www.roblox.com/library/5343169924
	- https://devforum.roblox.com/t/716491
	- https://gist.github.com/RealEthanPlayzDev/60258fb3a9282089aab838952a64895c
--]]

assert(game:GetService("RunService"):IsClient(), "Cutscene can only run in the client")

local cutsceneClass = {}
cutsceneClass.__index = cutsceneClass

local Easings = {
	["Linear"] = Enum.EasingStyle.Linear,
	["Quad"] = Enum.EasingStyle.Quad,
	["Exponential"] = Enum.EasingStyle.Exponential,
	["Cubic"] = Enum.EasingStyle.Cubic,
	["Sine"] = Enum.EasingStyle.Sine,
	["Quint"] = Enum.EasingStyle.Quint,
	["Bounce"] = Enum.EasingStyle.Bounce,
	["Quart"] = Enum.EasingStyle.Quart,
	["Back"] = Enum.EasingStyle.Back,
	["Elastic"] = Enum.EasingStyle.Elastic,
	["Circular"] = Enum.EasingStyle.Circular,
}

local EasingDirections = {
	["InOut"] = Enum.EasingDirection.InOut,
	["In"] = Enum.EasingDirection.In,
	["Out"] = Enum.EasingDirection.Out,
}

local TweenService = game:GetService("TweenService")

local UI = script.Assets:WaitForChild("Cutscene")

local function SetUp(cutscene, Data)
	local CameraPoints = cutscene.CameraPoints:GetChildren()
	local CameraFolder = cutscene.CameraPoints

	for i = 1, #Data, 1 do
		local Point = CameraFolder:FindFirstChild(tostring(i))
		
		local timeValue = Instance.new("NumberValue")
		timeValue.Parent = Point
		timeValue.Value = Data[i].Time
		timeValue.Name = "Time"

		local easingStyleValue = Instance.new("StringValue")
		easingStyleValue.Parent = Point
		easingStyleValue.Value = Data[i].EasingStyle.Name
		easingStyleValue.Name = "Style"

		local easingDirectionValue = Instance.new("StringValue")
		easingDirectionValue.Parent = Point
		easingDirectionValue.Value =  Data[i].EasingDirection.Name
		easingStyleValue.Name = "Direction"
	end
end

function cutsceneClass.new(Cameras: Folder, CutsceneData)
	local newCutscene = {}
	newCutscene.ClassName = "Cutscene"
	newCutscene.CameraPoints = Cameras
	newCutscene.CutsceneData = CutsceneData
	newCutscene.IsPlaying = false
	newCutscene.Completed = Instance.new("BindableEvent")
	
	setmetatable(newCutscene, cutsceneClass)

	SetUp(newCutscene, CutsceneData)

	return newCutscene
end

function cutsceneClass:Play()
	task.spawn(function()
		self.IsPlaying = true

		local Camera = workspace.CurrentCamera
		Camera.CameraType = Enum.CameraType.Scriptable

		if self.CutsceneData[1].CinematicBars == true then
			local bars = UI:Clone()
			bars.Parent = game.Players.LocalPlayer.PlayerGui

			TweenService:Create(bars.Bars.Frame, TweenInfo.new(.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {})
		end

		local StartTween = TweenService:Create(Camera,
			TweenInfo.new(self.CutsceneData[1].Time,
				self.CutsceneData[1].EasingStyle,
				self.CutsceneData[1].EasingDirection),
			{CFrame = self.CameraPoints["1"].CFrame}
		)
		StartTween:Play()
		StartTween.Completed:Wait()

		for i = 1, #self.CameraPoints:GetChildren() do
			local v = self.CameraPoints[tostring(i)]

			if v.Name == "1" then continue end

			local Tween = TweenService:Create(Camera,
				TweenInfo.new(self.CutsceneData[i].Time,
					self.CutsceneData[i].EasingStyle,
					self.CutsceneData[i].EasingDirection),
				{CFrame = self.CameraPoints[tostring(i)].CFrame}
			)
			Tween:Play()
			Tween.Completed:Wait()
		end

		self.Completed:Fire()
		Camera.CameraType = Enum.CameraType.Custom
	end)
end

function cutsceneClass:Destroy()
	table.clear(self)
end

return cutsceneClass
