#ifndef STORM_PLASMA_H
#define STORM_PLASMA_H

class SandSimulation;

#include "element.h"

class StormPlasma: public Element {
public:
    const double DECAY = 1.0 / 16;
    const double FALL = 1.0 / 4;

    void process(SandSimulation *sim, int row, int col) override {
        if (sim->randf() < DECAY) {
            sim->set_cell(row, col, 6);
        }
        if (sim->randf() >= FALL) {
            return;
        }
        int dir = (int) (sim->randf() * 3) - 1;
        if (dir != 0) {
            sim->move_and_swap(row, col, row, col + dir);
        } else {
            sim->move_and_swap(row, col, row + 1, col);
        }
    }

    double get_density() override {
        return 5.0;
    }

    double get_explode_resistance() override {
        return 0.8;
    }

    double get_acid_resistance() override {
        return 0.45;
    }
};

#endif // STORM_PLASMA_H