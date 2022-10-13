var h = "I'm getting loaded, yay!";

function create()
{
    trace(h);
}

function beatHit(curBeat:Int)
{
    switch(curBeat)
    {
        case 4:
            trace("HELLO IM BEAT 4!");
        case 8:
            trace("HELLO IM BEAT 8!");
    }
}

function stepHit(curStep:Int)
{
    switch(curStep)
    {
        case 16:
            trace("HELLO IM STEP 16!");
        case 32:
            trace("HELLO IM STEP 32!");
    }
}

