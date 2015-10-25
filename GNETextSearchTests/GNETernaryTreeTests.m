//
//  GNETrieTests.m
//  GNETextSearch
//
//  Created by Anthony Drendel on 8/31/15.
//  Copyright © 2015 Gone East LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GNETernaryTree.h"


// ------------------------------------------------------------------------------------------


// Private function implemented in GNETernaryTree.
int _GNETernaryTreeIncreaseCharBuffer(char **outBuffer, size_t *outBufferLength, size_t amount);


// ------------------------------------------------------------------------------------------


@interface GNETernaryTreeTests : XCTestCase
{
    GNETernaryTreePtr _treePtr;
}

@end


// ------------------------------------------------------------------------------------------


@implementation GNETernaryTreeTests


// ------------------------------------------------------------------------------------------
#pragma mark - Set Up / Tear Down
// ------------------------------------------------------------------------------------------
- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    GNETernaryTreeDestroy(_treePtr);
    _treePtr = NULL;
    [super tearDown];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Search Tests
// ------------------------------------------------------------------------------------------
- (void)testSearch_AddOneWord_CanFind
{
    NSString *word = @"Anthony";
    XCTAssertNoThrow([self insertWords:@[word] intoTree:&_treePtr]);
    GNEIntegerArrayPtr result = GNETernaryTreeSearch(_treePtr, word.UTF8String);
    XCTAssertTrue(result != NULL);
    XCTAssertEqual((size_t)1, GNEIntegerArrayGetCount(result));
    XCTAssertEqual((size_t)word.hash, GNEIntegerArrayGetIntegerAtIndex(result, 0));
    XCTAssertEqual(NULL, GNETernaryTreeSearch(_treePtr, @"anthony".UTF8String));
    [self assertResultsInTree:_treePtr equalWords:@[word]];
}


- (void)testSearch_AddTwoWords_CanFind
{
    NSArray *words = @[@"Ant", @"Awe"];
    XCTAssertNoThrow([self insertWords:words intoTree:&_treePtr]);
    [self assertCanFindWords:words inTree:_treePtr];
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"ant".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"awe".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"An".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"Aw".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"A".UTF8String));
    [self assertResultsInTree:_treePtr equalWords:words];
}


- (void)testSearch_AddTwoWordsReversed_CanFind
{
    NSArray *words = @[@"Awe", @"Ant"];
    XCTAssertNoThrow([self insertWords:words intoTree:&_treePtr]);
    [self assertCanFindWords:words inTree:_treePtr];
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"ant".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"awe".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"An".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"Aw".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"A".UTF8String));
    [self assertResultsInTree:_treePtr equalWords:@[@"Ant", @"Awe"]];
}


- (void)testSearch_AddThreeWords_CanFind
{
    NSArray *words = @[@"anthony", @"awesome", @"awful"];
    NSArray *randomizedWords = [self randomizeWords:words];
    XCTAssertNoThrow([self insertWords:randomizedWords intoTree:&_treePtr]);
    [self assertCanFindWords:words inTree:_treePtr];
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"Anthony".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"ant".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"awe".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"an".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"aw".UTF8String));
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"a".UTF8String));
    [self assertResultsInTree:_treePtr equalWords:words];
}


- (void)testSearch_Add12Words_CanFind
{
    NSArray *words = @[@"as", @"at", @"be", @"by", @"he", @"in",
                       @"is", @"it", @"of", @"on", @"or", @"to"];
    NSArray *randomizedWords = [self randomizeWords:words];
    XCTAssertNoThrow([self insertWords:randomizedWords intoTree:&_treePtr]);
    [self assertCanFindWords:words inTree:_treePtr];
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"ax".UTF8String));
    [self assertResultsInTree:_treePtr equalWords:words];
}


- (void)testSearch_AddEmoji_CanFind
{
    NSString *word = @"👌";
    XCTAssertNoThrow([self insertWords:@[word] intoTree:&_treePtr]);
    XCTAssertTrue(NULL != GNETernaryTreeSearch(_treePtr, word.UTF8String));
    [self assertResultsInTree:_treePtr equalWords:@[word]];
}


- (void)testSearch_LMN_CanFind
{
    NSArray *words = [self wordsBeginningWithLMN];
    NSArray *randomizedWords = [self randomizeWords:words];
    XCTAssertNoThrow([self insertWords:randomizedWords intoTree:&_treePtr]);
    [self assertCanFindWords:words inTree:_treePtr];
    XCTAssertTrue(NULL == GNETernaryTreeSearch(_treePtr, @"magicia".UTF8String));
    [self assertResultsInTree:_treePtr equalWords:words];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Private Tests
// ------------------------------------------------------------------------------------------
- (void)testIncreaseCharBuffer_NullBufferPointer_ReturnsNullBufferAnd0Length
{
    size_t length = 100;
    XCTAssertEqual(0, _GNETernaryTreeIncreaseCharBuffer(NULL, &length, length));
    XCTAssertEqual(0, length);
}


- (void)testIncreaseCharBuffer_NullBuffer_ReturnsNullBufferAnd0Length
{
    size_t length = 100;
    char *buffer = NULL;
    XCTAssertEqual(0, _GNETernaryTreeIncreaseCharBuffer(&buffer, &length, length));
    XCTAssertTrue(buffer == NULL);
    XCTAssertEqual(0, length);
}


- (void)testIncreaseCharBuffer_NullLengthPointer_ReturnsNullBuffer
{
    size_t length = 100;
    char *buffer = malloc(length * sizeof(char));
    XCTAssertEqual(0, _GNETernaryTreeIncreaseCharBuffer(&buffer, NULL, length));
    XCTAssertTrue(buffer == NULL);
    free(buffer);
}


- (void)testIncreaseCharBuffer_DoubleBufferLength_ReturnsValidBufferAndLength
{
    size_t length = 100;
    char *buffer = malloc(length * sizeof(char));
    XCTAssertEqual(1, _GNETernaryTreeIncreaseCharBuffer(&buffer, &length, length));
    XCTAssertTrue(buffer != NULL);
    XCTAssertEqual(200, length);
    free(buffer);
}


- (void)testIncreaseCharBuffer_IncreasePastMax_ReturnsNullPointerAnd0Length
{
    size_t remainder = 10;
    size_t length = (SIZE_MAX / sizeof(char)) - remainder;
    char *buffer = malloc(1000); // Malloc fails when trying to allocate SIZE_MAX memory.
    XCTAssertEqual(0, _GNETernaryTreeIncreaseCharBuffer(&buffer, &length, remainder + 1));
    XCTAssertTrue(buffer == NULL);
    XCTAssertTrue(length == 0);
}


- (void)testIncreaseCharBuffer_AmountIsTooLarge_ReturnsNullPointerAnd0Length
{
    size_t remainder = 10;
    size_t length = (SIZE_MAX / sizeof(char)) - remainder;
    char *buffer = malloc(1000); // Malloc fails when trying to allocate SIZE_MAX memory.
    XCTAssertEqual(0, _GNETernaryTreeIncreaseCharBuffer(&buffer, &length, remainder));
    XCTAssertTrue(buffer == NULL);
    XCTAssertTrue(length == 0);
}


// ------------------------------------------------------------------------------------------
#pragma mark - Helpers
// ------------------------------------------------------------------------------------------
- (void)insertWords:(NSArray *)words intoTree:(GNETernaryTreePtr *)doublePtr
{
    if (doublePtr == NULL)
    {
        return;
    }

    GNETernaryTreePtr treePtr = *doublePtr;
    for (NSString *word in words)
    {
        treePtr = GNETernaryTreeInsert(treePtr, word.UTF8String, word.hash);
    }

    *doublePtr = treePtr;
}


- (void)assertCanFindWords:(NSArray *)words inTree:(GNETernaryTreePtr)ptr
{
    for (NSString *word in words)
    {
        GNEIntegerArrayPtr result = GNETernaryTreeSearch(ptr, word.UTF8String);
        size_t count = GNEIntegerArrayGetCount(result);
        XCTAssertTrue(count > 0);
        BOOL didFind = NO;
        for (size_t i = 0; i < count && didFind == NO; i++)
        {
            didFind = ((size_t)word.hash == GNEIntegerArrayGetIntegerAtIndex(result, i));
        }
        XCTAssertTrue(didFind);
    }
}


- (void)assertResultsInTree:(GNETernaryTreePtr)ptr equalWords:(NSArray *)words
{
    NSArray *results = [self resultsInTree:ptr];
    XCTAssertEqual(results.count, words.count);

    if (words.count != results.count) { return; }
    NSUInteger count = words.count;
    for (NSUInteger i = 0; i < count; i++)
    {
        NSString *word = words[i];
        NSString *result = results[i];
        XCTAssertTrue([word isEqualToString:result]);
    }
}


- (NSArray *)resultsInTree:(GNETernaryTreePtr)ptr
{
    NSString *resultsStr = @"";

    if (ptr == NULL)
    {
        return @[resultsStr];
    }

    char *results = NULL;
    size_t length = 0;

    if (GNETernaryTreeCopyContents(ptr, &results, &length) == 1)
    {
        NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        resultsStr = [[NSString stringWithUTF8String:results] stringByTrimmingCharactersInSet:characterSet];
    }

    free(results);

    return [resultsStr componentsSeparatedByString:@"\n"];
}


- (NSArray *)randomizeWords:(NSArray *)words
{
    NSMutableArray *mutableCopy = [NSMutableArray arrayWithArray:words];
    NSMutableArray *randomized = [NSMutableArray array];
    while (mutableCopy.count > 0)
    {
        NSUInteger count = mutableCopy.count;
        NSUInteger randomIndex = (NSUInteger)arc4random_uniform((u_int32_t)count);
        [randomized addObject:mutableCopy[randomIndex]];
        [mutableCopy removeObjectAtIndex:randomIndex];
    }

    return [randomized copy];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Word Lists
// ------------------------------------------------------------------------------------------
- (NSArray *)wordsBeginningWithLMN
{
    NSString *lmn = @"lawmaker lawsuits laxative laxities layaways layering layettes layovers laziness leaching leadings leadoffs leafiest leaflets leaguers leaguing leakages leakiest leanings leapfrog learners learning leasable leashing leathers leathery leavened leavings lebanese lecithin lecterns lectured lecturer lectures leeching leeriest leewards leftists leftmost leftover legacies legalism legalist legality legalize legatees legation leggiest leggings leghorns leisured leisures lemmings lemonade lemonier lengthen lenience leniency leninist lenities lenitive leopards leotards lesbians lessened letdowns lethargy lettered leukemia levelers leveling leverage levering levitate levities lewdness lexicons liaisons libation libelers libeling libelous liberals liberate liberian libretto licensed licensee licenser licenses lickings licorice lifeboat lifeless lifelike lifeline lifelong lifetime lifework liftoffs ligament ligature lightens lighters lightest lighting ligneous lignites ligroins likelier likeness likening likewise limbered limeades limerick limiting limonite linchpin lineages linearly linefeed linesman linesmen lingered lingerer lingerie linguini linguist liniment linkages linkings linnaean linoleum linotype linseeds lionized lionizes lipstick liqueurs listened listener listings listless litanies literacy literary literate literati lithiums litigant litigate litmuses littered littlest littoral livelier livelong livening liveried liveries loamiest loathing lobbying lobbyist lobelias loblolly lobotomy lobsters locality localize locating location locative locators lockjaws lockouts locoweed locution lodestar lodgings lodgment loftiest logbooks logicals logician logistic logotype loitered loiterer lollipop londoner lonelier lonesome longboat longbows longhair longhand longhorn longings longleaf longlegs lookouts looniest loophole loosened lopsided lordlier lordship lothario loudness lounging lousiest louvered lovebird loveless lovelier lovelies lovelorn lovesick lovingly lowbrows lowdowns lowering lowlands lowliest loyalist lozenged lozenges lucidity luckiest luckless lukewarm lumbagos lumbered luminary luminous lummoxes lumpiest lunacies lunatics luncheon lunching lunettes lungfish lurching luscious lustiest lustrous lutetium lutheran luxuries lymphoid lynching lyrebird lyricism lyricist lysergic macaques macaroni macaroon macerate machetes machined machines machismo mackerel mackinaw maddened madhouse madonnas madrases madrigal madwoman madwomen maestros magazine magcards magentas magician magnates magnesia magnetic magnetos magnolia maharani mahatmas mahjongs mahogany maidenly mailbags mailgram mailings mainland mainline mainmast mainsail mainstay maintain maintops majestic majolica majoring majority maladies malagasy malaises malamute malarial malarias malarkey malaysia maldives maleness maligned malinger mallards malmseys maltases maltoses maltreat mammoths manacled manacles managers managing manatees mandamus mandarin mandated mandates mandible mandolin mandrake mandrels mandrill maneuver manfully mangiest mangling mangrove manholes manhoods manhunts maniacal manicure manifest manifold manikins maniples manliest mannered mannerly manorial manpower mansards mansions mantilla mantises mantissa mantling manually manumits marabous marathon marauded marauder marbling marchers marching marginal margined marigold marimbas marinade marinate mariners mariposa maritime marjoram markdown markedly marketed marketer markings marksman marksmen marlines marmoset marooned marquees marquise marriage marrying marshals marshier martians martinet martinis martyred marveled marxists maryland marzipan massacre massaged massages masseurs masseuse mastered masterly masthead mastiffs mastitis mastodon mastoids matadors matchbox matching material materiel maternal matinees matrices matrixes matronly mattered mattings mattocks mattress maturate maturing maturity maunders maverick maxillae maxillar maximize maximums mayflies mazurkas mealtime meanders meanings meanness meantime measlier measured measurer measures meatball meatiest mechanic meddlers meddling mediated mediates mediator medicaid medicare medicate medicine medieval mediocre meditate medullar medullas meetings megabits megabyte megalith megatons megawatt melamine melanges melanins melanoma meldings mellitus mellowed mellower melodeon melodies meltable meltdown membrane mementos memorial memoriam memories memorize menacing menhaden meninges meniscal meniscus mentally menthols mentions mephitic mephitis merchant merciful mercuric meridian meringue meriting mermaids merriest meshwork mesoderm mesozoic mesquite messages messiest metallic metaphor metazoan meteoric metering methanes methanol methinks metonyms metonymy metrical mexicans mezuzahs michigan microbes middling midlands midnight midpoint midriffs midterms midweeks midwives midyears mightier mightily migraine migrants migrated migrates milanese mildewed mildness mileages milepost militant military militate militias milkiest milkmaid milksops milkweed milldams milliard milliner millions millrace mimicked mimicker minarets minatory mindless minerals mingling minicabs minidisk minimize minimums minister ministry minority minotaur minstrel mintages minuends minutely minutiae miracles mirrored mirthful misapply miscalls miscarry miscasts mischief miscible miscount miscuing misdeals misdealt misdeeds misdoing miseries misfired misfires misguide misheard mishears mishmash misjudge misleads mismatch misnamed misnames misnomer misogamy misogyny misplace misplays misprint misquote misreads misruled misrules misshape missiles missions missives missouri misspell misspend misspent misstate missteps mistaken mistakes mistiest mistrals mistreat mistress mistrial mistrust misusing mitering mitigate mitzvahs mixtures mnemonic mobility mobilize mobsters moccasin modality modeling moderate moderato modestly modicums modified modifier modifies modulate mohammed moieties moistens moistest moisture molasses moldable moldered moldiest moldings molecule molehill moleskin molested mollusks momentum monarchs monarchy monastic monaural monazite monetary moneybag mongered mongolia mongoose mongrels monikers monistic monition monitors monitory monkeyed monocles monodies monodist monogamy monogram monolith monomers monomial monopoly monorail monotone monotony monotype monoxide monsoons monsters montages monument moochers mooching moodiest moonbeam mooncalf mooniest moorages moorings moraines moralist morality moralize morasses mordancy mordents moreover moribund mornings moroccan morosely morpheme morpheus morphine mortally mortared mortgage mortised mortises mortuary moseying mosquito mossback mossiest mothball mothered motherly motility motioned motivate motorcar motoring motorist motorize motorman motormen mottling mounding mountain mounting mourners mournful mourning mousiest mouthful mouthing movement movingly mucilage muckrake muddiest muddling muddying mudguard muezzins mufflers muffling muggiest muggings mulattos mulberry mulching mulcting muleteer mulleins mulligan mullions multiple multiply mumbling muminous munching muralist murcatel murdered murderer murkiest murmured murrains muscling muscular mushiest mushroom musicale musicals musician musketry muskrats mustache mustangs mustards mustered mustiest mutating mutation mutative muteness mutilate mutineer mutinied mutinies mutinous muttered mutually muzzling mycelium mycology myrmidon mystical mystique mythical nacelles nacreous naivetes nameless namesake namibian nankeens naperies napoleon narcoses narcosis narcotic narrated narrates narrator narrowed narrower narrowly narwhals nasality nascence nastiest national nativity nattiest naturals nauseate nauseous nautical nautilus navigate nazarene nearness neatness nebraska nebulous necklace neckline neckties neckwear neediest needless needling negating negation negative neglects negligee neighbor nektonic nematode nembutal neomycin neonatal neonates neophyte neoplasm neoprene nepalese nepenthe nephrite nepotism nerviest nervosas nestling netsukes nettling networks neuritis neuroses neurosis neurotic neutered neutrals neutrino neutrons newborns newcomer newlywed newsboys newscast newsiest newsreel nibbling niceties nickname nicotine niftiest nigerian niggling nightcap nihilism nihilist nimblest ninepins nineteen nineties nippiest nirvanas nitrated nitrates nitrides nitrites nitrogen nobelium nobility nobleman noblemen noblesse nobodies nocturne noisiest nominate nominees nomogram nonagons nonesuch nonjuror nonmetal nonsense nonunion nonwhite noodling noondays noontide noontime normalcy normally northern nosegays nosiness nostrils nostrums notables notaries notarize notation notching notebook nothings noticing notified notifies notional nouveaux novelist novellas november novocain nowadays nuclease nucleate nucleoli nucleons nudities nugatory nuisance numbered numbness numerals numerate numerous numskull nuptials nursling nurtured nurtures nuthatch nutmeats nutrient nutshell";

    return [lmn componentsSeparatedByString:@" "];
}


@end