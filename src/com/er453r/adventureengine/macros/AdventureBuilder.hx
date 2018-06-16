package com.er453r.adventureengine.macros;

import haxe.macro.ExprTools;
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import haxe.macro.Expr;

import sys.io.File;

using hx.strings.Strings; // augment all Strings with new functions

class AdventureBuilder {
    private static inline var SCRIPT_ANNOTATION = "script";
    private static inline var CONTENTS = "contents";

    private static inline var TITLE_REGEX = "^# (.+)";
    private static inline var SECTION_REGEX = "^## (.+)";
    private static inline var CHARACTER_REGEX = "### (.+)";
    private static inline var EMPTY_REGEX = "^[ \\s\\t]*$";

    public static function build():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        trace('Trying to build an adventure...');

        var file:String = getMeta(SCRIPT_ANNOTATION);

        if(file == null)
            Context.error('Script file not specified! Use class annotation "@$SCRIPT_ANNOTATION"', Context.currentPos());

        trace('Script file $file');

        var content = File.getContent(Context.resolvePath(file));

        //trace('Script: $content');

        var lines = content.split("\n");

        trace('Have ${lines.length} lines');

        for(n in 0...lines.length){
            var regex = new EReg(TITLE_REGEX, "");

            if(regex.match(lines[n])){
                trace('Title: ${regex.matched(1)}');

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

                fields.push({
                    name: name.toUpperCamel(),
                    access: [Access.APublic, Access.AStatic],
                    kind: FieldType.FVar(macro:Float, macro $v{1.5}),
                    pos: Context.currentPos()
                });

                continue;
            }

            regex = new EReg(EMPTY_REGEX, "");

            if(regex.match(lines[n])) // do nothing on empty
                continue;

            trace('Content: ${lines[n]}');
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
