package io.sourcya.playx_3d_scene.core.shape.common.model

import com.google.android.filament.Box
import com.google.android.filament.utils.Float2
import com.google.android.filament.utils.Float3
import com.google.android.filament.utils.Mat4
import com.google.android.filament.utils.Quaternion
import com.google.android.filament.utils.rotation
import io.sourcya.playx_3d_scene.core.utils.Color
import io.sourcya.playx_3d_scene.utils.gson


data class Vertex(val position: Position = Position(),
                  val normal: Direction? =null,
                  val uvCoordinates: UVCoordinates? = null,
                  val color: Color? = null
)

typealias Position = Float3
typealias Direction = Float3
typealias Size = Float3


typealias UVCoordinates = Float2

fun convertJsonToPosition(map:Map<String?,Any?>?): Position? {
    if(map == null) return null
    val json= gson.toJson(map)
    return gson.fromJson(json, Position::class.java)
}

fun convertJsonToSize(map:Map<String?,Any?>?): Size? {
    if(map == null) return null
    val json= gson.toJson(map)
    return gson.fromJson(json, Size::class.java)
}

fun convertJsonToDirection(map:Map<String?,Any?>?): Direction? {
    if(map == null) return null
    val json= gson.toJson(map)
    return gson.fromJson(json, Direction::class.java)
}

data class Submesh(val triangleIndices: List<Int>) {
    constructor(vararg triangleIndices: Int) : this(triangleIndices.toList())
}
fun FloatArray.toFloat3() = this.let { (x, y, z) -> Float3(x, y, z) }

fun Box(center: Position, halfExtent: Size) = Box(center.toFloatArray(), halfExtent.toFloatArray())

var Box.centerPosition: Position
    get() = center.toPosition()
    set(value) {
        setCenter(value.x, value.y, value.z)
    }
var Box.halfExtentSize: Size
    get() = halfExtent.toSize()
    set(value) {
        setHalfExtent(value.x, value.y, value.z)
    }
var Box.size
    get() = halfExtentSize * 2.0f
    set(value) {
        halfExtentSize = value / 2.0f
    }


fun FloatArray.toPosition() = this.let { (x, y, z) -> Position(x, y, z) }
fun FloatArray.toSize() = this.let { (x, y, z) -> Size(x, y, z) }

typealias Transform = Mat4

fun Mat4.toDoubleArray() : DoubleArray = toFloatArray().map { it.toDouble() }.toDoubleArray()
val Mat4.quaternion: Quaternion get() = rotation(this).toQuaternion()
