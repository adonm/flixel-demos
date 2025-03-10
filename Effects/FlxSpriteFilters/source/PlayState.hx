package;

import openfl.filters.DisplacementMapFilterMode;
import openfl.utils.Assets;
import openfl.filters.DisplacementMapFilter;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxFilterFrames;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import openfl.geom.Point;

#if flash
import flash.filters.BevelFilter;
import flixel.tweens.FlxEase;
#end

class PlayState extends FlxState
{
	static inline var SIZE_INCREASE:Int = 50;

	var spr1:FlxSprite;
	var spr2:FlxSprite;
	var spr3:FlxSprite;
	var spr4:FlxSprite;
	var spr5:FlxSprite;
	var spr6:FlxSprite;

	var txt1:FlxText;
	var txt2:FlxText;
	var txt3:FlxText;
	var txt4:FlxText;
	var txt5:FlxText;
	var txt6:FlxText;

	var isAnimSpr1:Bool;
	var isAnimSpr2:Bool;
	var isAnimSpr3:Bool;
	var isAnimSpr4:Bool;
	var isAnimSpr5:Bool;
	var isAnimSpr6:Bool;

	var spr2Filter:FlxFilterFrames;
	var spr3Filter:FlxFilterFrames;
	var spr4Filter:FlxFilterFrames;
	var spr5Filter:FlxFilterFrames;
	var spr6Filter:FlxFilterFrames;

	var tween2:FlxTween;
	var tween3:FlxTween;
	var tween5:FlxTween;

	var dropShadowFilter:DropShadowFilter;
	var displacementFilter:DisplacementMapFilter;

	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF01355F;

		var txt:FlxText = new FlxText(0, 10, 640, " Sprite filters - click on each sprite to animate or stop animation. ", 8);
		txt.alignment = CENTER;
		add(txt);

		spr1 = createSprite(0.25, -100, "No filter");
		spr1.antialiasing = true;

		var glowFilter = new GlowFilter(0xFF0000, 1, 50, 50, 1.5, 1);
		spr2 = createSprite(0.5, -100, "Glow");
		spr2Filter = createFilterFrames(spr2, glowFilter);
		tween2 = FlxTween.tween(glowFilter, {blurX: 4, blurY: 4}, 1, {type: PINGPONG});
		tween2.active = false;

		var blurFilter = new BlurFilter();
		spr3 = createSprite(0.75, -100, "Blur");
		spr3Filter = createFilterFrames(spr3, blurFilter);
		tween3 = FlxTween.tween(blurFilter, {blurX: 50, blurY: 50}, 1.5, {type: PINGPONG});
		tween3.active = false;

		dropShadowFilter = new DropShadowFilter(10, 45, 0, .75, 10, 10, 1, 1);
		spr4 = createSprite(0.25, 100, "Drop Shadow");
		spr4Filter = createFilterFrames(spr4, dropShadowFilter);

		#if flash
		var bevelFilter = new BevelFilter(6);
		spr5 = createSprite(0.5, 100, "Bevel\n(flash only)");
		spr5Filter = createFilterFrames(spr5, bevelFilter);
		tween5 = FlxTween.tween(bevelFilter, {distance: -6}, 1.5, {type: PINGPONG, ease: FlxEase.quadInOut});
		tween5.active = false;
		#end
		
		displacementFilter = new DisplacementMapFilter(Assets.getBitmapData("assets/StaticMap.png"), new Point(0, 0), 1, 1, 15, 1,
			DisplacementMapFilterMode.COLOR, 1, 0);
		spr6 = createSprite(0.75, 100, "Displacement");
		spr6Filter = createFilterFrames(spr6, displacementFilter);
		
	}

	function createSprite(xFactor:Float, yOffset:Float, label:String)
	{
		var sprite = new FlxSprite(FlxG.width * xFactor - SIZE_INCREASE, FlxG.height / 2 + yOffset - SIZE_INCREASE, "assets/logo.png");
		add(sprite);

		var text = new FlxText(sprite.x, sprite.y + 120, sprite.width, label, 10);
		text.alignment = CENTER;
		add(text);

		return sprite;
	}

	function createFilterFrames(sprite:FlxSprite, filter:BitmapFilter)
	{
		var filterFrames = FlxFilterFrames.fromFrames(sprite.frames, SIZE_INCREASE, SIZE_INCREASE, [filter]);
		updateFilter(sprite, filterFrames);
		return filterFrames;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check for animation toggles
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(spr1))
			{
				isAnimSpr1 = !isAnimSpr1;
			}
			else if (FlxG.mouse.overlaps(spr2))
			{
				isAnimSpr2 = !isAnimSpr2;
				tween2.active = isAnimSpr2;
			}
			else if (FlxG.mouse.overlaps(spr3))
			{
				isAnimSpr3 = !isAnimSpr3;
				tween3.active = isAnimSpr3;
			}
			else if (FlxG.mouse.overlaps(spr4))
			{
				isAnimSpr4 = !isAnimSpr4;
			}
			#if flash
			else if (FlxG.mouse.overlaps(spr5))
			{
				isAnimSpr5 = !isAnimSpr5;
				tween5.active = isAnimSpr5;
			}
			#end
			else if (FlxG.mouse.overlaps(spr6))
			{
				isAnimSpr6 = !isAnimSpr6;
			}
		}

		if (isAnimSpr1)
		{
			spr1.angle += 45 * elapsed;
		}
		if (isAnimSpr2)
		{
			spr2.angle += 45 * elapsed;
			updateFilter(spr2, spr2Filter);
		}
		if (isAnimSpr3)
		{
			spr3.angle += 45 * elapsed;
			updateFilter(spr3, spr3Filter);
		}
		if (isAnimSpr4)
		{
			spr4.angle += 45 * elapsed;
			updateDropShadowFilter(elapsed);
		}
		if (isAnimSpr5)
		{
			spr5.angle += 45 * elapsed;
			updateFilter(spr5, spr5Filter);
		}
		if (isAnimSpr6)
		{
			spr6.angle += 45 * elapsed;
			updateDisplaceFilter();
		}
	}

	function updateDisplaceFilter()
	{
		displacementFilter.scaleX = FlxG.random.float(-10, 10);
		displacementFilter.mapPoint = new Point(0, FlxG.random.float(0, 30));
		updateFilter(spr6, spr6Filter);
	}

	function updateDropShadowFilter(elapsed:Float)
	{
		dropShadowFilter.angle -= 360 * elapsed;
		updateFilter(spr4, spr4Filter);
	}

	function updateFilter(spr:FlxSprite, sprFilter:FlxFilterFrames)
	{
		// Reset the offset, it will ballon with each apply call
		spr.offset.set();
		sprFilter.applyToSprite(spr, false, true);
	}
}
