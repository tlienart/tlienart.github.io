using JuDoc

# this is needed for a "clean exit" when running from outside REPL.
ccall(:jl_exit_on_sigint, Void, (Cint,), 0)

curdir = @__DIR__
FOLDER_PATH = (typeof(curdir)==Void) ? pwd() : curdir

judoc()
#judoc(single_pass=false)
