package fluffyflux;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class Header extends Sprite
{
    public function new ()
    {
        super ();

        construct ();
    }

    private function construct ():Void
    {
        var format    = new TextFormat("Arial", 20, 0x7A0026);
        var textField = new TextField();

        textField.defaultTextFormat = format;
        textField.selectable        = false;

        textField.x     = 0;
        textField.y     = 0;
        textField.width = 200;

        textField.text  = "Fluffy Flux";

        addChild (textField);
    }
}
