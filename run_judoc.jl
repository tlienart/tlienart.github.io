using JuDoc

# this is needed for a "clean exit" when running from outside REPL.
ccall(:jl_exit_on_sigint, Void, (Cint,), 0)

# curdir = normpath(joinpath(@__DIR__, "/"))
# FOLDER_PATH = (typeof(curdir)==Void) ? pwd() : curdir

FOLDER_PATH = "/Users/tlienart/Desktop/tlienart.github.io/"

# try
bstask = @async begin
    try
        run(`browser-sync start -s -f "." --no-notify --logLevel silent --port 8000`)
    catch e
        if isa(e, InterruptException)
            # now find the PID of the node process and kill it
            pid = readstring(pipeline(`ps -el`, `grep browser-sync`, `grep node`))
            # this returns something with the second number being the PID (1718 here)
            # "  501  1718  1717 (...) node /usr/local/bin/browser-sync start -s -f . (...)
            # so we can retrieve that number and kill
            run(`kill $(split(pid)[2])`)
        else
            rethrow(e)
        end
   end
end

# this is blocking
judoc(single_pass=false)

# all done.
