local localworkspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local player = players.LocalPlayer

local function grabcandybasket(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local basket = localworkspace:WaitForChild("FFA_MAP"):WaitForChild("Shop"):WaitForChild("Grab - [Candy Basket]")
	local detector = basket:WaitForChild("ClickDetector")
	pcall(function()
		hrp.CFrame = basket.CFrame * CFrame.new(0, 3, 3)
		hrp.Anchored = true
		task.wait(0.1)
		hrp.Anchored = false
	end)
	pcall(function()
		fireclickdetector(detector)
	end)
end

local function enablenoclip(char)
	runservice.Stepped:Connect(function()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end)
end

local function startmainloop(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:WaitForChild("Humanoid")
	local folder = localworkspace:WaitForChild("FFA_MAP"):WaitForChild("INTERACTABLE_FILLBUILDING_DOORS")

	local function getclickdetector(model)
		for _, v in ipairs(model:GetDescendants()) do
			if v:IsA("ClickDetector") then
				return v, v.Parent:IsA("BasePart") and v.Parent or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
			end
		end
		return nil, nil
	end

	local function togglefourthslottool()
		pcall(function()
			humanoid:UnequipTools()
			local tools = {}
			for _, tool in ipairs(player.Backpack:GetChildren()) do
				if tool:IsA("Tool") then
					table.insert(tools, tool)
				end
			end
			if tools[4] then
				tools[4]:Equip()
			end
		end)
	end

	local doormodels = {}
	for _, model in ipairs(folder:GetChildren()) do
		if model:IsA("Model") then
			table.insert(doormodels, model)
		end
	end

	local cyclecount = 0
	while true do
		cyclecount = cyclecount + 1
		for index, model in ipairs(doormodels) do
			local part = model:FindFirstChildWhichIsA("BasePart") or model.PrimaryPart
			if part then
				local targetcframe = part.CFrame * CFrame.new(3, 3, 3)
				pcall(function()
					hrp.CFrame = targetcframe
					hrp.Anchored = true
					task.wait(0.1)
					hrp.Anchored = false
				end)

				local detector, detectorpart
				local timeout = 10
				local waited = 0
				repeat
					detector, detectorpart = getclickdetector(model)
					if not detector then
						task.wait(0.1)
						waited = waited + 0.1
					end
				until detector or waited >= timeout

				if detector and detectorpart then
					local distance = (hrp.Position - detectorpart.Position).Magnitude
					if distance <= detector.MaxActivationDistance then
						local actiontime = 0
						while actiontime < 3 do
							pcall(function()
								fireclickdetector(detector)
							end)
							togglefourthslottool()
							task.wait(0.1)
							actiontime = actiontime + 0.1
						end
					end
				end
				task.wait(0.5)
			end
		end
		task.wait(1)
	end
end

local function init(char)
	grabcandybasket(char)
	enablenoclip(char)
	startmainloop(char)
end

if player.Character then
	init(player.Character)
end

player.CharacterAdded:Connect(function(char)
	init(char)
end)
