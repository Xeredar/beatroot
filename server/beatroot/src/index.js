export default
{
    async fetch(request, env, ctx)
    {
        return await handleRequest(request, env).catch(handleError)
    }
}

/**
 * Receives a HTTP request and replies with a response.
 * @param {Request} request
 * @returns {Promise<Response>}
 */
async function handleRequest(request, env)
{
    const { method, url } = request
    const { host, pathname } = new URL(url)

    let pathComponents = pathname.split("/")

    switch(pathComponents[3])
    {
        case 'add':
        {
            let url = new URL(request.url)
            let name = url.searchParams.get("name")
            let points = url.searchParams.get("points")
            let scene = url.searchParams.get("scene")
            if(!name || name.length < 1) throw "Error"
            if(!points || points.length < 1) points = 0
            if(!scene || scene.length < 3) throw "Error"
            let inversepoints = 100000 - points
            await env.BEATROOT.put("points:" + scene + ":"+ inversepoints.toString().padStart(6, "0") + ":" + name, "", {metadata: { points: points, name: name }})

            let pointss = await env.BEATROOT.list({prefix:"points:"})
            if(pointss.keys.length > 100)
            {
                for(let i of range(100, pointss.keys.length))
                {
                    await env.BEATROOT.delete(pointss.keys[i].name)
                }
            }

            return new Response("Success", {status: 200, headers: {'content-type': 'application/json;charset=UTF-8', 'Access-Control-Allow-Origin': '*', 'Vary': 'Origin', 'Cache-Control': 'no-store'}})
        }

        case 'list':
        {
            let url = new URL(request.url)
            let scene = url.searchParams.get("scene")
            let pointss = await env.BEATROOT.list({prefix:"points:" + scene + ":"})
            return new Response(JSON.stringify({scene: scene, list: pointss.keys}), {status: 200, headers: {'content-type': 'application/json;charset=UTF-8', 'Access-Control-Allow-Origin': '*', 'Vary': 'Origin', 'Cache-Control': 'no-store'}})
        }
    }

    return new Response('Not Found', { status: 404 })
}

/**
 * Responds with an uncaught error.
 * @param {Error} error
 * @returns {Response}
 */
function handleError(error)
{
    console.error('Uncaught error:', error)

    const { stack } = error
    return new Response(stack || error, {
        status: 500,
        headers: {
            'Content-Type': 'text/plain;charset=UTF-8'
        }
    })
}
