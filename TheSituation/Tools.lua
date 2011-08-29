----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------


-- [OBJECTS] --
local Tools = SITUATION.Tools;


local colorPickerHandler, colorPickerParameter1, colorPickerParameter2;

function Tools.nilstring(text)
	if text == nil then
		return "nil"
	else
		return text
	end
end

function Tools.getHighestVal(table)
	local highestVal;
	for k, v in pairs ( table ) do
		if ( highestVal == nil ) then highestVal = v; end
		if ( v > highestVal ) then
		 	highestVal = v;
		end
	end
	return highestVal;
end


function Tools.getLowestVal(table)
	local lowestVal;
	for k, v in pairs ( table ) do
		if ( lowestVal == nil ) then lowestVal = v; end
		if ( v < lowestVal ) then
		 	lowestVal = v;
		end
	end
	return lowestVal;
end


function Tools.getNextLowestVal(val, table)
	local nextVal;
	for k, v in pairs ( table ) do
		if ( v <= val ) then
			if ( nextVal == nil ) then nextVal = v; end
			if ( (val - v) < (val - nextVal) ) then
		 		nextVal = v;
		 	end
		end
	end
	if ( nextVal == nil ) then nextVal = Tools.getLowestVal(table); end
	return nextVal;
end


function Tools.countTable(table)
	local i = 0;
	for k, v in pairs ( table ) do
		i = i + 1;
	end
	return i;
end


function Tools.clearTable(table)
	for i, v in pairs ( table ) do
		if ( v ~= nil ) then
			table[i] = nil;
		end
	end
end


function Tools.getIconPath(id)
	local _, _, iconPath, _, _, _, _, _, _  = GetSpellInfo(id);
	return iconPath;
end


function Tools.extractUnitType(pGuid)
	if ( pGuid ~= nil ) then
		local unitId = tonumber(pGuid:sub(5, 5), 16) % 8;
		if ( unitId == 0 ) then
			return 'player';
		elseif ( unitId == 4 ) then
			return 'pet';
		end
	end
	return nil;
end


function Tools.getSpellName(id, addRank)
	local name, rank, _, _, _, _, _, _, _  = GetSpellInfo(id);
	if ( name ~= nil ) then
		if ( addRank and rank ~= nil and rank ~= '' ) then
			return name..' ('..rank..')';
		else
			return name;
		end
	else
		SITUATION.printDebug('Could not retrieve spell name for: '..tostring(id));
	end
end


function Tools.extractPetId(pGuid)
	if ( pGuid ~= nil ) then
		return tonumber(pGuid:sub(6, 12), 16);
	end
	return nil;
end


function Tools.formatString(input)
	if ( input == nil ) then return nil; end
	string.gsub(input, "'", "\\'");
	return input;
end


function Tools.setupCheckBox(button)
	button:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	button:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	button:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
	button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
end


function Tools.setupRadioButton(button)
	button:SetNormalTexture("Interface\\LFGFrame\\BattlenetWorking4")
	button:SetCheckedTexture("Interface\\LFGFrame\\BattlenetWorking0")
end


function Tools.roundNumber(num)
	if ( num >= 0 ) then
		return math.floor(num + 0.5);
	else
		return math.ceil(num - 0.5);
	end
end


function Tools.showColorPicker(pColorTable, pHandler, p1, p2)
	colorPickerHandler = pHandler;
	colorPickerParameter1 = p1;
	colorPickerParameter2 = p2;
	ColorPickerFrame.opacity = 1 - pColorTable.a;
	ColorPickerFrame.hasOpacity = pColorTable.a ~= nil; -- Flip opacity setting; + = more visible; - = less visible.
	ColorPickerFrame:SetColorRGB(pColorTable.r, pColorTable.g, pColorTable.b);
	ColorPickerFrame.previousValues = {pColorTable.r, pColorTable.g, pColorTable.b, pColorTable.a};
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = Tools.colorPickerHandler, Tools.colorPickerHandler, Tools.colorPickerHandler; -- must preceed SetColorRGB() or previously used texture will get a change color event
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
end


function Tools.colorPickerHandler(pRestoreColor)
	local r, g, b, a;
	if ( pRestoreColor ~= nil ) then
		r, g, b, a = unpack(pRestoreColor);
	else
		a, r, g, b = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
		a = 1 - a;
	end
	colorPickerHandler(r, g, b, a, colorPickerParameter1, colorPickerParameter2);
end


function Tools.chopUpLogName(logName)
	local stringLength = strlen(logName);
	local startPos, endPos = strfind(logName, '-');
	if ( startPos ) then
		local playerName = strsub(logName, 1, (startPos-1));
		local playerServer = strsub(logName, (startPos+1), stringLength);
		return playerName, playerServer;
	end
	return logName, nil;
end


function Tools.updateTextDimensions(pFontString, pSetWidth, pSetHeight)
	local oldWidth = pFontString:GetWidth();
	local oldHeight = pFontString:GetHeight();
	pFontString:SetWidth(1000);
	pFontString:SetHeight(1000);
	local width = pFontString:GetStringWidth();
	local height = pFontString:GetStringHeight();
	if ( pSetWidth ) then
		pFontString:SetWidth(width);
	else
		if ( oldWidth == width ) then
			pFontString:SetWidth(0);
		else
			pFontString:SetWidth(oldWidth);
		end
	end
	if ( pSetHeight ) then
		pFontString:SetHeight(height);
	else
		if ( oldHeight == height ) then
			pFontString:SetHeight(0);
		else
			pFontString:SetHeight(oldHeight);
		end
	end
	return width, height;
end


function Tools.convertStringToVar(string)
	string = strlower(string);
	string = gsub(string, ' ', '_');
	string = gsub(string, "'", '');
	string = gsub(string, "-", '');
	return string;
end


function Tools.setColor(pTexture, pColorTable)
	pTexture:SetTexture(pColorTable.r, pColorTable.g, pColorTable.b, pColorTable.a);
end


function Tools.setTextColor(pText, pColorTable)
	pText:SetTextColor(pColorTable.r, pColorTable.g, pColorTable.b, pColorTable.a);
end


function Tools.setBarColor(pBar, pColorTable)
	pBar:SetStatusBarColor(pColorTable.r, pColorTable.g, pColorTable.b, pColorTable.a);
end


function Tools.setBackdropColor(pFrame, pColorTable)
	pFrame:SetBackdropColor(pColorTable.r, pColorTable.g, pColorTable.b, pColorTable.a);
end


function Tools.setupTexture(pFrame, pTexture)
	pFrame.texture = pFrame:CreateTexture();
	pFrame.texture:SetAllPoints(pFrame);
	if ( pTexture ~= nil ) then
		pFrame.texture:SetTexture(pTexture);
	end
end


function Tools.compareTables(pOperation, pMasterTable, pTargetTable)
	if ( pOperation == 'add' ) then
		for k, v in pairs ( pMasterTable ) do
			if ( type(pMasterTable[k]) == 'table' ) then
				if ( pTargetTable[k] == nil ) then
					pTargetTable[k] = {};
				end
				Tools.compareTables('add', pMasterTable[k], pTargetTable[k]);
			else
				if ( pTargetTable[k] == nil ) then
					pTargetTable[k] = pMasterTable[k];
				end
			end
		end
	elseif ( pOperation == 'remove' ) then
		for k, v in pairs ( pTargetTable ) do
			if ( pMasterTable[k] == nil ) then
				pTargetTable[k] = nil;
			else
				if ( type(pTargetTable[k]) == 'table' ) then
					Tools.compareTables('remove', pMasterTable[k], pTargetTable[k]);
				end
			end
		end
	elseif ( pOperation == 'copy' ) then
		for k, v in pairs ( pMasterTable ) do
			if ( type(pMasterTable[k]) == 'table' ) then
				if ( pTargetTable[k] == nil ) then
					pTargetTable[k] = {};
				end
				Tools.compareTables('copy', pMasterTable[k], pTargetTable[k]);
			else
				pTargetTable[k] = pMasterTable[k];
			end
		end
	end
end