word_size = 32
num_words = 256

local_array_size = 32

num_rw_ports = 0
num_r_ports = 1
num_w_ports = 1

tech_name = "freepdk45"
nominal_corner_only = False
# supply_voltages = [0.95, 1.1, 1.25]
# process_corners = ["TT"]

route_supplies = False
check_lvsdrc = True
perimeter_pins = False
#netlist_only = True
#analytical_delay = False

use_specified_corners = [
  ("TT", 1.1, 25),
  ("SS", 0.95, 125),
  ("FF", 1.25, 0)
]


output_name = "sram_{0}rw{1}r{2}w_{3}_{4}_{5}".format(num_rw_ports,
                                                      num_r_ports,
                                                      num_w_ports,
                                                      word_size,
                                                      num_words,
                                                      tech_name)
output_path = "macro/{}".format(output_name)
