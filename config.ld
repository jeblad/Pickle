project = 'Pickle'
title = 'Pickle documentation'
description = 'Testing framework for Lua embedded within Mediawiki.'
full_description = [[The [Pickle extension](https://mediawiki.org/wiki/Extension:Pickle) is a
project to integrate [continuous testing](https://en.wikipedia.org/wiki/continuous_testing) into an
environment for [continuous integration](https://en.wikipedia.org/wiki/continuous_integration), like
[Wikipedia](https://en.wikipedia.org/wiki/Wikipedia) which embed
[Lua-scripts](https://en.wikipedia.org/wiki/Lua_programming language) through the
[Scribunto extension](https://mediawiki.org/wiki/Extension:Scribunto). Within Wikipedia Lua is used
to implement advanced templates with [Lua modules](https://en.wikipedia.org/wiki/Help:Lua), and the
same solution is used on a lot of other websites and projects. Continuous integration is a core
element of [continuous deployment](https://en.wikipedia.org/wiki/continuous_deployment), which is
very important for sites that must be up and running 24×7.
[Pickle testing](https://mediawiki.org/wiki/Help:Pickle) is a kind of spec-style testing, which can
be described as a variant of [unit testing](https://en.wikipedia.org/wiki/unit_testing), or _how to
make the thing right_. Later on, Pickle might be extended with step-style testing, or _how to build
the right thing_. What to build, and how to build it, is not the only important thing. It is also
utterly important to reduce the overall risk associated with running live Lua development within an
active [MediaWiki](https://en.wikipedia.org/wiki/MediaWiki) project.]]
use_markdown_titles = true
format = 'markdown'
dir = 'docs'
output = 'mw.pickle'
-- all = true

readme = {
	'topics/activities.md',
	'topics/adapt.md',
	'topics/call-style.md',
	'topics/change-log.md',
	'topics/databases.md',
	'topics/dataflow.md',
	'topics/hello-world.md',
	'topics/lua-classes.md',
	'topics/musings.md',
	'topics/page-indicators.md',
	'topics/sources.md',
	'topics/spies.md',
	'topics/statistics.md',
	'topics/test-anything-protocol.md',
	'topics/test-case.md',
	'topics/test-doubles.md',
	'topics/testing.md',
	'topics/tracking-categories.md',
	'topics/translatewiki.md',
	'topics/vagrant.md',
	'topics/vscode-extensions.md',
	'topics/vscode-snippets.md'
}

examples = {
	'examples'
}

-- new_type( 'macro', 'Macros' )
custom_tags = {
	{ 'nick', title='Nicknames', hidden = false, format=nil },
	{ 'delayed', hidden = true },
	{ 'pick', hidden = true },
	{ 'transform', hidden = true },
	{ 'condition', hidden = true }
}

custom_display_name_handler = function(item, default_handler)
	-- show a label beside functions tagged with @delayed.
	local tagged = nil
	if item.type == 'lfunction' or item.type == 'function' then
		-- show a label beside functions tagged with @delayed.
		if item.tags.delayed then
			tagged = ( tagged or '' ) .. '[<a href="../topics/adapt.md.html#delayed">delayed</a>]'
		end
		-- show a label beside functions tagged with @pick.
		if item.type == 'function' and item.tags.pick then
			tagged = ( tagged or '' ) .. '[<a href="../topics/adapt.md.html#pick">pick</a>]'
		-- show a label beside functions tagged with @transform.
		elseif item.type == 'function' and item.tags.transform then
			tagged = ( tagged or '' ) .. '[<a href="../topics/adapt.md.html#transform">transform</a>]'
		-- show a label beside functions tagged with @condition.
		elseif item.type == 'function' and item.tags.condition then
			tagged = ( tagged or '' ) .. '[<a href="../topics/adapt.md.html#condition">condition</a>]'
		end
		if tagged then
			return item.name .. ' () ' .. tagged
		end
	end
	return default_handler(item)
end
