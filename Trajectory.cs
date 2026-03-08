using Godot;

public partial class Trajectory : GodotObject
{
	public Vector2 Position;
	public Vector2 TargetPos;
	public Vector2 DeltaPos;
	public float Direction = 1f;
	public float StepMagnitude = 1f;
	public Node2D Parent;

	public static float GetAngleFromComponents(Vector2 pos)
	{
		return Mathf.Atan2(pos.Y, pos.X);
	}

	public static float GetXComponent(float value)
	{
		return Mathf.Cos(value);
	}

	public static float GetYComponent(float value)
	{
		return Mathf.Sin(value);
	}

	public void SteerTowardsTransform(float steeringMagnitude)
	{
		float targetDirection = GetAngleFromComponents(TargetPos - Position);

		Direction = GetAngleFromComponents(new Vector2(
			Mathf.Lerp(GetXComponent(Direction), GetXComponent(targetDirection), steeringMagnitude),
			Mathf.Lerp(GetYComponent(Direction), GetYComponent(targetDirection), steeringMagnitude)
		));
	}

	public void Foward()
	{
		DeltaPos += new Vector2(
			GetXComponent(Direction) * StepMagnitude,
			GetYComponent(Direction) * StepMagnitude
		);

		Parent.DrawLine(Position, DeltaPos, Colors.White, 1);

		Position = DeltaPos;
	}
}
