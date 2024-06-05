import 'package:flutter/material.dart';
import 'package:todos/components/date_field_group.dart';
import 'package:todos/components/label_group.dart';
import 'package:todos/components/priority_field_group.dart';
import 'package:todos/components/time_field_group.dart';
import 'package:todos/const/route_argument.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/extension/date_time.dart';
import 'package:todos/extension/time_of_day.dart';
import 'package:todos/routes.dart';

class _OpenTypeConfig {
  final String title;
  final IconData icon;
  final void Function()? onPressed;

  const _OpenTypeConfig(this.title, this.icon, this.onPressed);
}

const TextStyle _labelTextStyle =
    TextStyle(color: Color(0xff1d1d26), fontFamily: 'Avenir', fontSize: 14.0);

const EdgeInsets _labelPadding = EdgeInsets.fromLTRB(20, 10, 20, 20);
const InputBorder _textFormBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black26, width: 0.5));

class TodoEditPage extends StatefulWidget {
  const TodoEditPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoEditPageState createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  bool isInitByRoute = false;
  OpenType _openType = OpenType.Preview;
  Todo? _todo;
  late Map<OpenType, _OpenTypeConfig> _openTypeConfigMap;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateTextEditingController =
      TextEditingController();
  final TextEditingController _startTimeTextEditingController =
      TextEditingController();
  final TextEditingController _endTimeTextEditingController =
      TextEditingController();

  void _edit() {
    setState(() {
      _openType = OpenType.Edit;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // save方法会调用所有表单项的onSave回调
      _formKey.currentState!.save();
      // 将todo作为返回值，这里todo就是一个Future<T>的T
      Navigator.of(context).pop(_todo);
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('TodoEdit page initState');
    _todo = Todo(date: DateTime.now().dayTime);

    _openTypeConfigMap = {
      OpenType.Preview: _OpenTypeConfig('查看待办事项', Icons.edit, _edit),
      OpenType.Edit: _OpenTypeConfig('编辑待办事项', Icons.check, _submit),
      OpenType.Add: _OpenTypeConfig('添加待办事项', Icons.check, _submit)
    };

    _dateTextEditingController.text = _todo!.date.dateString;
    _startTimeTextEditingController.text = _todo!.startTime.timeString;
    _endTimeTextEditingController.text = _todo!.endTime.timeString;
  }

  @override
  void dispose() {
    super.dispose();
    _dateTextEditingController.dispose();
    _startTimeTextEditingController.dispose();
    _endTimeTextEditingController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('didChangeDependencies called, ');
    if (!isInitByRoute) {
      // TODO: arguments在创建TODO时如何带上的？
      EditTodoPageArgument? arguments =
          ModalRoute.of(context)!.settings.arguments as EditTodoPageArgument?;
      if (arguments == null) {
        _openType = OpenType.Add;
      } else {
        _openType = arguments.openType;
      }

      debugPrint('arguments todo is : ${arguments?.openType}');
      _todo = arguments?.todo ?? _todo;
    }

    isInitByRoute = true;
    _dateTextEditingController.text = _todo!.date.dateString;
    _startTimeTextEditingController.text = _todo!.startTime.timeString;
    _endTimeTextEditingController.text = _todo!.endTime.timeString;
  }

  Widget _buildTextFormField(String title, String hintText,
      {int? maxLines, String? initialValue, FormFieldSetter<String>? onSaved}) {
    TextInputType inputType =
        maxLines == null ? TextInputType.multiline : TextInputType.text;
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: TextFormField(
        keyboardType: inputType,
        validator: (String? value) {
          return value == null ? '$title不能为空' : null;
        },
        onSaved: onSaved,
        textInputAction: TextInputAction.done,
        maxLines: maxLines,
        initialValue: initialValue,
        decoration:
            InputDecoration(hintText: hintText, enabledBorder: _textFormBorder),
      ),
    );
  }

  Widget _buildDateFormField(String title, String hintText,
      {DateTime? initialValue,
      TextEditingController? controller,
      Function(DateTime)? onSelect}) {
    DateTime now = DateTime.now();
    return LabelGroup(
        labelText: title,
        labelStyle: _labelTextStyle,
        padding: _labelPadding,
        child: DateFieldGroup(
            onSelect: onSelect,
            initialDate: initialValue,
            startDate:
                initialValue ?? DateTime(now.year, now.month, now.day - 1),
            endDate: DateTime(2025),
            child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: hintText, disabledBorder: _textFormBorder),
                validator: (String? value) {
                  return value == null ? '$title不能为空' : null;
                })));
  }

  Widget _buildTimeFormField(String title, String hintText,
      {TextEditingController? controller,
      TimeOfDay? initialValue,
      Function(TimeOfDay?)? onSelect}) {
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: TimeFieldGroup(
        onSelect: onSelect,
        initialTime: initialValue ?? const TimeOfDay(hour: 0, minute: 0),
        child: TextFormField(
          validator: (value) {
            if (value == null) {
              return '$title不能为空';
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            disabledBorder: _textFormBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityFormField(String title) {
    return LabelGroup(
        labelText: title,
        labelStyle: _labelTextStyle,
        padding: _labelPadding,
        child: PriorityFieldGroup(
          initialValue: _todo!.priority,
          onChange: (Priority priority) {
            setState(() {
              _todo!.priority = priority;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(_todo!.priority.description),
                    ),
                    Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 50,
                        color: _todo!.priority.color,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black26,
              )
            ],
          ),
        ));
  }

  Widget _buildForm() {
    bool canEdit = _openType != OpenType.Preview;
    return SingleChildScrollView(
      child: IgnorePointer(
        ignoring: !canEdit,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildTextFormField(
                    '名称',
                    '事项名称',
                    maxLines: 1,
                    initialValue: _todo!.title,
                    onSaved: (value) {
                      if (value != null) {
                        _todo!.title = value;
                      }
                    },
                  ),
                  _buildTextFormField(
                    '描述',
                    '事项描述',
                    initialValue: _todo!.description,
                    onSaved: (value) {
                      if (value != null) {
                        _todo!.description = value;
                      }
                    },
                  ),
                  _buildDateFormField('日期', '请选择日期',
                      initialValue: _todo!.date,
                      controller: _dateTextEditingController,
                      onSelect: (value) {
                    _todo!.date = value.dayTime;
                    // _dateTextEditingController.text = _todo!.date.dateString;
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: _buildTimeFormField('开始时间', '请选择开始时间',
                              initialValue: _todo!.startTime,
                              controller: _startTimeTextEditingController,
                              onSelect: (value) {
                        if (value != null) {
                          _todo!.startTime = value;
                          // _startTimeTextEditingController.text =
                          //     _todo!.startTime.timeString;
                        }
                      })),
                      Expanded(
                        child: _buildTimeFormField('结束时间', '请选择结束时间',
                            initialValue: _todo!.endTime,
                            controller: _endTimeTextEditingController,
                            onSelect: (value) {
                          if (value != null) {
                            _todo!.endTime = value;
                            // _endTimeTextEditingController.text =
                            //     _todo!.endTime.timeString;
                          }
                        }),
                      )
                    ],
                  ),
                  _buildPriorityFormField('优先级')
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                // TODO: 点击返回时，如果在编辑状态，应该根据是否表单项有变化来提醒用户当前正在编辑是否退出
                // 目前是直接返回，而且编辑态更改了表单项，也会保存后退出
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(INDEX_PAGE_URL));
          },
        ),
        title: Text(
          _openTypeConfigMap[_openType]!.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                _openTypeConfigMap[_openType]!.icon,
                color: Colors.black87,
              ),
              onPressed: _openTypeConfigMap[_openType]?.onPressed)
        ],
      ),
      body: _buildForm(),
    );
  }
}
