enum ErrorCode: String {
    case SERVER_ERROR = "Something went wrong with the server, please re-scan the file"
    case INVALID_REQUEST = "Something went wrong with the request, please re-scan the file"
    case MAX_SIZE_EXCEEDED = "Max file size exceeded, try cropping your image"
    case NO_RECOGNIZED_TEXT = "No recognized text, try cropping your image"
    case HARDCODED_ERROR = "Something went wrong with hardcoded response"
    case LOG_DATA_NOT_FOUND = "Scan did not find log data."
    case NO_ERROR = ""
    
    var message: String {
        return self.rawValue
    }
}
 
