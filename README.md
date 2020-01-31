# BleacherReport

This is a tiny api that handles recording of actions to and in memory database, for fast concurrent reads and supports write atomicity.
The project is basically a JSON API backed by an ETS table.


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
Now you can visit [`localhost:4000/api`](http://localhost:4000/api/) from your browser.


## Sampling

With the server running as above you can do a number of actions

1. You can post to [`localhost:4000/api/react`](http://localhost:4000/api/react) with a JSON payload like the ones below

```
%{
        "type" => "reaction",
        "action" => "add",
        "content_id" => content_id,
        "user_id" => "some_user_id",
        "reaction_type" => "fire"
      }
```

or to remove an reaction


```
 %{
        "type" => "reaction",
        "action" => "remove",
        "content_id" => content_id,
        "user_id" => "some_user_id",
        "reaction_type" => "fire"
      }
```


2. There is a get endpount at [`localhost:4000/api/reaction_counts/:some_id`](http://localhost:4000/api/reaction_counts)
	This endpoint expect an existing content id and will return a positive count or `error, nil` in the case of non existing counts

## Sample Requests

```bash
$ curl --request POST -H 'Content-Type: application/json' --data '{"user_id": "uid", "content_id": "cid", "type": "reaction", "action": "add", "reaction_type": "fire"}' http://localhost:4000/api/react/
{"user_id":"uid","content_id":"cid"}

$ curl --request POST -H 'Content-Type: application/json' --data '{"user_id": "u2id", "content_id": "cid", "type": "reaction", "action": "add", "reaction_type": "fire"}' http://localhost:4000/api/react/
{"user_id":"u2id","content_id":"cid"}

$ curl http://localhost:4000/api/reaction_counts/cid
{"reaction_count":{"fire":2},"content_id":"cid"}
```
## Notes
- This can be greatly improved by making our Cache use structs, this would include making structs of the data at the edges(controllers)
- While this will be fairly performant up to around 30 - 40k requests a second at such a point we need to start considering using
constructs such as GENSTAGE as the cache wrapper GenServer could becomea bottleneck and here backpressure would be helpful
- This can be tested more, perhaps property tests to discover the Cache behaviour with random instructions
- The typespecs in this project can be confirmed using something like dialyzer, didnt use it here as it takes time.
- Maybe phoenix is overkill, perhaps a plug endpoint would have sufficed ...

## License
Copy this and improve it please!
