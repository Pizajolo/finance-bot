async function getData() {
    const response = await fetch('graph');
    const data = await response.json();
    return data;
}

async function renderChart() {
    let data = await getData();
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: data['Date'],
            datasets: [{
                label: 'Apple price',
                data: data['Prices'],
                backgroundColor: 'rgba(78, 115, 223, 0.8)',
                borderColor: 'rgba(78, 115, 223, 0.8)',
                fill: false,
                pointRadius: 0
            },{
                label: 'Buy',
                data: data['Buy_Prices'],
                backgroundColor: 'rgba(78, 223, 113, 1)',
                borderColor: 'rgba(78, 223, 113, 1)',
                fill: true,
                // pointRadius: 1,
                showLine: false
            },{
                label: 'Sell',
                data: data['Sell_Prices'],
                backgroundColor: 'rgba(223, 78, 113, 1)',
                borderColor: 'rgba(223, 78, 113, 1)',
                fill: true,
                // pointRadius: 1,
                showLine: false
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