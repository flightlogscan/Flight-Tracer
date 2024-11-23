enum ErrorCode: String {
    case TRANSIENT_FAILURE = "Something went wrong, please re-upload the file"
    case MAX_SIZE_EXCEEDED = "Max size exceeded"
    case NO_RECOGNIZED_TEXT = "No recognized text"
    case NO_ERROR = ""
    
    var message: String {
        return self.rawValue
    }
}
