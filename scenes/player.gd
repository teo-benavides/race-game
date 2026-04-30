extends CharacterBody3D

signal died
signal respawned

const FLASH_INTERVAL = 0.2

var invincible := false
var flash_cooldown: float = 0.0

func _physics_process(delta: float) -> void:
    if invincible and flash_cooldown <= 0.0:
        %Model.visible = !%Model.visible
    
    flash_cooldown -= FLASH_INTERVAL * delta

func _on_area_3d_body_entered(_body: Node3D) -> void:
    $DeathParticles.emitting = true
    %Model.visible = false
    $Area3D.monitoring = false
    $RespawnTimer.start()
    died.emit()

func _on_respawn_timer_timeout() -> void:
    invincible = true
    $InvincibilityTimer.start()
    respawned.emit()

func _on_invincibility_timer_timeout() -> void:
    invincible = false
    %Model.visible = true
    $Area3D.monitoring = true
