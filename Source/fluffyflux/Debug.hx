package fluffyflux;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class Debug extends TextField
{
    public function new ()
    {
        super ();

        this.construct ();
    }

    private function construct (): Void
    {
        this.defaultTextFormat = new TextFormat ("Courier", 16, 0x7A0026);
        this.selectable        = false;

        this.width  = 300;
        this.height = 500;
    }
}
