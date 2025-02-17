// SPDX-License-Identifier: AGPL-3.0
// Copyright (c) 2023 - 2025 Gavin Henry <ghenry@sentrypeer.org>
//   _____            _              _____
//  / ____|          | |            |  __ \
// | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __
//  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__|
//  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |
// |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|
//                              __/ |
//                             |___/
//
/** LiveView Hook **/

import CalHeatmap from "cal-heatmap"
import Tooltip from 'cal-heatmap/plugins/Tooltip'
import LegendLite from 'cal-heatmap/plugins/LegendLite'
import CalendarLabel from 'cal-heatmap/plugins/CalendarLabel'

const SentrypeerCalHeatmap = {
    mounted() {
        const cal = new CalHeatmap()
        cal.paint({
                data: {
                    source: '/api/events/heatmap?end={{end=YYYY-MM-DDTHH:mm:ss[Z]}}&start={{start=YYYY-MM-DDTHH:mm:ss[Z]}}',
                    x: 'date',
                    y: d => +d['value'],
                    groupY: 'max',
                },
                date: {start: new Date(new Date().getFullYear(), 0, 1)}, // 1st January of the current year
                range: 12,
                itemSelector: '#event-heatmap',
                scale: {
                    color: {
                        type: 'threshold',
                        range: ['#6d50a0', '#73168c', '#c617f6', '#eca7ff'],
                        domain: [10000, 20000, 30000, 40000],
                    },
                },
                domain: {
                    type: 'month',
                    gutter: 4,
                    label: {text: 'MMM', textAlign: 'start', position: 'top'},
                },
                subDomain: {type: 'day', radius: 2, width: 11, height: 11, gutter: 4},

            },
            [
                [
                    Tooltip,
                    {
                        text: function (date, value, dayjsDate) {
                            return (
                                (value ? value : 'No') +
                                ' events received on ' +
                                dayjsDate.format('dddd, MMMM Do YYYY')
                            );
                        },
                    },
                ],
                [
                    LegendLite,
                    {
                        includeBlank: true,
                        itemSelector: '#ex-ghDay-legend',
                        radius: 2,
                        width: 11,
                        height: 11,
                        gutter: 4,
                    },
                ],
                [
                    CalendarLabel,
                    {
                        width: 30,
                        textAlign: 'start',
                        text: () => dayjs.weekdaysShort().map((d, i) => (i % 2 == 0 ? '' : d)),
                        padding: [25, 0, 0, 0],
                    },
                ],
            ]
        );

        window.addEventListener("sentrypeerhq:cal_previous", (event) => {
            cal.previous()
        })

        window.addEventListener("sentrypeerhq:cal_next", (event) => {
            cal.next()
        })
    }
}

export default SentrypeerCalHeatmap
