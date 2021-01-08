/*=============================================================================
 * UI_Label_Independent 
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is supposed to be able to draw text on screen with fonts
 * and draw styles that are not shared with other labels.
 *===========================================================================*/
 
class UI_Label_Independent extends UI_Label;  

defaultProperties
{
  // <FONT>_<SIZE>_<COLOR>_<optional: EFFECTS>
  
  /** ===== Fonts ===== **/
  // Cinzel: Small, White
	Begin Object class=UI_String_Style Name=Cinzel_Small_White
    drawColor=(R=255,G=255,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_WHITE]=Cinzel_Small_White
  
  // Cinzel: Small, Gray
	Begin Object class=UI_String_Style Name=Cinzel_Small_Gray
    drawColor=(R=185,G=185,B=185,A=255) 
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_GRAY]=Cinzel_Small_Gray
	
  // Cinzel: Small, Beige
	Begin Object class=UI_String_Style Name=CINZEL_SMALL_BEIGE
    drawColor=(R=255,G=250,B=242,A=220)
    font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_BEIGE]=Cinzel_Small_Beige
  
  // Cinzel: Small, Green
  Begin Object class=UI_String_Style Name=Cinzel_Small_Green
    drawColor=(R=80,G=235,B=90,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_GREEN]=Cinzel_Small_Green
  
  // Cinzel: Small, Red
  Begin Object class=UI_String_Style Name=Cinzel_Small_Red
    drawColor=(R=235,G=80,B=80,A=255) 
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_RED]=Cinzel_Small_Red
	
  // Cinzel: Small, Blue
	Begin Object class=UI_String_Style Name=Cinzel_Small_Blue
    drawColor=(R=30,G=120,B=255,A=255) 
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_BLUE]=Cinzel_Small_Blue
	
  // Cinzel: Small, Purple
	Begin Object class=UI_String_Style Name=Cinzel_Small_Purple
    drawColor=(R=175,G=30,B=255,A=255) 
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_PURPLE]=Cinzel_Small_Purple
	
  // Cinzel: Small, Orange
  Begin Object class=UI_String_Style Name=Cinzel_Small_Orange
    drawColor=(R=255,G=145,B=0,A=255) 
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_ORANGE]=Cinzel_Small_Orange
  
  // Cinzel: Small, Cyan
	Begin Object class=UI_String_Style Name=Cinzel_Small_Cyan
    drawColor=(R=51,G=204,B=255,A=255)
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_CYAN]=Cinzel_Small_Cyan
	
  // Cinzel: Small, Yellow
	Begin Object class=UI_String_Style Name=Cinzel_Small_Yellow
    drawColor=(R=255,G=255,B=102,A=255)
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_YELLOW]=Cinzel_Small_Yellow
	
  // Cinzel: Small, Tan
	Begin Object class=UI_String_Style Name=Cinzel_Small_Tan
    drawColor=(R=230,G=217,B=164,A=255)
		font=Font'GUI.Fonts.Cinzel_18'
  End Object
  uiFonts[DEFAULT_SMALL_TAN]=Cinzel_Small_Tan

  // Cinzel: Medium, White
  Begin Object class=UI_String_Style Name=Cinzel_Medium_White
    drawColor=(R=255,G=255,B=255,A=255)
		font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_WHITE]=Cinzel_Medium_White
	
  // Cinzel: Medium, Gold
  Begin Object class=UI_String_Style Name=Cinzel_Medium_Gold
    drawColor=(R=255,G=245,B=200,A=220)
    font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_GOLD]=Cinzel_Medium_Gold
  
  // Cinzel: Medium, Yellow
  Begin Object class=UI_String_Style Name=Cinzel_Medium_Yellow
    drawColor=(R=255,G=255,B=102,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_YELLOW]=Cinzel_Medium_Yellow
  
  // Cinzel: Medium, Orange
  Begin Object class=UI_String_Style Name=Cinzel_Medium_Orange
    drawColor=(R=255,G=170,B=88,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_ORANGE]=Cinzel_Medium_Orange
  
  // Cinzel: Medium, Gray
	Begin Object class=UI_String_Style Name=Cinzel_Medium_Gray
    drawColor=(R=130,G=130,B=130,A=255)
		font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_GRAY]=Cinzel_Medium_Gray
  
  // Cinzel: Medium, Green
	Begin Object class=UI_String_Style Name=Cinzel_Medium_Green
    drawColor=(R=80,G=235,B=90,A=255) 
		font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_GREEN]=Cinzel_Medium_Green
  
  // Cinzel: Medium, Green
	Begin Object class=UI_String_Style Name=Cinzel_Medium_Red
    drawColor=(R=235,G=80,B=80,A=255) 
		font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_RED]=Cinzel_Medium_Red
  
  // Cinzel: Medium, Cyan
	Begin Object class=UI_String_Style Name=Cinzel_Medium_Cyan
    drawColor=(R=51,G=204,B=255,A=255)
		font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_CYAN]=Cinzel_Medium_Cyan
  
  // Cinzel: Medium, Tan
	Begin Object class=UI_String_Style Name=Cinzel_Medium_Tan
    drawColor=(R=230,G=217,B=164,A=255)
		font=Font'GUI.Fonts.Cinzel_22'
  End Object
  uiFonts[DEFAULT_MEDIUM_TAN]=Cinzel_Medium_Tan
  
  // Cinzel: Large, White
	Begin Object class=UI_String_Style Name=Cinzel_Large_White
    drawColor=(R=255,G=255,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_28'
  End Object
  uiFonts[DEFAULT_LARGE_WHITE]=Cinzel_Large_White
  
  // Cinzel: Large, Tan
	Begin Object class=UI_String_Style Name=Cinzel_Large_Tan
    drawColor=(R=230,G=217,B=164,A=255)
    font=Font'GUI.Fonts.Cinzel_28'
  End Object
  uiFonts[DEFAULT_LARGE_TAN]=Cinzel_Large_Tan
  
  // Padding
  padding=(top=0, left=12, right=12, bottom=8)
  
  // Alignment
  alignY=CENTER
  alignX=CENTER
  
  // Scroll effect
	bScrollEffect=false
	cycleIndex=0
	pauseCount=0
  
  // Style cycling
  bCycleStyles=false
  cycleStyleLength=0.1  // Seconds
}





















