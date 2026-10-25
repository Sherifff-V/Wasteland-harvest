using Godot;

public partial class Player : CharacterBody2D
{
    private InputComponent _input;
    private MovementComponent _movement;

    public override void _Ready()
    {
        _input = GetNode<InputComponent>("InputComponent");
        _movement = GetNode<MovementComponent>("MovementComponent");

    }

    public override void _PhysicsProcess(double delta)
    {
        _movement.Move(this, _input.MoveDirection, delta);
    }
}