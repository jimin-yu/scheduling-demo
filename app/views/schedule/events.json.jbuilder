json.data do
    json.array! @events, :date, :time, :enabled
end
json.meta do
    json.result "success"
end