local ej = require "ejoy2d"
local fw = require "ejoy2d.framework"
local CONFIG = require "dawn_config"

local M = {}

local sw = fw.ScreenWidth
local sh = fw.ScreenHeight

local SKY_PCT = 0.01

local SKY_TEX_W = 1
local SKY_TEX_H = 1
local SEA_TEX_W = 512
local SEA_TEX_H = 512


local SIM_SPEED = 0.02
local WAVE_SPEED = 0.15
local SHIFT_SPEED = 0.01

local SL8 = math.pow(2, 8)
local SL16 = math.pow(2, 16)
local SL24 = math.pow(2, 24)
local PIOVER12 = math.pi / 12

local function _mix1(c1, c2, f)
	return c1*(1-f) + c2*f
end

local function _mix4(c1, c2, f)
	return {
		c1[1]*(1-f) + c2[1]*f,
		c1[2]*(1-f) + c2[2]*f,
		c1[3]*(1-f) + c2[3]*f,
		c1[4]*(1-f) + c2[4]*f,
	}
end

local function _mixc(c1, c2, f)
	local c = _mix4(c1, c2, f)
	return
		math.floor(c[4]*255) * SL24 +
		math.floor(c[1]*255) * SL16 +
		math.floor(c[2]*255) * SL8 +
		math.floor(c[3]*255)
end


function M:init()
	self:init_sim()
	self:layout_sim(false)
end

function M:update()
	
end


function M:draw()

	local s1 = CONFIG[15]
	local s2 = CONFIG[16]
	-- sea
	self.v_t0x = self.v_t0x + WAVE_SPEED
	self.v_t01 = self.v_t01 + WAVE_SPEED*self.v_t01_dir
	if self.v_t01 > 1 or self.v_t01 < 0 then
		self.v_t01_dir = -self.v_t01_dir
	end

	local m = 1

	self.v_sea.program_param.t = self.v_t0x
	self.v_sea.program_param.t1 = self.v_t01
	self.v_sea.program_param.sx = 20 / sw
	self.v_sea.program_param.far = _mix4(s1.sea_far, s2.sea_far, m)
	self.v_sea.program_param.near = _mix4(s1.sea_near, s2.sea_near, m)
	--self.v_sea.program_param.spec = _mix4(s1.sea_spec, s2.sea_spec, m)
	-- self.v_sea.program_param.refl = rc
	self.v_sea:draw()

end


function M:pause_time( ... )
	
end

function M:shift_time( ... )
	
end

function M:layout_sim( horz )

	if horz then
		sw = fw.ScreenHeight
		sh = fw.ScreenWidth
	else
		sw = fw.ScreenWidth
		sh = fw.ScreenHeight
	end

	

	self.v_sea:ps(sw*0.5, sh*(1+SKY_PCT)*0.5)
	self.v_sea:sr(sw/SEA_TEX_W, sh*(1-SKY_PCT)/SEA_TEX_H)

	
end

function M:init_sim( ... )
	self.v_sea = ej.sprite("dawn", "water")
	self.v_sea.program = "sea"
	
	self.v_t0x = 0  -- shader params
	self.v_t01 = 0
	self.v_t01_dir = 1
end


return M