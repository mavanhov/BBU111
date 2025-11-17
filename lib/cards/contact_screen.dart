import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lorsoth111/app_colors.dart';
import 'package:lorsoth111/models/contact.dart';

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});

  final _keyForm = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Contact>> getContacts() {
    String strId = _auth.currentUser!.uid;
    return _firestore
        .collection('contacts')
        .where('create', isEqualTo: strId)
        .orderBy('firstname')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Contact.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> deleteContact(
    BuildContext context,
    String id,
    String name,
  ) async {
    final isDeleted = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text("Sure you want to delete '$name' ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('YES'),
            ),
          ],
        );
      },
    );
    if (isDeleted == true) {
      EasyLoading.show();
      await Future.delayed(Duration(seconds: 1));
      await _firestore.collection('contacts').doc(id).delete();
      EasyLoading.showSuccess('One contact has been deleted.');
    }
  }

  void _addContactDialog(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final companyController = TextEditingController();
    String? gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 16,
          right: 16,
        ),
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "New Contact",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is Required!';
                    }
                    return null;
                  },
                  controller: firstNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                    prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is Required!';
                    }
                    return null;
                  },
                  controller: lastNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last name',
                    prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gender is required!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      Icons.transgender,
                      color: AppColors.bgColor,
                    ),
                  ),
                  value: gender,
                  items: ["Male", "Female"]
                      .map(
                        (gen) => DropdownMenuItem(value: gen, child: Text(gen)),
                      )
                      .toList(),
                  onChanged: (val) => gender = val!,
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone is Required!';
                    }
                    return null;
                  },
                  controller: phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Company is Required!';
                    }
                    return null;
                  },
                  controller: companyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company',
                    prefixIcon: Icon(Icons.home, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_keyForm.currentState!.validate()) {
                      String strId = _auth.currentUser!.uid;
                      EasyLoading.show();
                      await Future.delayed(Duration(seconds: 1));
                      await _firestore.collection("contacts").add({
                        "firstname": firstNameController.text,
                        "lastname": lastNameController.text,
                        "gender": gender,
                        "phone": phoneController.text,
                        "company": companyController.text,
                        "create": strId,
                        "createAt": DateTime.now(),
                      });
                      EasyLoading.showSuccess("A contact added");
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save, color: AppColors.textColor),
                  label: Text(
                    "Save",
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bgColor,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateContactDialog(BuildContext context, Contact contact) {
    final firstNameController = TextEditingController(text: contact.firstname);
    final lastNameController = TextEditingController(text: contact.lastname);
    final phoneController = TextEditingController(text: contact.phone);
    final companyController = TextEditingController(text: contact.company);
    String gender = contact.gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 16,
          right: 16,
        ),
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "New Contact",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is Required!';
                    }
                    return null;
                  },
                  controller: firstNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                    prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is Required!';
                    }
                    return null;
                  },
                  controller: lastNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last name',
                    prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gender is required!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Gender',
                    prefixIcon: Icon(
                      Icons.transgender,
                      color: AppColors.bgColor,
                    ),
                  ),
                  value: gender,
                  items: ["Male", "Female"]
                      .map(
                        (gen) => DropdownMenuItem(value: gen, child: Text(gen)),
                      )
                      .toList(),
                  onChanged: (val) => gender = val!,
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone is Required!';
                    }
                    return null;
                  },
                  controller: phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Company is Required!';
                    }
                    return null;
                  },
                  controller: companyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Company',
                    prefixIcon: Icon(Icons.home, color: AppColors.bgColor),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_keyForm.currentState!.validate()) {
                      EasyLoading.show();
                      await Future.delayed(Duration(seconds: 1));

                      final updateContact = Contact(
                        id: contact.id,
                        firstname: firstNameController.text,
                        lastname: lastNameController.text,
                        gender: gender,
                        phone: phoneController.text,
                        company: companyController.text,
                      );

                      await _firestore
                          .collection('contacts')
                          .doc(contact.id)
                          .update(updateContact.toMap());

                      EasyLoading.showSuccess("A contact added");
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save, color: AppColors.textColor),
                  label: Text(
                    "Save Change",
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bgColor,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: [
          IconButton(
            onPressed: () => _addContactDialog(context),
            icon: Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: StreamBuilder<List<Contact>>(
        stream: getContacts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final contacts = snapshot.data!;
          if (contacts.isEmpty) {
            return Center(child: Text('No Contact'));
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final mycontact = contacts[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  onLongPress: () => _updateContactDialog(context, mycontact),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.bgColor,
                    child: Text(
                      mycontact.firstname.isNotEmpty
                          ? mycontact.firstname[0]
                          : "?",
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ),
                  title: Text("${mycontact.firstname} ${mycontact.lastname}"),
                  subtitle: Text("${mycontact.gender}, ${mycontact.phone}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Chip(
                        label: Text(mycontact.company),
                        backgroundColor: AppColors.bgColor.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          String strname =
                              "${mycontact.firstname} ${mycontact.lastname}";
                          deleteContact(context, mycontact.id, strname);
                        },
                        icon: Icon(Icons.delete, color: AppColors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
