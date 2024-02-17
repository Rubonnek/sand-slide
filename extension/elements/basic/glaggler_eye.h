#ifndef GLAGGLER_H
#define GLAGGLER_H

#include "../element.h"

class GlagglerEye: public Element {
public:
    const double DECAY = 1.0 / 2048;

    void process(SandSimulation *sim, int row, int col) override {
        if (sim->randf() < DECAY) {
            sim->set_cell(row, col, 177);
        } 
    }

    double get_density() override {
        return 129.0;
    }

    double get_explode_resistance() override {
        return 1.0;
    }

    double get_acid_resistance() override {
        return 1.0;
    }

    int get_state() override {
        return 0;
    }

    int get_temperature() override {
        return 1;
    }

    int get_toxicity() override {
        return 1;
    }
};

#endif // GLAGGLER_H