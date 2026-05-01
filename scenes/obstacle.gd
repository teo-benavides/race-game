extends Node3D

func play_whoosh():
    $WhooshSFX.play()

func _on_passby_body_body_entered(body: Node3D) -> void:
    #play_whoosh()
    pass
