local colors = {
	head = Color(192, 57, 43, 255),
	back = Color(236, 240, 241, 255),
	text = Color(255, 255, 255, 255),
	btn = Color(52, 73, 94, 255),
	btn_hover = Color(44, 62, 80, 255),
	accept = Color(46, 204, 113, 255),
	accept_hover = Color(39, 174, 96, 255),
	cancel = Color(231, 76, 60, 255),
	cancel_hover = Color(192, 57, 43, 255),
	bar = Color(189, 195, 199, 255),
	barupdown = Color(127, 140, 141, 255),
	transfer = Color(230, 126, 34, 255),
	transfer_hover = Color(211, 84, 0, 255),
	transfer_disabled = Color(230, 126, 34, 150),
	accept_disabled = Color(46, 204, 113, 150),
	cancel_disabled = Color(231, 76, 60, 150),
}

local activeDesc = "";
local activeWeapons = {};

function CreateShipPanel(frame)
	local panel = vgui.Create("DPanel", frame);
	panel:SetSize(frame:GetWide() - 330, frame:GetTall() - 120);
	panel:SetPos(320, 110);
	
	local entScroll = vgui.Create("DScrollPanel", panel);
	entScroll:SetSize(panel:GetWide(), panel:GetTall());
	entScroll:SetPos(0, 0);
	entScroll:GetVBar().Paint = function() draw.RoundedBox(0, 0, 0, entScroll:GetVBar():GetWide(), entScroll:GetVBar():GetTall(), Color(255, 255, 255, 0)) end
	entScroll:GetVBar().btnUp.Paint = function() draw.RoundedBox(0, 0, 0, entScroll:GetVBar().btnUp:GetWide(), entScroll:GetVBar().btnUp:GetTall(), colors.barupdown) end
	entScroll:GetVBar().btnDown.Paint = function() draw.RoundedBox(0, 0, 0, entScroll:GetVBar().btnDown:GetWide(), entScroll:GetVBar().btnDown:GetTall(), colors.barupdown) end
	entScroll:GetVBar().btnGrip.Paint = function(w, h) draw.RoundedBox(0, 0, 0, entScroll:GetVBar().btnGrip:GetWide(), entScroll:GetVBar().btnGrip:GetTall(), colors.bar) end
	
	local shipments = fn.Filter(fn.Compose{fn.Not, fn.Curry(fn.GetValue, 2)("noship")}, CustomShipments)
	local count = 0;
	for i, v in pairs(CustomShipments) do
		local item = vgui.Create("DButton", entScroll);
		item:SetSize(entScroll:GetWide(), 50);
		item:SetPos(0, count * 55);
		item:SetText(" ");
		count = count + 1;
		local ia = false;
		function item:OnCursorEntered() ia = true; end
		function item:OnCursorExited() ia = false; end
		item.Paint = function()
			if (ia) then
				draw.RoundedBox(0, 0, 0, item:GetWide(), item:GetTall(), colors.transfer_hover);
			else
				draw.RoundedBox(0, 0, 0, item:GetWide(), item:GetTall(), colors.transfer);
			end
			draw.SimpleText(v.name, "f4Btn", item:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
			draw.SimpleText("$"..string.Comma(v.price), "f4Btn", (item:GetWide()/ 2) + 250, 10, colors.text, TEXT_ALIGN_CENTER);
		end
		item.DoClick = function()
		end
		
		local mdl = vgui.Create("DModelPanel", item);
		mdl:SetModel(v.model);
		mdl:SetSize(item:GetTall()+60, item:GetTall()+60);
		mdl:SetPos(0, -70);
		
		local buy = vgui.Create("DButton", item);
		buy:SetSize(100, item:GetTall());
		buy:SetPos(item:GetWide() - 100, 0);
		buy:SetText(" ");
		function buy:OnCursorEntered() ja = true; end
		function buy:OnCursorExited() ja = false; end	
		local ja = false;
		local text = "buy";		
		buy.Paint = function()
			if (ja) then
				draw.RoundedBox(0, 0, 0, buy:GetWide(), buy:GetTall(), colors.transfer_hover);
			else
				draw.RoundedBox(0, 0, 0, buy:GetWide(), buy:GetTall(), colors.transfer_hover);
			end
			if (buy:GetDisabled()) then
				draw.RoundedBox(0, 0, 0, buy:GetWide(), buy:GetTall(), colors.transfer_disabled);
			end
			draw.SimpleText(text, "f4Btn", buy:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
		end
		buy.DoClick = function()
			frame:Close();
			RunConsoleCommand("DarkRP", "buyshipment", v.name);
		end
		
		local cost = v.price;
		if (!LocalPlayer():canAfford(cost)) then buy:SetDisabled(true); end
		if not table.HasValue(v.allowed, LocalPlayer():Team()) then buy:SetDisabled(true); end
		
	end	
	
	return panel;
end

