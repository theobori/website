---
title: My opinionated tool to manage notes
date: "2026-09-05"
---

## Introduction

I was writing some notes in [GNU Emacs](https://www.gnu.org/software/emacs) and thought it might be fun to create a small, personal, pocket-sized tool for managing notes in a simple way. GNU Emacs is very comprehensive and well-suited for managing notes, I've been using it for several years to write my zettelkasten. However, I wanted to try a different note-taking tool. After doing some research, I realized it made more sense to write my own tool that would meet my specific criteria.

In this blog post, I explain my research journey leading up to the creation of my own personal note-taking tool. If you'd like more technical details, feel free to check out the project's technical documentation available in the [GitHub repository](https://github.com/theobori/a).

## My needs

This section describes my needs.

### File format independence

I want the file format of the notes to be independent of the tool. I want to write in [Markdown](https://commonmark.org/), [Org](https://orgmode.org/fr/), or even plain text. The tool does not support relationships between notes, this functionality will rely entirely on the file format.

### File naming scheme

I want each note to have metadata embedded in its file name. At a minimum, I want each note to have a title, tags, and a file extension.

### Flexible file hierarchy

Note files should be able to reside in a flat directory structure or in subfolders with an undefined maximum depth.

### Dedicated query language

The idea is to have a dedicated query language for filtering notes. Ideally, the query should be compiled into bytecode for a virtual machine, and then the bytecode should be executed for each note by passing the context. I want to be able to filter by at least title, tags, and modification date.

### Simplicity

I want the tool to be easy to use and intuitive. I'd like it so that even if I stop using the tool for three years, I can figure out how it works very quickly. It should support only basic features, that is, creating, renaming, editing, and filtering notes.

## Search for existing software

I looked into well-known note-taking software, [Obsidian](https://obsidian.md), [Notion](https://www.notion.com/fr), [Joplin](https://joplinapp.org/fr), but didn't find anything that quite fit the bill. They were complex, overloaded, commercially oriented, AI oriented, had unnecessary features, or weren't cross-platform. The closest thing to what I'm looking for is [zk](https://github.com/zk-org/zk).

## Inspiration

I usually use GNU Emacs, so I decided to explore packages specialized in note-taking and metadata filtering.

### denote.el

Denote.el is the Emacs package that comes closest to what I was looking for. It's a simple tool that uses filenames to infer certain metadata. I drew inspiration from the filename schema.

### org-ql

I stumbled upon org-ql by chance, it lets you search for notes using a custom query language that inspired me. It's a functional-style language similar to Emacs Lisp, it's used to filter notes by their metadata and implements basic binary operations.

## My personal tool

So I wrote a CLI that lets me create, rename, edit, and filter my notes using my custom language. Below is an example of a language expression.

```lisp
(or
  (or 
    (title "title1")
    (title "title2"))
  ;;
  ;; Comment 1
  ;;
  (tag "tag1")
  ;;
  ;; Comment 2
  ;;
  (if (from-date "2020-01-01")
    (title "title3")
  (title "title4"))
  ;;
  ;; Comment 3
  ;;
  (to-date "2020-02-01")
  ;;
  ;; Comment 4
  ;;
  (and
    (not (tag "tag2"))
    (tag "tag3")))
```

### Usage examples

This section provides a few examples of how to use the tool, which you can test directly in the root of the project's Git repository once the tool is installed.

Below is an example of recursively filtering notes in the './example' folder and then printing the path associated with each note.
```bash
a query -r example -q '(or
    (tag "leetcode")
    (tag "medium")
    (tag "hard")
    (title "problem2"))'
```

Below is an example of creating a note interactively in the './example' folder.
```bash
a create example
```

Below is an example of interactively renaming the note './example/aa'.
```bash
a rename example/aa
```

Below is an example of interactively filtering notes in the './example' directory recursively, followed by printing the path associated with each note.
```bash
a query -r example
```

Below is an example of filtering notes in the './example' directory recursively using ql code in the './example/dsa.ql' file, followed by editing the path associated with each note.

```bash
a query -r example -f example/dsa.ql edit
```

## Conclusion

I really enjoyed designing and building my own tool, the most challenging part was, of course, writing the query language, whether it was the grammar rules, the parsing, or the bytecode virtual machine. The goal is to use it for following my progress on DSA problems.