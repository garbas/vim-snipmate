============
snipmate.vim
============

:Author: `Michael Sanders`_
:Maintainer: `Rok Garbas`_
:Homepage: http://www.vim.org/scripts/script.php?script_id=2540 
:Contributors: `MarcWeber`_, `lilydjwg`_, `henrik`_, `steveno`_, `asymmetric`_, `jherdman`_, `ironcamel`_, `honza`_, `jb55`_, `robhudson`_, `kozo2`_, `MicahElliott`_, `darkwise`_, `redpill`_, `thisgeek`_, `sickill`_, `pose`_, `marutanm`_, `r00k`_, `jbernard`_, `holizz`_, `muffinresearch`_, `statik`_, Eustaquio Rangel


.. contents::


Why forking snipMate?
=====================

::

    After several unsuccessful attempts of contacting Michael Sanders, no
    commits in last half year and long pull request line on github (none of
    pull requests were commented/replied/rejected) I decided to take action and
    step up and bring some love to this widly used plugin.

    But nothing to worry about. We all get busy, accupied with our daily work
    or just lose interest in doing boring maintainance.

    While reviewing pull requests on github.com/msanders I found lots of great
    improvements and I decided to **friendly** fork it, review and apply patches
    that were sent, notify all the patch submiters and decided to do
    maintainance of snipmate.vim from now on. Ofcourse if somebody want to
    help, please don't hesitate to write me, I'm open to all suggestions. The
    only thing in what I'm not interested is leaving things like they are now.

    Maybe I'll only maintain it for a while until Michael Sanders takes things
    back into his hand or until some other super-hero shows up.

    Tnx and happy snipmating, Rok Garbas, 2011-02-02


Changelog
=========


1.0 [Unreleased]
----------------

    * Updated README: added contributors, instructions how to install snipMate,
      some spellchecking of my wonderfull english, added this Changelog
      [2011-02-07, `garbas`_]

    * From bellow mentioned merges I must spectialy mention `MarcWeber`_ patch
      which brought quite few functionalities/improvements:
        - snippets are loaded lazily.
        - snippets are no longer cached. Thus you always get the snippets you 
          just wrote to a file without reloading anything.
        - When visually selecting a snippet in a .snippets file you can press
          <cr> to replace spaces by tabs automatically in a smart way.
      Big +1 to `MarcWeber`_ for this. Important to note is that we now depend
      on `vim-addon-mw-utils`_ and `tlib`_.
      [2011-02-02, `garbas`_]

    * Marged pull requests of `MarcWeber`_, `lilydjwg`_, `henrik`_, `steveno`_,
      `asymmetric`_, `jherdman`_, `ironcamel`_, `honza`_, `jb55`_,
      `robhudson`_, `kozo2`_, `MicahElliott`_, `darkwise`_, `redpill`_,
      `thisgeek`_, `sickill`_, `pose`_,
      [2011-02-02, `garbas`_]


0.83 [2009-07-13]
-----------------

    * last release done by `Michael Sanders`_, you can found it here:
        http://www.vim.org/scripts/download_script.php?src_id=11006


How to install
==============

Unfortunatly there are many ways to how to install vim plugins. If you don't
see you prefered way of installation plugins please consider adding updating
this section.

Important to note is that since version 1.0 we depend on this 2 vim plugins:
    * `vim-addon-mw-utils`_
    * `tlib`_


Using `VAM`_
------------

.. todo:: need to test and write howto

Using `pathogen`_
--------------------------------------

::

    % cd ~/.vim
    % mkdir bundle
    % cd bundle
    % git clone https://github.com/tomtom/tlib_vim.git
    % git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
    % git clone git://github.com/garbas/vim-snipmate.git

Manually
--------

::

    % git clone git://github.com/msanders/snipmate.vim.git
    % cd snipmate.vim
    % cp -R * ~/.vim

Then in vim::

    :helptags ~/.vim/doc/


TODO / Future
=============

    * Add documentation part on how to install with `VAM`_
      [2011-02-07, `garbas`_]

    * Notify all "forkers" about new home and ask them nicely to review already
      merged changes and possibly send they changes.
      [2011-02-07, `garbas`_]

    * I'd like to investigate whether xptemplate or snipmate has the better
      engine. So maybe my vision of the future could be making xptemplate read
      snippet files. Its not imortant enough to me to work on it right now as
      snipmate works reasonable well for me.
      [2011-02-02, `MarcWeber`_]


.. _`Michael Sanders`: http://www.vim.org/account/profile.php?user_id=16544
.. _`Rok Garbas`: rok@garbas.si
.. _`VAM`: https://github.com/MarcWeber/vim-addon-manager
.. _`pathogen`: http://www.vim.org/scripts/script.php?script_id=2332
.. _`vim-addon-mw-utils`: https://github.com/MarcWeber/vim-addon-mw-utils
.. _`tlib`: https://github.com/tomtom/tlib_vim

.. _`garbas`: https://github.com/garbas
.. _`MarcWeber`: https://github.com/MarcWeber
.. _`lilydjwg`: https://github.com/lilydjwg
.. _`henrik`: https://github.com/henrik
.. _`steveno`: https://github.com/steveno
.. _`asymmetric`: https://github.com/asymmetric
.. _`jherdman`: https://github.com/jherdman
.. _`ironcamel`: https://github.com/ironcamel
.. _`honza`: https://github.com/honza
.. _`jb55`: https://github.com/jb55
.. _`robhudson`: https://github.com/robhudson
.. _`kozo2`: https://github.com/kozo2
.. _`MicahElliott`: https://github.com/MicahElliott
.. _`darkwise`: https://github.com/darkwise
.. _`redpill`: https://github.com/redpill
.. _`thisgeek`: https://github.com/thisgeek
.. _`sickill`: https://github.com/sickill
.. _`pose`: https://github.com/pose

.. _`marutanm`: https://github.com/marutanm
.. _`r00k`: https://github.com/r00k
.. _`jbernard`: https://github.com/jbernard
.. _`holizz`: https://github.com/holizz
.. _`muffinresearch`: https://github.com/muffinresearch
.. _`statik`: https://github.com/statik
