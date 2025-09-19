import numpy as np
a = np.arange(10, dtype=np.int32)
print( a )
np.save("array.npy", a)
m = np.matrix([[1, 2], [3, 4]])
print( m )
np.save("matrix.npy" , m)

m = np.array([
    [[1, 2, 3],
     [4, 5, 6]],

    [[7, 8, 9],
     [10, 11, 12]]
])

print(m)
print("Shape:", m.shape)
np.save("m3d.npy",m)

# Create a 3D array (2x3x4)
m = np.arange(24).reshape((2, 3, 4))
print("Shape:", m.shape)

# Save to file
np.save("m3d2.npy", m )

f=np.arange(14 , dtype=np.float32)
print( f )
np.save( "f32.npy" , f)