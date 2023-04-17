//
//  TextView.swift
//   Tab for Displaying and saving text
//
//  Created by Jeff Terry on 1/23/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct TextView: View {
    
    @EnvironmentObject var plotData :PlotClass
    
    @State  var document: TextExportDocument = TextExportDocument(message: "")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State var textSelectorString = "0"
    @State var textSelector = 0
    
    var body: some View {
        
        VStack{
            TextEditor(text: $plotData.plotArray[textSelector].calculatedText )
            
            HStack{
                
                Button("Save", action: {
                    isExporting = false
                    document.message = plotData.plotArray[textSelector].calculatedText
                    //fix broken picker sheet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isExporting = true
                    }
                    
                })
                    .padding()
                Button("Load", action: {
                    isImporting = false
                    
                    //fix broken picker sheet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isImporting = true
                    }
                })
                    .padding()
                
            }
            
            TextField("Text Selector", text: $textSelectorString,    onCommit: {self.textSelector = Int(textSelectorString)!})
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                
                //trying to get access to url contents
                if (CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL)) {
                    
                    
                    
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    
                    document.message = message
                    
                    plotData.plotArray[0].calculatedText = message
                        
                    //done accessing the url
                    CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                }
                else {
                    print("Permission error!")
                }
            } catch {
                // Handle failure.
                print(error.localizedDescription)
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: UTType.plainText,
            defaultFilename: "RawData"
        ) { result in
            if case .success = result {
                // Handle success.
            } else {
                // Handle failure.
            }
        }
        
        
        
    }
    
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
