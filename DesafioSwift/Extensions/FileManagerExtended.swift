//
//  UIImageExtended.swift
//  DesafioSwift
//
//  Created by Rodrigo Kapobel on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit


// MARK: Esta extensión de FileManager se encarga de guardar y borrar archivos de un directorio especificado por parámetro.
// Si el directorio especificado no existe al intentar guardar, FileManager se encarga de crearlo.

extension FileManager {

    func firstPath() -> String {
        
        // MARK: No puede dar nil o vacio
        
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].path
    }
    
    func getPath(_ subDirs: String ...) -> String {
        var firstPathStr: String = firstPath()
        for dir: String in subDirs {
            firstPathStr.append("/\(dir)")
        }
        
        return firstPathStr
    }
    
    func saveFile(data fileData: Data, withFileName fileName: String, inFolder folderName: String) {
    
        let filesPath: String = getPath(folderName)
        
        var isDir: ObjCBool = ObjCBool(booleanLiteral: false)
        
        if FileManager.default.fileExists(atPath: filesPath, isDirectory:&isDir) == false {
            do {
                try FileManager.default.createDirectory(atPath: filesPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
                return
            }
        }
        
        let filePath: String = filesPath + "/\(fileName)"
        
        let url: URL? = URL(fileURLWithPath: filePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
        
        if let letUrl = url {
            do {
                try fileData.write(to: letUrl, options: NSData.WritingOptions.atomic)
            } catch let error as NSError {
                print("Error moving file: \(error.localizedDescription)")
            }
        }else {
            print("The specified directory does not exist")
        }
    }
    
    func deleteFiles(fromFolder folderName: String) {
        
        let filesPath: String = getPath(folderName)
        
        let en: FileManager.DirectoryEnumerator? = FileManager.default.enumerator(atPath: filesPath)
        
        while let file: String = en?.nextObject() as! String? {
            do {
                try FileManager.default.removeItem(atPath: file)
            } catch let error as NSError {
                print("Error deleting file: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteFile(withName fileName: String, fromFolder folderName: String) {
        
        let filePath: String = getPath(folderName, fileName)
        
        var isDir: ObjCBool = ObjCBool(booleanLiteral: false)
        
        if FileManager.default.fileExists(atPath: filePath, isDirectory:&isDir) == true {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch let error as NSError {
                print("Error deleting file: \(error.localizedDescription)")
            }
        }
    }
    
    func getData(withName fileName: String, inFolder folderName: String) -> Data? {
        let filePath: String = getPath(folderName, fileName)
        
        let url: URL? = URL(fileURLWithPath: filePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
        
        if let letUrl = url {
            
            var data: Data? = nil
            
            do {
                data = try Data(contentsOf: letUrl)
            } catch let error as NSError {
                print("Error getting data: \(error.localizedDescription)")
            }
    
            if let letData = data {
                return letData
            }
        }
        
        return nil
    }
    
    func getImage(withName fileName: String, inFolder folderName: String) -> UIImage? {
        let data: Data? = getData(withName: fileName, inFolder: folderName)
        
        if let letData = data {
            
            let image: UIImage? = UIImage(data: letData)
            
            if let letImage = image {
                return letImage
            }
            
            return nil
        }
        
        return nil
    }
}
