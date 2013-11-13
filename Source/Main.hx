package;

import flash.display.Sprite;
import flash.events.Event;

class Main extends Sprite
{
    private var background:Sprite;

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
    }

    private function initialize ():Void
    {
        this.background = new Sprite();
    }

    private function resize (newWidth:Int, newHeight:Int):Void
    {
        this.background.graphics.beginFill (0xF2F2F2);
        this.background.graphics.drawRect (0, 0, newWidth, newHeight);
    }

    private function stage_onResize (event:Event):Void
    {
        resize (stage.stageWidth, stage.stageHeight);
    }
}
