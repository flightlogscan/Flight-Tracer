enum ErrorCode: String {
    case SERVER_ERROR = "Something went wrong with the server, please re-scan the file"
    case INVALID_REQUEST = "Something went wrong with the request, please re-scan the file"
    case MAX_SIZE_EXCEEDED = "Max size exceeded"
    case NO_RECOGNIZED_TEXT = "No recognized text"
    case HARDCODED_ERROR = "Something went wrong with hardcoded response"
    case NO_ERROR = ""
    
    var message: String {
        return self.rawValue
    }
}
