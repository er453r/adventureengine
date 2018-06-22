package com.er453r.adventureengine;

class AdventureParser {
    private static inline var TITLE_REGEX = "^# (.+)";
    private static inline var SECTION_REGEX = "^## (.+)";
    private static inline var CHARACTER_REGEX = "### (.+)";
    private static inline var EMPTY_REGEX = "^[ \\s\\t]*$";

    public var title:String;
    public var characters:Array<Character> = [];

    public function new(script:String){
        var lines = script.split("\n");

        trace('Have ${lines.length} lines');

        for(n in 0...lines.length){
            var regex = new EReg(TITLE_REGEX, "");

            if(regex.match(lines[n])){
                title = regex.matched(1);

                trace('Title: $title');

                continue;
            }

            regex = new EReg(SECTION_REGEX, "");

            if(regex.match(lines[n])){
                trace('Section: ${regex.matched(1)}');

                continue;
            }

            regex = new EReg(CHARACTER_REGEX, "");

            if(regex.match(lines[n])){
                var name = regex.matched(1);

                trace('Sub-section: ${name}');

                characters.push(new Character(name, regex.matchedRight()));

                continue;
            }

            regex = new EReg(EMPTY_REGEX, "");

            if(regex.match(lines[n])) // do nothing on empty
                continue;

            trace('Content: ${lines[n]}');
        }

        trace(this);
    }

    public function toString():String{
        return '$title - a tale of ${characters.length} characters';
    }
}
