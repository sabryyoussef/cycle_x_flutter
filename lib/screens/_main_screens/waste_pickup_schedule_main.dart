import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';
import 'package:waste_wise/screens/waste_pickup_schedule/waste_pickup_schedule_form.dart';
import 'package:waste_wise/screens/waste_pickup_schedule/waste_pickup_schedule_details.dart';
import 'package:provider/provider.dart';
import 'package:waste_wise/utils/provider_utils.dart';
import '../../services/mock_waste_pickup_service.dart';

class WastePickupScheduleMain extends StatefulWidget {
  const WastePickupScheduleMain({super.key});

  @override
  State<WastePickupScheduleMain> createState() =>
      _WastePickupScheduleMainState();
}

class _WastePickupScheduleMainState extends State<WastePickupScheduleMain> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final MockWastePickupService _mockService = MockWastePickupService();

  Future<void> _deletePickup(String documentId) async {
    try {
      // Use mock service on Linux/Windows
      if (Platform.isLinux || Platform.isWindows) {
        await _mockService.deletePickup(documentId);
        setState(() {}); // Refresh the UI
      } else {
        // Use Firebase on supported platforms
        await FirebaseFirestore.instance
            .collection('waste_pickups')
            .doc(documentId)
            .delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup schedule canceled successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel pickup schedule')),
      );
    }
  }

  // Function to show confirmation dialog
  Future<void> _confirmDelete(String documentId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content:
            const Text('Are you sure you want to cancel this pickup schedule?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text(
              'No',
              style: TextStyle(color: Colors.green[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              _deletePickup(documentId); // Proceed with deletion
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.green[600]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = ProviderUtils.getUserRepository(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WastePickupScheduleForm()),
          );
        },
        backgroundColor: Colors.green[600],
        shape: const CircleBorder(),
        elevation: 6.0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/vehicle.jpg"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          StreamBuilder<MyUser>(
                              stream: userRepo.user,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: 35,
                                  ); // Show loading indicator while waiting
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error: ${snapshot.error}'); // Show error if there is one
                                } else if (!snapshot.hasData) {
                                  return const Text(
                                    "Hi, User",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ); // Handle case where there's no data
                                } else {
                                  MyUser user = snapshot.data!;
                                  return Text(
                                    "Hi, ${user.name}",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              }),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search by Waste Type',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10)),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'My Waste Pickup Schedules',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Platform.isLinux || Platform.isWindows
                ? _buildMockData()
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('waste_pickups')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var pickupData = snapshot.data!.docs;

                      // Filter the pickupData based on the search query
                      var filteredData = pickupData.where((pickup) {
                        var wasteType =
                            pickup['wasteType'].toString().toLowerCase();
                        return wasteType.contains(_searchQuery);
                      }).toList();

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: List.generate(
                            filteredData.length,
                            (index) {
                              var pickup = filteredData[index];
                              String documentId = pickup.id; // Document ID

                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    border: Border.all(
                                        color: Colors.green.shade600, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Pickup Request",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color:
                                                          Colors.green.shade600,
                                                      width: 1)),
                                              child: Text(
                                                "Scheduled",
                                                style: TextStyle(
                                                  color: Colors.green.shade600,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 18, color: Colors.black),
                                            const SizedBox(width: 8),
                                            Text(
                                              pickup['scheduledDate'],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.delete_outline,
                                                size: 18, color: Colors.black),
                                            const SizedBox(width: 8),
                                            Text(
                                              pickup['wasteType'],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                var pickupData = pickup.data()
                                                    as Map<String, dynamic>?;

                                                if (pickupData != null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WastePickupScheduleDetails(
                                                              pickup:
                                                                  pickupData,
                                                              documentId:
                                                                  pickup.id),
                                                    ),
                                                  );
                                                } else {
                                                  // Handle the case where pickupData is null
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Pickup details are missing')),
                                                  );
                                                }
                                              },
                                              icon: Icon(Icons.info,
                                                  color: Colors.green[600]),
                                              label: Text(
                                                "Details",
                                                style: TextStyle(
                                                    color: Colors.green[600]),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    color:
                                                        Colors.green.shade600,
                                                    width: 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                _confirmDelete(documentId);
                                              },
                                              icon: const Icon(Icons.cancel,
                                                  color: Colors.red),
                                              label: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    color: Colors.red,
                                                    width: 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockData() {
    return FutureBuilder<List<MockWastePickup>>(
      future: _mockService.getScheduledPickups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading pickup schedules'),
          );
        }

        final pickups = snapshot.data ?? [];

        // Filter pickups based on search query
        final filteredPickups = pickups.where((pickup) {
          return pickup.wasteType.toLowerCase().contains(_searchQuery);
        }).toList();

        if (filteredPickups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  pickups.isEmpty
                      ? 'No pickup schedules available'
                      : 'No pickups match your search',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pickups.isEmpty
                      ? 'Schedule your first waste pickup!'
                      : 'Try a different search term',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: filteredPickups.map((pickup) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      _getWasteTypeIcon(pickup.wasteType),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    pickup.wasteType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${pickup.scheduledDate}'),
                      Text('Address: ${pickup.address}'),
                      Text('Phone: ${pickup.phone}'),
                      if (pickup.description.isNotEmpty)
                        Text('Description: ${pickup.description}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _confirmDelete(pickup.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Cancel Schedule'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to pickup details if needed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pickup ID: ${pickup.id}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  IconData _getWasteTypeIcon(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'e-waste':
        return Icons.devices;
      case 'paper waste':
        return Icons.description;
      case 'metal waste':
        return Icons.build;
      case 'plastic waste':
        return Icons.local_drink;
      default:
        return Icons.recycling;
    }
  }
}
