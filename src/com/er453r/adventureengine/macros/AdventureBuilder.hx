package com.er453r.adventureengine.macros;

import haxe.macro.ExprTools;
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import haxe.macro.Expr;

import sys.io.File;

using hx.strings.Strings; // augment all Strings with new functions

class AdventureBuilder {
    private static inline var SCRIPT_ANNOTATION = "script";

    public static function build():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        trace('Trying to build an adventure...');

        var file:String = getMeta(SCRIPT_ANNOTATION);

        if(file == null)
            Context.error('Script file not specified! Use class annotation "@$SCRIPT_ANNOTATION"', Context.currentPos());

        trace('Script file $file');

        var content = File.getContent(Context.resolvePath(file));

        var adventure:AdventureParser = new AdventureParser(content);

        adventure.dump();

        for(character in adventure.characters){
            fields.push({
                name: character.name.toUpperCamel(),
                access: [Access.APublic, Access.AStatic],
                kind: FieldType.FVar(macro:Character, macro new Character($v{character.name}, $v{character.description})),
                pos: Context.currentPos()
            });
        }

        return fields;
    }

    static public function getMeta(name:String):String {
        var meta:MetadataEntry = getMetaEntry(name);

        if(meta != null && meta.params.length > 0)
            return ExprTools.getValue(meta.params[0]);

        return null;
    }

    static public function getMetaEntry(name:String):MetadataEntry {
        var classType:ClassType;

        switch (Context.getLocalType()) {
            case TInst(r, _):
                classType = r.get();
            case _:
        }

        for (meta in classType.meta.get())
            if(meta.name == name)
                return meta;

        return null;
    }
}
