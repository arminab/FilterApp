//
//  Filters.swift
//  FilterApp
//
//  Created by Armin on 5/22/16.
//  Copyright © 2016 Armin. All rights reserved.
//

import Foundation
import UIKit


class Filter{
    var image: UIImage?
    
    
    func constrast(modifier: Int) ->RGBAImage{
        var rgba = RGBAImage(image: self.image!)!
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for y in 0..<rgba.height{
            for x in 0..<rgba.width{
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                
                totalBlue += Int(pixel.blue)
                totalGreen += Int(pixel.green)
                totalRed += Int(pixel.red)
                rgba.pixels[index] = pixel
            }
        }
 
        let pixelCount = rgba.width * rgba.height
        let avgRed = totalRed / pixelCount
        let avgBlue = totalBlue / pixelCount
        let avgGreen = totalGreen / pixelCount
        let sum = avgBlue + avgGreen + avgRed
        
        for y in 00..<rgba.height{
            for x in 0..<rgba.width{
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                let modify = Int(modifier)
                
                if (Int(pixel.red) + Int(pixel.blue) + Int(pixel.green) < sum){
                    let redDelta = Int(pixel.red) - avgRed
                    let blueDelta = Int(pixel.blue) - avgBlue
                    let greenDelta = Int(pixel.green) - avgGreen
                    pixel.blue = UInt8(max(min(255,avgBlue + modify * blueDelta),0))
                    pixel.green = UInt8(max(min(255,avgGreen + modify * greenDelta),0))
                    pixel.red = UInt8(max(min(255,avgRed + modify * redDelta),0))
                    rgba.pixels[index] = pixel
                }
                
            }
        }
        
        return rgba
    }
    
    func grayscale()->RGBAImage{
        var rgba = RGBAImage(image: self.image!)!
        for y in 0..<rgba.height{
            for x in 0..<rgba.width{
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                let avg = UInt8((Double(pixel.blue) + Double(pixel.green) + Double(pixel.red))/3.0)
                pixel.blue = avg
                pixel.green = avg
                pixel.red = avg
                rgba.pixels[index] = pixel
            }
        }
        return rgba
    }
    
    func brightness(brightness: Int) -> RGBAImage{
        var rgba = RGBAImage(image: self.image!)!
        for y in 0..<rgba.height{
            for x in 0..<rgba.width{
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                pixel.blue = UInt8(max(min(255,brightness + Int(pixel.blue)),0))
                pixel.green = UInt8(max(min(255,brightness + Int(pixel.green)),0))
                pixel.red = UInt8(max(min(255,brightness + Int(pixel.red)),0))
                rgba.pixels[index] = pixel
            }
        }
        return rgba
    }
    func colorInversion() -> RGBAImage{
        var rgba = RGBAImage(image: self.image!)!
        for y in 0..<rgba.height{
            for x in 0..<rgba.width{
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                pixel.blue = UInt8(255 - pixel.blue)
                pixel.green = UInt8(255 - pixel.green)
                pixel.red = UInt8(255 - pixel.red)
                rgba.pixels[index] = pixel
            }
        }
        return rgba
    }
    
    func threshold(threshold:Int)-> RGBAImage{
        var rgba = RGBAImage(image: self.image!)!
        for y in 0..<rgba.height{
            for x in 0..<rgba.width{
                let index = y * rgba.width + x
                var pixel = rgba.pixels[index]
                if (UInt8((UInt8(Float(pixel.blue) * 0.0722) + UInt8(Float(pixel.green) * 0.7152) + UInt8(Float(pixel.red) * 0.2126))) >= UInt8(threshold)){
                    pixel.blue = 255
                    pixel.green = 255
                    pixel.red = 255
                } else {
                    pixel.blue = 0
                    pixel.green = 0
                    pixel.red = 0
                }
                
                rgba.pixels[index] = pixel
            }
        }
        return rgba
    }
}
