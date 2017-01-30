import 'package:angular2/core.dart';
import 'dart:html' as html;
import 'bt.dart' as b;
import 'dart:typed_data';


@Component(selector: 'my-app',
    template: """
    <h1>Hello {{name}}</h1>
    <div>
    <div *ngFor='let v of logs'>{{v}}</div>
    </div>
    <button (click)='onClick()'>Click</button>

    """
)
class AppComponent {
  var name = 'Angular';
  List<String> logs = [];

  log(String l) {
    print(l);
    logs.add(l);
  }

  onClick() async {
    b.Bluetooth bluetooth = b.getBluetooth();
    b.BluetoothDevice device = await bluetooth.requestDevice({ "filters": [{ "services": ['battery_service']}]});
    log("name : ${device.name}");
    log("id : ${device.id}");

    b.BluetoothRemoteGATTServer server = await device.gatt.connect();
    log("server.connected : ${server.connected}");

    b.BluetoothRemoteGATTService service = await server.getPrimaryService('battery_service');
    log("service.isPrimary : ${service.isPrimary}");
    log("service.uuid : ${service.uuid}");

    b.BluetoothRemoteGATTCharacteristic chara = await service.getCharacteristic('battery_level');
    log("service.uuid : ${chara.uuid}");

    ByteData buffer = await chara.readValue();
    log("service.value : ${buffer}");
    log("service.value : ${buffer.lengthInBytes}");
    log("service.value : ${buffer.buffer.asUint8List()}");
  }
}
