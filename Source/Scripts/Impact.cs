using Godot;
using System;

public partial class Impact : MeshInstance3D
{
    [Export]
    Curve mAnimCurve, mImpactCurve;
    [Export]
    private float mAnimTime = 1.0f;
    private float mEnlapsedtime;
    private ShaderMaterial mMaterial;

    private bool mAnimate = false;

    public override void _Ready()
    {
        mEnlapsedtime = 0.0f;
        mMaterial = (ShaderMaterial)this.GetActiveMaterial(0);
        base._Ready();
    }

    private void SetImpactOrigin(Vector3 pos) 
    {
        mMaterial.SetShaderParameter("_impact_origin", pos);
        mMaterial.SetShaderParameter("_impact_anim", 0.0f);
        mAnimate = true;
        mEnlapsedtime = 0.0f;
    }

    private void OnArea3DInputEvent(Camera3D camera, InputEvent @event, Vector3 position, Vector3 normal, int shape_idx) 
    {
        if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed)
        {
            switch (mouseEvent.ButtonIndex)
            {
                case MouseButton.Left:
                    SetImpactOrigin(position);
                    break;
                default:
                    break;
            }
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        if (mAnimate)
        {
            if (mEnlapsedtime < mAnimTime)
            {
                float normalizeTime = mEnlapsedtime / mAnimTime;
                mMaterial.SetShaderParameter("_impact_blend", mAnimCurve.Sample(normalizeTime));
                mMaterial.SetShaderParameter("_impact_anim", mImpactCurve.Sample(normalizeTime));
                mEnlapsedtime += (float)delta;
            }
            else 
            {
                mMaterial.SetShaderParameter("_impact_blend", 0.0f);
                mMaterial.SetShaderParameter("_impact_anim", 0.0f);
                mEnlapsedtime = 0.0f;
                mAnimate = false;
            }
        }
        base._PhysicsProcess(delta);
    }
}
