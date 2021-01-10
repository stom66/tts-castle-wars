# New Wiki

# Welcome

Welcome to your wiki! This is the default page we've installed for your convenience. Go ahead and edit it.

## Wiki features

This wiki uses the [Markdown](httpdaringfireball.netprojectsmarkdown) syntax. The [MarkDownDemo tutorial](httpsbitbucket.orgtutorialsmarkdowndemo) shows how various elements are rendered. The [Bitbucket documentation](httpsconfluence.atlassian.comxFA4zDQ) has more information about using a wiki.

The wiki itself is actually a git repository, which means you can clone it, edit it locallyoffline, add images or any other file type, and push it back to us. It will be live immediately.

Go ahead and try

```
$ git clone httpsbitbucket.orgsearangerstomtts-castle-wars.gitwiki
```

Wiki pages are normal files, with the .md extension. You can edit them locally, as well as creating new ones.

## Syntax highlighting


You can also highlight snippets of text (we use the excellent [Pygments][] library).

[Pygments] httppygments.org


Here's an example of some Python code

```
#!python

def wiki_rocks(text)
    formatter = lambda t funky+t
    return formatter(text)
```


You can check out the source of this page to see how that's done, and make sure to bookmark [the vast library of Pygment lexers][lexers], we accept the 'short name' or the 'mimetype' of anything in there.
[lexers] httppygments.orgdocslexers


Have fun!
