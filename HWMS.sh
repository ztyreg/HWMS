# 4_Homework_Management_System
# 郑天杨 3160102142
#!/bin/bash
#
# This is a simple homework management system.
# 3 groups of users: admin, teacher and student.


#######################################
# admnin_menu
# Description:
#   管理员菜单
#   管理员的操作是以admin_开头的函数
#   各admin_函数的含义见菜单函数内的注释
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0
#######################################
function admin_menu { # 管理员菜单
  printf "\n\t\t***** ADMIN Menu *****\n\n"
  printf "What do you want to do? (enter number)\n
  1 Create teacher accounts
  2 Edit teacher accounts
  3 Delete teacher accounts
  4 List teacher accounts
  5 Create courses
  6 Edit courses
  7 Delete courses
  8 Add teacher accounts to courses
  9 Delete teacher accounts from courses
  0 Exit\n"
  printf "\n==> Do: " # 选择

  local admin_action # 选择
  read admin_action

  case "$admin_action" in
    1) admin_ct # 创建教师账户
      ;;
    2) admin_et # 编辑教师账户
      ;;
    3) admin_dt # 删除教师账户
      ;;
    4) admin_lt # 显示教师账户
      ;;
    5) admin_cc # 创建课程
      ;;
    6) admin_ec # 编辑课程
      ;;
    7) admin_dc # 删除课程
      ;;
    8) admin_atc # 绑定教师与课程
      ;;
    9) admin_dtc # 解绑教师与课程
      ;;
    0) exit 0 # 退出
      ;;
    *) # 无效
      printf "Invalid Option. Try again.\n"
      admin_menu # 返回菜单
      ;;
  esac # 结束
}

function admin_ct() { # 创建教师账户
  printf "\n\t--- ADMIN Creating Teacher Accounts ---\n\n" # 提示
  printf "ADMIN: you are creating a new teacher account. You need to enter
  the teacher's work number and his/her name.\n"
  printf "\n==> Teacher's work number (enter 0 to return to menu): " # 输入提示

  local new_tch_work_number
  read new_tch_work_number # 读入

  local existed=$(awk -F"," -v var="$new_tch_work_number" '{if ($1 == var) \
  { print $1 }}' teacher_account 2> /dev/null) # 如果工号存在，输出工号；否则为0
  
  if [[ -n "$existed" ]]; then # 创建的工号已经存在
    printf "@@ work number already existed. Try again.\n"
    admin_ct
    exit 1
  fi

  if [[ "$new_tch_work_number" = 0 ]]; then # 选择退出
    admin_menu # 返回菜单
    exit 1
  fi

  if [[ -z "$new_tch_work_number" ]]; then # 不能为空
    printf "@@ Teacher's work number cannot be empty. Try again.\n"
    admin_ct # 重新创建
    exit 1
  fi

  printf "\n==> Teacher's name (enter 0 to return to menu): " # 输入提示

  local new_tch_name
  read new_tch_name # 读入

  if [[ "$new_tch_name" = 0 ]]; then # 选择退出
    admin_menu # 返回菜单
    exit 1
  fi

  if [[ -z "$new_tch_name" ]]; then # 不能为空
    printf "@@ Teacher's name cannot be empty. Try again.\n"
    admin_ct # 重新创建
    exit 1
  fi

  echo "$new_tch_work_number,$new_tch_name" # 打印
  echo "$new_tch_work_number,$new_tch_name" >> teacher_account # 添加记录

  printf "Creation succeeded! :)\n" # 成功
  admin_menu # 返回菜单
}

function admin_et() {
  printf "\n\t--- ADMIN Editing Teacher Accounts ---\n\n" # 提示
  printf "ADMIN: you are editing teacher accounts\n"
  printf "Please enter the teacher work number (enter 0 to return to menu):\n"
  printf "\n==> work number: " # 输入提示

  local edit_tch_work_number
  read edit_tch_work_number # 读入

  if [[ "$edit_tch_work_number" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  local edit_tch_name=0

  edit_tch_name=$(awk -F"," -v var="$edit_tch_work_number" '{if ($1 == var) \
  { print $2 }}' teacher_account 2> /dev/null) # 如果姓名存在，输出姓名；否则为0

  if [[ -z "$edit_tch_name" ]]; then #  检查输入的工号是否存在
    printf "@@ work number not found. Try again.\n"
    admin_et # 重新编辑
    exit 1
  fi

  printf "Please choose to (enter number):
  1 Edit teacher work number
  2 Edit teacher name\n"
  printf "\n==> Edit: " # 输入提示

  local admin_edit
  read admin_edit # 读入

  case "$admin_edit" in
    1)
      printf "\nADMIN: you are editing the work number of:
      $edit_tch_work_number
      $edit_tch_name\n"
      printf "\n==> Enter new work number: " # 输入提示

      local tmp
      read tmp # 读入
      local existed=$(awk -F"," -v var="$tmp" '{if ($1 == var) \
      { print $1 }}' teacher_account 2> /dev/null) # 如果工号存在，输出工号；否则为0

      if [[ -n "$existed" ]]; then # 修改的工号已经存在
        printf "@@ work number already existed. Try again.\n"
        admin_et
        exit 1
      fi

      if [[ -z "$tmp" ]]; then # 不能为空
        printf "@@ Teacher's work number cannot be empty. Try again.\n"
        admin_et # 重新编辑
        exit 1
      fi

      sed -i /$edit_tch_work_number/d teacher_account # 删除原记录
      echo "$tmp,$edit_tch_name" >> teacher_account # 添加新记录
      ;;
    2)
      printf "\nADMIN: you are editing the name of:
      $edit_tch_work_number
      $edit_tch_name\n"
      printf "\n==> Enter new name: " # 输入提示

      local tmp
      read tmp # 读入

      if [[ -z "$tmp" ]]; then # 不能为空
        printf "@@ Teacher's name cannot be empty. Try again.\n"
        admin_et # 重新编辑
        exit 1
      fi

      sed -i /$edit_tch_work_number/d teacher_account # 删除原记录
      echo "$edit_tch_work_number,$tmp" >> teacher_account # 添加新记录
      ;;
  esac

  printf "Editing succeeded! :)\n" # 成功
  admin_menu # 返回菜单
}

function admin_dt() {
  printf "\n\t--- ADMIN Deleting Teacher Accounts ---\n\n" # 提示
  printf "ADMIN: you are deleting teacher accounts\n"
  printf "Please enter the teacher work number (enter 0 to return to menu):\n"
  printf "\n==> work number: " # 输入提示

  local delete_tch_work_number
  read delete_tch_work_number # 读入

  if [[ "$delete_tch_work_number" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  delete_tch_work_number=$(awk -F"," -v var="$delete_tch_work_number" '{if ($1 == var) \
  { print $1 }}' teacher_account 2> /dev/null) # 如果工号存在，输出工号；否则为0

  if [[ -z "$delete_tch_work_number" ]]; then #  检查输入的工号是否存在
    printf "@@ work number not found. Try again.\n"
    admin_dt # 重新编辑
    exit 1
  fi

  sed -i /$delete_tch_work_number/d teacher_account # 删除记录

  printf "Deletion succeeded! :)\n"
  admin_menu # 返回菜单
}

function admin_lt() {
  printf "\n\t--- ADMIN Listing Teacher Accounts ---\n\n" # 提示
  awk -F"," '{print $1"\t"$2}' teacher_account 2> /dev/null
  admin_menu # 返回菜单
}

function admin_cc() {
  printf "\n\t--- ADMIN Creating Courses ---\n\n" # 提示
  printf "ADMIN: you are creating a new course. You need to enter
  the course name.\n"
  printf "\n==> Course name (enter 0 to return to menu): " # 输入提示

  local new_cs_name
  read new_cs_name # 读入

  local existed=$(awk -F"," -v var="$new_cs_name" '{if ($1 == var) \
  { print $1 }}' course_list 2> /dev/null) # 如果名称存在，输出名称；否则为0
  
  if [[ -n "$existed" ]]; then # 创建的课程已经存在
    printf "@@ Course already existed. Try again.\n"
    admin_cc
    exit 1
  fi

  if [[ "$new_cs_name" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  if [[ -z "$new_cs_name" ]]; then # 不能为空
    printf "@@ Course name cannot be empty. Try again.\n"
    admin_cc # 重新创建
    exit 1
  fi

  echo "$new_cs_name"
  echo "$new_cs_name" >> course_list # 添加记录

  printf "Creation succeeded! :)\n"
  admin_menu # 返回菜单
}

function admin_ec() {
  printf "\n\t--- ADMIN Editing Courses ---\n\n" # 提示
  printf "ADMIN: you are editing courses\n"
  printf "Please enter the course name (enter 0 to return to menu):\n"
  printf "\n==> Course name: " # 输入提示

  local edit_cs_name
  read edit_cs_name # 读入

  if [[ "$edit_cs_name" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  edit_cs_name=$(awk -F"," -v var="$edit_cs_name" '{if ($1 == var) \
  { print $1 }}' course_list 2> /dev/null) # 如果名称存在，输出名称；否则为0

  if [[ -z "$edit_cs_name" ]]; then #  检查输入的课程名称是否存在
    printf "@@ Course name not found. Try again.\n"
    admin_ec # 重新编辑
    exit 1
  fi

  printf "\nADMIN: you are editing the course name of:
  $edit_cs_name\n" # 提示
  printf "\n==> Enter new course name: " # 输入提示

  local tmp
  read tmp # 读入
  local existed=$(awk -F"," -v var="$tmp" '{if ($1 == var) \
  { print $1 }}' course_list 2> /dev/null) # 如果名称存在，输出名称；否则为0

  if [[ -n "$existed" ]]; then # 修改的课程名称已经存在
    printf "@@ Course name already existed. Try again.\n"
    admin_ec
    exit 1
  fi

  if [[ -z "$tmp" ]]; then # 不能为空
    printf "@@ Course name cannot be empty. Try again.\n"
    admin_ec # 重新编辑
    exit 1
  fi

  sed -i /$edit_cs_name/d course_list # 删除原记录
  echo "$tmp" >> course_list # 添加新记录
  
  printf "Editing succeeded! :)\n"
  admin_menu # 返回菜单
}

function admin_dc() {
  printf "\n\t--- ADMIN Deleting Courses ---\n\n" # 提示
  printf "ADMIN: you are deleting courses\n"
  printf "Please enter the course name (enter 0 to return to menu):\n"
  printf "\n==> Course name: " # 输入提示

  local delete_cs_name
  read delete_cs_name # 读入

  if [[ "$delete_cs_name" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  delete_cs_name=$(awk -F"," -v var="$delete_cs_name" '{if ($1 == var) \
  { print $1 }}' course_list 2> /dev/null) # 如果名称存在，输出名称；否则为0

  if [[ -z "$delete_cs_name" ]]; then # 检查输入的课程名称是否存在
    printf "@@ Course name not found. Try again.\n"
    admin_dc # 重新编辑
    exit 1
  fi

  sed -i /$delete_cs_name/d course_list # 删除记录

  printf "Deletion succeeded! :)\n"
  admin_menu # 返回菜单
}

function admin_atc() {
  printf "\n\t--- ADMIN Adding Teacher Accounts to Courses ---\n\n" # 提示
  printf "ADMIN: you are adding teacher accounts to courses\n"
  printf "Please enter the course name (enter 0 to return to menu):\n"
  printf "\n==> Course name: " # 输入提示

  # 课程
  local atc_cs_name
  read atc_cs_name # 读入

  if [[ "$atc_cs_name" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  atc_cs_name=$(awk -F"," -v var="$atc_cs_name" '{if ($1 == var) \
  { print $1 }}' course_list 2> /dev/null) # 如果名称存在，输出名称；否则为0

  if [[ -z "$atc_cs_name" ]]; then #  检查输入的课程名称是否存在
    printf "@@ Course name not found. Try again.\n"
    admin_atc # 重新编辑
    exit 1
  fi

  # 教师
  printf "Please enter the teacher work number (enter 0 to return to menu):\n"
  printf "\n==> work number: " # 输入提示

  local atc_tch_work_number
  read atc_tch_work_number # 读入

  if [[ "$atc_tch_work_number" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  atc_tch_work_number=$(awk -F"," -v var="$atc_tch_work_number" '{if ($1 == var) \
  { print $1 }}' teacher_account 2> /dev/null) # 如果工号存在，输出工号；否则为0

  if [[ -z "$atc_tch_work_number" ]]; then #  检查输入的工号是否存在
    printf "@@ work number not found. Try again.\n"
    admin_atc # 重新编辑
    exit 1
  fi

  # 添加
  sed -i "/$atc_cs_name/s/$/,$atc_tch_work_number/" course_list

  local atc_tch_name
  atc_tch_name=$(awk -F"," -v var="$atc_tch_work_number" '{if ($1 == var) \
  { print $2 }}' teacher_account 2> /dev/null) # 如果名称存在，输出名称；否则为0

  echo "$atc_tch_work_number $atc_tch_name teaching $atc_cs_name"
  printf "Adding teacher accounts to courses succeeded! :)\n"
  admin_menu # 返回菜单
}

function admin_dtc() {
  printf "\n\t--- ADMIN Adding Teacher Accounts to Courses ---\n\n" # 提示
  printf "ADMIN: you are adding teacher accounts to courses\n"
  printf "Please enter the course name (enter 0 to return to menu):\n"
  printf "\n==> Course name: " # 输入提示

  # 课程
  local dtc_cs_name
  read dtc_cs_name # 读入

  if [[ "$dtc_cs_name" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  dtc_cs_name=$(awk -F"," -v var="$dtc_cs_name" '{if ($1 == var) \
  { print $1 }}' course_list 2> /dev/null) # 如果名称存在，输出名称；否则为0

  if [[ -z "$dtc_cs_name" ]]; then #  检查输入的课程名称是否存在
    printf "@@ Course name not found. Try again.\n"
    admin_dtc # 重新编辑
    exit 1
  fi

  # 教师
  printf "Please enter the teacher work number (enter 0 to return to menu):\n"
  printf "\n==> work number: " # 输入提示

  local dtc_tch_work_number
  read dtc_tch_work_number # 读入

  if [[ "$dtc_tch_work_number" = 0 ]]; then
    admin_menu # 返回菜单
    exit 1
  fi

  dtc_tch_work_number=$(awk -F"," -v var="$dtc_tch_work_number" '{if ($1 == var) \
  { print $1 }}' teacher_account 2> /dev/null)  # 如果工号存在，输出工号；否则为0

  if [[ -z "$dtc_tch_work_number" ]]; then #  检查输入的工号是否存在
    printf "@@ work number not found. Try again.\n"
    admin_dtc # 重新编辑
    exit 1
  fi

  # 删除
  sed -i "/$dtc_cs_name/s/,$dtc_tch_work_number//" course_list

  local dtc_tch_name
  dtc_tch_name=$(awk -F"," -v var="$dtc_tch_work_number" '{if ($1 == var) \
  { print $2 }}' teacher_account 2> /dev/null)  # 如果名称存在，输出名称；否则为0

  echo "$dtc_tch_work_number $dtc_tch_name NOT teaching $dtc_cs_name"
  printf "Deleting teacher accounts from courses succeeded! :)\n"
  admin_menu # 返回菜单
}

#######################################
# teacher_menu
# Description:
#   教师菜单
#   教师的操作是以teacher_开头的函数
#   各teacher_函数的含义见菜单函数内的注释
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0
#######################################
function teacher_menu() { # 教师菜单
  printf "\n\t\t***** TEACHER Menu *****\n\n"
  printf "~~HELLO: $1 $2\n"
  printf "What do you want to do? (enter number)\n
  1 Create student accounts for courses
  2 Import student accounts for courses
  3 Edit student accounts for courses
  4 Delete student accounts for courses
  5 Find student accounts
  6 Create/edit course information
  7 Delete course information
  8 List course information
  9 Create/edit labs
  10 Delete labs
  11 List labs
  12 Find student homework completion state
  13 Print student homework completion state
  0 Exit\n"
  printf "\n==> Do: " # 选择

  local teacher_action # 选择
  read teacher_action

  case "$teacher_action" in
    1) teacher_cs "$1" "$2" # 创建学生账号
      ;;
    2) teacher_is "$1" "$2" # 导入学生账号
      ;;
    3) teacher_es "$1" "$2" # 编辑学生账号
      ;;
    4) teacher_ds "$1" "$2" # 删除学生账号
      ;;
    5) teacher_fs "$1" "$2" # 查找学生账号
      ;;
    6) teacher_cci "$1" "$2" # 创建编辑课程信息
      ;;
    7) teacher_dci "$1" "$2" # 删除课程信息
      ;;
    8) teacher_lci "$1" "$2" # 显示课程信息
      ;;
    9) teacher_cl "$1" "$2" # 创建作业
      ;;
    10) teacher_dl "$1" "$2" # 删除作业
      ;;
    11) teacher_ll "$1" "$2" # 显示作业
      ;;
    12) teacher_fl "$1" "$2" # 查找学生作业完成情况
      ;;
    13) teacher_pl "$1" "$2" # 打印学生作业完成情况
      ;;
    0) exit 0 # 退出
      ;;
    *) # 无效
      printf "Invalid Option. Try again.\n"
      teacher_menu "$1" "$2"
      ;;
  esac # 结束
}

function teacher_cs() {
  printf "\n\t--- TEACHER Creating Student Accounts ---\n\n" # 创建学生账户
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are creating a new student account. You need to enter
  the course name, the student number and his/her name.\n"
  
  # 选择课程名称
  teacher_select_course "$1" "$2"
  local new_stu_course_name=$tmp_course_name
  # 结束选择课程名称

  printf "\n==> Student number (enter 0 to return to menu): " # 学号

  local new_stu_number # 学号
  read new_stu_number

  local existed=$(awk -F"," -v var="$new_stu_number" '{if ($3 == var) \
  { print $1 }}' course_data 2> /dev/null) # 检查学号是否存在
  
  if [[ -n "$existed" ]]; then # 创建的学号已经存在
    printf "@@ Student number already existed. Try again.\n"
    teacher_cs "$1" "$2"
    exit 1
  fi

  if [[ "$new_stu_number" = 0 ]]; then # 选择退出
    teacher_menu "$1" "$2"
    exit 1
  fi

  if [[ -z "$new_stu_number" ]]; then # 不能为空
    printf "@@ Student number cannot be empty. Try again.\n"
    teacher_cs "$1" "$2"
    exit 1
  fi

  printf "\n==> Student's name (enter 0 to return to menu): " # 学生姓名

  local new_stu_name # 学生姓名
  read new_stu_name

  if [[ "$new_stu_name" = 0 ]]; then # 选择退出
    teacher_menu "$1" "$2"
    exit 1
  fi

  if [[ -z "$new_stu_name" ]]; then # 不能为空
    printf "@@ Student's name cannot be empty. Try again.\n"
    teacher_cs "$1" "$2"
    exit 1
  fi

  # echo "$new_stu_number,$new_stu_name" # 学号和姓名
  # echo "$new_stu_number,$new_stu_name" >> student_account
  echo "$new_stu_course_name,$1,$new_stu_number,$new_stu_name" >> course_data

  echo "$new_stu_name in $new_stu_course_name taught by $2" # 提示
  printf "Creation succeeded! :)\n" # 成功
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_is() {
  printf "\n\t--- TEACHER Importing Student Accounts ---\n\n" # 导入学生账户
  printf "~~HELLO: $1 $2\n"  # 欢迎
  printf "TEACHER: you are importing student accounts. You need to enter
  the course name and to specify the input file." 

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local imp_stu_course_name=$tmp_course_name
  # 结束选择课程名称

  printf "Please enter the input file name (enter 0 to exit):\n"
  printf "\n==> Input file name (enter name): " # 输入提示

  local imp_stu_file
  read imp_stu_file # 读入

  if [[ ! -e "$imp_stu_file" ]]; then # 检查文件是否存在
    echo "@@ File does not exist! Try again."
    teacher_is "$1" "$2"
    exit 1 # 退出
  fi

  awk -F"," -v cs="$imp_stu_course_name" -v tch="$1" \
  '{print cs","tch","$1","$2}' "$imp_stu_file" >> course_data # 添加记录

  awk '!seen[$0]++' course_data > tmpfile # 不重复
  cat tmpfile > course_data
  rm tmpfile

  # cat "$imp_stu_file" >> student_account
  # awk '!seen[$0]++' student_account > tmpfile
  # cat tmpfile > student_account
  # rm tmpfile

  printf "Import succeeded! :)\n" # 成功
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_es() {
  printf "\n\t--- TEACHER Importing Student Accounts ---\n\n" # 导入学生账户
  printf "~~HELLO: $1 $2\n"  # 欢迎
  printf "\nTEACHER: you are editing student accounts. You need to enter
  the course name and to specify the input file." 

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local edit_stu_course_name=$tmp_course_name
  # 结束选择课程名称

  # 选择学生
  teacher_course_select_student "$1" "$2" "$edit_stu_course_name"
  local edit_stu_number=$tmp_stu_number
  local edit_stu_name=$tmp_stu_name
  # 结束选择学生

  # 开始编辑
  printf "Please choose to (enter number):
  1 Edit student number
  2 Edit student name\n"
  printf "\n==> Edit: " # 输入提示

  local teacher_edit # 选项
  read teacher_edit

  case "$teacher_edit" in
    1) # 编辑学号
      printf "\nTEACHER: you are editing the student number of:
      $edit_stu_number
      $edit_stu_name\n"
      printf "\n==> Enter new student number: " # 输入

      local tmp
      read tmp # 新学号
      local existed=$(awk -F"," -v var="$tmp" '{if ($3 == var) \
      { print $3 }}' course_data 2> /dev/null)

      if [[ -n "$existed" ]]; then # 修改的学号已经存在
        printf "@@ student number already existed. Try again.\n"
        teacher_es "$1" "$2"
        exit 1
      fi

      if [[ -z "$tmp" ]]; then # 不能为空
        printf "@@ Student number cannot be empty. Try again.\n"
        teacher_es "$1" "$2" # 重新编辑
        exit 1
      fi

      sed -i "s/$edit_stu_course_name,$1,$edit_stu_number/$edit_stu_course_name,$1,$tmp/" \
      course_data # 替换
      ;;
    2) # 编辑姓名
      printf "\nTEACHER: you are editing the student number of:
      $edit_stu_number
      $edit_stu_name\n"
      printf "\n==> Enter new name: " # 输入

      local tmp
      read tmp # 读入

      if [[ -z "$tmp" ]]; then # 不能为空
        printf "@@ Student name cannot be empty. Try again.\n"
        teacher_es "$1" "$2" # 重新编辑
        exit 1
      fi

      sed -i "s/$edit_stu_course_name,$1,$edit_stu_number,$edit_stu_name/$edit_stu_course_name,$1,$edit_stu_number,$tmp/" \
      course_data # 替换
      ;;
  esac

  printf "Editing succeeded! :)\n"
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_ds() {
  printf "\n\t--- TEACHER Deleting Student Accounts ---\n\n" # 删除学生账户
  printf "~~HELLO: $1 $2\n"  # 欢迎
  printf "TEACHER: you are deleting student accounts\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local delete_stu_course_name=$tmp_course_name
  # 结束选择课程名称

  # 选择学生
  teacher_course_select_student "$1" "$2" "$delete_stu_course_name"
  local delete_stu_number=$tmp_stu_number
  local delete_stu_name=$tmp_stu_name
  # 结束选择学生

  sed -i "/$delete_stu_course_name,$1,$delete_stu_number/d" course_data # 删除

  echo "$delete_stu_number $delete_stu_name of $delete_stu_course_name deleted."
  printf "Deletion succeeded! :)\n"
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_fs() {
  printf "\n\t--- TEACHER Finding Student Accounts ---\n\n" # 删除学生账户
  printf "~~HELLO: $1 $2\n"  # 欢迎
  printf "TEACHER: you are finding student accounts\n"
  printf "Please enter the student number\n"
  printf "\n==> Student number (enter 0 to return to menu): " # 学号

  local find_stu_number # 学号
  read find_stu_number

  if [[ "$find_stu_number" = 0 ]]; then # 选择退出
    teacher_menu "$1" "$2"
    exit 1
  fi

  if [[ -z "$find_stu_number" ]]; then # 不能为空
    printf "@@ Student number cannot be empty. Try again.\n"
    teacher_fs "$1" "$2"
    exit 1
  fi

  local existed=$(awk -F"," -v var="$find_stu_number" '{if ($3 == var) \
  { print $1 }}' course_data 2> /dev/null) # 检查学号是否存在
  
  if [[ -z "$existed" ]]; then # 学号不存在
    printf "@@ Student number does not exist. Try again.\n"
    teacher_fs "$1" "$2"
    exit 1
  fi

  local find_stu_name=$(awk -F"," -v var="$find_stu_number" '{if ($3 == var) \
  { print $4 }}' course_data 2> /dev/null) # 检查学号是否存在
  printf "$find_stu_number $find_stu_name enrolled in:\n"
  awk -F"," -v var="$find_stu_number" 'var ~ $3 {print $1,$2}' course_data
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_cci() {
  printf "\n\t--- TEACHER Creating/Editing Course Information ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are creating/editing course information.
  You need to enter the course name.\n"
  
  printf "The information of your courses:\n" # 已有课程信息
  printf "  =========================\n"
  ls *_"${1}"_info 2> /dev/null | awk '{print "  "$0}' | sort
  printf "  =========================\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local new_info_course_name=$tmp_course_name
  # 结束选择课程名称

  vim "${new_info_course_name}_${1}_info" # 创建编辑课程信息

  printf "Course information for $new_info_course_name:\n" # 打印课程信息
  printf "  ^^^^^^^\n"
  cat "${new_info_course_name}_${1}_info"
  printf "  ^^^^^^^\n"
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_dci() {
  printf "\n\t--- TEACHER Deleting Course Information ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are deleting course information.
  You need to enter the course name.\n"
  
  printf "The information of your courses:\n" # 已有课程信息
  printf "  =========================\n"
  ls *_"${1}"_info 2> /dev/null | awk '{print "  "$0}' | sort
  printf "  =========================\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local delete_info_course_name=$tmp_course_name
  # 结束选择课程名称

  rm "${delete_info_course_name}_${1}_info" 2> /dev/null # 删除
  if [[ "$?" -eq 1 ]] ; then
    echo "@@ No course information for $delete_info_course_name." # 没有文件
  else
    printf "Course information for $delete_info_course_name deleted.\n" # 删除成功
  fi

  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_lci() {
  printf "\n\t--- TEACHER Listing Course Information ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are listing course information.
  You need to enter the course name.\n"
  
  printf "The information of your courses:\n" # 显示已有课程信息
  printf "  =========================\n"
  ls *_"${1}"_info 2> /dev/null | awk '{print "  "$0}' | sort
  printf "  =========================\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local list_info_course_name=$tmp_course_name
  # 结束选择课程名称

  if [[ -e "${list_info_course_name}_${1}_info" ]]; then
    printf "Course information for $list_info_course_name:\n" # 课程信息
    printf "  ^^^^^^^\n"
    cat "${list_info_course_name}_${1}_info" # 文件内容
    printf "  ^^^^^^^\n"
  else
    echo "@@ No course information for $list_info_course_name." # 无文件
  fi
  
  read -p "Press enter to continue"
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_cl() {
  printf "\n\t--- TEACHER Creating/Editing Labs ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are creating/editing labs.
  You need to enter the course name.\n"
  
  printf "The labs of your courses:\n" # 显示已有作业
  printf "  =========================\n"
  ls *_"${1}"_lab 2> /dev/null | awk -F"_" '{print "  "$1}' | sort
  printf "  =========================\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local new_lab_course_name=$tmp_course_name
  # 结束选择课程名称

  vim "${new_lab_course_name}_${1}_lab" # 编辑作业

  printf "Lab for $new_lab_course_name:\n" # 显示作业内容
  printf "  ^^^^^^^^^^^^^^^^^^^^^\n"
  cat "${new_lab_course_name}_${1}_lab"
  printf "  ^^^^^^^^^^^^^^^^^^^^^\n"
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_dl() {
  printf "\n\t--- TEACHER Deleting Labs ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are deleting labs.
  You need to enter the course name.\n"
  
  printf "The labs of your courses:\n" # 显示已有作业
  printf "  =========================\n"
  ls *_"${1}"_lab 2> /dev/null | awk -F"_" '{print "  "$1}' | sort
  printf "  =========================\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local delete_lab_course_name=$tmp_course_name
  # 结束选择课程名称

  rm "${delete_lab_course_name}_${1}_lab" 2> /dev/null # 删除作业
  if [[ "$?" -eq 1 ]] ; then
    echo "@@ No lab for $delete_lab_course_name." # 没有作业
  else
    printf "Lab for $delete_lab_course_name deleted.\n" # 成功删除
  fi

  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_ll() {
  printf "\n\t--- TEACHER Listing Labs ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are listing labs.
  You need to enter the course name.\n"
  
  printf "The labs of your courses:\n" # 显示已有作业
  printf "  =========================\n"
  ls *_"${1}"_lab 2> /dev/null | awk '{print "  "$0}' | sort
  printf "  =========================\n"

  # 选择课程名称
  teacher_select_course "$1" "$2"
  local list_lab_course_name=$tmp_course_name
  # 结束选择课程名称

  if [[ -e "${list_lab_course_name}_${1}_lab" ]]; then # 文件存在
    printf "Lab for $list_lab_course_name:\n"
    printf "  ^^^^^^^\n"
    cat "${list_lab_course_name}_${1}_lab" # 显示
    printf "  ^^^^^^^\n"
  else
    echo "@@ No lab for $list_lab_course_name." #不存在
  fi
  
  read -p "Press enter to continue"
  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_fl() {
  printf "\n\t--- TEACHER Finding Homework Completion States ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are finding homework completion states.
  You need to enter the course name and the student number.\n"
  
  # 选择课程名称
  teacher_select_course "$1" "$2"
  local find_course_name=$tmp_course_name
  # 结束选择课程名称

  # 选择学生
  teacher_course_select_student "$1" "$2" "$find_course_name"
  local find_stu_number=$tmp_stu_number
  local find_stu_name=$tmp_stu_name
  # 结束选择学生

  printf "The homework state of $find_stu_number $find_stu_name in $find_course_name is:\n"
  local completed=$(awk -F"," -v var="$find_course_name,$1,$find_stu_number" \
  '{print $5}' course_data) # 完成状态

  if [[ "$completed" -eq 0 || -z "$completed" ]]; then # 不存在或为0
    printf "NOT completed.\n" # 未完成
  else 
    printf "Completed.\n" # 已完成
  fi

  teacher_menu "$1" "$2" # 回到菜单
}

function teacher_pl() {
  printf "\n\t--- TEACHER Printing Homework Completion States ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "TEACHER: you are printing homework completion states.
  You need to enter the course name.\n"
  
  # 选择课程名称
  teacher_select_course "$1" "$2"
  local print_course_name=$tmp_course_name
  # 结束选择课程名称

  printf "Homework states of $print_course_name (1: completed):\n" # 作业完成情况
  printf "  =======================================\n"
  # awk -F"," -v var="$print_course_name,$1" \
  # 'BEGIN {print "  Number Name\t\t\tState"} \
  # var ~ $0 {print "  "$3,$4"\t\t"$5}' course_data
  printf "  Course #TCH #STU Name\tState\n"
  sed "/$print_course_name,$1/s/^/  /p" course_data # 用sed打印作业完成情况
  printf "  =======================================\n"

  read -p "Press enter to continue"
  teacher_menu "$1" "$2" # 回到菜单
}

#######################################
# teacher_select_course
# Description:
#   管理员创建教师账户
# Globals:
#   tmp_course_name
# Arguments:
#   teacher work number
#   teacher name
# Returns:
#   0
#######################################
function teacher_select_course() {
  # 开始查找教师所教课程
  printf "The course(s) you teach are:\n" # 列出所教课程
  printf "  =========================\n"
  awk -F"," -v tch="$1" '$0~tch {print "  "$1}' course_list | sort # 列出所教课程
  tmp_cs=$(awk -F"," -v tch="$1" 'BEGIN { ORS="," }; \
  $0~tch {print $1}' course_list) # 另一格式，每一个课程名后都有一个逗号
  tmp_cs=,$tmp_cs # 再加一个逗号
  printf "  =========================\n"
  printf "Please choose from the courses listed above.\n"
  printf "\n==> Course name (enter name, 0 to exit): " # 选择课程
  # 结束查找教师所教课程

  declare -g tmp_course_name # 课程名称
  tmp_course_name=""
  read tmp_course_name # 读入

  # 用grep测试输入是否在课程列表里
  if echo "$tmp_cs" | grep ",$tmp_course_name," 1> /dev/null; then
    echo "You choosed $tmp_course_name" 
  else
    printf "@@ Invalid course name. Try again.\n" # 如果不在，输入无效
    teacher_select_course "$1" "$2" "$3"
  fi

  if [[ "$tmp_course_name" = 0 ]]; then # 选择退出
    teacher_menu "$1" "$2"
  fi
}

#######################################
# teacher_course_select_student
# Globals:
#   tmp_stu_number
#   tmp_stu_name
# Arguments:
#   teacher work number
#   teacher name
#   course name
# Returns:
#   0
#######################################
function teacher_course_select_student() {
  # 开始列出课程学生列表
  printf "The student(s) of $3 are:\n" # 列出课程学生
  printf "  ========================================\n"
  awk -F"," -v var="$3,$1" \
  '$0~var {print "  "$3,$4}' course_data | sort
  tmp_cs=$(awk -F"," -v var="$3,$1" 'BEGIN { ORS="," }; \
  $0~var {print $3}' course_data) # 另一格式，每一个学号后都有一个逗号
  tmp_cs=,$tmp_cs # 再加一个逗号
  printf "  ========================================\n"
  printf "Please choose from the students listed above.\n"
  printf "\n==> Student number (enter number, 0 to exit): " # 选择学生
  # 结束列出课程学生列表

  declare -g tmp_stu_number
  tmp_stu_number=
  read tmp_stu_number # 读入

  # 开始用grep测试输入是否在学生列表里
  if echo "$tmp_cs" | grep ",$tmp_stu_number," 1> /dev/null; then
    echo "Editing student accounts $tmp_stu_number" 
  else
    printf "@@ Invalid student number. Try again.\n" # 如果不在，输入无效
    teacher_es "$1" "$2"
  fi
  # 结束用grep测试输入是否在学生列表里

  # 获取学生姓名
  tmp_stu_name=$(awk -F"," -v var="$tmp_stu_number" 'var ~ $3 {f=1} \
  f{print $4; exit}' course_data)
}

#######################################
# student_menu
# Description:
#   学生菜单
#   学生的操作是以student_开头的函数
#   各student_函数的含义见菜单函数内的注释
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0
#######################################
function student_menu() { # 学生菜单
  printf "\n\t\t***** TEACHER Menu *****\n\n"
  printf "~~HELLO: $1 $2\n"
  printf "What do you want to do? (enter number)\n
  1 Create/edit labs
  2 Find lab completion states
  0 Exit\n"
  printf "\n==> Do: " # 选择

  local student_action # 选择
  read student_action

  case "$student_action" in
    1) student_cl "$1" "$2" # 创建作业
      ;;
    2) student_fl "$1" "$2" # 查找作业完成情况
      ;;
    0) exit 0 # 退出
      ;;
    *) # 无效
      printf "Invalid Option. Try again.\n"
      student_menu "$1" "$2" # 返回菜单
      ;;
  esac
}

function student_cl() {
  printf "\n\t--- STUDENT Creating/Editing Labs ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "STUDENT: you are creating/editing labs.
  You need to enter the course name.\n"
  
  printf "The labs of your courses:\n" # 显示作业
  printf "  =========================\n"

  awk -F"," -v var="$1" 'var ~ $3 {print $1"_"$2}' course_data > tmpfile # 临时文件
 
  while IFS='' read -r line || [[ -n "$line" ]]; do
    ls "${line}_lab" >> tmpfile2 # 临时文件，用于提取作业完成情况
  done < tmpfile

  cat tmpfile2 | sed s/_lab//g > tmp_cs_tch # 一些操作
  awk -F"_" '{print "  "$1}' tmpfile
  tmp_cs=$(awk -F"_" 'BEGIN {ORS=","} {print $1}' tmpfile)
  tmp_cs=,$tmp_cs
  rm tmpfile tmpfile2 # 删除临时文件

  printf "  =========================\n"
  printf "Please choose from the courses listed above.\n"
  printf "\n==> Course name (enter name, 0 to exit): " # 选择课程

  local tmp_course_name
  read tmp_course_name # 读入

  # 用grep测试输入是否在课程列表里
  if echo "$tmp_cs" | grep ",$tmp_course_name," 1> /dev/null; then
    echo "You are to edit the lab of $tmp_course_name" 
  else
    printf "@@ Invalid course name. Try again.\n" # 如果不在，输入无效
    student_cl "$1" "$2"
  fi

  if [[ "$tmp_course_name" = 0 ]]; then # 选择退出
    student_menu "$1" "$2" # 返回菜单
  fi

  tmp_name=$(awk -F"_" -v var="$tmp_course_name" 'BEGIN {ORS=""} var==$1 {print $0}' \
  tmp_cs_tch) # 临时变量
  rm tmp_cs_tch

  read -p "Press enter to continue"
  vim "${tmp_name}_${1}_lab" # 编辑作业

  tmp_match=$(echo "${tmp_name}_${1}_lab" | sed 's/_/,/g' | sed 's/lab//g')

  if [[ -e "${tmp_name}_${1}_lab" ]]; then # 文件存在
    cat course_data | sed "/$tmp_match/s/$/,1/g" > tmpfile
    cat tmpfile > course_data
    rm tmpfile
  fi 

  printf "Lab submitted! :)\n" # 成功提交
  read -p "Press enter to continue"
  student_menu "$1" "$2" # 返回菜单
}

function student_fl() {
  printf "\n\t--- STUDENT Finding Lab States ---\n\n" # 课程信息
  printf "~~HELLO: $1 $2\n" # 欢迎
  printf "STUDENT: you are finding lab states.\n"

  printf "The lab states of your courses:\n" # 作业完成情况
  printf "  =======================================\n"

  awk -F"," -v var="$1" 'var ~ $3 {print $1"_"$2}' course_data > tmpfile # 一些操作
 
  while IFS='' read -r line || [[ -n "$line" ]]; do
    ls "${line}_lab" 2> /dev/null >> tmpfile2 
  done < tmpfile # 作业文件名

  cat tmpfile2 | sed "s/_/,/g" | sed "s/lab/$1/g" > tmpfile

  printf "  Course Name\t\t State\n"

  while IFS='' read -r line || [[ -n "$line" ]]; do
    cat course_data | sed -nr "/^$line/p" | awk -F"," '{print "  "$1"\t\t\t"$5}'
  done < tmpfile # 显示

  rm tmpfile tmpfile2 # 删除临时文件

  printf "  =======================================\n"
  read -p "Press enter to continue"
  student_menu "$1" "$2" # 返回菜单
}

#######################################
# log_in
# Description:
#   登陆界面
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
function log_in() {
  printf "\n\t\t************************\n"
  printf "\t\t*******   HWMS   *******\n"
  printf "\t\t*******   v1.0   *******\n"
  printf "\t\t************************\n\n"
  printf "Welcome to HWMS. Please choose your account type (enter number):
  1 admin
  2 teacher
  3 student\n"
  printf "\n==> Your account type: " # 输入提示
  
  local acc_type
  read acc_type # 读入

  case "$acc_type" in
    1|admin|Admin|ADMIN)
      admin_menu # 返回菜单
      printf "\n\t\t*******   HWMS   *******\n" # 横幅
      printf "\t\t*******   ADMIN  *******\n\n"
      ;;
    2|teacher|Teacher|TEACHER)
      printf "\n\t\t*******   HWMS   *******\n" # 横幅
      printf "\t\t*******  TEACHER *******\n\n"
      printf "TECHER: you are logging in to HWMS\n"
      printf "Please enter you work number\n"
      printf "\n==> work number: " # 输入提示

      local log_tch_work_number
      read log_tch_work_number # 读入

      local log_tch_name=$(awk -F"," -v var="$log_tch_work_number" '{if ($1 == var) \
      { print $2 }}' teacher_account 2> /dev/null) # 教师姓名是否存在
      
      if [[ -z "$log_tch_name" ]]; then # 教师账户不存在
        printf "@@ Teacher account not found.\n"
        log_in # 重新登录
      fi

      teacher_menu "$log_tch_work_number" "$log_tch_name" # 切换到教师菜单
      ;;
    3|student|Student|STUDENT)
      printf "\n\t\t*******   HWMS   *******\n" # 横幅
      printf "\t\t*******  STUDENT *******\n\n"
      printf "STUDENT: you are logging in to HWMS\n"
      printf "Please enter your student number\n"
      printf "\n==> student number: " # 输入提示

      local log_stu_number
      read log_stu_number # 读入

      local log_stu_name=$(awk -F"," -v var="$log_stu_number" '{if ($3 == var) \
      { print $4; exit }}' course_data 2> /dev/null) # 学生姓名是否存在
      
      if [[ -z "$log_stu_name" ]]; then # 教师账户不存在
        printf "@@ Student account not found.\n"
        log_in # 重新登录
      fi
      student_menu "$log_stu_number" "$log_stu_name" # 切换到学生菜单
      ;;
    *) # 无效
      echo "@@ Invalid account type. Try again."
      log_in
      ;;
  esac # 结束
}

#######################################
# main
# Description:
#   主函数
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0
#######################################
function main() {
  log_in # 登陆函数
}

main "$@" # 主函数
