import 'package:bytebank_dashboard/components/progress.dart';
import 'package:bytebank_dashboard/dao/contact_dao.dart';
import 'package:bytebank_dashboard/models/contact.dart';
import 'package:bytebank_dashboard/screens/contacts_form.dart';
import 'package:bytebank_dashboard/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class ContatctsList extends StatefulWidget {
  @override
  _ContatctsListState createState() => _ContatctsListState();
}

class _ContatctsListState extends State<ContatctsList> {
  final ContactDao contactDao = ContactDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: List(),
        future: contactDao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Contact contact = contacts[index];
                  return _ContactItem(
                    contact,
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TransactionForm(contact),
                        ),
                      );
                    },
                  );
                },
                itemCount: contacts.length,
              );
              break;
          }
          return Text('Unknown error has been detect');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ContactsForm(),
            ),
          )
              .then((value) {
            //Esse then serve para atualizar a lista apos o usuario confirmar a inclusao
            // do contato no formulario
            setState(() {
              widget.createState();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
