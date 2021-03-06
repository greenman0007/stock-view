<script>
    $(function () {
        $('#stockInfoTable').bootstrapTable({
            url: '${request.contextPath}/stockInfo/page',
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            method: "post",
            pagination: true,
            sidePagination: "server",
            toolbar: "#toolbar",
            columns: [{
                field: 'stockCode',
                title: '代码',
                formatter: function (value, row, index) {
                    return '<a href="javascript:void(0)" data-url="${request.contextPath}/stockInfo/history/'+row.id+'" onclick="showHistory(this)">'+value+'</a>';
                }
            }, {
                field: 'stockName',
                title: '股票名称'
            }, {
                field: 'market',
                title: '市场'
            }, {
                field: 'negotiableQty',
                title: '流通股本',
                sortable: true
            }, {
                field: 'stockRealtime.open',
                title: '开盘价(元)'
            }, {
                field: 'stockRealtime.currentPrice',
                title: '当前价(元)',
                sortable: true
            }, {
                field: 'stockRealtime.increaseRate',
                title: '涨跌幅',
                sortable: true,
                formatter: function (value, row, index) {
                    if (value && ""!=value) {
                        if (value >= 0) {
                            return "<span class='increase'>"+(value*100).toFixed(2)+"%"+"<i class='glyphicon glyphicon-arrow-up'></i></span>";
                        } else {
                            return "<span class='decrease'>"+(value*100).toFixed(2)+"%"+"<i class='glyphicon glyphicon-arrow-down'></i></span>";
                        }
                    } else {
                        return value;
                    }
                }
            }, {
                field: 'stockRealtime.dealQty',
                title: '成交量(股)',
                sortable: true
            }, {
                field: 'stockRealtime.dealMoney',
                title: '成交金额(万元)',
                sortable: true,
                formatter: function (value, row, index) {
                    return Number(value/10000).toFixed(2)
                }
            }, {
                field: 'stockRealtime.high',
                title: '最高价'
            }, {
                field: 'stockRealtime.low',
                title: '最低价'
            }, {
                field: 'stockRealtime.realTime',
                title: '更新时间'
            }]
        });
        $(".market-toggle").on("click", function (e) {
            var $this = e.target;
            $($this).siblings().removeClass("active");
            $($this).addClass("active");
            $("#market").val($($this).attr("data-market"));
            search();
        })
    })
    function search() {
        $('#stockInfoTable').bootstrapTable("refreshOptions",{
            queryParams:function(params){
                var query = $.extend( true, params, $("#stockQueryForm").serializeJSON() );
                return query;
            }
        });
    }
    function showHistory(obj) {
        var url = $(obj).attr("data-url");
        $.get(url, function (result) {
            $("#content").html(result);
        });
    }
</script>
<div id="toolbar">
    <div class="btn-group" role="group" aria-label="...">
        <button type="button" class="btn btn-default market-toggle" data-market="">所有</button>
        <button type="button" class="btn btn-default market-toggle" data-market="sh">沪股</button>
        <button type="button" class="btn btn-default market-toggle" data-market="sz" >深股</button>
    </div>
    <form class="form-inline" id="stockQueryForm">
        <input type="hidden" id="market" name="market" value="">
        <div class="form-group">
            <input type="text" class="form-control" id="stockName" name="stockName" placeholder="股票名">
        </div>
        <div class="form-group">
            <input type="text" class="form-control" id="stockCode" name="stockCode" placeholder="股票代码">
        </div>
        <button type="button" class="btn btn-primary" onclick="search()">搜索</button>
    </form>
</div>
<table id="stockInfoTable">
</table>