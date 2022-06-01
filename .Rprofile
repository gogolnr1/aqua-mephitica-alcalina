output_dir <- "./output"
options(tinytex.verbose = TRUE)
options(tinytex.clean = FALSE)
options(tinytex.output_dir = output_dir)
options(tinytex.engine_args = sprintf("'--output-directory=%s'", output_dir))

tinytex::latexmk("tex/preface.tex")
tinytex::latexmk("tex/transcription.tex")
tinytex::latexmk("tex/synopsis.tex")
tinytex::latexmk("tex/_bundle.tex")
