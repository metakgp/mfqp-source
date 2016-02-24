var start = function(){
  donutty('donutsdep',depwise[window.location.search.slice(4,6)],window.location.search.slice(4,6),40,70);
  displaylist(window.location.search.slice(4,6));
  console.log(window.location.search.slice(4,6));
}

var displaylist = function(id){
  for(var i=0;i<sortedkeys.length;i++){
    if (sortedkeys[i].slice(0,2)===id){
      if (subjects[sortedkeys[i]][1]===true){
        $("#subjectlist").append($("<li class='listclass col-md-6'></li>").html(sortedkeys[i]+" : "+subjects[sortedkeys[i]][0]+" <span class='glyphicon glyphicon-ok' style='color:green'></span>"));
      }
      else if (subjects[sortedkeys[i]][1]===false){
        $("#subjectlist").append($("<li class='listclass col-md-6'></li>").html(sortedkeys[i]+" : "+subjects[sortedkeys[i]][0]+" <span class='glyphicon glyphicon-remove' style='color:red'></span>"));
      }
    }
  }
};

var donutty = function(eleid,arr,key,r1,r2){
  var linearScale1 = d3.scale.linear().domain([0,(arr[0]+arr[1])]).range([0,360]);
  var linearScale2 = d3.scale.linear().domain([0,(arr[0]+arr[1])]).range([0,100]);
  var newarr=[0,0];

  newarr[0]=linearScale1(arr[0]+arr[1]);
  newarr[1]=linearScale1(arr[1]);


    var statcol = ['#34495e', '#2ecc71'];

	var arc_sex = d3.svg.arc()
		//.innerRadius(32)
		//.outerRadius(48)
    .innerRadius(r1+2)
    .outerRadius(r2-2)
		.startAngle(0)
		.endAngle(function(d,i){
			return d*pi/180;
		});


  var donutsvg=d3.select("#"+eleid).append("svg").attr("class",key).attr("width",2*r2).attr("height",((2*r2)+20)).attr("style","cursor:pointer");
	donutsvg.append("g").attr("style","transform:translate("+r2+"px,"+(r2+10)+"px)").selectAll("path").data(newarr).enter()
	.append("path").attr("d",arc_sex).attr("fill",function(d,i){
			return statcol[i];
		});
	//donutsvg.append('circle').attr('cx',80).attr('cy',100).attr('r',r1-2).attr('fill','#383838');
	donutsvg.append("text").attr("text-anchor","middle").attr("x",r2).attr("y",r2+5).attr("class","descrip").style('font-size',r1).style('font-weight',900).attr("class","pointer").text(key);
	donutsvg.append("text").attr("text-anchor","middle").attr("x",r2).attr("y",parseInt(1.5*r2)-(5)).attr("class","descrip").style('font-size', r1).attr("class","pointer").text(linearScale2(arr[1]).toFixed(0)+"%");
  //donutsvg.append("text").attr("text-anchor","middle").attr("x",50).attr("y",75).text("collected");

  donutsvg.on("click",function(){
    var id = $(this).attr("class");
    console.log(id);
    window.location.href = 'dep.html?id='+id;
    //donutty("donutsdep",depwise[id],id);
  });

};

// semicolon is there in the included file
var subjects = @@include("./include/subjects.json");

var total_no = Object.keys(subjects).length;
var done_no=0;
var depwise={};
var pi = Math.PI;


for (var key in subjects) {
  var sub = key.slice(0,2);
  if (depwise[sub]=== undefined){
    depwise[sub]=[0,0];
  }
  if (subjects[key][1]===true){
    done_no++;
    depwise[sub][1]++;
  }
  else{
    depwise[sub][0]++;
  }
}

var perc = (done_no*100/total_no).toFixed(2);
var sorted=[];
var sortedkeys = [];


for(var key in depwise){
    var temp = depwise[key][1]/(depwise[key][0]+depwise[key][1]);
    sorted.push([key,temp]);
  }

  for(var key in subjects){
    sortedkeys.push(key);
  }

  sorted.sort(function(a, b) {
    return b[1] - a[1];
  });
  sortedkeys.sort();


window.onload = function(){
  $("#percentageover").html(perc+"%");
  var bar =  d3.select("#progressbar").append("svg").attr("width",300).attr("height",20);
  bar.append("rect").attr("width",280).attr("height",20).attr("x",10).attr("fill","#34495e");
  bar.append("rect").attr("width",parseInt(perc*280/100)).attr("height",20).attr("x",10).attr("fill","#2ecc71");
  bar.append("circle").attr("cx",10).attr("cy",10).attr("r",10).attr("fill","#2ecc71");
  bar.append("circle").attr("cx",290).attr("cy",10).attr("r",10).attr("fill","#34495e");

  $("#numberover").html(done_no);
  $("#total").html(total_no);
  var width = parseInt(d3.select('#home').style('width'), 10);
  var density =  window.devicePixelRatio;

  width = width/density;

  if (width>800){
    var r1 = 30;
    var r2 = 50;
  }
  else{
    var r1=90;
    var r2=120;
  }
  
  for(var i=0;i<sorted.length;i++){
    donutty("donuts",depwise[sorted[i][0]],sorted[i][0],r1,r2);
  }

  $(".buttonupload").click(function(){
  $("#thanks").css("display","block");
});

};
