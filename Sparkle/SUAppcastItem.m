//
//  SUAppcastItem.m
//  Sparkle
//
//  Created by Andy Matuschak on 3/12/06.
//  Copyright 2006 Andy Matuschak. All rights reserved.
//

#import "SUAppcastItem.h"
#import "SUAppcastItem+Private.h"
#import "SUVersionComparisonProtocol.h"
#import "SULog.h"
#import "SUConstants.h"
#import "SUSignatures.h"
#import "SPUInstallationType.h"


#include "AppKitPrevention.h"

static NSString *SUAppcastItemDeltaUpdatesKey = @"deltaUpdates";
static NSString *SUAppcastItemDisplayVersionStringKey = @"displayVersionString";
static NSString *SUAppcastItemSignaturesKey = @"signatures";
static NSString *SUAppcastItemFileURLKey = @"fileURL";
static NSString *SUAppcastItemInfoURLKey = @"infoURL";
static NSString *SUAppcastItemContentLengthKey = @"contentLength";
static NSString *SUAppcastItemDescriptionKey = @"itemDescription";
static NSString *SUAppcastItemMaximumSystemVersionKey = @"maximumSystemVersion";
static NSString *SUAppcastItemMinimumSystemVersionKey = @"minimumSystemVersion";
static NSString *SUAppcastItemReleaseNotesURLKey = @"releaseNotesURL";
static NSString *SUAppcastItemTitleKey = @"title";
static NSString *SUAppcastItemVersionStringKey = @"versionString";
static NSString *SUAppcastItemPropertiesKey = @"propertiesDictionary";
static NSString *SUAppcastItemInstallationTypeKey = @"SUAppcastItemInstallationType";

@implementation SUAppcastItem

@synthesize dateString = _dateString;
@synthesize deltaUpdates = _deltaUpdates;
@synthesize displayVersionString = _displayVersionString;
@synthesize signatures = _signatures;
@synthesize fileURL = _fileURL;
@synthesize contentLength = _contentLength;
@synthesize infoURL = _infoURL;
@synthesize itemDescription = _itemDescription;
@synthesize maximumSystemVersion = _maximumSystemVersion;
@synthesize minimumSystemVersion = _minimumSystemVersion;
@synthesize releaseNotesURL = _releaseNotesURL;
@synthesize title = _title;
@synthesize versionString = _versionString;
@synthesize osString = _osString;
@synthesize propertiesDictionary = _propertiesDictionary;
@synthesize installationType = _installationType;
@synthesize minimumAutoupdateVersion = _minimumAutoupdateVersion;
@synthesize phasedRolloutInterval = _phasedRolloutInterval;

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self != nil) {
        _deltaUpdates = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSDictionary class], [SUAppcastItem class]]] forKey:SUAppcastItemDeltaUpdatesKey];
        _displayVersionString = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemDisplayVersionStringKey] copy];
        _signatures = (SUSignatures *)[decoder decodeObjectOfClass:[SUSignatures class] forKey:SUAppcastItemSignaturesKey];
        _fileURL = [decoder decodeObjectOfClass:[NSURL class] forKey:SUAppcastItemFileURLKey];
        _infoURL = [decoder decodeObjectOfClass:[NSURL class] forKey:SUAppcastItemInfoURLKey];
        
        if (_fileURL == nil && _infoURL == nil) {
            return nil;
        }
        
        _contentLength = (uint64_t)[decoder decodeInt64ForKey:SUAppcastItemContentLengthKey];
        
        NSString *installationType = [decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemInstallationTypeKey];
        if (!SPUValidInstallationType(installationType)) {
            return nil;
        }
        
        _installationType = [installationType copy];
        
        _itemDescription = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemDescriptionKey] copy];
        _maximumSystemVersion = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemMaximumSystemVersionKey] copy];
        _minimumSystemVersion = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemMinimumSystemVersionKey] copy];
        _minimumAutoupdateVersion = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastElementMinimumAutoupdateVersion] copy];
        _releaseNotesURL = [decoder decodeObjectOfClass:[NSURL class] forKey:SUAppcastItemReleaseNotesURLKey];
        _title = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemTitleKey] copy];
        
        NSString *versionString =  [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastItemVersionStringKey] copy];
        if (versionString == nil) {
            return nil;
        }
        
        _versionString = versionString;
        
        _osString = [(NSString *)[decoder decodeObjectOfClass:[NSString class] forKey:SUAppcastAttributeOsType] copy];
        
        NSDictionary *propertiesDictionary = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[[NSDictionary class], [NSString class], [NSDate class], [NSArray class]]] forKey:SUAppcastItemPropertiesKey];
        if (propertiesDictionary == nil) {
            return nil;
        }
        
        _propertiesDictionary = propertiesDictionary;
        
        _phasedRolloutInterval = [decoder decodeObjectOfClass:[NSNumber class] forKey:SUAppcastElementPhasedRolloutInterval];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if (self.deltaUpdates != nil) {
        [encoder encodeObject:self.deltaUpdates forKey:SUAppcastItemDeltaUpdatesKey];
    }
    
    if (self.displayVersionString != nil) {
        [encoder encodeObject:self.displayVersionString forKey:SUAppcastItemDisplayVersionStringKey];
    }
    
    if (self.signatures != nil) {
        [encoder encodeObject:self.signatures forKey:SUAppcastItemSignaturesKey];
    }
    
    if (self.fileURL != nil) {
        [encoder encodeObject:self.fileURL forKey:SUAppcastItemFileURLKey];
    }
    
    if (self.infoURL != nil) {
        [encoder encodeObject:self.infoURL forKey:SUAppcastItemInfoURLKey];
    }
    
    [encoder encodeInt64:(int64_t)self.contentLength forKey:SUAppcastItemContentLengthKey];
    
    if (self.itemDescription != nil) {
        [encoder encodeObject:self.itemDescription forKey:SUAppcastItemDescriptionKey];
    }
    
    if (self.maximumSystemVersion != nil) {
        [encoder encodeObject:self.maximumSystemVersion forKey:SUAppcastItemMaximumSystemVersionKey];
    }
    
    if (self.minimumSystemVersion != nil) {
        [encoder encodeObject:self.minimumSystemVersion forKey:SUAppcastItemMinimumSystemVersionKey];
    }
    
    if (self.minimumAutoupdateVersion != nil) {
        [encoder encodeObject:self.minimumAutoupdateVersion forKey:SUAppcastElementMinimumAutoupdateVersion];
    }
    
    if (self.releaseNotesURL != nil) {
        [encoder encodeObject:self.releaseNotesURL forKey:SUAppcastItemReleaseNotesURLKey];
    }
    
    if (self.title != nil) {
        [encoder encodeObject:self.title forKey:SUAppcastItemTitleKey];
    }
    
    if (self.versionString != nil) {
        [encoder encodeObject:self.versionString forKey:SUAppcastItemVersionStringKey];
    }
    
    if (self.osString != nil) {
        [encoder encodeObject:self.osString forKey:SUAppcastAttributeOsType];
    }
    
    if (self.propertiesDictionary != nil) {
        [encoder encodeObject:self.propertiesDictionary forKey:SUAppcastItemPropertiesKey];
    }
    
    if (self.installationType != nil) {
        [encoder encodeObject:self.installationType forKey:SUAppcastItemInstallationTypeKey];
    }
    
    if (self.phasedRolloutInterval != nil) {
        [encoder encodeObject:self.phasedRolloutInterval forKey:SUAppcastElementPhasedRolloutInterval];
    }
}

- (BOOL)isDeltaUpdate
{
    NSDictionary *rssElementEnclosure = [self.propertiesDictionary objectForKey:SURSSElementEnclosure];
    return [rssElementEnclosure objectForKey:SUAppcastAttributeDeltaFrom] != nil;
}

- (BOOL)isCriticalUpdate
{
    return [(NSArray *)[self.propertiesDictionary objectForKey:SUAppcastElementTags] containsObject:SUAppcastElementCriticalUpdate];
}

- (BOOL)isMacOsUpdate
{
    return self.osString == nil || [self.osString isEqualToString:SUAppcastAttributeValueMacOS];
}

- (NSDate *)date
{
    NSString *dateString = self.dateString;
    if (dateString == nil) {
        return nil;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"E, dd MMM yyyy HH:mm:ss Z";
    
    return [dateFormatter dateFromString:dateString];
}

- (BOOL)isInformationOnlyUpdate
{
    return self.infoURL && !self.fileURL;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    return [self initWithDictionary:dict relativeToURL:nil failureReason:nil];
}

- (nullable instancetype)initWithDictionary:(NSDictionary *)dict relativeToURL:(NSURL * _Nullable)appcastURL failureReason:(NSString *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        NSDictionary *enclosure = [dict objectForKey:SURSSElementEnclosure];

        // Try to find a version string.
        // Finding the new version number from the RSS feed is a little bit hacky. There are two ways:
        // 1. A "sparkle:version" attribute on the enclosure tag, an extension from the RSS spec.
        // 2. If there isn't a version attribute, Sparkle will parse the path in the enclosure, expecting
        //    that it will look like this: http://something.com/YourApp_0.5.zip. It'll read whatever's between the last
        //    underscore and the last period as the version number. So name your packages like this: APPNAME_VERSION.extension.
        //    The big caveat with this is that you can't have underscores in your version strings, as that'll confuse Sparkle.
        //    Feel free to change the separator string to a hyphen or something more suited to your needs if you like.
        NSString *newVersion = [enclosure objectForKey:SUAppcastAttributeVersion];
        if (newVersion == nil) {
            newVersion = [dict objectForKey:SUAppcastAttributeVersion]; // Get version from the item, in case it's a download-less item (i.e. paid upgrade).
        }
        if (newVersion == nil) // no sparkle:version attribute anywhere?
        {
            SULog(SULogLevelError, @"warning: <%@> for URL '%@' is missing %@ attribute. Version comparison may be unreliable. Please always specify %@", SURSSElementEnclosure, [enclosure objectForKey:SURSSAttributeURL], SUAppcastAttributeVersion, SUAppcastAttributeVersion);

            // Separate the url by underscores and take the last component, as that'll be closest to the end,
            // then we remove the extension. Hopefully, this will be the version.
            NSArray<NSString *> *fileComponents = [(NSString *)[enclosure objectForKey:SURSSAttributeURL] componentsSeparatedByString:@"_"];
            if ([fileComponents count] > 1) {
                newVersion = [[fileComponents lastObject] stringByDeletingPathExtension];
            }
        }

        if (!newVersion) {
            if (error) {
                *error = [NSString stringWithFormat:@"Feed item lacks %@ attribute, and version couldn't be deduced from file name (would have used last component of a file name like AppName_1.3.4.zip)", SUAppcastAttributeVersion];
            }
            return nil;
        }

        _propertiesDictionary = [[NSDictionary alloc] initWithDictionary:dict];
        _title = [(NSString *)[dict objectForKey:SURSSElementTitle] copy];
        _dateString = [(NSString *)[dict objectForKey:SURSSElementPubDate] copy];
        _itemDescription = [(NSString *)[dict objectForKey:SURSSElementDescription] copy];

        NSString *theInfoURL = [dict objectForKey:SURSSElementLink];
        if (theInfoURL) {
            if (![theInfoURL isKindOfClass:[NSString class]]) {
                SULog(SULogLevelError, @"%@ -%@ Info URL is not of valid type.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            } else {
                if (appcastURL != nil) {
                    _infoURL = [NSURL URLWithString:theInfoURL relativeToURL:appcastURL];
                } else {
                    _infoURL = [NSURL URLWithString:theInfoURL];
                }
            }
        }

        // Need an info URL or an enclosure URL. Former to show "More Info"
        //	page, latter to download & install:
        if (!enclosure && !theInfoURL) {
            if (error) {
                *error = @"No enclosure in feed item";
            }
            return nil;
        }

        NSString *enclosureURLString = [enclosure objectForKey:SURSSAttributeURL];
        if (!enclosureURLString && !theInfoURL) {
            if (error) {
                *error = @"Feed item's enclosure lacks URL";
            }
            return nil;
        }
        
        if (enclosureURLString) {
            NSString *enclosureLengthString = [enclosure objectForKey:SURSSAttributeLength];
            long long contentLength = 0;
            if (enclosureLengthString != nil) {
                contentLength = [enclosureLengthString longLongValue];
            }
            _contentLength = (contentLength > 0) ? (uint64_t)contentLength : 0;
        }

        if (enclosureURLString) {
            // Sparkle used to always URL-encode, so for backwards compatibility spaces in URLs must be forgiven.
            NSString *fileURLString = [enclosureURLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            if (appcastURL != nil) {
                _fileURL = [NSURL URLWithString:fileURLString relativeToURL:appcastURL];
            } else {
                _fileURL = [NSURL URLWithString:fileURLString];
            }
        }
        if (enclosure) {
            _signatures = [[SUSignatures alloc] initWithDsa:[enclosure objectForKey:SUAppcastAttributeDSASignature] ed:[enclosure objectForKey:SUAppcastAttributeEDSignature]];
            _osString = [enclosure objectForKey:SUAppcastAttributeOsType];
        }

        _versionString = [(NSString *)newVersion copy];
        _minimumSystemVersion = [(NSString *)[dict objectForKey:SUAppcastElementMinimumSystemVersion] copy];
        _maximumSystemVersion = [(NSString *)[dict objectForKey:SUAppcastElementMaximumSystemVersion] copy];
        _minimumAutoupdateVersion = [(NSString *)[dict objectForKey:SUAppcastElementMinimumAutoupdateVersion] copy];
        
        NSString* rolloutIntervalString = [(NSString *)[dict objectForKey:SUAppcastElementPhasedRolloutInterval] copy];
        if (rolloutIntervalString != nil) {
            _phasedRolloutInterval = @(rolloutIntervalString.integerValue);
        }

        NSString *shortVersionString = [enclosure objectForKey:SUAppcastAttributeShortVersionString];
        if (nil == shortVersionString) {
            shortVersionString = [dict objectForKey:SUAppcastAttributeShortVersionString]; // fall back on the <item>
        }

        if (shortVersionString) {
            _displayVersionString = [shortVersionString copy];
        } else {
            _displayVersionString = [_versionString copy];
        }
        
        NSString *attributeInstallationType = [enclosure objectForKey:SUAppcastAttributeInstallationType];
        NSString *chosenInstallationType;
        if (attributeInstallationType == nil) {
            // If we have a flat package, assume installation type is guided
            // (flat / non-archived interactive packages are not supported)
            // Otherwise assume we have a normal application inside an archive
            if ([_fileURL.pathExtension isEqualToString:@"pkg"] || [_fileURL.pathExtension isEqualToString:@"mpkg"]) {
                chosenInstallationType = SPUInstallationTypeGuidedPackage;
            } else {
                chosenInstallationType = SPUInstallationTypeApplication;
            }
        } else if (!SPUValidInstallationType(attributeInstallationType)) {
            if (error != NULL) {
                *error = [NSString stringWithFormat:@"Feed item's enclosure lacks valid %@ (found %@)", SUAppcastAttributeInstallationType, attributeInstallationType];
            }
            return nil;
        } else if ([attributeInstallationType isEqualToString:SPUInstallationTypeInteractivePackage]) {
            SULog(SULogLevelDefault, @"warning: '%@' for %@ is deprecated. Use '%@' instead.", SPUInstallationTypeInteractivePackage, SUAppcastAttributeInstallationType, SPUInstallationTypeGuidedPackage);
            
            chosenInstallationType = attributeInstallationType;
        } else {
            chosenInstallationType = attributeInstallationType;
        }
        
        _installationType = [chosenInstallationType copy];

        // Find the appropriate release notes URL.
        NSString *releaseNotesString = [dict objectForKey:SUAppcastElementReleaseNotesLink];
        if (releaseNotesString) {
            NSURL *url;
            if (appcastURL != nil) {
                url = [NSURL URLWithString:releaseNotesString relativeToURL:appcastURL];
            } else {
                url = [NSURL URLWithString:releaseNotesString];
            }
            if ([url isFileURL]) {
                SULog(SULogLevelError, @"Release notes with file:// URLs are not supported");
            } else {
                _releaseNotesURL = url;
            }
        } else if ([self.itemDescription hasPrefix:@"http://"] || [self.itemDescription hasPrefix:@"https://"]) { // if the description starts with http:// or https:// use that.
            _releaseNotesURL = [NSURL URLWithString:(NSString * _Nonnull)self.itemDescription];
        } else {
            _releaseNotesURL = nil;
        }

        NSArray *deltaDictionaries = [dict objectForKey:SUAppcastElementDeltas];
        if (deltaDictionaries) {
            NSMutableDictionary *deltas = [NSMutableDictionary dictionary];
            for (NSDictionary *deltaDictionary in deltaDictionaries) {
                NSString *deltaFrom = [deltaDictionary objectForKey:SUAppcastAttributeDeltaFrom];
                if (!deltaFrom) continue;

                NSMutableDictionary *fakeAppCastDict = [dict mutableCopy];
                [fakeAppCastDict removeObjectForKey:SUAppcastElementDeltas];
                [fakeAppCastDict setObject:deltaDictionary forKey:SURSSElementEnclosure];
                SUAppcastItem *deltaItem = [[SUAppcastItem alloc] initWithDictionary:fakeAppCastDict];

                if (deltaItem != nil) {
                    [deltas setObject:deltaItem forKey:deltaFrom];
                }
            }
            _deltaUpdates = deltas;
        }
    }
    return self;
}

@end
