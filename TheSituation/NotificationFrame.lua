----------
-- Name: TheSituation
-- Version: 2.0.x
-- License: All Rights Reserved
----------


--=====--=====--=====--
-- [PRIVATE PROPERTIES]
--=====--=====--=====--

local NotificationFrame = SITUATION.NotificationFrame;

local NOTIFICATION_HEIGHT=300
local NOTIFICATION_WIDTH=300

function NotificationFrame.build()
	NotificationFrame.frame = CreateFrame("Frame");
	NotificationFrame.frame:ClearAllPoints();
	NotificationFrame.frame:SetHeight(NOTIFICATION_HEIGHT);
	NotificationFrame.frame:SetWidth(NOTIFICATION_WIDTH);
	NotificationFrame.frame:SetScript("OnUpdate", NotificationFrame.onUpdate);
	NotificationFrame.frame:Hide();
	NotificationFrame.frame.text = NotificationFrame.frame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont");
	NotificationFrame.frame.text:SetAllPoints();
	NotificationFrame.frame:SetPoint("CENTER", 0, 200);
	NotificationFrame.textFrameTime = 0;
end


function NotificationFrame.onUpdate()
  if (NotificationFrame.textFrameTime < GetTime() - 3) then
    local alpha = NotificationFrame.frame:GetAlpha();
    if (alpha ~= 0) then NotificationFrame.frame:SetAlpha(alpha - .05); end
    if (aplha == 0) then NotificationFrame.frame:Hide(); end
  end
end
 
function NotificationFrame.message(message)
  NotificationFrame.frame.text:SetText(message);
  NotificationFrame.frame:SetAlpha(1);
  NotificationFrame.frame:Show();
  NotificationFrame.textFrameTime = GetTime();
end