
# Scope
This is an extension that adds basic spec-style testing to Lua modules as used by the Scribunto extension on a wiki running the Mediawiki software.

The project is on-going, and as such will be extremly unstable &ndash; it might even trigger a meltdown of your computer. :)

## Identification
The _head_ of the extension is targeted at the _head_ of [Mediawiki](https://www.mediawiki.org/wiki/Download) and the _head_ of [Extension:Scribunto](https://www.mediawiki.org/wiki/Extension:Scribunto). There are made no attemps to make the extension compatible with older versions. The versions can be downloaded from Wikimedias git repository, or from GitHub.

A help portal for users are avalable at [Mediawiki](https://www.mediawiki.org/wiki/Special:MyLanguage/Help:Spec).

* [Mediawiki](https://phabricator.wikimedia.org/diffusion/MW/)
** Wikimedias git repository ``` git clone https://gerrit.wikimedia.org/r/p/mediawiki/core.git ```
** GitHubs git repository ``` git clone https://github.com/wikimedia/mediawiki.git ```
* [MediaWiki-extensions-Scribunto](https://phabricator.wikimedia.org/tag/mediawiki-extensions-scribunto/) / [extension-Scribunto](https://phabricator.wikimedia.org/diffusion/ELUA/)
** Wikimedias git repository ``` git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Scribunto ```
** GitHubs git repository ``` git clone https://github.com/wikimedia/mediawiki-extensions-Scribunto.git ```
* [MediaWiki-extensions-Spec](https://phabricator.wikimedia.org/tag/mediawiki-extensions-spec/) / [extension-Scribunto](https://phabricator.wikimedia.org/diffusion/) (not available yet)
** GitHubs git repository ``` git clone https://github.com/wikimedia/mediawiki-extensions-Spec.git ```

## System overview
The purpose of this extension is to make it possible to do efficient [continous testing](https://en.wikipedia.org/wiki/Continuous_testing) by detecting some Lua modules (pages) as holding a Spec, and the Lua code on those pages can then be run both in automatic and manual mode to verify correct  operation of some other modules. This makes it possible to do continous testing in an environment where new code are not only added as part of [continous integration](https://en.wikipedia.org/wiki/Continuous_integration), but even developed in the production environment itself.

## Document overview
The document is targeted to those that need a quick overview of the extension at a system level. That is a developer or system maintainer with technical experience. It is not ment as a documentation for the casual user. A end user documentation is available at [Help:Spec](https://www.mediawiki.org/wiki/Help:Spec)

For a description of the install procedure check out [Extension:Spec](https://www.mediawiki.org/wiki/Extension:Spec)

# Referenced documents
Core documents
* [MediaWiki: Help:Spec](https://www.mediawiki.org/wiki/Help:Spec)
* [Mediawiki: Extension:Spec](https://www.mediawiki.org/wiki/Extension:Spec)
* [Phabricator: MediaWiki-extensions-Spec](https://phabricator.wikimedia.org/tag/mediawiki-extensions-spec/)

Additional documents
* [Wikipedia: Continous testing](https://en.wikipedia.org/wiki/Continuous_testing)
* [Wikipedia: Continous integration](https://en.wikipedia.org/wiki/Continuous_integration)
* [Wikipedia: Continuous delivery](https://en.wikipedia.org/wiki/Continuous_delivery)
* [Wikipedia: Unit testing](https://en.wikipedia.org/wiki/Unit_testing)
* [The RSpec Book](https://pragprog.com/book/achbd/the-rspec-book)
* [RSpec: API documentation](http://rspec.info/documentation/)
* [busted: Elegant Lua unit testing](http://olivinelabs.com/busted/)

# Design decisions
A core design choice was to make the impact on the servers as small as possible. That means not running anything without it being highly likely that the results can be used in further processing. It starts with short circuit on content model, which is available in the title structure, and only then request additional data. Thus the number of modules that should need further inspection should be fairly low, and then the overall load from the extension should be small.

If a relation between a _tester_ (the code testing a module) and a _testee_ (the module being tested) is found, then page properties are used to maintain a page specific state. If that state changes then extension data is set up and later consumed by additional handlers. That makes it possible to create a pluggable system where components can be added and detached as necessary.

Spec code is written at the site in a similar fashion as other Lua code, the only requirement is that spec code should be a subpage with a specific name.

The spec code is assumed to connect with the provided Lua modules, and follows the usual _describe_, _context_, and _it_ ladder. Each of those manipulates _subject_ and _expect_ to set the expected behaviour from some subunit within the _testee_. This is farly similar to how [RSpec](http://rspec.info/documentation/) and [Busted](http://olivinelabs.com/busted/) works.

Core areas of Reliability, Availability, Serviceability/Maintainability, Usability, and Safety ([RAS(U)](https://en.wikipedia.org/wiki/Reliability,_availability_and_serviceability_(computing)), [RAMS](https://en.wikipedia.org/wiki/RAMS)) is assumed to be sufficently covered. An alternate formulation could be to use availbility as the sole composite measure.
* [Availability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page7) is usually a percentage given by reliability, maintainability, serviceability, performance and security, with a calculation based on agreed service time and downtime. There has been no attempts to calculate such a number for the extension itself.
* [Reliability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page61) is a measure of how long system can perform its function without interruption, usually given as [MTBF](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page47) or [MTBSI](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page48). There has been no attempts to measure this for the extension itself.
* [Maintainability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page46) is a measure of how fast a system can be restored to normal operation, usually given as [MTRS](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page=48). There has been no attempts to measure this for the extension itself, but as the extension has extensive testing it is assumed that it should be fairly good.
* [Serviceability](https://en.wikipedia.org/wiki/Serviceability_(computer)) (also _supportability_) is the ability of technical support personnel to install, configure, and monitor computer products, identify exceptions or faults, debug or isolate faults. In this context the ability to support this extension. There has been no attempts to measure this for the extension itself, but as the extension has extensive testing it is assumed that it should be fairly good.
* [Usability](https://www.exin.com/assets/exin/frameworks/108/glossaries/english_glossary_v1.0_201404.pdf#page=66) is how easilly a system can be used. The extension is based upon time-proven techniques from the current interface, and no new types of interactions are defined.
* [Safety](https://en.wikipedia.org/wiki/Safety) &ndash; other than use of a system user for logging purposes, it is not known that any part of the code needs special [safty engineering](https://en.wikipedia.org/wiki/Safety_engineering)

# Architectural design
## Components
At a high level the extension consists of core units to run the tests, to extract and track the state from those tests, and inject the tracked state into the common user interface. In addition there are some support libraries.

To run the tests
* LuaLibrary (PHP, Lua)
  * engine (Lua)
  * extractor (Lua)
  * render (Lua)
  * report (Lua)

To extract and track the state
* ExtractStatus (PHP)
* InvokeSubpage (PHP)

Support libraries
* Singletons (PHP)
* Sublinks (PHP)
* TestAnythingProtocol (PHP)
* TrackObserver (PHP)
* TNamedStrategies.php
* TNamedStrategy.php
* util.lua
* Stack.lua

## Concept of execution
The extension interact with the core system through hooks registered in [Hooks.php](https://github.com/jeblad/spec/blob/master/includes/Hooks.php) especially `Spec\Hooks::onContentAlterParserOutput()`. This function will track state changes, and set [page properties](https://www.mediawiki.org/wiki/Manual:Page_props_table) and extension data accordingly. Other hooks will then pick up the extension data and act on them, thereby setting [page indicators](https://www.mediawiki.org/wiki/Help:Page_status_indicators), [tracking categories](https://www.mediawiki.org/wiki/Help:Tracking_categories), and do [public logging](https://www.mediawiki.org/wiki/Manual:Logging_to_Special:Log).

The call `Spec\Hooks::onContentAlterParserOutput()` will also run a call to identify a strategy to invoke the proper subpage ([InvokeSuppage](https://github.com/jeblad/spec/tree/master/includes/InvokeSubpage)), process the result from that page ([TestAnythingProtocol](https://github.com/jeblad/spec/tree/master/includes/TestAnythingProtocol)), and then identify the status from the remaining data ([ExtractStatus](https://github.com/jeblad/spec/tree/master/includes/ExtractStatus)). The call is set up so it can handle both calls made for the tester (aka the spec-page) and the testee (aka the ordinary module).

The test itself is run as Lua, and is set up in the `Spec.setupInterface()` call ([Spec.lua](https://github.com/jeblad/spec/blob/master/includes/LuaLibrary/lua/non-pure/Spec.lua)) by a call from  `Spec\LuaLibrary::register()` ([LuaLibrary.php](https://github.com/jeblad/spec/blob/master/includes/LuaLibrary/LuaLibrary.php)).

The tests follows spec-style, with _describe_, _context_, and _it_. Those will then encapsulate tests, which use _subject_ and _expect_ to verify correct behavior of the module under test. The code for those modules can be found in [engine](https://github.com/jeblad/spec/tree/master/includes/LuaLibrary/lua/pure/speclib/engine). The engine will produce [reports](https://github.com/jeblad/spec/tree/master/includes/LuaLibrary/lua/pure/speclib/report) which are pure data about the tests. Those reports are then [rendered](https://github.com/jeblad/spec/tree/master/includes/LuaLibrary/lua/pure/speclib/render). As of this writing there are three different types of renders. Two of them are plain text renders, one giving a compact style layout and one that giving a full style. The third render creates a web style layout.

Test data can be provided to _describe_, _context_, and _it_ as nearly free form text. The data from the text is [extracted](https://github.com/jeblad/spec/tree/master/includes/LuaLibrary/lua/pure/speclib/extractor) and casted into the correct type. The present set of extractors are far from comprehensive, but assumed to be sufficient to make the system functional.

## Interface design
The extension does not provide additional subsystems that can be used by the system (site) as such, but will itself use features from the system. In particular [TrackCategory](https://github.com/jeblad/spec/tree/master/includes/TrackCategory), [TrackIndicator](https://github.com/jeblad/spec/tree/master/includes/TrackIndicator), and [TrackLogEntry](https://github.com/jeblad/spec/tree/master/includes/TrackLogEntry), will access facilities from Mediawiki. How this is done is described on [Help:Spec/Tracking categories](https://www.mediawiki.org/wiki/Help:Spec/Tracking_categories), [Help:Spec/Page status indicators](https://www.mediawiki.org/wiki/Help:Spec/Page_status_indicators), and [Help:Spec/Test status log](https://www.mediawiki.org/wiki/Help:Spec/Test_status_log).

In addition to facilities used by the extension it is possible to make new site specific testing frameworks as long as it exports TAP-formatted reports. By following the [TAP standard](https://testanything.org/) (it is a _personal standard_, and not a rigid one) the extension can use the new framework as its own. If the call must be changed, possibly also the name of the subpage holding the tests, then the configuration must be adjusted. The configuration section in [extension.json](https://github.com/jeblad/spec/blob/master/extension.json) would be _InvokeSubpage_.

# Detailed design
The following is in a somewhat logical order.
## InvokeSubpage
The unit finds a strategy for accessing a subpage, where the test has a positive outcome if a given page exist (or should exist) in a correct location. That is a relation between a _testee_ (the module being tested) and a _tester_ (the code testing a module) can be established. If the relation exist, or should exist, then the strategy provide methods for the name of the subpage, and also the question that will be parsed and will then provide the report. When a strategy find a usable relation it will not itself track the relation but leave it to the caller.

The strategies use options from the section `InvokeSubpage` in the extensions own [extension.json](https://github.com/jeblad/spec/blob/master/extension.json). It is possible to adapt this section to additional entries, typically new ways to invoke the subpage.

The strategy classes are divided into a common [interface](https://github.com/jeblad/spec/blob/master/includes/InvokeSubpage/IInvokeSubpageStrategy.php) and a [singleton](https://github.com/jeblad/spec/blob/master/includes/InvokeSubpage/InvokeSubpageStrategies.php), where the singleton is the accesspoint for higher level code. All PHP classes that implements the strategy are implementations of the interface.

## ExtractStatus
The unit finds a strategy for interpreting the report from a subpage, where the test has a positive outcome if a given parser evaluates to true. That is the tests reports are interpreted as TAP-formatted, and according to the given report it can be simplified into a final state. If a state is recognized, then the strategy provide a method for the name of the strategy which is the same as the state. The current (final) state will then be compared to previous state by the caller.

The strategies use options from the section `ExtractStatus` in the extensions own [extension.json](https://github.com/jeblad/spec/blob/master/extension.json). It is possible to adapt this section to additional entries, typically new states.

The strategy classes are divided into a common [interface](https://github.com/jeblad/spec/blob/master/includes/ExtractStatus/IExtractStatus.php) and a [singleton](https://github.com/jeblad/spec/blob/master/includes/ExtractStatus/ExtractStatusStrategies.php), where the singleton is the accesspoint for higher level code. All PHP classes that implements the strategy are implementations of the interface.

## LuaLibrary
## Singletons
## Sublinks
## TestAnythingProtocol
## TestConsole
Visual design of the system follows the same idea as the debug console, where a panel is positioned below the usual editor and then extended with Javascript in the browser. 
## TrackCategory
## TrackIndicator
## TrackLogEntry
## TrackObserver
# Requirements traceability
_none_

# Notes
_none_
