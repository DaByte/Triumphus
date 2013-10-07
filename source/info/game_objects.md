This document describes the objects that are part of this game.

# Game objects

Game objects are objects that define the structure of the game. They all have a representation in the game hierarchy.

## Entities

An entity is an object that has a distinct existence as an individual unit that may take decisions and perform actions.

### Players

Players are users who are playing the game. They are associated with a client which is connected to the game server. They are represented in the game hierarchy by `Player` objects contained in the `Players` service.

### Empires

An empire is an entity that owns one or many empires. All empires have one or many leaders who are players. The leaders of an empire may control the soldiers of that empire. An empire is said to be eliminated when it has lost possession of all its territories. Empires are represented by `Team` objects in the game hierarchy. All these `Team` objects are contained in the `Teams` service.

There is always a fixed number of empires in the game. Leaders of an empire can change as players join and leave the game.

#### Empire capitals

All empires have a capital, which is the only territory they have when the game starts, and when they are given a second chance by the game after having been eliminated (when this happens, the old capital loses its capital status and a new capital is chosen by the game). The capital of an empire gets twice the reinforcements of what it would get if it had not been a capital. Empire capitals also get the same defense advantage as country capitals.

### Armies

An army is an entity that can move from one territory to another and attack. Armies belong to either empires or independent countries. When an army belongs to an empire, the leaders of that empire may control it. When it belongs to an independent country, the game code controls the army and attempts to use it to liberate territories in the country that are owned by an empire. Armies are represented in the game hierarchy by parts.

## Events

An event is an occurrence; it is something that happens during the execution of the game. All events of a same kind share the same representation in the game hierarchy: they are represented either by a `RemoteEvent` object or by a `BindableEvent` object, depending on the needs. When an event occurs, the appropriate method of its object representation in the hierarchy is used to indicate that the event has occurred.

### Battle

A battle is an event that occurs when an army arrives at a territory to which it is hostile and attacks it. When a battle happens, soldiers will die in the army present in the territory and in the army attacking the territory. The defense of the territory that is being attacked is taken into consideration and can make soldiers die slower in the defending army. The outcome of a battle is largely predictable, but some randomness is involved.

### Revolution

A revolution is an event that occurs when a country or a territory becomes independent after being part of an empire. Revolutions will usually happen in countries that are owned by empires that are too powerful, at moments that cannot be predicted. They are the game mechanism that allows the game to go on forever without a round system being needed.

## Regions

### Territories

A territory is a region that is contained in a country and that can contain cities. Territories can have one or many soldiers, and they are either part of an independent country or owned by an empire.

#### Reinforcement

Territories will recruit soldiers over time. The reinforcement value of a territory defines the speed at which that territory recruits soldiers. Territories are represented by parts in the game hierarchy.

#### Defense

Territories may have natural or political advantages that make them have better defense. These advantages usually come from geographical elements. A territory's defense is taken into consideration when a battle occurs.

### Countries

A country is a region that is contained in a map and that can contain territories. Countries are represented by models in the game hierarchy and all territories in a country will have the same color. All countries have a name, and these names are unique.

#### Country capitals

A country capital is a territory which is the capital of a country. Country capitals have a defense advantage. The capital of a country that has a capital is defined by the value of a `ObjectValue` object contained in the object representation of the country. The value of this `ObjectValue` object is the object representation of the territory which is the capital of the country.

### Maps

A map is a region that contains countries and that is contained at the root of the physical game hierarchy. There can only be one map at a time in a particular game instance. All maps have a name, and map names must be unique.

## Geographical elements

### Cities

A city is a geographical element that is contained in a territory. Cities are represented by parts in the game hierarchy. The number of cities in a territory is a factor of the reinforcement value of that territory. Cities may have a name, but this is optional. City names are not currently used or displayed in the game.

#### Importance

Some cities may be considered by the game as important, while others may be considered as not important. If a city is important, it will contain a `BoolValue` object named "Important" of which the value will be `true`. Important cities will earn the territory that contain them a higher reinforcement value bonus than cities that are not important. They will also have a different color.

### Mountains

A mountain is a geographical element that is contained in a territory. Mountains are represented by models in the game hierarchy. A territory that contains a mountain will receive a defense bonus.

### Rivers

A river is a geographical element that is contained in a territory. Rivers are represented by models in the game hierarchy. A territory that contains a river will receive a defense bonus.

### Lakes

A lake is a geographical element that is contained in a territory. Lakes are represented by parts in the game hierarchy. They have no effect on the game.