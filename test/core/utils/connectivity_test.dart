import 'package:devexam/core/utils/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

ConnectivityObserver connectivityObserver;

class MockNetworkHandler extends Mock implements NetworkHandler {}

MockNetworkHandler mockedNetworkHandler;

void main() {
  setUpAll(() {
    mockedNetworkHandler = MockNetworkHandler();
    connectivityObserver =
        ConnectivityObserver(interval: Duration(microseconds: 0));
    connectivityObserver.networkHandler = mockedNetworkHandler;
  });

  group("ConnectivityObserver", () {
    test("connectionTest goes online", () async {
      // Mocks ping request to return online status
      when(mockedNetworkHandler.pingIP()).thenAnswer(
          (realInvocation) => Future.value(ConnectivityStatus.online));
      connectivityObserver.connectionTest();

      // Check if periodic timer started.
      expect(connectivityObserver.timerHandler.isActive, true);

      // Wait for the periodic timer to execute first step.
      await Future.delayed(Duration(microseconds: 10));

      // check if previous result is online, which means that we are online
      expect(connectivityObserver.previousResult, ConnectivityStatus.online);
    });

    test("connectionTest goes offline", () async {
      // Mocks ping request to return online status
      when(mockedNetworkHandler.pingIP()).thenAnswer(
          (realInvocation) => Future.value(ConnectivityStatus.offline));
      connectivityObserver.connectionTest();

      // Check if periodic timer started.
      expect(connectivityObserver.timerHandler.isActive, true);

      // Wait for the periodic timer to execute first step.
      await Future.delayed(Duration(microseconds: 10));

      // check if previous result is online, which means that we are online
      expect(connectivityObserver.previousResult, ConnectivityStatus.offline);
    });
  });

  group("NetworkHandler", () {
    test("pingIp throws an exception", () async {
      // It's impossible to connect 255.255.255.255 broadcast address with TCP.
      NetworkHandler networkHandler = NetworkHandler(
        "255.255.255.255",
        52,
        Duration(milliseconds: 100),
      );
      expect(await networkHandler.pingIP(), ConnectivityStatus.offline);
    });
  });
}
