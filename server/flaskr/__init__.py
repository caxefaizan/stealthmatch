import os, json
from flask import Flask
from flask_socketio import SocketIO, emit, join_room
from flaskr.db import get_db
from flaskr.common import writeMessageAndSendResponse


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY="dev",
        DATABASE=os.path.join(app.instance_path, "flaskr.sqlite"),
    )
    # app.config.from_pyfile("config.py")

    socketio = SocketIO(app)

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile("config.py", silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    def get_room_name(sender, recipientId):
        recipient = (
            get_db()
            .execute(
                "SELECT u.*" f" FROM user u " f" WHERE u.id = '{recipientId}'",
            )
            .fetchone()
        )
        x = [sender, recipient["username"]]
        x.sort()
        room_name = "_".join(x)
        return room_name

    @socketio.on("clientConnect")
    def handle_my_custom_event(json):
        room_name = get_room_name(json["sender"], json["receiver"])
        # print(f"client: {json['sender']} connected to room {room_name}")
        join_room(room_name)

    # when message is sent from client
    @socketio.on("submitMessage")
    def handle_my_custom_event(username, rId, message, size):
        room_name = get_room_name(username, rId)
        # store message in db
        messages = writeMessageAndSendResponse(username, rId, message, size)

        updateString = f"""<li id="message-li" class="list-group-item"><span id="message-span-{{loop.revindex}}" class="label label-info">{username}: </span>{message}</li>"""
        # trigger function on client
        emit(
            "serverMessagesUpdate",
            json.dumps({"message": updateString}),
            to=room_name,  # send to room
        )

    from . import db

    db.init_app(app)

    from . import auth

    app.register_blueprint(auth.bp)

    from . import blog

    app.register_blueprint(blog.bp)
    app.add_url_rule("/", endpoint="index")

    return app
