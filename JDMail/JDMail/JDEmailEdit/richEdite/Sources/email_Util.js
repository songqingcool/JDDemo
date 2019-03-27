var Email = {};

Email.ReplaceImgSrc = function(contentId,content)
{
   var imgs = document.getElementsByTagName("img");
    for(var i =0; i<imgs.length;i++)
    {
        var srcPath = "cid:"+contentId;
        if(imgs[i].src == srcPath)
        {
            imgs[i].src="data:image/png;base64,"+content;
        }
        
        if(imgs[i].width>window.screen.width)
        {
            imgs[i].style.width = "100%";
            imgs[i].style.height = "auto";
        }
    }
    
    var divs = document.getElementsByTagName("div");
  
    for(var i =0; i<divs.length;i++)
    {
        divs[i].style.width = "100%";
        divs[i].style.height = "auto";
    }
    
    var tables = document.getElementsByTagName("table");
    
    for(var i =0; i<tables.length;i++)
    {
        tables[i].style.width = "100%";
        tables[i].style.height = "auto";
    }
}
