#ifndef BLACK_HOLE_H
#define BLACK_HOLE_H

class SandSimulation;

#include "element.h"

class BlackHole: public Element {
public:
    const double GRAB = 1.0 / 32;
    const double PROCESS = 1.0 / 64;

    void process(SandSimulation *sim, int row, int col) override {
        if (sim->randf() < PROCESS) {
            return;
        }
        for (int y = row - 1; y <= row + 1; y++) {
            for (int x = col - 1; x <= col + 1; x++) {
                if (sim->in_bounds(y, x) && sim->get_cell(y, x) != 29) {
                    sim->set_cell(y, x, 0);
                }
            }
        }
        if (sim->cardinal_touch_count(row, col, 0) == 0) {
            return;
        }
        for (int y = row - 5; y <= row + 5; y++) {
            for (int x = col - 5; x <= col + 5; x++) {
                if (sim->randf() >= GRAB) {
                    continue;
                }
                if (!sim->in_bounds(y, x) || sim->get_cell(y, x) == 29) {
                    continue;
                }
                
                int dirRow = row - y < 0 ? -1 : 1;
                int dirCol = col - x < 0 ? -1 : 1;
                if (row == y) dirRow = 0;
                if (col == x) dirCol = 0;
                sim->move_and_swap(y, x, y + dirRow, x + dirCol);
            }
        }
    }

    double get_density() override {
        return 1000000.0;
    }

    double get_explode_resistance() override {
        return 10.0;
    }

    double get_acid_resistance() override {
        return 10.0;
    }
};

#endif // BLACK_HOLE_H