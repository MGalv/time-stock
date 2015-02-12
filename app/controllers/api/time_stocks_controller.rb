class Api::TimeStocksController < ApplicationController
  def create
    stamps.sort! { |x,y| x[1] <=> y[1] }
    when_to_sell = nil
    when_to_buy = nil
    size = stamps.size - 1
    stamps.each do |wtb|
      stamps.each_with_index do |stamp, i|
        if stamps[size - i][0].to_i > wtb[0].to_i
          when_to_sell = stamp
          return
        end
      end
      if when_to_sell
        when_to_buy = wtb
        return
      end
    end
    stock_response = [code, when_to_buy, when_to_sell].join(",")
    file_name = Rails.root.join('public', 'logs.txt')

    File.open(file_name, "w") do |f|
      f.write(stock_response)
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
end
