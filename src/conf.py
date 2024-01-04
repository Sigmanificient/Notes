#!/usr/bin/env python3

from datetime import date

extensions = [
    "myst_parser",
    "sphinx.ext.intersphinx",
    "sphinx.ext.todo",
    "sphinx_copybutton",
    "sphinx_design",
    "sphinx_sitemap",
    "notfound.extension",
]

myst_enable_extensions = [
    "colon_fence",
    "linkify",
    "tasklist",
]

myst_heading_anchors = 3
myst_number_code_blocks = [ "c" ]

templates_path = [ ]

source_suffix = ".md"
master_doc = "index"

project = "Notes"
author = "Sigmanificient"
copyright = f"2021 - {date.today().year}, Sigmanificient"

pygments_style = "sphinx"
todo_include_todos = True

html_theme = "furo"
html_baseurl = "https://notes.1l.is/"
html_favicon = "favicon.png"

html_static_path = []
html_extra_path = []
html_css_files = []

sitemap_url_scheme = "{link}"

# Not found
notfound_urls_prefix = "/"
