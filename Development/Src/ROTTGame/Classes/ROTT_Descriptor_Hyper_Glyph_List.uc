/*=============================================================================
 * ROTT_Descriptor_Hyper_Glyph_List
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class holds all design data for the Hyper Glyphs system
 *===========================================================================*/

class ROTT_Descriptor_Hyper_Glyph_List extends object;

`include(ROTTColorLogs.h)

/*============================================================================= 
 * getHyper_Glyph()
 *
 * 
 *===========================================================================*/
public static function getHyperGlyph
(
  coerce byte index
)
{
  
}

/*============================================================================= 
 * setTextFields()
 *
 * 
 *===========================================================================*/
public static function setTextFields
(
  out Hyper_GlyphDescriptor script,
  string Hyper_GlyphName,
  string Hyper_GlyphInfo1,
  string Hyper_GlyphInfo2,
  string Hyper_GlyphStats
) 
{
  script.displayText[Hyper_Glyph_NAME] = Hyper_GlyphName;
  script.displayText[Hyper_Glyph_INFO_1] = Hyper_GlyphInfo1;
  script.displayText[Hyper_Glyph_INFO_2] = Hyper_GlyphInfo2;
  script.displayText[Hyper_Glyph_STATS] = Hyper_GlyphStats;
}

/*============================================================================= 
 * Hyper_Glyphs
 *===========================================================================*/
defaultProperties 
{
  
}


















