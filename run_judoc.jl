using JuDoc

# this is needed for a "clean exit" when running from outside REPL.
ccall(:jl_exit_on_sigint, Void, (Cint,), 0)

# curdir = normpath(joinpath(@__DIR__, "/"))
# FOLDER_PATH = (typeof(curdir)==Void) ? pwd() : curdir

FOLDER_PATH = "/Users/tlienart/Desktop/tlienart.github.io/"

# NOTE: works with bash, would have to be tested with other shells, we don't
# care at this point, when other users, we'll see
# NOTE: add a message, should go `localhost:8000`, also make this a function
# wrapping around the JuDoc call with single_pass = false or something.
run(`bash -c "browser-sync start -s -f $FOLDER_PATH --no-notify --logLevel silent --port 8000 --no-open &"`)

# this is blocking, when interrupted, it also kills the background process.
judoc(single_pass=false)

# all done.
