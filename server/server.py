import os
from aiohttp import web

RABBIT_ROUTE = (os.path.abspath(os.path.dirname(__file__)) 
               + "/static/rabbitmq_install.sh")
MONGO_ROUTE = (os.path.abspath(os.path.dirname(__file__)) 
              + "/static/mongo_install.sh")

routes = web.RouteTableDef()

@routes.get("/api/v1/get_rabbit")
async def get_rabbit_handler(request):
    return web.FileResponse(RABBIT_ROUTE)

@routes.get("/api/v1/get_mongo")
async def get_mongo_handler(request):
    return web.FileResponse(MONGO_ROUTE)

def init():
    app = web.Application()
    app.router.add_routes(routes)
    return app

if __name__ == "__main__":
    web.run_app(init(), host="0.0.0.0", port = 80)

