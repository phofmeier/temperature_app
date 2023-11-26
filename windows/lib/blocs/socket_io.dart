import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class SocketIOObserver extends BlocObserver {
  const SocketIOObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('${bloc.runtimeType} $change');
  }
}

abstract class SocketIOEvent {}

class SocketIOConnectingEvent extends SocketIOEvent {}

class SocketIOConnectEvent extends SocketIOEvent {}

class SocketIODisconnectEvent extends SocketIOEvent {}

class SocketIOOnConnectEvent extends SocketIOEvent {}

class SocketIOConnectErrorEvent extends SocketIOEvent {
  final WebSocketException data;
  SocketIOConnectErrorEvent(this.data);
}

class SocketIOConnectTimeoutEvent extends SocketIOEvent {}

class SocketIOOnDisconnectEvent extends SocketIOEvent {}

class SocketIOErrorEvent extends SocketIOEvent {}

class SocketIOJoinedEvent extends SocketIOEvent {}

class SocketIONewTempDataEvent extends SocketIOEvent {
  final data;
  SocketIONewTempDataEvent(this.data);
}

enum SocketIOConnectionStatus {
  initial,
  connected,
  disconnected,
}

class SocketIOState extends Equatable {
  final SocketIOConnectionStatus connectionStatus;
  final String moreInfo;
  double temp_1;
  double temp_2;

  SocketIOState(this.connectionStatus,
      {this.moreInfo = "", this.temp_1 = 0, this.temp_2 = 0});

  factory SocketIOState.connected(String moreInfo) {
    return SocketIOState(SocketIOConnectionStatus.connected,
        moreInfo: moreInfo);
  }

  factory SocketIOState.disconnected() {
    return SocketIOState(SocketIOConnectionStatus.disconnected);
  }

  SocketIOState newTempData(data) {
    double temp1New = data[0][1];
    double temp2New = data[1][1];
    return SocketIOState(connectionStatus,
        moreInfo: moreInfo, temp_1: temp1New, temp_2: temp2New);
  }

  @override
  List<Object?> get props => [connectionStatus, moreInfo, temp_1, temp_2];
}

class SocketIOBloc extends Bloc<SocketIOEvent, SocketIOState> {
  late final socket_io.Socket _socket;

  SocketIOBloc() : super(SocketIOState(SocketIOConnectionStatus.initial)) {
    _socket = socket_io.io(
      'http://localhost:5000/js',
      socket_io.OptionBuilder()
          .setTimeout(3000)
          .setReconnectionDelay(5000)
          .disableAutoConnect()
          .disableReconnection()
          .setTransports(['websocket']).build(),
    );

    _socket.onConnecting((data) => add(SocketIOConnectingEvent()));
    _socket.onConnect((_) => add(SocketIOOnConnectEvent()));
    _socket.onConnectError((data) => add(SocketIOConnectErrorEvent(data)));
    _socket.onConnectTimeout((data) => add(SocketIOConnectTimeoutEvent()));
    _socket.onDisconnect((_) => add(SocketIOOnDisconnectEvent()));
    _socket.onError((data) => add(SocketIOErrorEvent()));
    _socket.on('joined', (data) => add(SocketIOJoinedEvent()));
    _socket.on("new_temp_data", (data) => add(SocketIONewTempDataEvent(data)));

    // User events
    on<SocketIOConnectEvent>((event, emit) {
      _socket.connect();
    });

    on<SocketIODisconnectEvent>((event, emit) {
      _socket.disconnect();
    });
    // Socket events
    on<SocketIOConnectingEvent>((event, emit) {
      emit(SocketIOState.connected("Connecting"));
    });
    on<SocketIOOnConnectEvent>((event, emit) {
      print("Debug connected received");
      print(_socket.id);
      emit(SocketIOState.connected(_socket.id!));
    });
    on<SocketIOConnectErrorEvent>((event, emit) {
      emit(SocketIOState.connected("Connection Error: ${event.data}"));
    });
    on<SocketIOConnectTimeoutEvent>((event, emit) {
      emit(SocketIOState.connected("Connection timeout"));
    });
    on<SocketIOOnDisconnectEvent>((event, emit) {
      emit(SocketIOState.disconnected());
    });
    on<SocketIOErrorEvent>((event, emit) {
      emit(SocketIOState.connected("ErrorEvent"));
    });
    on<SocketIOJoinedEvent>((event, emit) {
      emit(SocketIOState.connected("JoinedEvent"));
    });
    on<SocketIONewTempDataEvent>((event, emit) {
      print(event.data);
      emit(state.newTempData(event.data));
    });
  }
  @override
  Future<void> close() async {
    super.close();
    _socket.dispose();
  }
}

class SocketIOConnection {
  late socket_io.Socket socket;
  SocketIOConnection() {
    socket = socket_io.io(
        'http://localhost:5000',
        socket_io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.onDisconnect((_) => print('disconnect'));

    //  socket.on('event', (data) => print(data));
    print("done");
  }

  void changeURL(String newUri) {
    socket.disconnect();
    socket = socket_io.io(newUri);
  }

  void addListener(event, function) {
    socket.on(event, function);
  }
}
