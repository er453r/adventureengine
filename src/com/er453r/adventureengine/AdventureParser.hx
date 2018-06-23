package com.er453r.adventureengine;

class AdventureParser {
    private var titleRegex = ~/^# (.+)/;
    private var sectionRegex = ~/^## (.+)/;
    private var characterRegex = ~/### (.+)/;
    private var emptyRegex = ~/^[ \s\t]*$/;

    public var title:String;
    public var characters:Array<Character> = [];

    public function new(script:String){
        var lines = script.split("\n");

        trace('Have ${lines.length} lines');

        for(n in 0...lines.length){
            if(titleRegex.match(lines[n])){
                title = titleRegex.matched(1);

                trace('Title: $title');

                continue;
            }

            if(sectionRegex.match(lines[n])){
                trace('Section: ${sectionRegex.matched(1)}');

                continue;
            }

            if(characterRegex.match(lines[n])){
                var name = characterRegex.matched(1);

                trace('Sub-section: ${name}');

                characters.push(new Character(name, characterRegex.matchedRight()));

                continue;
            }

            if(emptyRegex.match(lines[n])) // do nothing on empty
                continue;

            trace('Content: ${lines[n]}');
        }

        trace(this);
    }

    public function toString():String{
        return '$title - a tale of ${characters.length} characters';
    }
}
