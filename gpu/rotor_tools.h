/* C interface for generator exponentiation and rotor operations */

/* Like the Cg interface rotors are represented as eight-dimensional vectors
 * and generators by six-dimensional vectors. Unlike Cg there are no vector
 * primitive types in C and so appropriately dimensioned arrays of floats are
 * used. */

/* Sets rotor[] to contain the exponentiation of generator[] */
void exp_rotor(float generator[6], float rotor[8]);

/* Sets x to the point the origin is mapped to by rotor[] */
void apply_rotor_to_origin(float rotor[8], float x[3]);

/* Overwrites x with the point x is mapped to by rotor[] */
void apply_rotor(float rotor[8], float x[3]);

