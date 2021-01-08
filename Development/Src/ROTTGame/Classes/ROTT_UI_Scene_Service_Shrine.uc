/*=============================================================================
 * ROTT_UI_Scene_Service_Shrine
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the shrine service for item offerings.
 *===========================================================================*/

class ROTT_UI_Scene_Service_Shrine extends ROTT_UI_Scene;

// Pages
var privatewrite ROTT_UI_Page_Party_Selection partySelection;
var privatewrite ROTT_UI_Page_Stats_Inspection statsInspection;
var privatewrite ROTT_UI_Page_Mgmt_Window_Shrine_Offering shrineMgmt;

// Party
var private ROTT_UI_Party_Display partyDisplayer;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  partySelection = ROTT_UI_Page_Party_Selection(findComp("Party_Selection_UI"));
  statsInspection = ROTT_UI_Page_Stats_Inspection(findComp("Stats_Inspection_UI"));
  shrineMgmt = ROTT_UI_Page_Mgmt_Window_Shrine_Offering(findComp("Shrine_Management_UI"));
  
  // References
  partyDisplayer = ROTT_UI_Party_Display(ROTT_UI_Page(findComp("Service_Info_Herb_Shrine")).findComp("Party_Displayer"));
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Show party
  partyDisplayer.renderParty(gameInfo.getActiveParty()); 
  partyDisplayer.syncIconEffects();
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered.  Each page receives
 * a call for the onSceneDeactivation() event
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  bResetOnLoad=true
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Pages ===== **/
  // Scene Background Page
	begin object class=ROTT_UI_Page Name=Scene_Background_Page
		tag="Scene_Background_Page"
    bInitialPage=true
    
    /** ===== Textures ===== **/
    // Left menu backgrounds
    begin object class=UI_Texture_Info Name=Menu_Background_Left_Texture
      componentTextures.add(Texture2D'GUI.Menu_Background_Left')
    end object
    
    // Rightside background
    begin object class=UI_Texture_Info Name=Menu_Background_Texture
      componentTextures.add(Texture2D'GUI.Menu_Background')
    end object
    
    /** ===== UI Components ===== **/
    // Left background
    begin object class=UI_Sprite Name=Menu_Background_Left
      tag="Menu_Background_Left"
      bEnabled=true
      posX=0
      posY=0
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      images(0)=Menu_Background_Left_Texture
    end object
    componentList.add(Menu_Background_Left)
    
    // Right background
    begin object class=UI_Sprite Name=Menu_Background_Right
      tag="Menu_Background_Right"
      bEnabled=true
      posX=720
      posY=0
      posXEnd=NATIVE_WIDTH
      posYEnd=NATIVE_HEIGHT
      images(0)=Menu_Background_Texture
    end object
    componentList.add(Menu_Background_Right)
    
	end object
	pageComponents.add(Scene_Background_Page)
  
  // Stats Inspection Menu
	begin object class=ROTT_UI_Page_Stats_Inspection Name=Stats_Inspection_UI
		tag="Stats_Inspection_UI"
	end object
	pageComponents.add(Stats_Inspection_UI)
  
  // Shrine Management Window
	begin object class=ROTT_UI_Page_Mgmt_Window_Shrine_Offering Name=Shrine_Management_UI
		tag="Shrine_Management_UI"
	end object
	pageComponents.add(Shrine_Management_UI)
  
  // Service info
	begin object class=ROTT_UI_Page Name=Service_Info_Herb_Shrine
		tag="Service_Info_Herb_Shrine"
    bInitialPage=true
    
    // Half size window
    begin object class=UI_Texture_Info Name=Half_Window
      componentTextures.add(Texture2D'GUI.Reset_Cost_Window'
    end object
    
    // Window background
    begin object class=UI_Sprite Name=Service_Window
      tag="Service_Window"
      posX=0
      posY=0
      images(0)=Half_Window
    end object
    componentList.add(Service_Window)
    
    // Header label
    begin object class=UI_Label Name=Header_Label
      tag="Header_Label"
      posX=0
      posY=74
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      fontStyle=DEFAULT_LARGE_TAN
      AlignX=CENTER
      AlignY=TOP
      labelText="Item Offering Ritual"
    end object
    componentList.add(Header_Label)
      
    /** Test description stuff? **/
    // Mgmt Window - Title Label
    begin object class=UI_Label Name=Mgmt_Window_Label_0
      tag="Mgmt_Window_Label_0"
      posX=0
      posY=112
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="(Shrine service)"
      fontStyle=DEFAULT_SMALL_GRAY
    end object
    componentList.add(Mgmt_Window_Label_0)
    
    // Mgmt Window - Description Labels
    begin object class=UI_Label Name=Mgmt_Window_Label_1
      tag="Mgmt_Window_Label_1"
      posX=0
      posY=151
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="Select a character."
    end object
    componentList.add(Mgmt_Window_Label_1)
    
    begin object class=UI_Label Name=Mgmt_Window_Label_2
      tag="Mgmt_Window_Label_2"
      posX=0
      posY=189
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="Donating herbs at this shrine provides"
    end object
    componentList.add(Mgmt_Window_Label_2)
    
    begin object class=UI_Label Name=Mgmt_Window_Label_3
      tag="Mgmt_Window_Label_3"
      posX=0
      posY=216
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="experience to the character chosen."
    end object
    componentList.add(Mgmt_Window_Label_3)
    
    /*
    begin object class=UI_Label Name=Mgmt_Window_Label_4
      tag="Mgmt_Window_Label_4"
      posX=0
      posY=243
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText=""
    end object
    componentList.add(Mgmt_Window_Label_4)
    
    begin object class=UI_Label Name=Mgmt_Window_Label_5
      tag="Mgmt_Window_Label_5"
      posX=0
      posY=297
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText=""
    end object
    componentList.add(Mgmt_Window_Label_5)
    
    begin object class=UI_Label Name=Mgmt_Window_Label_6
      tag="Mgmt_Window_Label_6"
      posX=0
      posY=324
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText=""
    end object
    componentList.add(Mgmt_Window_Label_6)
    
    begin object class=UI_Label Name=Mgmt_Window_Label_7
      tag="Mgmt_Window_Label_7"
      posX=0
      posY=351
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText=""
    end object
    componentList.add(Mgmt_Window_Label_7)
    */
    
    // Party Displayer
    begin object class=ROTT_UI_Party_Display Name=Party_Displayer
      tag="Party_Displayer"
      bEnabled=true
      posX=60
      posY=544
      XOffset=200
      YOffset=0
    end object
    componentList.add(Party_Displayer)
    
	end object
	pageComponents.add(Service_Info_Herb_Shrine)
  
  // Party selection Menu
	begin object class=ROTT_UI_Page_Party_Selection Name=Party_Selection_UI
		tag="Party_Selection_UI"
    bInitialPage=true
    
    navMode=ITEM_SHRINE_NAVIGATION
	end object
	pageComponents.add(Party_Selection_UI)
  
}









