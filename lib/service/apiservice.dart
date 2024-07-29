import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://reqres.in/api';
  static const String baseUrl1 = 'https://jsonblob.com/api/jsonBlob';
  static const String uaturl = 'http://150.230.238.12/dmsmobileapi/api';

  static Future<List<dynamic>> getUser(int dgroup, int dname) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      print('List API Response: ${response.body}');
      final data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<String>> labels(int dgroup, int dname) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Table1'] != null && data['Table1'].isNotEmpty) {
        return (data['Table1'][0] as Map<String, dynamic>).keys.toList();
      }
      return [];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> filterequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`=\'$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> filterbeginswith(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr` like \'$inv%\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> filtercontains(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr` like \'%25$inv%\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> filterendswith(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr` like \'%25$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> amountfilterequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`=$inv&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> amountfiltergreater(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`>$inv&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> amountfiltergreaterthanorequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`>=$inv&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> amountfilterlesser(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`<$inv&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> amountfilterlesserorequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`<$inv&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> datefilterequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`=\'$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> datefiltergreater(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`>\'$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> datefiltergreaterorequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`>=\'$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> datefilterlesser(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`<\'$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<dynamic>> datefilterlesserorequals(
      int dgroup, int dname, String attr, String inv) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report?DGroup=$dgroup&DName=$dname&dbCondition=`$attr`<=\'$inv\'&action=grid&activeflag&isPendingFileUpload=N'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      const baseUrl = 'http:\\\\150.230.238.12\\dmsfiles\\dmsdoc';
      List<dynamic> table = data['Table'];
      List<Map<String, dynamic>> updatedTable =
          table.map<Map<String, dynamic>>((item) {
        String filePath = item['File Path'];
        // Replace the local path with the base URL
        String newFilePath = filePath.replaceFirst('D:\\dmsfilesave', baseUrl);
        return {...item, 'File Path': newFilePath};
      }).toList();
      return updatedTable; // Return the list of users directly
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<Map<String, dynamic>> getBarChart(
      int empid, String orglvl1code, String orglvl2code) async {
    final response = await http.get(Uri.parse(
        '$uaturl/Dashboard/Dashboard?EmpId=$empid&orglvl1code=$orglvl1code&orglvl2code=$orglvl2code'));
    if (response.statusCode == 200) {
      print('Bar Chart API Response: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> login(
      String username, String password, String iv) async {
    final response = await http.post(Uri.parse(
        '$uaturl/login/validatelogin?txtusername=$username&txtpwd=$password&iv=$iv'));
    if (response.statusCode == 200) {
      print('Login API Response: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> doclabels(int empid) async {
    final response = await http
        .get(Uri.parse('$uaturl/dashboard/getdoclabels?EmpId=$empid'));
    if (response.statusCode == 200) {
      print("Doc Labels API Response : ${response.body}");
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> profile(int empid) async {
    final response =
        await http.post(Uri.parse('$uaturl/login/EmpProfile?emp_id=$empid'));
    if (response.statusCode == 200) {
      print("Profile Labels API Response : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> docgroupnames(
      int empid, String parentcode, String dependcode) async {
    final response = await http.get(Uri.parse(
        '$uaturl/dashboard/docgroupnames?EmpId=$empid&parentcode=$parentcode&dependcode="$dependcode'));
    if (response.statusCode == 200) {
      print("Group Names API Response : ${response.body}");
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> docnames(int empid) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report/getdocgroup?EmpId=$empid&p_action=getdocgroup'));
    if (response.statusCode == 200) {
      print("Doc Name API Response : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['Table'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> docgroupsnames(int empid) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report/getdocgroup?EmpId=$empid&p_action=getdocname'));
    if (response.statusCode == 200) {
      print("DocGroup Names API Response : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['Table'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> namegroup(
      int empid, String docname, int docgroupid) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report/getdocgroup?EmpId=$empid&p_action=$docname&docgroupid=$docgroupid'));
    if (response.statusCode == 200) {
      print("Namegroup API Response : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['Table'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> deptunit(String dept) async {
    final response = await http.get(Uri.parse(
        '$uaturl/report/getdocgroup?p_action=GetUnitForDept&p_department=$dept'));
    if (response.statusCode == 200) {
      print("DeptUnit API Response : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['Table'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> dashboard(
      int empid, String orglvl1code, String orglvl2code) async {
    final response = await http.get(Uri.parse(
        '$uaturl/Dashboard/Dashboard?EmpId=$empid&orglvl1code=$orglvl1code&orglvl2code=$orglvl2code'));
    if (response.statusCode == 200) {
      print("Dashboard API Response: ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String> forgotpassword(String empcode, String email) async {
    final response = await http.post(Uri.parse(
        '$uaturl/login/forgotpassword?emp_code=$empcode&Useremailid=$email'));

    if (response.statusCode == 200) {
      final responseBody = response.body.trim(); // Ensure it's trimmed
      print("forgotpassword API Response: $responseBody");
      return responseBody; // Return the plain text response
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static Future<String> changePassword({
    required String userName,
    required String password,
    required String iv,
    required String oldPassword,
    required String newPassword,
    required String cpassword,
  }) async {
    // Create the request body
    final Map<String, dynamic> body = {
      'userName': userName,
      'password': password,
      'iv': iv,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'cpassword': cpassword,
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse('$uaturl/login/Changepassword/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('Raw response body: ${response.body}');
      // Check if the request was successful
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to change password. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while changing the password.');
    }
  }
}
