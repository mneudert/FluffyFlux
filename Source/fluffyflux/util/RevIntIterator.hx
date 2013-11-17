package fluffyflux.util;

class RevIntIterator
{
    var min: Int;
    var max: Int;

    public function new (max: Int, min: Int)
    {
        this.min = min;
        this.max = max;
    }

    public function hasNext()
    {
        return (max > min);
    }

    public function next() {
        return max--;
    }
}
