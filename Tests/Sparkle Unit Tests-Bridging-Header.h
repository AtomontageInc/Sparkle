//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "SUUnarchiver.h"
#import "SUUnarchiverProtocol.h"
#import "SUBinaryDeltaUnarchiver.h"
#import "SUPipedUnarchiver.h"
#import "SUBinaryDeltaCommon.h"
#import "SUFileManager.h"
#import "SUExport.h"
#import "SUAppcast.h"
#import "SUAppcast+Private.h"
#import "SUAppcastItem.h"
#import "SUAppcastDriver.h"
#import "SUVersionComparisonProtocol.h"
#import "SUStandardVersionComparator.h"
#import "SUUpdateValidator.h"
#import "SUHost.h"
#import "SUSignatures.h"
#import "SPUInstallationType.h"

NS_ASSUME_NONNULL_BEGIN

// Duplicated to avoid exporting a private symbol from SUFileManager
static const char *SUAppleQuarantineIdentifier = "com.apple.quarantine";

@interface SUFileManager (Private)

- (BOOL)_acquireAuthorizationWithError:(NSError *_Nullable __autoreleasing *_Nullable)error;

- (BOOL)_itemExistsAtURL:(NSURL *)fileURL;
- (BOOL)_itemExistsAtURL:(NSURL *)fileURL isDirectory:(nullable BOOL *)isDirectory;

@end

@interface SUAppcastDriver (Private)

+ (SUAppcastItem *)bestItemFromAppcastItems:(NSArray *)appcastItems getDeltaItem:(SUAppcastItem *_Nullable __autoreleasing *_Nullable)deltaItem withHostVersion:(NSString *)hostVersion comparator:(id<SUVersionComparison>)comparator;

+ (SUAppcast *)filterSupportedAppcast:(SUAppcast *)appcast phasedUpdateGroup:(NSNumber * _Nullable)phasedUpdateGroup skippedVersion:(NSString * _Nullable)skippedVersion hostVersion:(NSString * _Nullable)hostVersion versionComparator:(id<SUVersionComparison> _Nullable)versionComparator testOSVersion:(BOOL)testOSVersion testMinimumAutoupdateVersion:(BOOL)testMinimumAutoupdateVersion;

@end

@interface SUBinaryDeltaUnarchiver (Private)

+ (void)updateSpotlightImportersAtBundlePath:(NSString *)targetPath;

@end

NS_ASSUME_NONNULL_END
