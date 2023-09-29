rm(list = ls())
require(logger)
f <- function() {
    result <- tryCatch(
        expr = {
            stop("foo")
        },
        error = function(e) {
            print(class(e))
            print("-----------------")
            log_error(e$message)
            print("-----------------")
            print("error, retunring NULL")
            return(NULL)
        },
        warning = function(w) {
            log_warn(str(w))
            print("warning, retunring NULL")
            return(NULL)
        },
        finally = {
            # what gets returned here?
        }
    )
    return(result)
}
logFile<-"error.log"
file.remove(logFile)
log_appender(appender_file(logFile))
f()
