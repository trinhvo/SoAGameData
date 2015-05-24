local LabelStyle = require "Data/UI/label_style"

local nameLabel = {}

function addWidgetToList(w)
  WidgetList.addItem(widgetList, w)
end

panelCounter = 0
function newPanel()
  local p = Form.makePanel(this, "Panel" .. panelCounter, 0, 0, 10, 10)
  Panel.setWidthPercentage(p, 1.0)
  Panel.setClippingEnabled(p, false)
  Panel.setMinSize(p, 300, 30)
  addWidgetToList(p)
  local l = LabelStyle.make("Label" .. panelCounter, "")
  panelCounter = panelCounter + 1
  alignLabel(l, p)
  return {panel = p, label = l}
end

function alignLabel(l, p)
  Label.setPositionPercentage(l, 0.03, 0.5) 
  Label.setWidthPercentage(l, 0.65) 
  Label.setTextScale(l, 0.55, 0.55)
  Label.setParent(l, p)
end

function updateUI(t) 
  if t == 0 then
    Form.disable(this)
  else
    Form.enable(this)
    Label.setText(namePanel.label, Space.getBodyName(t))
    Label.setText(massPanel.label, string.format("Mass : %.2e", Space.getBodyMass(t)))
    Label.setText(diameterPanel.label, string.format("Diameter (KM): %.2f", Space.getBodyDiameter(t)))
    Label.setText(rotPeriodPanel.label, string.format("Day (Hours): %.2f", Space.getBodyRotPeriod(t) / 3600.0))
    Label.setText(tiltPanel.label, string.format("Axial Tilt: %.2f", Space.getBodyAxialTilt(t)))
  end
end

function onTargetChange(t)
  updateUI(t)
end
Vorb.register("onTargetChange", onTargetChange)

function init()
  
  -- Widget list
  widgetList = Form.makeWidgetList(this, "widgetList", 0, 0, 1000, 1000)
  WidgetList.setPositionPercentage(widgetList, 0.7, 0.03)
  WidgetList.setDimensionsPercentage(widgetList, 0.3, 0.9)
  WidgetList.setMinSize(widgetList, 300, 100)
  WidgetList.setAutoScroll(widgetList, true)
  
  namePanel = newPanel();
  Label.setXPercentage(namePanel.label, 0.5)
  Label.setWidgetAlign(namePanel.label, WidgetAlign.CENTER)
  Label.setTextAlign(namePanel.label, TextAlign.CENTER)
  Label.setTextScale(namePanel.label, 0.8, 0.8)
  
  diameterPanel = newPanel()
  massPanel = newPanel()
  rotPeriodPanel = newPanel()
  tiltPanel = newPanel()
  updateUI(Space.getTargetBody())
end

Vorb.register("init", init)
