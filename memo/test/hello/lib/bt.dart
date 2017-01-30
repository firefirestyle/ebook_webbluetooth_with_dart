library bluetooth;

import 'dart:js' as js;
import 'dart:async';
import 'dart:typed_data';

Bluetooth getBluetooth() {
  var n = js.context["navigator"];
  return new Bluetooth(n["bluetooth"]);
}


// { filters: [{ services: ['battery_service'] }] }

typedef dynamic vfunc(dynamic);

class Promise {
  js.JsObject jsObj;

  Promise(this.jsObj) {
  }

  Promise then(vfunc) {
    var v = jsObj.callMethod("then", [vfunc]);
    return new Promise(v);
  }

  Promise catchError(vfunc) {
    var v = jsObj.callMethod("catch", [vfunc]);
    return new Promise(v);
  }
}


class Bluetooth {
  js.JsObject jsObj;

  Bluetooth(this.jsObj) {
  }

  //opetions -> { "filters": [{ "services": ['battery_service']}]}
  Future<BluetoothDevice> requestDevice(Map options) {
    js.JsObject p1 = jsObj.callMethod("requestDevice", [
      new js.JsObject.jsify(options)
    ]);
    var ret = new Completer();
    Promise v = new Promise(p1);
    v.then((v) {
      ret.complete(new BluetoothDevice(v));
    }).catchError((v) {
      ret.completeError(v);
    });
    return ret.future;
  }
}

class BluetoothDevice {
  js.JsObject jsObj;

  String get name => jsObj["name"];

  String get id => jsObj["id"];

  BluetoothRemoteGATTServer get gatt =>
      new BluetoothRemoteGATTServer(this.jsObj["gatt"]);

  BluetoothDevice(this.jsObj) {
  }
}

class BluetoothRemoteGATTServer {
  js.JsObject jsObj;

  bool get connected => jsObj["connected"];

  BluetoothDevice get device => new BluetoothDevice(jsObj["device"]);

  BluetoothRemoteGATTServer(this.jsObj) {
    ;
  }

  Future<BluetoothRemoteGATTServer> connect() {
    Promise p1 = jsObj.callMethod("connect");
    var ret = new Completer();
    p1.then((v) {
      ret.complete(new BluetoothRemoteGATTServer(v));
    }).catchError((v) {
      ret.completeError(v);
    });
    return ret.future;
  }

  void disconnect() {
    jsObj.callMethod("disconnect");
  }

  Future<BluetoothRemoteGATTService> getPrimaryService(dynamic serviceUuid) {
    Promise p1 = jsObj.callMethod("getPrimaryService",[serviceUuid]);
    var ret = new Completer();
    p1.then((v) {
      ret.complete(new BluetoothRemoteGATTService(v));
    }).catchError((v) {
      ret.completeError(v);
    });
    return ret.future;
  }

  Future<List<BluetoothRemoteGATTService>> getPrimaryServices(
      [dynamic serviceUuid = null]) {
    Promise p1;
    if (serviceUuid == null) {
      p1 = jsObj.callMethod("getPrimaryServices");
    } else {
      p1 = jsObj.callMethod("getPrimaryServices", [serviceUuid]);
    }
    var ret = new Completer<List<BluetoothRemoteGATTService>>();
    p1.then((v) {
      js.JsArray vs = v;
      List<BluetoothRemoteGATTService> re = [];
      for (var vv in vs) {
        re.add(new BluetoothRemoteGATTService(vv));
      }
      ret.complete(re);
    }).catchError((v) {
      ret.completeError(v);
    });
    return ret.future;
  }
}
// BluetoothServiceUUID

class BluetoothRemoteGATTService {
  js.JsObject jsObj;

  BluetoothRemoteGATTService(this.jsObj) {
    ;
  }

  BluetoothDevice get device => new BluetoothDevice(jsObj["device"]);

  bool get isPrimary => jsObj["isPrimary"];

  String get uuid => jsObj["uuid"];

  //
  Future<BluetoothRemoteGATTCharacteristic> getCharacteristic(
      dynamic characteristic) {
    Promise p1 = jsObj.callMethod("getCharacteristic",[characteristic]);
    var ret = new Completer();
    p1.then((v) {
      ret.complete(new BluetoothRemoteGATTCharacteristic(v));
    }).catchError((v) {
      ret.completeError(v);
    });
    return ret.future;
  }
}

class DataView {
  ByteBuffer buffer;
  int byteOffset;
  int byteLength;
  DataView(this.buffer, this.byteOffset, this.byteLength){

  }
}

class BluetoothRemoteGATTCharacteristic {
  js.JsObject jsObj;

  BluetoothRemoteGATTCharacteristic(this.jsObj) {

  }

  BluetoothRemoteGATTService get service =>
      new BluetoothRemoteGATTService(jsObj["uuid"]);

  String get uuid => jsObj["uuid"];
  TypedData get value => jsObj["value"];
  Future<ByteData> readValue(){
    Promise p1 = jsObj.callMethod("readValue");
    var ret = new Completer();
    p1.then((v) {
      ret.complete(v);
    }).catchError((v) {
      ret.completeError(v);
    });
    return ret.future;
  }
}
