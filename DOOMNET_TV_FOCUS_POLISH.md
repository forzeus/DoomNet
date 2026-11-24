# TV focus polish after 5.9.20

Real Tuvio test: remote works; VPN and YouTube work. Visual fixes only:
- Power: keep its own round focus ring; suppress duplicate global rectangle in every connection state.
- Ping: use local rounded pill outline that moves with the changing layout.
- Log search: native InputDecoration focused border around the entire search field, not the editable text.
- Log category/level: clip to rounded chip and draw local outline on its full bounds.
- Settings sections: rounded local outline with no underlying square focus fill.
- Sidebar: remove separate icon indicator/ink focus background; retain full-row focus outline and selected colors.
- Preserve native key handling, activation and directional focus traversal from 5.9.20.
- Preview checks include local outline regression tests; real-TV visual verification still required.
