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
const ORIGINAL_LEFT_WHEEL_ROTATION: Vector3 = Vector3(-65.2, -56.3, 24.7)
const ORIGINAL_RIGHT_WHEEL_ROTATION: Vector3 = Vector3(-65.2, 0.0, 27.9)
const WHEEL_ROTATION := 40.0

var invincible := false
var flash_cooldown: float = 0.0
var _engine_power: float = 0.0
var engine_power: float:
    set(value):
        _engine_power = value
        $EngineSFX.pitch_scale = lerpf(MIN_ENGINE_SFX_PITCH, MAX_ENGINE_SFX_PITCH, _engine_power)
        if _engine_power == 0.0:
            %ThrusterLeft.visible = false
            %ThrusterRight.visible = false
        else:
            %ThrusterLeft.visible = true
            %ThrusterRight.visible = true
            %ThrusterLeft.scale.y = thruster_scale_curve.sample(_engine_power)
            %ThrusterRight.scale.y = thruster_scale_curve.sample(_engine_power)
        %OmniLight3D.omni_range = thruster_light_curve.sample(_engine_power)
        %OmniLight3D2.omni_range = thruster_light_curve.sample(_engine_power)
    get():
        return _engine_power

var direction: float:
    set(value):
        if value > 0.0:
            $BackWheelLeft.rotation_degrees.z = lerp(ORIGINAL_LEFT_WHEEL_ROTATION.z, ORIGINAL_LEFT_WHEEL_ROTATION.z - WHEEL_ROTATION, value)
            $BackWheelRight.rotation_degrees.z = ORIGINAL_RIGHT_WHEEL_ROTATION.z
        elif value < 0.0:
            $BackWheelLeft.rotation_degrees.z = ORIGINAL_LEFT_WHEEL_ROTATION.z
            $BackWheelRight.rotation_degrees.z = lerp(ORIGINAL_RIGHT_WHEEL_ROTATION.z, ORIGINAL_RIGHT_WHEEL_ROTATION.z + WHEEL_ROTATION, -value)
        else:
            $BackWheelLeft.rotation_degrees.z = ORIGINAL_LEFT_WHEEL_ROTATION.z
            $BackWheelRight.rotation_degrees.z = ORIGINAL_RIGHT_WHEEL_ROTATION.z

func _ready() -> void:
    $BackWheelLeft.rotation_degrees = ORIGINAL_LEFT_WHEEL_ROTATION
    $BackWheelRight.rotation_degrees = ORIGINAL_RIGHT_WHEEL_ROTATION

func _physics_process(delta: float) -> void:
    if invincible and flash_cooldown <= 0.0:
        %Model.visible = !%Model.visible
        $BackWheelLeft.visible = !$BackWheelLeft.visible
        $BackWheelRight.visible = !$BackWheelRight.visible
        $FrontWheelLeft.visible = !$FrontWheelLeft.visible
        $FrontWheelRight.visible = !$FrontWheelRight.visible
    flash_cooldown -= FLASH_INTERVAL * delta

func _on_hurtbox_body_entered(body: Node3D) -> void:
    #if body is Goal:
        #$EngineSFX.stop()
        #finished_track.emit()
    #elif body.name == "PassbyBody":
        #$PassbySFX.play()
        #pass
    $DeathSFX.play()
    $Explosion00/Sparks.emitting = true
    $Explosion00/Flash.emitting = true
    $Explosion00/Burn.emitting = true
    $Explosion00/SmokeUranium.emitting = true
    %Model.visible = false
    $BackWheelLeft.visible = false
    $BackWheelRight.visible = false
    $FrontWheelLeft.visible = false
    $FrontWheelRight.visible = false
    $Hurtbox.set_deferred("monitoring", false)
    $RespawnTimer.start()
    died.emit()

func _on_respawn_timer_timeout() -> void:
    invincible = true
    $InvincibilityTimer.start()
    respawned.emit()

func _on_invincibility_timer_timeout() -> void:
    invincible = false
    %Model.visible = true
    $BackWheelLeft.visible = true
    $BackWheelRight.visible = true
    $FrontWheelLeft.visible = true
    $FrontWheelRight.visible = true
    $Hurtbox.set_deferred("monitoring", true)

func _on_boost_area_body_entered(_body: Node3D) -> void:
    boosted.emit()
    $BoostSFX.play()

func _on_goal_area_body_entered(body: Node3D) -> void:
    $EngineSFX.stop()
    finished_track.emit()
