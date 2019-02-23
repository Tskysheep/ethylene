import QtQuick 2.0
import "../Widget"

Item {

    property string bgColor: "#344750"
    //property string bgColor: "#d3d3d4"
    property int loadindex: 0
    property int currentIndex: 0
    property int oldindex: 0
    property int subcurrentIndex: 0
    signal indexChanged(var index);
    signal subBtnSelected(int index,int subindex);
    property var dataModel;
    //onCurrentIndexChanged: indexChanged(currentIndex)
    //onSubcurrentIndexChanged: subBtnSelected(currentIndex,subcurrentIndex)

    //background
    Rectangle{
        id:bg
        anchors.fill: parent
        color: bgColor
    }

    Column{
        anchors.fill: parent
        Item{
            width: parent.width
            height: 100
            Image {
                source: "qrc:/imgs/icons/hongtai_logo.png"
                anchors.centerIn: parent
            }
        }
        Item{
            width: parent.width
            height: parent.height-100
            Column{
                id:col
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Repeater{
                    model: dataModel
                    delegate:
                        ImageCheckBox{
                            width: parent.width
                            height: 80
                            checked: selected
                            imgSource: imgSrc
                            text: title
                            subModel: subdataModel
                            submenuVisible: onHovered

                            onBntClicked: {
                                if(index === 7) {server.logOut();mainWin.close()}
                                //sky一级按钮被按下,
                                if(loadindex === index){//sky一级被重复按下，根据情况显示子菜单
                                    menuList.setProperty(index,"onHovered",!submenuVisible);
                                    return;
                                }


                            //如果没有二级菜单的，直接发送信号，切换页面
                                if(menuList.get(index).subdataModel === undefined){
                                    //清除一级菜单被选中状态
                                    for(var a = 0 ; a<menuList.count ; a++){
                                        if(menuList.get(a).selected){
                                            menuList.setProperty(a,"selected",false);
                                        }

                                        //点击其他的一级按钮时，关闭原来的一级按钮对应的二级菜单
                                        if(menuList.get(a).onHovered){
                                            menuList.setProperty(a,"onHovered",false);
                                        }
                                    }

                                    //清除二级菜单被选择状态
                                    for(var b = 0 ; b < menuList.count; b++){
                                        if(menuList.get(b).subdataModel === undefined)//排除没有二级菜单的页面
                                            continue;

                                        for(var c = 0; c < menuList.get(b).subdataModel.count; c++){
                                           menuList.get(b).subdataModel.setProperty(c,"selected",false)
                                        }

                                    }

                                    //切换页面
                                    menuList.setProperty(index,"selected",true);
                                    indexChanged(index);
                                    loadindex = index
                                    return;
                                }

                             //有二级菜单的情况
                                for(var a = 0 ; a<menuList.count ; a++){
                                    //清除一级菜单被选中状态
                                    if(menuList.get(a).selected){
                                        menuList.setProperty(a,"selected",false);
                                    }
                                    //点击其他的一级按钮时，关闭原来的一级按钮对应的二级菜单
                                    if(menuList.get(a).onHovered){
                                        menuList.setProperty(a,"onHovered",false);
                                    }
                                }
                                //使一级菜单高亮
                                menuList.setProperty(index,"selected",true);
                                //使二级菜单悬浮
                                menuList.setProperty(index,"onHovered",true);

                                //oldindex = currentIndex;
                                //currentIndex = index;
                            }


                            onSubbtnClicked: {
                                //sky二级按钮被按下
                                //sky同一个二级重复按下，二级按钮 selected 属性更改为true,子菜单隐藏
                                if((index === loadindex) && (subcurrentIndex === subbtn_index)){
                                    menuList.get(index).subdataModel.setProperty(subbtn_index,"selected",true);
                                    menuList.setProperty(index,"onHovered",!submenuVisible);
                                    return;
                                }
//                                //sky不是被重复按下，将已经被按下的二级按钮 selected 属性更改为false,子菜单隐藏
//                                for(var b = 0 ; b < menuList.get(index).subdataModel.count; b++){
//                                    if(menuList.get(index).subdataModel.get(b).selected){
//                                        menuList.get(index).subdataModel.setProperty(b,"selected",false) //sky将已经被按下的二级按钮 selected 属性更改为false
//                                        for(var c = 0; c < menuList.count; c++){//sky子菜单隐藏
//                                            if(menuList.get(c).onHovered){
//                                                menuList.setProperty(c,"onHovered",false);
//                                            }
//                                        }
//                                    }
//                                }

                                //只要不是同一个二级按钮被按下，先将全部的二级按钮selected 属性都置为false （即清除二级菜单被选择状态）
                                for(var b = 0 ; b < menuList.count; b++){
                                    if(menuList.get(b).subdataModel === undefined)//排除没有二级菜单的页面
                                        continue;

                                    for(var c = 0; c < menuList.get(b).subdataModel.count; c++){
                                       menuList.get(b).subdataModel.setProperty(c,"selected",false)
                                    }

                                }

                                //sky当前按下的二级按钮 selected 属性更改为true
                                menuList.get(index).subdataModel.setProperty(subbtn_index,"selected",true)

                                subcurrentIndex  = subbtn_index
                                subBtnSelected(currentIndex,subcurrentIndex)//sky发出信号，通知改变页面
                                loadindex = index

                                for(var d = 0; d < menuList.count; d++){//sky子菜单隐藏
                                    if(menuList.get(d).onHovered){
                                        menuList.setProperty(d,"onHovered",false);
                                    }
                                }
                            }


                            //子菜单弹出逻辑处理
                            onBtnHoveredChanged: {

                                //清除一级菜单被选中状态
                                for(var a = 0 ; a<menuList.count ; a++){
                                    if(menuList.get(a).selected){
                                        menuList.setProperty(a,"selected",false);
                                    }
                                }

                                //清除二级菜单悬浮状态
                                for(var a = 0; a < menuList.count; a++){
                                    if(menuList.get(a).onHovered){
                                        menuList.setProperty(a,"onHovered",false)
                                    }
                                }

                                //使当前鼠标所指的一级菜单高亮
                                menuList.setProperty(index,"selected",true);
                                //使当前鼠标所指的一级菜单的二级菜单悬浮
                                menuList.setProperty(index,"onHovered",true)

                                //记录鼠标所指的一级菜单的位置
                                currentIndex = index;



                            }
                    }
                }
            }
        }
    }

}
