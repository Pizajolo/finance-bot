const xlabels = [];
const y_open = [];
const y_high = [];

async function getData() {
    const response = await fetch('graph');
    const data = await response.json();
    for(let i in data) {
        xlabels.push(data[i]["Date"]);
        y_open.push(data[i]["Open"]);
        y_high.push(data[i]["High"])
    }
}

async function renderChart() {
    await getData();
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: xlabels,
            datasets: [{
                label: 'Apple price',
                data: y_open,
                backgroundColor: 'rgba(78, 115, 223, 0.8)',
                borderColor: 'rgba(78, 115, 223, 0.8)',
                fill: false,
                pointRadius: 0
            },{
                label: 'Apple price High',
                data: y_high,
                backgroundColor: 'rgba(78, 223, 113, 0.8)',
                borderColor: 'rgba(78, 223, 113, 0.8)',
                fill: false,
                pointRadius: 0
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: false
                    }
                }]
            },
            maintainAspectRatio: false
        }
    });
}


async function app() {
    renderChart();
}

app();