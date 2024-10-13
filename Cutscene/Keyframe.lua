local keyframeClass = {}
keyframeClass.__index = keyframeClass

function keyframeClass.new(Time, EasingStyle, EasingDirection, CinematicBars, DepthOfField)
	return setmetatable({
		ClassName = "CutsceneKeyframe",
		Time = Time or 1,
		EasingStyle = EasingStyle or Enum.EasingStyle.Linear,
		EasingDirection = EasingDirection or Enum.EasingDirection.InOut,
		CinematicBars = CinematicBars or false,
		DepthOfField = DepthOfField or false
	}, keyframeClass)
end

return keyframeClass