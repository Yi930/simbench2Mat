import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os

import pandapower as pp
import pandapower.topology as top
import pandapower.plotting as plot
import simbench as sb

sb_code = "1-complete_data-mixed-all-0-sw"  # rural MV grid of scenario 0 with full switchs
net = sb.get_simbench_net(sb_code)

lines = [net.line['from_bus'].tolist(), net.line['to_bus'].tolist()]
buses = net.bus
# loads = net.load
geoData = [net.bus_geodata['x'].tolist(), net.bus_geodata['y'].tolist()]
loads = net.load.bus.tolist()
gens = net.gen.bus.tolist()

pp.runpp(net)
p_mw = net.res_bus.p_mw.to_list()
q_mvar = net.res_bus.q_mvar.tolist()
