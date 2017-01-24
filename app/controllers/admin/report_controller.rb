class Admin::ReportController < ApplicationController
  before_action :logged_in_user, :verify_admin

  def index
    @end_month = params[:date].nil? ? Date.today.end_of_month :
      Date.new(params[:date][:year].to_i, params[:date][:month].to_i,1).end_of_month
    start_month = (@end_month<<11).beginning_of_month
    users_counts = User.group_by_month(start_month, @end_month).count
    categories_counts = Category.group_by_month(start_month, @end_month).count
    words_counts = Word.group_by_month(start_month, @end_month).count

    @chart_categories = []
    @users_data = []
    @categories_data = []
    @words_data = []

    last_12_months_after.reverse!.each do |month|
      @chart_categories << month
      @users_data << (users_counts[month].nil? ? 0 : users_counts[month])
      @categories_data << (categories_counts[month].nil? ? 0 : categories_counts[month])
      @words_data << (words_counts[month].nil? ? 0 : words_counts[month])
    end

    chart_data = [{
      name: t("chart.categories"),
      data: @categories_data
    }, {
      name: t("chart.words"),
      data: @words_data
    }, {
      name: t("chart.users"),
      data: @users_data
    }]

    respond_to do |format|
      format.html do
        @chart = LazyHighCharts::HighChart.new("line") do |f|
          f.title(text: t("chart.title_last_year"), x: -20)
          f.subtitle(text: t("chart.sub_title"), x: -20)
          f.xAxis(categories: @chart_categories)
          chart_data.each do |s|
            f.series(s)
          end
          f.yAxis [{title: {text: t("chart.y_axis_title")} },
            {plotLines: [{:value => 0, :width => 1, :color => "#808080"}]}]
          f.legend(layout: "vertical", align: "right", verticalAlign: "top",
            x: -10, y: 100, borderWidth: 0)
          f.chart({defaultSeriesType: "line"})
        end
      end
      format.js
    end
  end

  def last_12_months_after
    (0..11).map{|i| (@end_month - i.month).strftime("%Y\-%m")}
  end
end
