import graphviz
from opyenxes.data_in.XUniversalParser import XUniversalParser
from functools import reduce

# --- 1. Ładowanie i przetwarzanie logu zdarzeń XES ---
path = 'repairExample.xes'
with open(path) as log_file:
    log = XUniversalParser().parse(log_file)[0]

workflow_log = []
for trace in log:
    workflow_trace = []
    for event in trace:
        # Poprawka: Użycie 'concept:name' dla nazwy zdarzenia
        event_name = event.get_attributes()['concept:name'].get_value()
        workflow_trace.append(event_name)
    workflow_log.append(workflow_trace)

# --- 2. Implementacja prostego heurystycznego górnika ---
w_net = dict()
for w_trace in workflow_log:
    for i in range(0, len(w_trace) - 1):
        ev_i, ev_j = w_trace[i], w_trace[i+1]
        if ev_i not in w_net.keys():
            w_net[ev_i] = set()
        w_net[ev_i].add(ev_j)

# Liczenie częstotliwości zdarzeń
ev_counter = dict()
for w_trace in workflow_log:
    for ev in w_trace:
        ev_counter[ev] = ev_counter.get(ev, 0) + 1

# Liczenie częstotliwości przepływów
flow_counter = dict()
for w_trace in workflow_log:
    for i in range(len(w_trace) - 1):
        flow = (w_trace[i], w_trace[i+1])
        flow_counter[flow] = flow_counter.get(flow, 0) + 1

# --- 3. Funkcja do rysowania sieci heurystycznej ---
def draw_heuristic_net(w_net, ev_counter, flow_counter, filename, min_task_freq=0, min_flow_freq=0):
    # Inicjalizacja grafu Graphviz
    G = graphviz.Digraph(format='png')
    G.graph_attr['rankdir'] = 'LR'
    G.node_attr['shape'] = 'Mrecord'

    color_min = min(ev_counter.values()) if ev_counter else 0
    color_max = max(ev_counter.values()) if ev_counter else 0

    for event in w_net:
        if ev_counter.get(event, 0) < min_task_freq:
            continue

        text = event + ' (' + str(ev_counter[event]) + ")"
        
        if color_max > color_min:
            value = ev_counter[event]
            color_val = int(float(color_max - value) / float(color_max - color_min) * 100.00)
            my_color = "#ff9933" + str(hex(color_val))[2:].zfill(2)
        else:
            my_color = "#ff9933ff"

        G.node(event, label=text, style="rounded,filled", fillcolor=my_color)

        for preceding in w_net[event]:
            flow = (event, preceding)
            if flow_counter.get(flow, 0) < min_flow_freq:
                continue

            flow_freq = flow_counter.get(flow, 0)
            edge_label = str(flow_freq)
            
            if flow_counter:
                max_flow_freq = max(flow_counter.values())
                min_flow_freq_val = min(flow_counter.values())
                if max_flow_freq > min_flow_freq_val:
                    penwidth = 1 + 4 * (flow_freq - min_flow_freq_val) / (max_flow_freq - min_flow_freq_val)
                else:
                    penwidth = 1
            else:
                penwidth = 1

            G.edge(event, preceding, label=edge_label, penwidth=str(penwidth))

    ev_source = set(w_net.keys())
    ev_target = reduce(lambda x,y: x|y, w_net.values()) if w_net.values() else set()
    ev_start_set = ev_source - ev_target
    ev_end_set = ev_target - ev_source

    for ev_end in ev_end_set:
        if ev_counter.get(ev_end, 0) >= min_task_freq:
            G.node(ev_end, shape='circle', label='', style='rounded,filled', fillcolor='#ffffcc')

    if any(ev_counter.get(ev, 0) >= min_task_freq for ev in ev_start_set):
        G.node("start", shape="circle", label="")
        for ev_start in ev_start_set:
            if ev_counter.get(ev_start, 0) >= min_task_freq:
                G.edge("start", ev_start)

    base_filename = filename.rsplit('.', 1)[0]
    G.render(base_filename, view=False, cleanup=True)

# Generowanie diagramów heurystycznych
draw_heuristic_net(w_net, ev_counter, flow_counter, 'simple_heuristic_net_extended.png')
print("Wygenerowano 'simple_heuristic_net_extended.png' z częstotliwościami zadań i przejść.")

draw_heuristic_net(w_net, ev_counter, flow_counter, 'simple_heuristic_net_filtered.png', min_task_freq=5, min_flow_freq=2)
print("Wygenerowano 'simple_heuristic_net_filtered.png' z filtrowaniem (min. częstotliwość zadania: 5, min. częstotliwość przepływu: 2).")

# --- 4. Implementacja uproszczonego algorytmu Alfa ---
print("\n--- Uproszczony algorytm Alfa ---")

# Przykładowe dane dla algorytmu Alfa
direct_succession = {
    'a': {'b','c'}, 'b': {'c','d'}, 'c': {'b','d'},
    'd': {'e','f'}, 'e': {'g'}, 'f': {'g'}
}
causality = {
    'a': {'b', 'c'}, 'b': {'d'}, 'c': {'d'},
    'd': {'e','f'}, 'e': {'g'}, 'f': {'g'}
}
parallel_events = {('b', 'c'), ('c', 'b')}
start_set_events = {'a'}
end_set_events = {'g'}
inv_causality = {
    'd': {'b', 'c'},
    'g': {'e', 'f'}
}

# Klasa do tworzenia grafów BPMN z bramkami
class MyGraph(graphviz.Digraph):
    def __init__(self, *args):
        super(MyGraph, self).__init__(*args)
        self.graph_attr['rankdir'] = 'LR'
        self.node_attr['shape'] = 'Mrecord'
        self.graph_attr['splines'] = 'ortho'
        self.graph_attr['nodesep'] = '0.8'
        self.edge_attr.update(penwidth='2')

    def add_event(self, name):
        super(MyGraph, self).node(name, shape="circle", label="")

    def add_and_gateway(self, name, *args):
        super(MyGraph, self).node(name, shape="diamond", width=".6", height=".6",
                                  fixedsize="true", fontsize="40", label="+")

    def add_xor_gateway(self, name, *args):
        super(MyGraph, self).node(name, shape="diamond", width=".6", height=".6",
                                  fixedsize="true", fontsize="35", label="×")

    def add_and_split_gateway(self, source, targets, *args):
        gateway = 'ANDs ' + str(source) + '->' + str(sorted(list(targets)))
        self.add_and_gateway(gateway, *args)
        super(MyGraph, self).edge(source, gateway)
        for target in targets:
            super(MyGraph, self).edge(gateway, target)

    def add_xor_split_gateway(self, source, targets, *args):
        gateway = 'XORs ' + str(source) + '->' + str(sorted(list(targets)))
        self.add_xor_gateway(gateway, *args)
        super(MyGraph, self).edge(source, gateway)
        for target in targets:
            super(MyGraph, self).edge(gateway, target)

    def add_and_merge_gateway(self, sources, target, *args):
        gateway = 'ANDm ' + str(sorted(list(sources))) + '->' + str(target)
        self.add_and_gateway(gateway, *args)
        super(MyGraph, self).edge(gateway, target)
        for source in sources:
            super(MyGraph, self).edge(source, gateway)

    def add_xor_merge_gateway(self, sources, target, *args):
        gateway = 'XORm ' + str(sorted(list(sources))) + '->' + str(target)
        self.add_xor_gateway(gateway, *args)
        super(MyGraph, self).edge(gateway, target)
        for source in sources:
            super(MyGraph, self).edge(source, gateway)

# Tworzenie grafu dla algorytmu Alfa
G_alpha = MyGraph()
G_alpha.comment = 'Alpha Algorithm Process Model'

# Dodawanie węzłów aktywności
all_events = set(direct_succession.keys())
for event in all_events:
    is_source_of_split = len(causality.get(event, {})) > 1
    is_target_of_merge = any(event in targets and len(targets) > 1 for targets in inv_causality.values())
    if not is_source_of_split and not is_target_of_merge:
        G_alpha.node(event, style="rounded,filled", fillcolor="#ffffcc")

# Dodawanie bramek rozdzielających
for event in causality:
    if len(causality[event]) > 1:
        if tuple(sorted(list(causality[event]))) in parallel_events:
            G_alpha.add_and_split_gateway(event, causality[event])
        else:
            G_alpha.add_xor_split_gateway(event, causality[event])
    elif len(causality[event]) == 1:
        target_event = list(causality[event])[0]
        if target_event not in inv_causality or len(inv_causality[target_event]) == 1:
            G_alpha.edge(event, target_event)

# Dodawanie bramek scalających
for event in inv_causality:
    if len(inv_causality[event]) > 1:
        if tuple(sorted(list(inv_causality[event]))) in parallel_events:
            G_alpha.add_and_merge_gateway(inv_causality[event], event)
        else:
            G_alpha.add_xor_merge_gateway(inv_causality[event], event)
    elif len(inv_causality[event]) == 1:
        source = list(inv_causality[event])[0]
        if len(causality.get(source, {})) == 1:
            G_alpha.edge(source, event)

# Dodawanie zdarzenia początkowego
G_alpha.add_event("start")
if len(start_set_events) > 1:
    if tuple(sorted(list(start_set_events))) in parallel_events:
        G_alpha.add_and_split_gateway("start", start_set_events)
    else:
        G_alpha.add_xor_split_gateway("start", start_set_events)
else:
    G_alpha.edge("start", list(start_set_events)[0])

# Dodawanie zdarzenia końcowego
G_alpha.add_event("end")
if len(end_set_events) > 1:
    if tuple(sorted(list(end_set_events))) in parallel_events:
        G_alpha.add_and_merge_gateway(end_set_events, "end")
    else:
        G_alpha.add_xor_merge_gateway(end_set_events, "end")
else:
    G_alpha.edge(list(end_set_events)[0], "end")

G_alpha.render('simple_alpha_graph', view=True)
print("Wygenerowano 'simple_alpha_graph.pdf' (lub inny format domyślny) z modelem procesu BPMN na podstawie algorytmu Alfa.")