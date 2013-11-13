package;

import flash.display.Sprite;
import flash.events.Event;

import fluffyflux.Header;

class Main extends Sprite
{
    private var background:Sprite;
    private var header:Header;

    public function new ()
    {
        super ();

        initialize ();
        construct ();

        resize (stage.stageWidth, stage.stageHeight);
        stage.addEventListener (Event.RESIZE, stage_onResize);
    }

    private function construct ():Void
    {
        addChild (this.background);

        this.header.y = 25;
        addChild (this.header);
    }

    private function initialize ():Void
    {
        this.background = new Sprite();
        this.header     = new Header();
    }

    private function resize (newWidth:Int, newHeight:Int):Void
    {
        this.background.graphics.beginFill (0xF2F2F2);
        this.background.graphics.drawRect (0, 0, newWidth, newHeight);

        this.header.x = newWidth / 2 - this.header.width / 2;
    }

    private function stage_onResize (event:Event):Void
    {
        resize (stage.stageWidth, stage.stageHeight);
    }
}
