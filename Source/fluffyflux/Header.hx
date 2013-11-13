package fluffyflux;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class Header extends Sprite
{
    public function new ()
    {
        super ();

        construct ();
    }

    private function construct ():Void
    {
        var textField = new TextField();
        var format    = new TextFormat("Arial", 20, 0x7A0026);

        format.align = TextFormatAlign.CENTER;

        textField.defaultTextFormat = format;
        textField.selectable        = false;

        textField.x      = 0;
        textField.y      = 0;
        textField.width  = 200;
        textField.height = 30;

        textField.text  = "Fluffy Flux";

        addChild (textField);
    }
}
