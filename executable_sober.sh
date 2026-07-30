#!/bin/bash
busctl --user call org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.OpenURI OpenURI "ssa{sv}" "" "$1" 0
