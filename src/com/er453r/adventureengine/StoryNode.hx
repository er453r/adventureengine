package com.er453r.adventureengine;

class StoryNode {
    private var nodes:Array<StoryNode> = [];

    private var content:String;
    private var parent:StoryNode;

    public var fork:Bool = false;

    public function getParent():StoryNode {
        trace('[$content] PARENT - $parent');

        return parent;
    }

    public function new(content:String) {
        this.content = content;
    }

    public function add(storyNode:StoryNode){
        trace('Adding $storyNode to $this');

        storyNode.parent = fork ? this : this.parent;

        trace('$storyNode parent set to ${storyNode.parent}');

        nodes.push(storyNode);
    }

    public function toString(){
        return '[StoryNode | $content]';
    }

    public function dump(indent:Int = 0, par:String = ""){
        var prefix = "";

        for(n in 0...indent)
            prefix += ">";

        if(indent > 0)
            prefix += ' [$par]';

        trace(prefix + content);

        for(node in nodes)
            node.dump(indent + (fork ? 1 : 0), content);
    }
}
