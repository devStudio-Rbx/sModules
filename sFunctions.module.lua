--// Initialization

local Module	= {}

--// Functions

function Module.RoundNumber(Number, Divider)
	--/ Rounds a number using round half up
	
	Divider = Divider or 1
	return math.floor(Number / Divider + 0.5) * Divider
end

function Module.PickRandom(Values)
	--/ Will return a random pick from a table; NOT DICTIONARY
	
	return Values[math.random(1, #Values)]
end

function Module.GenerateString(Length)
	--/ Will return a random string of the required length
	
	assert(Length ~= nil, "A string length must be specified")
	
	local GeneratedString = ""
	
	for Count = 1, Length do
		GeneratedString = GeneratedString .. string.char(math.random(65, 90))
	end
	
	return GeneratedString
end

function Module.GetIndexByValue(Values, DesiredValue)
	--/ Returns the index of a value in a table or dictionary
	
	for Index, Value in next, Values do
		if Value == DesiredValue then
			return Index
		end
	end
	
	return nil
end

function Module.GetDescendants(ObjectInstance)
	--/ Returns descendants of an Instances
	
	local Descendants = ObjectInstance:GetChildren()
	local Count = 0
	
	repeat
		Count = Count + 1
		Descendants = Module.MergeTables(
			Descendants,
			Descendants[Count]:GetChildren()
		)
	until Count == #Descendants
	
	return Descendants
end

function Module.CallOnChildren(ParentInstance, FunctionToCall, Recursive)
	--/ Runs a function on all children of an Instance
	--/ If Recursive is true, will run on all descendants
	
	assert(typeof(ParentInstance) == "Instance", "ParentInstance is not an Instance")
	assert(type(FunctionToCall) == "function", "FunctionToCall is not a function")
	
	if #ParentInstance:GetChildren() == 0 then return end
	
	local Children = Recursive and Module.GetDescendants(ParentInstance) or ParentInstance:GetChildren()
	
	for _, Child in next, Children do
		FunctionToCall(Child)
	end
end

function Module.CallOnValues(Table, FunctionToCall)
	--/ Run a function on all values of a table or dictionary
	
	if #Table == 0 then return end
	
	for _, Value in next, Table do
		FunctionToCall(Value)
	end
end

function Module.Modify(ObjectInstance, Values)
	--/ Modifies an Instance using a table of properties and values
	
	assert(typeof(ObjectInstance) == "Instance", "ObjectInstance is not an Instance")
	assert(type(Values) == "table", "Values is not a table")
	
	for Property, Value in next, Values do
		if type(Property) == "number" then
			Value.Parent = ObjectInstance
		else
			ObjectInstance[Property] = Value
		end
	end
	
	return ObjectInstance
end

function Module.Retrieve(InstanceName, InstanceClass, InstanceParent)
	--/ Finds an Instance by name and creates a new one if it doesen't exist
	
	local SearchInstance, InstanceCreated = InstanceParent:FindFirstChild(InstanceName)
	
	if not SearchInstance then
		InstanceCreated = true
		SearchInstance = Instance.new(InstanceClass)
		SearchInstance.Name = InstanceName
		SearchInstance.Parent = InstanceParent
	end
	
	return SearchInstance, InstanceCreated
end

function Module.IteratePages(Pages)
	return coroutine.wrap(function()
		local PageNumber = 0

		repeat
			PageNumber = PageNumber + 1
			local Page = Pages:GetCurrentPage()
			for a = 1, #Page do
				coroutine.yield(PageNumber, Page[a])
			end
		until Pages.IsFinished or Pages:AdvanceToNextPageAsync()
	end)
end

return Module
