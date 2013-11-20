package fluffyflux;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class GamePoints extends TextField
{
    private var points: Int;

    public function new ()
    {
        super ();

        this.construct ();
    }

    public function addPoints (points: Int): Void
    {
        this.points += points;
        this.text    = "Points: " + this.points;
    }

    private function construct (): Void
    {
        var format = new TextFormat ("Arial", 20, 0x7A0026);

        format.align = TextFormatAlign.CENTER;

        this.defaultTextFormat = format;
        this.selectable        = false;
        this.width             = 200;
        this.height            = 30;

        this.points = 0;
        this.text   = "Points: 0";
    }
}
