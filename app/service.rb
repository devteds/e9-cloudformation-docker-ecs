require 'sinatra'
require "sinatra/namespace"

class Book
    @@books = [
        { id: "123", name: "Docker for Beginners" },
        { id: "124", name: "Docker with Kubernetes" },
        { id: "125", name: "Docker on ECS" }
    ]

    def self.all
        @@books
    end

    def self.find(book_id)
        @@books.select { |p| p[:id] == book_id }.first
    end
end

get '/' do
    'Healthy!!!'
end

get '/stat' do
    'Healthy!!!'
end

namespace '/api' do

    before do
        content_type 'application/json'
    end
    
    # /api/books
    get '/books' do
        Book.all.to_json
    end

    # /api/books/:id
    get '/books/:id' do
        if (book = Book.find(params[:id])) != nil
            book.to_json
        else
            halt(404, { message:'book Not Found'}.to_json)
        end
    end

end
