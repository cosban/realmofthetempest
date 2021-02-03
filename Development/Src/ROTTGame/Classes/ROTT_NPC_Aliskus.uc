/*=============================================================================
 * ROTT_NPC_Aliskus
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Aliskus is the opening NPC gatekeeper.  Through this dialog, the player
 * selects their first familiar spirit and the name for their account.
 *===========================================================================*/
 
class ROTT_NPC_Aliskus extends ROTT_NPC_Container;

// Macros for formatting dialog content
`DEFINE NEW_NODE(TOPIC, MODE) addDialogNode(`TOPIC, `MODE, 
`DEFINE ENDNODE );

`DEFINE ADD_OPTIONS(TOPIC, MODE) addOptions(`TOPIC, `MODE, 

/*=============================================================================
 * initDialogue()
 * 
 * This sets all the dialog content
 *===========================================================================*/
public function initDialogue() {
  super.initDialogue();
  
  // Pre-Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "In a subtractive space, black is the absolute combination",
    "of all things."
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "And in the additive space, black is the emptiness of all things.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "But here in this world, black magic is both.",
    ""
  `ENDNODE
  setColor(DEFAULT_MEDIUM_GOLD);
  
  // Intro
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Wake up.",
    ""
  `ENDNODE
  overrideMusic(INTRODUCTION, NUETRAL);
  setColor(DEFAULT_MEDIUM_WHITE);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Even if you're dead, you can wake up.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "That's a trick I once learned from a gatekeeper.",
    "I've studied their connection to the ethereal stream."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "There are two sides to any gate.",
    "And when the gate awakens, we have crossed it."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Death is life's complement.",
    "Each are governed by the same gate."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "We are here to cheat life's complement, for that which",
    "precedes life is \"not living.\""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "A gate that awakens with birth, awakens with death.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "No world is made without paradox, no matter",
    "how omnipotent the hand may be."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "But whatever you seek to obtain here is no more obtainable",
    "than it is where you've come from."
  `ENDNODE
  
  //`NEW_NODE(INTRODUCTION, NUETRAL)
  //  "So is dialetheism enough to save us from madness?",
  //  ""
  //`ENDNODE
  //
  //`ADD_OPTIONS(INTRODUCTION, NUETRAL)
  //  "Yes",
  //  "No",
  //  "Yes and no",
  //  "What's dialetheism?"
  //`ENDNODE
  
  //`NEW_NODE(INTRODUCTION, NUETRAL)
  //  "The world is still waiting to feel your presence.",             
  //  "Your answers to my questions seem muted."
  //`ENDNODE
  //
  //`NEW_NODE(INTRODUCTION, NUETRAL)
  //  "Since you're such a fragile spirit,",             
  //  "I'll grant you a familiar."
  //`ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The world is still waiting to feel our presence.",         
    "So let's incarnate your first familiar."
  `ENDNODE
  
  /// character creation
  characterCreation(INTRODUCTION, NUETRAL);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "What should they call you?",             
    ""
  `ENDNODE
  
  /// Name creation
  nameCreation(INTRODUCTION, NUETRAL);
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Alright then.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Brace yourself %n.",
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "I came into the world like spit,",
    "and so will you."
  `ENDNODE
  
  /// Force goodbye
  worldTransfer(INTRODUCTION, NUETRAL, MAP_TALONOVIA_TOWN);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=ALISKUS
  
  // Fade in effects for new game
  bFadeIn=true
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Blue
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Blue')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Blue
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Aliskus
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Gatekeeper_Cyan_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Aliskus
  end object
  npcSprites=NPC_Sprites
}

















  
  /*
  `NEW_NODE(INTRODUCTION, NUETRAL)
  "Now let your mind and tongue spin threads of thought,",          // this dialogue is meh
    "like a spider in your skull."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
  "Are you a gathering of threads, or a single rope?",              // this dialogue is meh
    "Are you an 'I' or a 'We'?"
  `ENDNODE
  
  */
  

















