package com.er453r.adventureengine;

import haxe.ds.StringMap;

class AdventureParser {
    private static inline var CHARACTERS_SECTION = "Characters";
    private static inline var STORY_SECTION = "Story";

    private var titleRegex = ~/^# (.+)/; // this matches the title, and only the title
    private var sectionRegex = ~/^## (.+)/; // this matches sections as "Characters", "Story", "The end"
    private var subSectionRegex = ~/### (.+)/; // this matches sub-sections as characters, chapters
    private var emptyRegex = ~/^[ \s\t]*$/; // matches empty lines
    private var indentRegex = ~/^(>+) (.+)$/; // match indents

    private var currentlyParsing:ScriptPart = ScriptPart.OTHER;
    private var currentIndentLevel:Int = 0;

    public var title:String;
    public var characters:StringMap<Character> = new StringMap<Character>();
    public var story:StoryNode = new StoryNode("");

    public function new(script:String){
        var lines = script.split("\n");

        trace('Have ${lines.length} lines');

        for(n in 0...lines.length){
            var line = lines[n];

            if(titleRegex.match(line)){
                title = titleRegex.matched(1);

                trace('Title: $title');

                continue;
            }

            if(sectionRegex.match(line)){
                var sectionName = sectionRegex.matched(1);

                trace('Section: ${sectionName}');

                if(sectionName == CHARACTERS_SECTION){
                    trace("Parsing CHARACTERS section");

                    currentlyParsing = ScriptPart.CHARACTERS;
                }

                if(sectionName == STORY_SECTION){
                    trace("Parsing STORY section");

                    currentlyParsing = ScriptPart.STORY;
                }

                continue;
            }

            if(subSectionRegex.match(line)){
                var name = subSectionRegex.matched(1);

                trace('Sub-section: ${name}');

                if(currentlyParsing == ScriptPart.CHARACTERS)
                    characters.set(name, new Character(name, subSectionRegex.matchedRight()));

                if(currentlyParsing == ScriptPart.STORY){
                    var newStoryNode:StoryNode = new StoryNode(line);

                    story.add(newStoryNode);

                    story = newStoryNode;
                }

                continue;
            }

            if(emptyRegex.match(line)) // do nothing on empty
                continue;

            if(currentlyParsing == ScriptPart.STORY){
                if(indentRegex.match(line)){
                    var indentDiff = indentRegex.matched(1).length - currentIndentLevel;

                    if(indentDiff == 1 || indentDiff == -1){
                        currentIndentLevel += indentDiff;

                        trace('Changing INDENT level to $currentIndentLevel');
                    }
                    else if(indentDiff != 0)
                        throw 'INDENT diff other than -1,0,+1';
                }

                var newStoryNode:StoryNode = new StoryNode(line);

                story.add(newStoryNode);

                story = newStoryNode;

                trace(story);

                continue;
            }

            trace('Other content: $line');
        }

        trace(this);
    }

    public function toString():String{
        return '$title - a tale of ${Lambda.count(characters)} characters';
    }
}
