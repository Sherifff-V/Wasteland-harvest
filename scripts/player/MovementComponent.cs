using Godot;

public partial class MovementComponent : Node
{
    [Export] public float Speed = 180f;
    [Export] public float Acceleration = 1200f;
    [Export] public float Friction = 800f;

    float timeSinceStart = 0.5f;

    public void Move(CharacterBody2D body, Vector2 direction, double delta)
    {
        float rate = direction == Vector2.Zero ? Friction : Acceleration;

        float stopDelta = rate * (float)delta;
        
        if (direction == Vector2.Zero)
        {
            timeSinceStart = 0.5f;
        }
        else
        {
            timeSinceStart = Mathf.Min(timeSinceStart + (float)delta, 1f);

            float speedChangeModifier = timeSinceStart * timeSinceStart;
            stopDelta *= speedChangeModifier;
        }


        Vector2 target = direction * Speed;

        body.Velocity = body.Velocity.MoveToward(target, stopDelta);
        body.MoveAndSlide();
    }
}