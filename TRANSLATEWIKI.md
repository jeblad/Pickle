# TranslateWiki

This extension is translated at
[TranslateWiki](https://translatewiki.net/wiki/Special:Translate/mwgithub-pickle).

Some of the messages are special markers, and should not be translated. It may
still be necessary to adapt them somehow, and in those cases special care must
be taken to not disturb normal parsing.

The descriptions (the qqq-messages) marked as `{{Optional}}` goes in the group
_mwgithub-pickle_ in the file `groups/MediaWiki/mwgithub.yaml` at the repo for
TranslateWiki. The public configuration repository can be found at
[Phabricator](https://phabricator.wikimedia.org/diffusion/GTWN/).

A common EPIC used for bug tracking is found at
[T169455 - Maintenance of optional and ignored messages](https://phabricator.wikimedia.org/T169455).

To extract the optional messages use

```bash
fgrep '{{Optional}}' i18n/qqq.json | grep -o ".*:" | grep -o "[-a-z]*"
```

To extract the ignored messages use

```bash
fgrep '{{Notranslate}}' i18n/qqq.json | grep -o ".*:" | grep -o "[-a-z]*"
```
