package com.er453r.adventureengine;

class StoryNode {
    private var nodes:Array<StoryNode> = [];

    private var content:String;

    public function new(content:String) {
        this.content = content;
    }

    public function add(storyNode:StoryNode){
        nodes.push(storyNode);
    }

    public function toString(){
        return '[StoryNode] $content';
    }
}
