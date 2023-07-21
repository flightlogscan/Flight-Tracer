struct FieldNameConverter {
    
    let joshExampleToMFB = [
        "DATE": "Date",
        "AIRCRAFT IDENT": "Tail Number",
        "AIRCRAFT MAKE AND MODEL": "Model",
        "TOTAL DURATION OF FLIGHT": "Total Flight Time",
        "NO": "Approaches",
        "LNDGS": "Landings",
        "DAY": "FS Day Landings",
        "NIGHT_LNDGS": "FS Night Landings",
        "CROSS COUNTRY": "X-Country",
        "NIGHT": "Night",
        "ACTUAL INSTRUMENT": "IMC",
        "SIMULATED INSTRUMENT (HOOD)": "Simulated Instrument",
        "DUAL RECEIVED": "Dual Received",
        "AS FLIGHT INSTRUCTOR": "CFI",
        "SECOND IN COMMAND": "SIC",
        "PILOT IN COMMAND": "PIC",
        "ROUTE OF FLIGHT": "Route",
        "TO": "To",
        "FROM": "From",
        "REMARKS AND ENDORSEMENTS": "Comments",
        "TYPE": "Approach Name(s)",
        "SOLO": "Solo Time"
    ]
    
    func convertFieldName(detectedFieldName: String) -> String {
        
        let je = joshExampleToMFB[detectedFieldName]!
        print("je \(je)")
        return joshExampleToMFB[detectedFieldName]!
    }
}
