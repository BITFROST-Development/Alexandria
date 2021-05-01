//
//  InputStreamReader.swift
//  Alexandria
//
//  Created by Waynar Bocangel Calderon on 3/31/21.
//  Copyright © 2021 BITFROST. All rights reserved.
//

import Foundation

public class InputStreamReader {
   public let path: String

   fileprivate let file: UnsafeMutablePointer<FILE>!

   init?(path: String) {
	  self.path = path
	  file = fopen(path, "r")
	  guard file != nil else { return nil }
   }

   public var nextLine: String? {
	  var line:UnsafeMutablePointer<CChar>? = nil
	  var linecap:Int = 0
	  defer { free(line) }
	  return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
   }

   deinit {
	  fclose(file)
   }
}

extension InputStreamReader: Sequence {
   public func  makeIterator() -> AnyIterator<String> {
	  return AnyIterator<String> {
		 return self.nextLine
	  }
   }
}
