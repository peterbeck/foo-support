::workaround german xp; http://code.google.com/p/gitso/issues/detail?id=42
:: foo.li systeme + software 2013

@echo off
%systemroot%\system32\netstat.exe %1 | sed s/HERGESTELLT/ESTABLISHED/ | sed s/ABH.*/LISTEN/