using Godot;

public partial class InputComponent : Node
{
    public Vector2 MoveDirection { get; private set; }

    public override void _Process(double delta)
    {
        MoveDirection = Input.GetVector("move_left", "move_right", "move_up", "move_down");

    }
}