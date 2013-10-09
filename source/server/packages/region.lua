--- The region package is used to generate maps and manipulate regions.
-- author: Mark Otaris
-- copyright: Copyright Mark Otaris 2013
-- license: Creative Commons Attribution-ShareAlike 2.0 Generic
-- module: region

local region = {}

settings:Add('RegionNames', 'string', "City")

--- This function generates a random name for a region.
-- The names are taken from a seed located in the setting named "RegionNames".
-- This seed must consist of comma-separated names. The last name must have a comma after it.
function region.generate_name()
	local city_names = {}
	for city_name in settings.CityNames do
		city_names[#city_names + 1] = city_name
	end
	return city_names[math.random(#city_names)]
end

--- This function creates a city.
-- It should not be used directly; instead, the `CreateCity` bindable function located inside territory objects should be used.
-- @{[[Part]]}: territory This should be the territory the city will be part of.
-- ?bool: important This should be a boolean value that indicates whether the city that will be created is important. If not specified, it will be assumed that the city is not important.
-- ?string: name This is an optional parameter that indicates the name of the city. If none is mentioned, the name "City" will be used.
-- treturn: @{[[Part]]} A @{[[Part]]} object that represents the city.
-- todo: Add support for positions. They should be relative to the middle of the territory or to its northwest corner.
function region.create_city(territory, important, name)
	local city = Instance.new('Part', territory)
	city.Name = name or "City"
	city.Anchored = true
	city.BottomSurface = Enum.SurfaceType.Smooth
	city.FormFactor = Enum.FormFactor.Plate
	city.TopSurface = Enum.SurfaceType.Smooth
	
	if important then
		local importance_indicator = Instance.new('BoolValue', city)
		importance_indicator.Name = "Important"
		importance_indicator.Value = true
	end
	
	return city
end

--- This function generates a city.
-- It should not be used directly; instead, the `GenerateCity` bindable function located inside territory objects should be used.
-- This function will generate a city with a random importance, a random position (not implemented) and a random name (not implemented).
-- @{[[Part]]}: territory This should be the territory the city will be part of.
-- todo: Generate a random position for the city and make sure it doesn't overlap with another city or is too close (using magnitude)
function region.generate_city(territory)
	local city = region.create_city(territory, math.random(2) == 1, region.generate_name())
end

--- This function creates a territory.
-- It should not be used directly; instead, the `CreateTerritory` bindable function located inside country objects should be used.
-- @{[[Model]]}: country This should be the country the territory will be part of.
-- @{[[Vector2]]}: size This should be the size of the territory.
-- @{[[Vector2]]}: position This should be the position of the territory.
-- string: name This is an optional parameter that indicates the name of the territory. If none is mentioned, the name "Territory" will be used.
-- treturn: @{[[Part]]} A @{[[Part]]} object that can contain parts representing cities and parts or models representing geographical elements.
function region.create_territory(country, size, position, name)
	local territory = Instance.new('Part', country)
	territory.Name = name or "Territory"
	territory.Anchored = true
	territory.BottomSurface = Enum.SurfaceType.Smooth
	territory.FormFactor = Enum.FormFactor.Symmetric
	territory.Position = Vector3.new(position.X, 0, position.Y)
	territory.Size = Vector3.new(size.X, 0, size.Y)
	territory.TopSurface = Enum.SurfaceType.Smooth

	local bindable_create_city = Instance.new('BindableFunction', territory)
	bindable_create_city.Name = "CreateCity"
	bindable_create_city.OnInvoke = function(...) region.create_city(territory, ...) end
	
	local bindable_generate_city = Instance.new('BindableFunction', territory)
	bindable_generate_city.Name = "GenerateCity"
	bindable_generate_city.OnInvoke = function(...) region.generate_city(territory, ...) end

	return territory
end
--- This function creates a country.
-- It should not be used directly; instead, the `CreateCountry` bindable function located inside map objects should be used.
-- string: name This should be the name of the country that will be created. This parameter is mandatory, but if it is not specified, the name "Country" will be used.
-- @{[[Model]]}: map This should be the map the country will be part of.
-- treturn: @{[[Model]]} A @{[[Model]]} object of which the `Name` property is the name of the country. The model can contain parts representing territories.
function region.create_country(name, map)
	local country = Instance.new('Model', map)
	country.Name = name or "Country"
	
	local bindable_create_territory = Instance.new('BindableFunction', country)
	bindable_create_territory.Name = "CreateTerritory"
	bindable_create_territory.OnInvoke = function(...) region.create_territory(country, ...) end

	return country
end


--- This function creates a map.
-- string: name This should be the name of the map that will be created. This parameter is mandatory, but if it is not specified, the name "Map" will be used.
-- ?Workspace: parent This should be either the value `nil`, if the map is not meant to be used yet, or the root of the physical game hierarchy.
-- treturn: @{[[Model]]} A @{[[Model]]} object of which the @{[[Name]]} property is the name of the map and that can contain @{[[Model]]} objects representing countries.
function region.create_map(name, parent)
	local map = Instance.new('Model', parent)
	map.Name = name or "Map"

	local bindable_create_country = Instance.new('BindableFunction', map)
	bindable_create_country.Name = "CreateCountry"
	bindable_create_country.OnInvoke = function(name) region.create_country(name, map) end

	return map
end

return region