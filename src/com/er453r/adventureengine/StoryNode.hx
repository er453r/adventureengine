package com.er453r.adventureengine;

class StoryNode {
    private var nodes:Array<StoryNode> = [];
    private var content:String;

    public function new(content:String) {
        this.content = content;
    }

    public function size():Int{
        return nodes.length;
    }

    public function add(storyNode:StoryNode){
        nodes.push(storyNode);
    }

    public function dump(indent:Int = 0, par:String = ""){
        var prefix = "";

        for(n in 0...indent)
            prefix += ">";

        if(indent > 0)
            prefix += ' [$par] ';

        trace(prefix + content);

        for(node in nodes)
            node.dump(indent + (nodes.length > 1 ? 1 : 0), content);
    }

    public function dot(indent:Int = 0):String{
        var string = "";
        var prefix = "";

        for(n in 0...indent)
            prefix += "    ";

        for(node in nodes){
            string += '$prefix"$content" -> "${node.content}"\n';

            string += node.dot(indent + (nodes.length > 1 ? 1 : 0));
        }

        return string;
    }

    public function toString(){
        return '[StoryNode | $content]';
    }
}
