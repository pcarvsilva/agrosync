export const BarChart = {
    mounted() {
        var ctx = this.el.getContext('2d');
        myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [],
                datasets:
                    [
                        {
                            borderSkipped: true,
                            backgroundColor: "#14512e",
                            data: [],

                        },
                    ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        ticks: {
                            beginAtZero: true,
                            display: false
                        },
                        grid: {
                            display: false,
                            drawBorder: true,
                        }
                    },
                    y: {
                        ticks: {
                            beginAtZero: true,
                            display: false,
                            drawBorder: false
                        },
                        grid: {
                            display: false,
                            color: 'rgba(246, 251, 255, 1)',
                            drawBorder: false,
                        },
                    },
                },
                plugins: {
                    legend: {
                        display: false,
                        labels: {
                            font: {
                                size: 12,
                                family: "'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'",
                                weight: "500",
                                lineHeight: "15px",
                            }
                        }
                    }
                }
            },
        });

        id = this.el.id.toString()

        this.handleEvent("update_bar_chart", ({ chart_data }) => {
            var new_ctx = document.getElementById(chart_data.id).getContext('2d');
            Chart.getChart(chart_data.id).destroy();

            chart = new Chart(new_ctx, {
                type: 'bar',
                data: {
                    labels: chart_data.labels,
                    datasets:
                        [
                            {
                                borderSkipped: true,
                                backgroundColor: "#14512e",
                                data: chart_data.data,
                            },
                        ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            ticks: {
                                beginAtZero: true,
                                display: false
                            },
                            grid: {
                                display: false,
                                drawBorder: true,
                            }
                        },
                        y: {
                            ticks: {
                                beginAtZero: true,
                                display: false,
                                drawBorder: false
                            },
                            grid: {
                                display: false,
                                color: 'rgba(246, 251, 255, 1)',
                                drawBorder: false,
                            },
                        },
                    },
                    plugins: {
                        legend: {
                            display: false,
                            labels: {
                                font: {
                                    size: 12,
                                    family: "'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif'",
                                    weight: "500",
                                    lineHeight: "15px",
                                }
                            }
                        }
                    }
                },
            });

        })
    }
}
