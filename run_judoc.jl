using JuDoc

# this is needed for a "clean exit" when running from outside REPL.
ccall(:jl_exit_on_sigint, Void, (Cint,), 0)

FOLDER_PATH = @__DIR__

#judoc()
judoc(single_pass=false)
