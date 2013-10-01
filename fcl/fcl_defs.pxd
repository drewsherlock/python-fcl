from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "Python.h":
       ctypedef struct PyObject
       void Py_INCREF(PyObject *obj)
       void Py_DECREF(PyObject *obj)

cdef extern from "boost/shared_ptr.hpp" namespace "boost":
    cppclass shared_ptr[T]:
        shared_ptr() except +
        shared_ptr(T*) except +
        T* get()

cdef extern from "fcl/data_types.h" namespace "fcl":
    ctypedef double FCL_REAL

cdef extern from "fcl/math/vec_3f.h" namespace "fcl":
    cdef cppclass Vec3f:
        Vec3f() except +
        Vec3f(FCL_REAL x, FCL_REAL y, FCL_REAL z) except +
        FCL_REAL& operator[](size_t i)

cdef extern from "fcl/math/matrix_3f.h" namespace "fcl":
    cdef cppclass Matrix3f:
        Matrix3f() except +
        Matrix3f(FCL_REAL xx, FCL_REAL xy, FCL_REAL xz,
                 FCL_REAL yx, FCL_REAL yy, FCL_REAL yz,
                 FCL_REAL zx, FCL_REAL zy, FCL_REAL zz) except +
        FCL_REAL operator()(size_t i, size_t j)

cdef extern from "fcl/math/transform.h" namespace "fcl":
    cdef cppclass Quaternion3f:
        Quaternion3f() except +
        Quaternion3f(FCL_REAL a, FCL_REAL b,
                     FCL_REAL c, FCL_REAL d) except +
        void fromRotation(Matrix3f& R)
        void fromAxisAngle(Vec3f& axis, FCL_REAL angle)
        FCL_REAL& getW()
        FCL_REAL& getX()
        FCL_REAL& getY()
        FCL_REAL& getZ()

    cdef cppclass Transform3f:
        Transform3f() except +
        Transform3f(Matrix3f& R_, Vec3f& T_)
        Transform3f(Quaternion3f& q_, Vec3f& T_)

cdef extern from "fcl/collision_object.h" namespace "fcl":
    cdef enum OBJECT_TYPE:
        OT_UNKNOWN, OT_BVH, OT_GEOM, OT_OCTREE, OT_COUNT
    cdef enum NODE_TYPE:
        BV_UNKNOWN, BV_AABB, BV_OBB, BV_RSS, BV_kIOS, BV_OBBRSS, BV_KDOP16, BV_KDOP18, BV_KDOP24,
        GEOM_BOX, GEOM_SPHERE, GEOM_CAPSULE, GEOM_CONE, GEOM_CYLINDER, GEOM_CONVEX, GEOM_PLANE,
        GEOM_HALFSPACE, GEOM_TRIANGLE, GEOM_OCTREE, NODE_COUNT

    cdef cppclass CollisionGeometry:
        CollisionGeometry() except +
        OBJECT_TYPE getObjectType()
        NODE_TYPE getNodeType()
        void computeLocalAABB()

    cdef cppclass CollisionObject:
        CollisionObject() except +
        CollisionObject(shared_ptr[CollisionGeometry]& cgeom_) except +
        CollisionObject(shared_ptr[CollisionGeometry]& cgeom_, Transform3f& tf) except +
        OBJECT_TYPE getObjectType()
        NODE_TYPE getNodeType()

cdef extern from "fcl/shape/geometric_shapes.h" namespace "fcl":
    cdef cppclass ShapeBase(CollisionGeometry):
        ShapeBase() except +

    cdef cppclass Box(ShapeBase):
        Box(FCL_REAL x, FCL_REAL y, FCL_REAL z) except +
        Vec3f side

    cdef cppclass Sphere(ShapeBase):
        Sphere(FCL_REAL radius_) except +
        FCL_REAL radius

    cdef cppclass Capsule(ShapeBase):
        Capsule(FCL_REAL radius_, FCL_REAL lz_) except +
        FCL_REAL radius
        FCL_REAL lz

    cdef cppclass Cone(ShapeBase):
        Cone(FCL_REAL radius_, FCL_REAL lz_) except +
        FCL_REAL radius
        FCL_REAL lz

    cdef cppclass Cylinder(ShapeBase):
        Cylinder(FCL_REAL radius_, FCL_REAL lz_) except +
        FCL_REAL radius
        FCL_REAL lz

    cdef cppclass Convex:
        Convex(Vec3f* plane_nomals_,
               FCL_REAL* plane_dis_,
               int num_planes,
               Vec3f* points_,
               int num_points_,
               int* polygons_) except +

cdef extern from "fcl/broadphase.h" namespace "fcl":
    ctypedef bool (*CollisionCallBack)(CollisionObject* o1, CollisionObject* o2, void* cdata)
    ctypedef bool (*DistanceCallBack)(CollisionObject* o1, CollisionObject* o2, void* cdata, FCL_REAL& dist)

cdef extern from "fcl/broadphase/broadphase_dynamic_AABB_tree.h" namespace "fcl":
    cdef cppclass DynamicAABBTreeCollisionManager:
        DynamicAABBTreeCollisionManager() except +
        void registerObjects(vector[CollisionObject*]& other_objs)
        void registerObject(CollisionObject* obj)
        void unregisterObject(CollisionObject* obj)
        void collide(CollisionObject* obj, void* cdata, CollisionCallBack callback)
        void distance(CollisionObject* obj, void* cdata, DistanceCallBack callback)
        void setup()
        void update()
        void clear()
        bool empty()
        size_t size()