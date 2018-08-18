using JuDoc

const SINGLE_PASS = false
const FOLDER_PATH = "/Users/tlienart/Desktop/tlienart.github.io/"

if SINGLE_PASS
    JuDoc.judoc()
else
    # this is needed for a "clean exit" when running from outside REPL.
    ccall(:jl_exit_on_sigint, Nothing, (Cint,), 0)

    # curdir = normpath(joinpath(@__DIR__, "/"))
    # FOLDER_PATH = (typeof(curdir)==Void) ? pwd() : curdir



    # NOTE: works with bash, would have to be tested with other shells, we don't
    # care at this point, when other users, we'll see
    # NOTE: add a message, should go `localhost:8000`, also make this a function
    # wrapping around the JuDoc call with single_pass = false or something.
    run(`bash -c "browser-sync start -s -f $FOLDER_PATH --no-notify --logLevel silent --port 8000 --no-open &"`)

    # this is blocking, when interrupted, it also kills the background process.
    JuDoc.judoc(single_pass=false)
end
