# i18n

Add languages as necessary. English is the source language for translations,
all other languages are targets. Norwegian Bokmål is an example target language.

## Glossary

If you need a glossary, a lot of the terms are tecnical jargon, one is defined at
[Help:Spec/Glossary](https://www.mediawiki.org/wiki/Help:Spec/Glossary).

## Templates

There should be a template `spec-gloss` reading (with additional markup)

> [//mediawiki.org/wiki/Special:MyLanguage/Help:Spec/Glossary glossary]

There should be a template `spec-indicator-desc` reading

> This is the text for the link to the spec page, given that the test result is "{{{1}}}". Should be
> a very minimalistic text that can be used as link in the page indicators.

There should be a template `spec-invoke-desc` reading

> This is the message used to get the result for a specific page in the module space. The message is
> chosen depending on som hauristics.

There should be a template `spec-subpage-desc` reading

> This is the message used to build the link to a specific page in the module space. The message is
> chosen depending on som hauristics.

There should be a template `spec-report-vivid` reading

> This is the version for the full html layout.

There should be a template `spec-report-full` reading

> This is the version for the full text layout.

There should be a template `spec-report-compact` reading

> This is the version for the compact text layout.

There should be a template `spec-pick-element` reading

> This identifies the {{{2}}} element, that is by using {{{1}}} as index.

There should be a template `spec-preprocess` reading

> This is a message being used in the report.

There should be a template `spec-string-format` reading

> This processes the string by applying a "{{{1}}}" transform.

There should be a template `spec-ustring-format` reading

> This processes the Unicode string by applying a "{{{1}}}" transform.
