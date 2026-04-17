export interface PhraseModel {
  id: number;
  en: string;
  ar: string;
}

export interface PhrasesGroup {
  id: number;
  text: ResourceStr;
  phrases: PhraseModel[];
}

const GREETINGS_PHRASES: PhraseModel[] = [
  { id: 1, en: 'Hello', ar: 'مرحبًا' },
  { id: 2, en: 'Good morning', ar: 'صباح الخير' },
  { id: 3, en: 'Good night', ar: 'تصبح على خير' }
]

const BASIC_PHRASES: PhraseModel[] = [
  { id: 4, en: 'Thank you', ar: 'شكرًا' },
  { id: 5, en: 'Please', ar: 'من فضلك' },
  { id: 6, en: 'Yes', ar: 'نعم' },
  { id: 7, en: 'No', ar: 'لا' }
];

const HELP_PHRASES: PhraseModel[] = [
  { id: 8, en: 'I need help', ar: 'أحتاج إلى مساعدة' },
  { id: 9, en: 'Where is the bathroom?', ar: 'أين الحمام؟' },
  { id: 10, en: 'Call the police!', ar: 'اتصل بالشرطة!' }
];

const TRAVEL_PHRASES: PhraseModel[] = [
  { id: 11, en: 'Where is the airport?', ar: 'أين المطار؟' },
  { id: 12, en: 'I have a reservation', ar: 'لدي حجز' },
  { id: 13, en: 'How much is the ticket?', ar: 'كم سعر التذكرة؟' }
];

const SHOPPING_PHRASES: PhraseModel[] = [
  { id: 14, en: 'How much is this?', ar: 'بكم هذا؟' },
  { id: 15, en: 'Do you accept credit cards?', ar: 'هل تقبلون البطاقات الائتمانية؟' },
  { id: 16, en: 'I want this one', ar: 'أريد هذا' }
];

const EMERGENCY_PHRASES: PhraseModel[] = [
  { id: 17, en: 'Call an ambulance!', ar: 'اتصل بالإسعاف!' },
  { id: 18, en: 'I am lost', ar: 'لقد ضعت' },
  { id: 19, en: 'My phone was stolen', ar: 'تمت سرقة هاتفي' }
];

export const PHRASES_GROUPS: PhrasesGroup[] = [
  { id: 1, text: $r('app.string.greetings'), phrases: GREETINGS_PHRASES },
  { id: 2, text: $r('app.string.basic'), phrases: BASIC_PHRASES },
  { id: 3, text: $r('app.string.help'), phrases: HELP_PHRASES },
  { id: 4, text: $r('app.string.travel'), phrases: TRAVEL_PHRASES },
  { id: 5, text: $r('app.string.shopping'), phrases: SHOPPING_PHRASES },
  { id: 6, text: $r('app.string.emergency'), phrases: EMERGENCY_PHRASES }
];
