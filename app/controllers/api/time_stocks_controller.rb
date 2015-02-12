class Api::TimeStocksController < ApplicationController
  def create
    file_name = Rails.root.join('public', 'logs.txt')
    File.open(file_name, "a") do |f|
      f.puts(stock_response)
    end

    respond_to do |f|
      f.html { render text: stock_response, response: 200 }
    end
  end

  private

  def code
    @code ||= params[:stock_name]
  end

  def stamps
    @stamps ||= params[:rates].collect{|row| row.split(',')}
  end

  def stock_response
    @stock_response ||= calculate
  end

  def calculate
    stamps.sort! { |x,y| x[1].to_f <=> y[1].to_f }
    when_to_sell = nil
    when_to_buy = nil
    size = stamps.size - 1
    stamps.each do |wtb|
      stamps.each_with_index do |stamp, i|
        if stamps[size - i][0].to_i > wtb[0].to_i && stamps[size - i][1].to_i > wtb[1].to_i
          when_to_sell = stamps[size - i]
          break
        end
      end
      if when_to_sell
        when_to_buy = wtb
        break
      end
    end

    [code, (when_to_buy[0] if when_to_buy), (when_to_sell[0] if when_to_sell)].join(",")
  end
end
