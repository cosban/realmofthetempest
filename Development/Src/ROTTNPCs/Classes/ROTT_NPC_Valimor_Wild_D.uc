/*=============================================================================
 * NPC - Valimor Wilderness (D)
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A wilderness NPC in Valimor.
 *===========================================================================*/

class ROTT_NPC_Valimor_Wild_D extends ROTT_NPC_Container;

// Macros for formatting dialog content
`DEFINE NEW_NODE(TOPIC, MODE)           addDialogNode(`TOPIC, `MODE, 
`DEFINE ADD_OPTIONS(TOPIC, MODE)        addOptions(`TOPIC, `MODE, 
`DEFINE ADD_REPLY(TOPIC, MODE, INDEX)   addReplyChain(`TOPIC, `MODE, `INDEX,

`DEFINE ENDNODE );

/*=============================================================================
 * initDialogue()
 * 
 * This sets all the dialog content
 *===========================================================================*/
public function initDialogue() {
  super.initDialogue();
  
  // Intro
  `NEW_NODE(GREETING, NUETRAL)
    "We are RETARDED, so you look away.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Falling from a dark tree, to a poisoned fountain.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Swallowed by the youth and spit back again.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "RETARDS never love you.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Because RETARDS are never loved.",
    ""
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Aren't you RETARDED?  Would you like to",
    "crawl with us through the old filth of fallen angels?"
  `ENDNODE
  
  `NEW_NODE(GREETING, NUETRAL)
    "Come here little RETARD, spit with us.",
    "We'll wait for you."
  `ENDNODE
  
  // ----------------------------------------------------------------------- //
  
  setInquiry(
    "Goodnight",
    "",
    "",
    "",
    
    BEHAVIOR_GOODBYE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE
  );
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=GENERIC
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Texture
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Texture
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Sprite_Texture
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Purple_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Sprite_Texture
  end object
  npcSprites=NPC_Sprites
}





