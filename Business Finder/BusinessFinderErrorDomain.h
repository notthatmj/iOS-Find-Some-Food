//
//  BusinessFinderErrorDomain.h
//  Business Finder
//
//  Created by Michael Johnson on 9/28/16.
//  Copyright © 2016 Michael Johnson. All rights reserved.
//

extern NSString *const kBusinessFinderErrorDomain;

typedef NS_ENUM(NSInteger, BusinessesDataControllerError) {
    kBusinessesDataControllerErrorLocation=0,
    kBusinessesDataControllerErrorLocationPermissionDenied,
    kBusinessesDataControllerErrorServer
};

