extends CharacterBody3D

signal died
signal respawned
signal finished_track
signal boosted

const FLASH_INTERVAL = 0.2

var invincible := false
var flash_cooldown: float = 0.0

func _physics_process(delta: float) -> void:
    if invincible and flash_cooldown <= 0.0:
        %Model.visible = !%Model.visible
    
    flash_cooldown -= FLASH_INTERVAL * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body is Goal:
        finished_track.emit()
    elif body is Boost:
        boosted.emit()
    else:
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
