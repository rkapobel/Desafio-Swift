//
//  UIImageExtended.swift
//  DesafioSwift
//
//  Created by Marcelo De Luca on 21/2/17.
//  Copyright © 2017 Rodrigo Kapobel. All rights reserved.
//

import UIKit

class UIImageExtended: UIImage {
    
    func saveImage(imageData: NSData, withImageName imageName: String, inFolder folderName: String) {
    
        let path: String = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].path
        
        let imagesPath: String = path + "\(folderName)"
        
        var isDir: ObjCBool = ObjCBool(booleanLiteral: false)
        
        if FileManager.default.fileExists(atPath: imagesPath, isDirectory:&isDir) && isDir.boolValue == true {
            do {
                try  FileManager.default.createDirectory(atPath: imagesPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
        
        let filePath: String = imagesPath + "\(imageName)"
    
        do {
            try imageData.write(toFile: filePath, options: NSData.WritingOptions.atomic)
        } catch let error as NSError {
            print("Error moving file: \(error.localizedDescription)")
        }
    }
    
    func deleteImages(fromFolder folderName: String) {
        let path: String = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].path
        
        let imagesPath: String = path + "\(folderName)"
        
        let en: FileManager.DirectoryEnumerator? = FileManager.default.enumerator(atPath: imagesPath)
        
        while let file: String = en?.nextObject() as! String? {
            do {
                try FileManager.default.removeItem(atPath: file)
            } catch let error as NSError {
                print("Error deleting file: \(error.localizedDescription)")
            }
        }
    }

}

/*
 
 + (void)deleteImagesFromFolder:(NSString *)folderName {
 NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
 NSURL *cachesDirectory = [paths objectAtIndex:0];
 NSString *imagesPath = [[cachesDirectory path] stringByAppendingFormat:@"/%@/%@", IMAGES_FOLDER, folderName];
 
 NSFileManager *fm = [NSFileManager defaultManager];
 NSDirectoryEnumerator* en = [fm enumeratorAtPath:imagesPath];
 NSError* err = nil;
 BOOL res;
 
 NSString* file;
 while (file = [en nextObject]) {
 res = [fm removeItemAtPath:[imagesPath stringByAppendingPathComponent:file] error:&err];
 if (!res && err) {
 LogError(err);
 }
 }
 }
 
 + (void)deleteImage:(NSString *)imageName fromFolder:(NSString *)folderName {
 NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
 NSURL *cachesDirectory = [paths objectAtIndex:0];
 NSString *imagePath = [[cachesDirectory path] stringByAppendingFormat:@"/%@/%@/%@", IMAGES_FOLDER, folderName, imageName];
 
 if (imagePath) {
 if ([[NSFileManager defaultManager] fileExistsAtPath:[imagePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]]) {
 NSError* err = nil;
 [[NSFileManager defaultManager] removeItemAtPath:[imagePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]] error:&err];
 LogError(err);
 }
 }
 }
 
 + (UIImage *)getImage:(NSString *)imageName inFolder:(NSString *)folderName {
 NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
 NSURL *cachesDirectory = [paths objectAtIndex:0];
 NSString *imagePath = [[cachesDirectory path] stringByAppendingFormat:@"/%@/%@/%@", IMAGES_FOLDER, folderName, imageName];
 
 NSURL *url = [NSURL URLWithString:[imagePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
 NSData *data = [NSData dataWithContentsOfFile:[url path]];
 
 UIImage *image = [UIImage imageWithData:data];
 
 return image;
 }
 
 
 + (NSString *)getImageStringRepresentation:(NSString *)imageName inFolder:(NSString *)folderName {
 NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
 NSURL *cachesDirectory = [paths objectAtIndex:0];
 NSString *imagePath = [[cachesDirectory path] stringByAppendingFormat:@"/%@/%@/%@", IMAGES_FOLDER, folderName, imageName];
 
 NSURL *url = [NSURL URLWithString:[imagePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
 NSData *data = [NSData dataWithContentsOfFile:[url path]];
 NSString *image = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
 
 return image;
 }
 
*/
