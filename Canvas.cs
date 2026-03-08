using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class Canvas : Node2D
{
	private static ulong _FrameCount;

	[Export] public int Side = 30;
	[Export] public float Spacing = 0.4f;

	public List<Trajectory> Children = [];

	public override void _Ready()
	{
		RenderingServer.ViewportSetClearMode(
			GetViewport().GetViewportRid(),
			RenderingServer.ViewportClearMode.Never
		);

		Vector2 viewportSize = GetViewportRect().Size;

		Spacing = Spacing * viewportSize.X / Side;

		int startNum = -Math.Abs(Side);
		int i = startNum;
		int endNum = Math.Abs(Side) + 1;

		while (i < endNum)
		{
			int j = startNum;

			while (j < endNum)
			{
				var pos = new Vector2(i * Spacing, j * Spacing);
				var traj = new Trajectory
				{
					Position = pos,
					TargetPos = pos,
					DeltaPos = pos,
					Parent = this
				};

				Children.Add(traj);

				j += 1;
			}

			i += 1;
		}
	}

	public override void _Process(double delta)
	{
		_FrameCount = Engine.GetProcessFrames();
		QueueRedraw();
	}

	public override void _Draw()
	{
		Fill(Color.Color8(0, 0, 0, 10));

		foreach (var child in Children)
		{
			child.TargetPos = new Vector2(
				TransformationSequence(child.Position.X + Mathf.Cos(_FrameCount * 0.5f) * 50),
				TransformationSequence(child.Position.Y + Mathf.Sin(_FrameCount * 0.5f) * 50)
			);

			child.SteerTowardsTransform(1);
			child.Foward();
		}
	}

	public void Fill(Color color)
	{
		Vector2 viewportSize = GetViewportRect().Size;

		DrawRect(new Rect2(
			Position - viewportSize / 2,
			viewportSize
		), color);
	}

	public static List<T> RotateArray<T>(List<T> arr, int steps)
	{
		int n = arr.Count;
		int s = ((steps % n) + n) % n;

		return [.. arr[s..], .. arr[..s]];
	}

	public static float ShiftFloat(float num, int steps)
	{
		string numStr = Math.Abs(num).ToString();
		var splitted = numStr.Split('.');

		string intPart = splitted[0];
		string fracPart = splitted.Length > 1 ? splitted[1] : "";

		int decimalIndex = intPart.Length;

		List<char> digits = [.. (intPart + fracPart).ToCharArray()];

		List<char> rotated;

		if (steps < 0)
		{
			int r = Math.Abs(steps);
			rotated = RotateArray(digits, digits.Count - (r % digits.Count));
		}
		else
		{
			rotated = RotateArray(digits, steps);
		}

		string newStr =
			string.Concat(rotated.Take(decimalIndex)) +
			"." +
			string.Concat(rotated.Skip(decimalIndex));

		float result = float.Parse(newStr);

		if (num < 0)
			result *= -1;

		return result;
	}

	public static float TransformationSequence(float num)
	{
		float result = 0;

		for (int i = 0; i < 6; i++)
		{
			result += ShiftFloat(num, i);
		}

		result /= 12;

		return result;
	}
}
