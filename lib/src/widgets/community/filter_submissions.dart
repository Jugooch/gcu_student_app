class ProfanityCheck {
  static final List<String> _bannedWords = [
    'arse',
    'arsehole',
    'arses',
    'arseholes',
    'arsenigga',
    'arseniggas',
    'arsenigger',
    'arseniggers',
    'assnigga',
    'assniggas',
    'assnigger',
    'assniggers',
    'abo',
    'abbo',
    'abos',
    'abbos',
    'abboes',
    'aboes',
    'bitch',
    'bitches',
    'bitchs',
    'bitchy',
    'bitchass',
    'bitchtits',
    'bitching',
    'bitched',
    'bitchblower',
    'bloody',
    'bastard',
    'bastards',
    'bellend',
    'beaner',
    'beaners',
    'cock',
    'chink',
    'cocksucker',
    'cocks',
    'cocksuckers',
    'cunt',
    'cunts',
    'cracker',
    'cracka',
    'crackers',
    'crackaz',
    'crackas',
    'cum',
    'cums',
    'cumduzzler',
    'cumduzzlers',
    'cumming',
    'cumdumpster',
    'cumdumpsters',
    'cuntgrabbers',
    'cuntgrabber',
    'cunter',
    'cunters',
    'cuntlicker',
    'cuntlickers',
    'clitfucker',
    'clitfuckers',
    'childfucker',
    'childfuckers',
    'chinks',
    'chinky',
    'chinkies',
    'chinky chonk',
    'chinky-chonks',
    'chinky-chonk',
    'chinky chonks',
    'coon',
    'coons',
    'dick',
    'dik',
    'dick head',
    'dickhead',
    'dicks',
    'dikz',
    'dix',
    'dickweasel',
    'dickweasels',
    'dickweed',
    'dickweeds',
    'dick heads',
    'dickheads',
    'dicksucker',
    'dicksuckers',
    'dyke',
    'dykes',
    'dunecoon',
    'dunecoons',
    'dune coon',
    'dune coons',
    'dumbarse',
    'dumbarses',
    'frick',
    'fuck',
    'fucker',
    'fucking',
    'fucked',
    'fricker',
    'fucks',
    'fuckin',
    'fuckers',
    'frickers',
    'fricking',
    'fricked',
    'fuckhead',
    'fucktard',
    'fuckheads',
    'fucktards',
    'fucktardis',
    'fucka',
    'fuckaz',
    'fat fuck',
    'fatfuck',
    'fag',
    'faggot',
    'fags',
    'faggots',
    'faggy',
    'faggoting',
    'fatarse',
    'fatarses',
    'gaydo',
    'gaydoes',
    'gaydos',
    'god damn',
    'goddamn',
    'goddamnit',
    'god dammit',
    'god damn it',
    'gook',
    'gooks',
    'gringo',
    'gringos',
    'gringoes',
    'ho',
    'hos',
    'heeb',
    'heebs',
    'hoe',
    'hoes',
    'hebe',
    'hebes',
    'jizz',
    'kak',
    'kaks',
    'kike',
    'kikes',
    'kaffir',
    'kaffirs',
    'lezzie',
    'lezzies',
    'lezzo',
    'lezzos',
    'mcfaggot',
    'motherfucking',
    'motherfuckin',
    'motherfucker',
    'motherfuckers',
    'mofo',
    'nigga',
    'niga',
    'niguh',
    'nigguh',
    'nigger',
    'niggur',
    'niger',
    'nigr',
    'niggas',
    'niggaz',
    'nigaz',
    'niggaz',
    'nigaz',
    'niggers',
    'niggurz',
    'nigerz',
    'nigrz',
    'nigrs',
    'paki',
    'pakis',
    'porn',
    'porno',
    'pornos',
    'prick',
    'prik',
    'pricks',
    'prikz',
    'priks',
    'prix',
    'poonani',
    'queer',
    'queers',
    'shit',
    'shitty',
    'shits',
    'sheepshagger',
    'sheep shagger',
    'sheepshaggers',
    'sheep shaggers',
    'sandnigga',
    'sand nigga',
    'sandnigger',
    'sand nigger',
    'sandniggas',
    'sand niggas',
    'sandniggers',
    'sand niggers',
    'shitter',
    'shita',
    'shitters',
    'shitaz',
    'shitting',
    'shittin’',
    'shitted',
    'shithead',
    'shitheads',
    'spic',
    'spik',
    'spics',
    'spix',
    'spikz',
    'shithouse',
    'shithouses',
    'shittiest',
    'shittier',
    'shitpost',
    'shitposting',
    'shitpostin’',
    'shitposter',
    'shitposts',
    'shitposters',
    'shat',
    'slut',
    'sluts',
    'snow nigger',
    'snow nigga',
    'snownigger',
    'snow nigga',
    'snow niggers',
    'snow niggas',
    'snow niggaz',
    'snowniggers',
    'snowniggas',
    'snowniggaz',
    'tacohead',
    'tacoheads',
    'thot',
    'thotbot',
    'thots',
    'thotbots',
    'unclefucker',
    'unclefucka',
    'uncle fucker',
    'uncle fucka',
    'unclefuckers',
    'unclefuckaz',
    'uncle fuckers',
    'uncle fuckaz',
    'vag',
    'vags',
    'wank',
    'wanks',
    'wanking',
    'wanked',
    'whore',
    'whorseson',
    'whores',
    'whoresons',
    'wetback',
    'wetbacks',
    'white cracker',
    'whitecracker',
    'whitecracka',
    'white cracka',
    'white crackers',
    'whitecrackers',
    'whitecrackaz',
    'white crackaz',
    'white crackas',
    'wog',
    'wogs',
    'wop',
    'wops',
    'zipperhead',
    'zipperheads',
  ];

  static bool containsProfanity(String input) {
    final inputLowercase = input.toLowerCase();
    return _bannedWords.any((word) => inputLowercase.contains(word));
  }
}