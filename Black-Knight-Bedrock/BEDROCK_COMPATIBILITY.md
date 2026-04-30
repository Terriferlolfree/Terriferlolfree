# Black Knight - Bedrock/PE Compatibility Notes

## Fully Converted (Working on Bedrock/PE)
- **Block Textures**: ancient debris, crying obsidian, fire, glowstone, netherite block, obsidian, respawn anchor (all variants)
- **Item Textures**: apple, diamond sword, end crystal, ender pearl, experience bottle, golden apple, all netherite tools/armor items, totem of undying
- **Entity Textures**: end crystal
- **Armor Model Textures**: diamond armor (layer 1 & 2), netherite armor (layer 1 & 2)
- **Particle Textures**: all 51 particle textures (critical hit, damage, effects, enchanted hit, explosions, generic, glitter, sweep)
- **Misc Textures**: enchanted glint (entity & item), hunger indicators
- **Animations**: all animated textures converted to Bedrock flipbook format (crying obsidian, glowstone, fire, respawn anchor, ender pearl, experience bottle, totem of undying)
- **Language Files**: all 128 language translations converted to Bedrock .lang format with clean item names

## Not Convertible (Java-Only Features)
These features are exclusive to Java Edition and have no Bedrock equivalent:

- **OptiFine Custom Sky**: sky textures, cloud textures, starfield (Bedrock doesn't support OptiFine)
- **OptiFine Emissive Textures**: emissive texture suffix system
- **OptiFine Color Properties**: custom loading screen colors
- **Custom Item Models**: Java's item model JSON system (smaller item scaling, shield model) has no Bedrock equivalent
- **Custom Font Providers**: bitmap font characters for hunger indicators in item names - stripped from language files for compatibility
- **GUI Container Textures**: Bedrock uses a completely different UI system - Java GUI textures cannot be directly used
- **Creative Inventory Tabs**: different UI framework on Bedrock

## Installation on Mobile (Pocket Edition)
1. Download the `.mcpack` file to your device
2. Tap the file - Minecraft should open and import it automatically
3. Go to Settings > Global Resources > Activate the pack
4. The pack will apply to all worlds

## Installation on Other Bedrock Platforms
- **Windows 10/11**: Double-click the `.mcpack` file
- **Xbox/PlayStation**: Transfer via Minecraft Realms or use the built-in marketplace
- **Nintendo Switch**: Transfer via Minecraft Realms
