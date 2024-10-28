from spin_sdk.http import IncomingHandler, Request, Response
from urllib.parse import urlsplit, parse_qs
import random
import json

class IncomingHandler(IncomingHandler):
    def handle_request(self, request: Request) -> Response:
        query_string = parse_qs(urlsplit(request.uri).query)
        tag = query_string['tag'][0] if query_string['tag'] else ''

        with open('./quotes.json') as data:
            all_quotes = json.load(data)
            matching_quotes = [f"{quote['Quote']} (c) {quote['Author']}" for quote in all_quotes
                               if tag in quote['Tags']]
            random_quote = random.choice(matching_quotes)
            return Response(
                200,
                {"content-type": "text/plain"},
                bytes(f'{random_quote}\n', "utf-8")
            )
