--- The region package is used to generate maps and manipulate regions.

local region = {}

--- Creates a city
-- This function should not be used directly. Instead, the `CreateCity` bindable function located inside territory objects should be used.
-- @param territory This should be the territory the city will be part of.
-- @param important This should be a boolean value that indicates whether the city that will be created is important.
-- @param name This is an optional parameter that indicates the name of the city. If none ism entioned, the name "City" will be used.
-- @return A `Part` object that represents the city.
function region.create_city(territory, important, name)
	local city = Instance.new('Part', territory)
	city.Name = name or "City"
	
	if important then
		local importance_indicator = Instance.new('BoolValue', city)
		importance_indicator.Name = "Important"
		importance_indicator.Value = true
	end
	
	return city
end

--- Creates a territory
-- This function should not be used directly. Instead, the `CreateTerritory` bindable function located inside country objects should be used.
-- @param country This should be the country the territory will be part of.
-- @param name This is an optional parameter that indicates the name of the territory. If none ism entioned, the name "Territory" will be used.
-- @return A `Part` object that can contain parts representing cities and parts or models representing geographical elements.
function region.create_territory(country, name)
	local territory = Instance.new('Part', country)
	territory.Name = name or "Territory"

	return territory
end

--- Creates a country
-- This function should not be used directly. Instead, the `CreateCountry` bindable function located inside map objects should be used.
-- @param name This should be the name of the country that will be created. This parameter is mandatory, but if it is not specified, the name "Country" will be used.
-- @param map This should be the map the country will be part of.
-- @return A `Model` object of which the `Name` property is the name of the country. The model can contain parts representing territories.
function region.create_country(name, map)
	local country = Instance.new('Model', map)
	country.Name = name or "Country"
	
	local bindable_create_territory = Instance.new('BindableFunction', country)
	bindable_create_territory.Name = "CreateTerritory"
	bindable_create_territory.OnInvoke = function(...) region.create_territory(bindable_create_territory, ...) end

	return country
end


--- Creates a map
-- @param name This should be the name of the map that will be created. This parameter is mandatory, but if it is not specified, the name "Map" will be used.
-- @param parent This should be either the value `nil`, if the map is not meant to be used yet, or the root of the physical game hierarchy.
-- @return A `Model` object of which the `Name` property is the name of the map and that can contain `Model` objects representing countries.
function region.create_map(name, parent)
	local map = Instance.new('Model', parent)
	map.Name = name or "Map"

	local bindable_create_country = Instance.new('BindableFunction', map)
	bindable_create_country.Name = "CreateCountry"
	bindable_create_country.OnInvoke = function(...) region.create_country(bindable_create_country, ...) end

	return map
end

return region