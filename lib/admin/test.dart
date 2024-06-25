import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/admin/financial_custody/financial_custody_order_details.dart';
import 'package:flutter/material.dart';

class ListViewPagination extends StatefulWidget {
  const ListViewPagination({super.key});

  @override
  State<ListViewPagination> createState() => _ListViewPaginationState();
}

class _ListViewPaginationState extends State<ListViewPagination> {
  final int _limit = 10;

  DocumentSnapshot? _lastDocument;

  bool _isLoading = false;

  bool _hasMoreData = true;

  final List<DocumentSnapshot> _documents = [];

  @override
  void initState() {
    super.initState();
    _fetchMoreData();
  }

  void _fetchMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    /// TODO: Change collection by collection name
    Query query = FirebaseFirestore.instance
        .collection("transactions")
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _lastDocument = snapshot.docs.last;
        _documents.addAll(snapshot.docs);
        _isLoading = false;
        if (snapshot.docs.length < _limit) {
          _hasMoreData = false;
        }
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            _hasMoreData) {
          _fetchMoreData();
        }
        return false;
      },
      child: _documents.isEmpty && !_isLoading
          ? const Center(child: Text("Empty list"))
          : ListView.builder(
        itemCount: _documents.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _documents.length) {
            return const LinearProgressIndicator();
          }

          final document = _documents[index];
          final data = document.data() as Map<String, dynamic>;

          /// TODO: Add data card here
          return InkWell(
            onTap: () {
              (user.type == "عهدة")
                  ? Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(
                    userData: user,
                  ),
                ),
              )
                  : () {};
            },
            child: Card(
              color: Colors.grey[200],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey),
              ),
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildListTile("User Email", user.email ?? ""),
                  buildListTile("User Name", user.userName ?? ""),
                  buildListTile("Budget Name", user.budgetName ?? ''),
                  buildListTile("Amount", "${user.amount ?? 0}"),
                  buildListTile("Budget Type", user.type ?? ''),
                  (user.cashOrCredit == false)
                      ? buildListTile("Payment Method", "Credit")
                      : buildListTile("Payment Method", "Cash"),
                  (user.cashOrCredit == false)
                      ? buildListTile(
                      "Bank Name", user.bankName ?? '')
                      : Container(),
                  (user.cashOrCredit == false)
                      ? buildListTile("Account Number",
                      "${user.accountNumber ?? 0}")
                      : Container(),
                  buildListTile("Status", user.status ?? ''),
                  buildListTile("Start Date", user.date ?? ''),
                  (user.type == "اذن صرف")
                      ? buildListTile(
                      "End Date", user.expected_date ?? '')
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  ListTile buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: SelectableText(
        subtitle,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}