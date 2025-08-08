export interface PhraseModel {
  id: number;
  text: ResourceStr;
}

export interface PhrasesGroup {
  id: number;
  text: ResourceStr;
  phrases: PhraseModel[];
}

const GREETINGS_PHRASES: PhraseModel[] = [
  { id: 1, text: $r('app.string.greeting_hello') },
  { id: 2, text: $r('app.string.greeting_good_morning') },
  { id: 3, text: $r('app.string.greeting_good_night') },
]

const BASIC_PHRASES: PhraseModel[] = [
  { id: 4, text: $r('app.string.basic_thank_you') },
  { id: 5, text: $r('app.string.basic_please') },
  { id: 6, text: $r('app.string.basic_yes') },
  { id: 7, text: $r('app.string.basic_no') }
];

const HELP_PHRASES: PhraseModel[] = [
  { id: 8, text: $r('app.string.help_i_need_help') },
  { id: 9, text: $r('app.string.help_where_is_toilet') },
  { id: 10, text: $r('app.string.help_call_police') }
];

const TRAVEL_PHRASES: PhraseModel[] = [
  { id: 11, text: $r('app.string.travel_where_is_airport') },
  { id: 12, text: $r('app.string.travel_i_have_reservation') },
  { id: 13, text: $r('app.string.travel_how_much_is_ticket') }
];

const SHOPPING_PHRASES: PhraseModel[] = [
  { id: 14, text: $r('app.string.shopping_how_much') },
  { id: 15, text: $r('app.string.shopping_do_you_accept_card') },
  { id: 16, text: $r('app.string.shopping_i_want_this') }
];

const EMERGENCY_PHRASES: PhraseModel[] = [
  { id: 17, text: $r('app.string.emergency_call_ambulance') },
  { id: 18, text: $r('app.string.emergency_im_lost') },
  { id: 19, text: $r('app.string.emergency_my_phone_is_stolen') }
];

export const PHRASES_GROUPS: PhrasesGroup[] = [
  {
    id: 1,
    text: $r('app.string.greetings'),
    phrases: GREETINGS_PHRASES
  },
  {
    id: 2,
    text: $r('app.string.basic'),
    phrases: BASIC_PHRASES
  },
  {
    id: 3,
    text: $r('app.string.help'),
    phrases: HELP_PHRASES
  },
  {
    id: 4,
    text: $r('app.string.travel'),
    phrases: TRAVEL_PHRASES
  },
  {
    id: 5,
    text: $r('app.string.shopping'),
    phrases: SHOPPING_PHRASES
  },
  {
    id: 6,
    text: $r('app.string.emergency'),
    phrases: EMERGENCY_PHRASES
  }
];
