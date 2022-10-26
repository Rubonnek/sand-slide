#ifndef ELEMENT_H
#define ELEMENT_H

class SandSimulation;

#include "../sand_simulation.h"

class Element {
public:
    virtual void process(SandSimulation *sim, int row, int col) = 0;
    virtual double get_density() = 0;
};

#endif // ELEMENT_H