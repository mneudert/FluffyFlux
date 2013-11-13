package;

import flash.display.Sprite;
import flash.events.Event;

import fluffyflux.Game;
import fluffyflux.Header;

class Main extends Sprite
{
    private var background:Sprite;
    private var game:Game;
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

        this.game.y = this.header.y + this.header.height + 25;
        addChild (this.game);
    }

    private function initialize ():Void
    {
        this.background = new Sprite();
        this.game       = new Game();
        this.header     = new Header();
    }

    private function resize (newWidth:Int, newHeight:Int):Void
    {
        this.background.graphics.beginFill (0xF2F2F2);
        this.background.graphics.drawRect (0, 0, newWidth, newHeight);

        this.header.x = newWidth / 2 - this.header.width / 2;

        this.game.resize (newWidth, Std.int(newHeight - this.header.y - this.header.height - 50));
    }

    private function stage_onResize (event:Event):Void
    {
        resize (stage.stageWidth, stage.stageHeight);
    }
}
