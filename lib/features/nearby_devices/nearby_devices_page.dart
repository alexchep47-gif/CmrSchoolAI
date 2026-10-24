import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections_plus/flutter_nearby_connections_plus.dart';

import '../../core/theme/app_theme.dart';

class NearbyDevicesPage extends StatefulWidget {
  const NearbyDevicesPage({super.key});

  @override
  State<NearbyDevicesPage> createState() => _NearbyDevicesPageState();
}

class _NearbyDevicesPageState extends State<NearbyDevicesPage> {
  final NearbyService _nearbyService = NearbyService();
  StreamSubscription? _devicesSubscription;
  StreamSubscription? _messagesSubscription;
  List<Device> _devices = const [];
  bool _isRunning = false;
  bool _isStarting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _devicesSubscription = _nearbyService.stateChangedSubscription(
      callback: (devices) {
        if (mounted) setState(() => _devices = List<Device>.from(devices));
      },
    );
    _messagesSubscription = _nearbyService.dataReceivedSubscription(
      callback: (_) {},
    );
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    if (kIsWeb || _isStarting || _isRunning) return;
    setState(() {
      _isStarting = true;
      _error = null;
    });
    try {
      await _nearbyService.init(
        serviceType: 'cmr-connect',
        strategy: Strategy.P2P_CLUSTER,
        deviceName: 'CmrSchoolAI',
        callback: (running) {
          if (mounted) setState(() => _isRunning = running == true);
        },
      );
      await _nearbyService.startAdvertisingPeer(deviceName: 'CmrSchoolAI');
      await _nearbyService.startBrowsingForPeers();
      if (mounted) setState(() => _isRunning = true);
    } catch (error) {
      if (mounted) setState(() => _error = 'Active le Bluetooth, le Wi‑Fi et les autorisations à proximité.');
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  Future<void> _stopDiscovery() async {
    if (kIsWeb) return;
    await _nearbyService.stopBrowsingForPeers();
    await _nearbyService.stopAdvertisingPeer();
    if (mounted) setState(() => _isRunning = false);
  }

  @override
  void dispose() {
    unawaited(_stopDiscovery());
    _devicesSubscription?.cancel();
    _messagesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUnsupported = kIsWeb;
    return Scaffold(
      appBar: AppBar(title: const Text('Appareils à proximité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: AppTheme.navy,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.wifi_tethering, color: AppTheme.orange, size: 34),
                const SizedBox(height: 12),
                Text('Connexion directe', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('Détecte les téléphones proches grâce au Wi‑Fi pair-à-pair et au Bluetooth, sans serveur.', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: isUnsupported || _isStarting ? null : (_isRunning ? _stopDiscovery : _startDiscovery),
                  icon: Icon(_isRunning ? Icons.stop_circle_outlined : Icons.radar),
                  label: Text(_isStarting ? 'Activation…' : (_isRunning ? 'Arrêter la détection' : 'Rechercher autour de moi')),
                ),
              ]),
            ),
          ),
          if (isUnsupported) const Padding(padding: EdgeInsets.only(top: 20), child: Text('La détection directe est disponible sur les applications Android et iOS. La version web ne peut pas accéder au Wi‑Fi pair-à-pair du téléphone.')),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 20), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 24),
          Text('${_devices.length} appareil${_devices.length == 1 ? '' : 's'} trouvé${_devices.length == 1 ? '' : 's'}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          if (_devices.isEmpty) Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [Icon(Icons.devices_other_outlined, size: 42, color: Theme.of(context).colorScheme.outline), const SizedBox(height: 10), const Text('Aucun appareil détecté'), const SizedBox(height: 6), const Text('Ouvre cette page sur les deux téléphones et accepte les autorisations.', textAlign: TextAlign.center)])))
          else ..._devices.map((device) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.smartphone)), title: Text(device.deviceName.isEmpty ? 'Appareil sans nom' : device.deviceName), subtitle: Text(_stateLabel(device.state)), trailing: device.state == SessionState.connected ? const Icon(Icons.check_circle, color: Colors.green) : FilledButton(onPressed: () => _nearbyService.invitePeer(deviceID: device.deviceId, deviceName: device.deviceName), child: const Text('Connecter'))))),
        ],
      ),
    );
  }

  String _stateLabel(SessionState state) => switch (state) {
        SessionState.connected => 'Connecté',
        SessionState.connecting => 'Connexion en cours…',
        SessionState.notConnected => 'Disponible',
      };
}
