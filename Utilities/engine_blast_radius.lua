local glVertex      = gl.Vertex
local glPushAttrib  = gl.PushAttrib
local glLineStipple = gl.LineStipple
local glDepthTest   = gl.DepthTest
local glLineWidth   = gl.LineWidth
local glColor       = gl.Color
local glBeginEnd    = gl.BeginEnd
local glPopAttrib   = gl.PopAttrib
local glCreateList  = gl.CreateList
local glCallList    = gl.CallList
local glDeleteList  = gl.DeleteList
local glPopMatrix   = gl.PopMatrix
local glPushMatrix  = gl.PushMatrix
local glScale       = gl.Scale
local glTranslate   = gl.Translate
local GL_LINES      = GL.LINES
local GL_LINE_LOOP           = GL.LINE_LOOP

local circleDivs           = 64

local PI                     = math.pi
local cos                    = math.cos
local sin                    = math.sin

local aoeLineWidthMult     = 64
local numAoECircles        = 9
local aoeColor             = {1, 0, 0, 1}
local mouseDistance = 1000
local floor                  = math.floor

local pulse_timmer = Spring.GetTimer()
local function getPulse()
  local time = Spring.DiffTimers(Spring.GetTimer(), pulse_timmer)
  return 1 - (time - floor(time))
end

local function UnitCircleVertices()
  for i = 1, circleDivs do
    local theta = 2 * PI * i / circleDivs
    glVertex(cos(theta), 0, sin(theta)) 
  end
end

local function DrawCircle(x, y, z, radius)
  glPushMatrix()
  glTranslate(x, y, z)
  glScale(radius, radius, radius)
  glBeginEnd(GL_LINE_LOOP, UnitCircleVertices)
  glPopMatrix()
end

function drawBlastRadius(tx, ty, tz, weaponDef)
  local aoe = weaponDef.damageAreaOfEffect
  local ee = weaponDef.edgeEffectiveness

  glLineWidth(math.max(0.05, aoeLineWidthMult * aoe / mouseDistance))

  for i = 1, numAoECircles do
    local proportion = i / (numAoECircles + 1)
    local radius = aoe * proportion
    local alpha = aoeColor[4] * (1 - proportion) / (1 - proportion * ee) * getPulse()
    glColor(aoeColor[1], aoeColor[2], aoeColor[3], alpha)
    DrawCircle(tx, ty, tz, radius)
  end

  glColor(1,1,1,1)
  glLineWidth(1)
end

function drawLine(x1, y1, z1, x2, y2, z2)
  glPushAttrib(GL.LINE_BITS)
  gl.LineStipple("springdefault")
  glDepthTest(false)
  glLineWidth(1)
  glColor(1, 0, 0, setTargetAlpha)
  glBeginEnd(GL.LINES, function()
    glVertex(x1, y1, z1)
    glVertex(x2, y2, z2)
  end)

  glColor(1, 1, 1, 1)
  glLineStipple(false)
  glPopAttrib()
end
