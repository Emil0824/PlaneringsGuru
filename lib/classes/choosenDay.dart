// ignore_for_file: file_names

class ChoosenDay{
  static DateTime choosenDay = DateTime.now();

  static Function changeToDayViewCallBack = () {};


  static reset(){
    choosenDay = DateTime.now();
  }

  static change(DateTime day){
    choosenDay = day;
  }


}