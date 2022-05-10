Framework.RegisterServerCallback('Identity:registerIdentity', function(source, cb, data)
	local xPlayer = Framework.GetPlayerFromId(source)
	
	if xPlayer then
		if checkNameFormat(data.firstname) and checkNameFormat(data.lastname) and checkSexFormat(data.sex) and checkDOBFormat(data.dateofbirth) and checkHeightFormat(data.height) then

			currentIdentity = {
				firstName = formatName(data.firstname),
				lastName = formatName(data.lastname),
				dateOfBirth = data.dateofbirth,
				sex = data.sex,
				height = data.height
			}

			--xPlayer.setName(('%s %s'):format(currentIdentity.firstName, currentIdentity.lastName))
			-- firstname
			xPlayer.setFirstname(currentIdentity.firstName)
			xPlayer.set('firstName', currentIdentity.firstName)
			xPlayer.setMetadata('firstName', currentIdentity.firstName)

			-- lastname
			xPlayer.setLastname(currentIdentity.lastName)
			xPlayer.set('lastName', currentIdentity.lastName)
			xPlayer.setMetadata('lastName', currentIdentity.lastName)

			-- dateofbirth
			xPlayer.setDateofbirth(currentIdentity.dateOfBirth)
			xPlayer.set('dateofbirth', currentIdentity.dateOfBirth)
			xPlayer.setMetadata('dateofbirth', currentIdentity.dateOfBirth)

			-- sex
			xPlayer.setSex(currentIdentity.sex)
			xPlayer.set('sex', currentIdentity.sex)
			xPlayer.setMetadata('sex', currentIdentity.sex)

			-- height
			xPlayer.setHeight(currentIdentity.height)
			xPlayer.set('height', currentIdentity.height)
			xPlayer.setMetadata('height', currentIdentity.height)

			currentIdentity.metadata = xPlayer.getMetadata()

			saveIdentityToDatabase(xPlayer.getCitizenid(), currentIdentity)

			cb(true)
		else
			cb(false)
		end
	else
		cb(false)
	end
end)



function saveIdentityToDatabase(citizenid, identity)
	MySQL.Sync.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height, metadata = @metadata WHERE citizenid = @citizenid', {
		['@citizenid']  = citizenid,
		['@firstname'] = identity.firstName,
		['@lastname'] = identity.lastName,
		['@dateofbirth'] = identity.dateOfBirth,
		['@sex'] = identity.sex,
		['@height'] = identity.height,
		['@metadata'] = json.encode(identity.metadata)
	})
end

function checkNameFormat(name)
	if not checkAlphanumeric(name) then
		if not checkForNumbers(name) then
			local stringLength = string.len(name)
			if stringLength > 0 and stringLength < Config.MaxNameLength then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function checkDOBFormat(dob)
	local date = tostring(dob)
	if checkDate(date) then
		return true
	else
		return false
	end
end

function checkSexFormat(sex)
	if sex == "m" or sex == "M" or sex == "f" or sex == "F" then
		return true
	else
		return false
	end
end

function checkHeightFormat(height)
	local numHeight = tonumber(height)
	if numHeight < Config.MinHeight or numHeight > Config.MaxHeight then
		return false
	else
		return true
	end
end

function formatName(name)
	local loweredName = convertToLowerCase(name)
	local formattedName = convertFirstLetterToUpper(loweredName)
	return formattedName
end

function convertToLowerCase(str)
	return string.lower(str)
end

function convertFirstLetterToUpper(str)
	return str:gsub("^%l", string.upper)
end

function checkAlphanumeric(str)
	return (string.match(str, "%W"))
end

function checkForNumbers(str)
	return (string.match(str,"%d"))
end

function checkDate(str)
	if string.match(str, '(%d%d%d%d)/(%d%d)/(%d%d)') ~= nil then
		local y, m, d = string.match(str, '(%d+)/(%d+)/(%d+)')
		y = tonumber(y)
		m = tonumber(m)
		d = tonumber(d)
		if ((d <= 0) or (d > 31)) or ((m <= 0) or (m > 12)) or ((y <= Config.LowestYear) or (y > Config.HighestYear)) then
			return false
		elseif m == 4 or m == 6 or m == 9 or m == 11 then
			if d > 30 then
				return false
			else
				return true
			end
		elseif m == 2 then
			if y%400 == 0 or (y%100 ~= 0 and y%4 == 0) then
				if d > 29 then
					return false
				else
					return true
				end
			else
				if d > 28 then
					return false
				else
					return true
				end
			end
		else
			if d > 31 then
				return false
			else
				return true
			end
		end
	else
		return false
	end
end
