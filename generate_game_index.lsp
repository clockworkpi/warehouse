#!/usr/bin/env newlisp
(module "util.lsp")
(module "getopts.lsp")
(module "json.lsp")

(shortopt "d" (setq gamefolder getopts:arg) "" "game folder")
(shortopt "?" (getopts:usage) nil "Print this help message")

(getopts (2 (main-args))); parse getopt

(if (or (nil? gamefolder) (= gamefolder ""))
	(begin
		(getopts:usage)
		(exit)
	)
)

(setq files (directory gamefolder))

(setq res (list ))

(dolist (x files)
	(if (and (not (starts-with x ".")) (directory? (string gamefolder "/" x )))
		(begin
			(setq gametype (read-file (string gamefolder "/" x "/.game")))
			;(println gametype)
			(if (not (nil? gametype))
				(begin
					(setq item_list '())
					(setq _file (exec (string "raw.github.lsp " gamefolder "/'" x "'/file/*")))
					(setq _shots (exec (string "raw.github.lsp " gamefolder "/'" x "'/shots/*")))

					(setq item_list (list (list "title" x) (list "type" gametype)))
					
					(if (= (length _file) 1)
						(push (list "file" (nth 0 _file)) item_list)
						(push (list "file" _file) item_list)
					)
					(if (= (length _shots) 1)
						(push (list "shots" (nth 0 _shots)) item_list)
						(push (list "shots" _shots) item_list)
					)
					;(println item_list)
					(reverse item_list)
					(push item_list res)
				)
			)
		)
	)
)

(set 'indexjson:list res) 
(println (Json:Lisp->Json indexjson))


(exit)
