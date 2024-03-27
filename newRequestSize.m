function Users = newRequestSize(Users, req_size)

for i = 1:length(Users)
    Users(i).req_size = req_size;
end

end