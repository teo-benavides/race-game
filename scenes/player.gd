extends CharacterBody3D
class_name Player

signal died
signal respawned
signal finished_track
signal boosted

var thruster_scale_curve: Curve = preload("res://resources/thruster_scale_curve.tres")
var thruster_light_curve: Curve = preload("res://resources/thruster_light_curve.tres")

const FLASH_INTERVAL = 0.2
const MIN_ENGINE_SFX_PITCH := 1.0
const MAX_ENGINE_SFX_PITCH := 3.0
const MAX_THRUSTER_SCALE := 1.0

var invincible := false
var flash_cooldown: float = 0.0
var _engine_power: float = 0.0
var engine_power: float:
    set(value):
        _engine_power = value
        $EngineSFX.pitch_scale = lerpf(MIN_ENGINE_SFX_PITCH, MAX_ENGINE_SFX_PITCH, _engine_power)
        #$Thruster1.get_surface_override_material(0).set_shader_parameter("reveal", lerp(0.757, 0.515, _engine_power))
        #var old_pos = $Thruster1.position 
        if _engine_power == 0.0:
            $Thruster1.visible = false
            $Thruster2.visible = false
        else:
            $Thruster1.visible = true
            $Thruster2.visible = true
            $Thruster1.scale.y = thruster_scale_curve.sample(_engine_power)
            $Thruster2.scale.y = thruster_scale_curve.sample(_engine_power)
        $OmniLight3D.omni_range = thruster_light_curve.sample(_engine_power)
        $OmniLight3D2.omni_range = thruster_light_curve.sample(_engine_power)
        #$Thruster1.position = old_pos
        #$Thruster1.scale_object_local(Vector3(1.0, _engine_power + 0.001, 1.0))
    get():
        return _engine_power

func _physics_process(delta: float) -> void:
    if invincible and flash_cooldown <= 0.0:
        %Model.visible = !%Model.visible
    
    flash_cooldown -= FLASH_INTERVAL * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Goal:
        $EngineSFX.stop()
        finished_track.emit()
    elif body.name == "PassbyBody":
        #$PassbySFX.play()
        pass
    else:
        $DeathSFX.play()
        $Explosion00/Sparks.emitting = true
        $Explosion00/Flash.emitting = true
        $Explosion00/Burn.emitting = true
        $Explosion00/SmokeUranium.emitting = true
        %Model.visible = false
        $Area3D.set_deferred("monitoring", false)
        $RespawnTimer.start()
        died.emit()

func _on_respawn_timer_timeout() -> void:
    invincible = true
    $InvincibilityTimer.start()
    respawned.emit()

func _on_invincibility_timer_timeout() -> void:
    invincible = false
    %Model.visible = true
    $Area3D.set_deferred("monitoring", true)

func _on_boost_area_body_entered(_body: Node3D) -> void:
    boosted.emit()
    $BoostSFX.play()
