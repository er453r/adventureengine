package com.er453r.adventureengine;

import haxe.ds.StringMap;

class AdventureParser {
    private static inline var CHARACTERS_SECTION = "Characters";
    private static inline var STORY_SECTION = "Story";

    private var titleRegex = ~/^# (.+)/; // this matches the title, and only the title
    private var sectionRegex = ~/^## (.+)/; // this matches sections as "Characters", "Story", "The end"
    private var subSectionRegex = ~/### (.+)/; // this matches sub-sections as characters, chapters
    private var emptyRegex = ~/^[ \s\t]*$/; // matches empty lines
    private var indentRegex = ~/^(>*)\s*(.*)$/; // match indents

    private var currentlyParsing:ScriptPart = ScriptPart.STORY; // parse story by default
    private var currentIndentLevel:Int = 0;

    private var title:String;

    private var story:StoryNode;
    private var currentStoryNode:StoryNode;
    private var storyStack:Array<StoryNode> = [];
    private var hangingForkNodes:Array<StoryNode> = [];
    private var lastDecreaseIndex:UInt = 0;

    public var characters:StringMap<Character> = new StringMap<Character>();

    public function new(script:String){
        var lines = script.split("\n");

        trace('Have ${lines.length} lines');

        for(n in 0...lines.length){
            var line = lines[n];

            if(titleRegex.match(line)){
                currentlyParsing = ScriptPart.OTHER;

                title = titleRegex.matched(1);

                currentStoryNode = story = new StoryNode(title);

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

                continue;
            }

            if(currentlyParsing == ScriptPart.STORY){
                var shouldCollectHanging:Bool = false;

                if(indentRegex.match(line)){
                    trace('LINE $line');

                    var indentDiff = indentRegex.matched(1).length - currentIndentLevel;

                    trace('Indent diff $indentDiff');

                    if(indentDiff == 1){
                        trace('Current stack fork is $currentStoryNode');

                        storyStack.push(currentStoryNode);
                    }
                    else if(indentDiff < 0){
                        hangingForkNodes.push(currentStoryNode); // rembeber fork end for the merge

                        for(i in indentDiff...0)
                            currentStoryNode = storyStack.pop();

                        trace('Stack decrease, current is $currentStoryNode');

                        lastDecreaseIndex = n;
                    }
                    else if(indentDiff == 0){
                        if(lastDecreaseIndex == n - 1){ // no increase after a decrease  - this means an end of fork
                            trace('Ending fork $currentStoryNode');

                            // now every fork ending, should point to the next node
                            shouldCollectHanging = true;

                            if(currentStoryNode.size() == 1)
                                trace('[WARN] Ending a fork with 1 branch - unnessesary branching');
                            else if(currentStoryNode.size() < 1)
                                throw 'Unexpected number of fork branches - ${currentStoryNode.size()}';
                        }
                    }
                    else
                        throw 'Indent diff ($indentDiff) other than -1,0,+1';

                    currentIndentLevel += indentDiff;

                    trace('Changing INDENT level to $currentIndentLevel');

                    line = indentRegex.matched(2);
                }

                if(emptyRegex.match(line)) // do nothing on empty
                    continue;

                var newStoryNode:StoryNode = new StoryNode(StringTools.trim(line));

                if(shouldCollectHanging){
                    for(hangingNode in hangingForkNodes)
                        hangingNode.add(newStoryNode);

                    hangingForkNodes = [];
                }

                if(currentStoryNode == null){ // if nothing has begun yet
                    currentStoryNode = story = newStoryNode;
                }
                else{ // else append and save as current
                    if(!shouldCollectHanging)
                        currentStoryNode.add(newStoryNode);

                    currentStoryNode = newStoryNode;
                }

                trace(currentStoryNode);

                continue;
            }

            trace('Other content: $line');
        }

        trace(this);
    }

    public function dump(){
        story.dump();
    }

    public function dot():String{
        return 'digraph ${title == null ? 'Story' : title} {\n${story.dot(1)}}';
    }

    public function toString():String{
        return '${title == null ? 'A' : '$title -  a'} tale of ${Lambda.count(characters)} characters';
    }
}
