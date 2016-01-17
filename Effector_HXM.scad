/* Effector with kinematic positioning, also used as level sensor (see D-Box documentation or HXM documentation). Designed to use the Fisher delta hotend (fins diam 17 mm, attach by bottom disk diam 19mm) .
This effector is part of the HXM delta printer design, recycling Fisher printer components.
It could be used on the original Fisher, but new arms shall be built and new carriage reprinted. Parameters shall be adapted (arm length and effector offset). The effector is not larger than the original Fisher. Original bed shall be removed (its component will go in the effector) and print shall be done directly on the base plate (with a buildtak). Recommended arm length is  
files in : https://github.com/PRouzeau/HXM-Delta-Printer
(c) Pierre ROUZEAU Jan 2016
* Part licence : CERN OHL V1.2
* Program license GPL2 & 3
* Documentation licence : CC BY-SA
* Recommended filament : ABS or PETG, to resist heat. PLA is not recommended. 
Part 1 : Assembly, only for information
Printing without support, some bridging, so temperature shall be not too high 
(test parts in COLORED PETG at 280°C)
Part 2 : effector base, print in 0.3mm layers, fill-in honeycomb 75%
Part 3 : hotend support, print in 0.2~0.25 mm layer, fill-in honeycomb 50%
On the hotend support, some cleaning with a cutter is needed, notably to make room for the hotend fins. 
Part 4 : Cable attach, on effector and on printer top
Effector offset is 28mm. Arm space is 58 mm.
with the Fisher delta hotend, distance between the hotend nozzle and the ball axis is 32mm (used only in simulator).
two fans 25x25x10mm in 5V or 12V, use good quality.  
recommended : Sunon MC25100V2-A99 (5V ) or Sunon MC25101V2-A99 (12V)
A fiber gasket (plumbing red type) is used to separate the hotend support and the hotend.  Internal diameter shall be cut to 17mm, thickness 1.5 mm. Use a 20/27 (3/4") standard gasket and adjust with a cutter.
The support is attached on the effector with rubber rings cutted from a bike tire tube
LOad while triggering the sensor shall be ~1kg. Below that, the traction of the bowden tube trigger the sensor and calibration fails.
kinematic is done with cylinder diam 5x10, hole M3, as found in the Fisher bed support.
Instead of what is shown on photo, only one pair of cylinder could be used for the sensor, no need to chain the three pairs, that will always be the weaker rubber which trigger.
To see how the sensor works, look to the D-Box documentation here :
http://rouzeau.net/Print3D/DBox
The hotend shall be attached with 4 M3x35 countersunk bolts, in STAINLESS STEEL and medium washers.
Note that this are the same screws as used to attach the extruder on its plate.
*/

qpart = 1;
dia_ball = 5.95; //real ball diameter.  Ball hole programmed is 0.15mm over this diameter
ballplay = 0.2; // extra diameter on ball sockets
holeplay = 0.15; // extra diameter on ALL cylinders 
hotdia  = 15.8;
hotring = 11.8;
ballSocketExt= 1.1; // ball socket extension over medium plane
if (qpart) {
  if (qpart==1) { // effector assembly
     effsq();
     rotz(60) hotsup(); 
     hotend();
     acc();
  }  
  else if (qpart==2) effsq(); // effector base
  else if (qpart==3)  rot(180) hotsup();  // upside/down support for printing  
  else if (qpart==4) hotsup(); // support for simulation , normal position
  else if (qpart==5) {  // cables retainers
    cablem();
    duplx (15,2) tsl (30) cablem2();
  }
  else if (qpart==8) { 
    difference() {
      hotsup(); 
      *cubez (150,150,50,0,0,-5); //cut to  check shapes and wall thicknesses
    } 
    *color ("red") cylz (18,17, 0,0,-3); // check hotend height
  }  
  else if (qpart==9) difference() { // checking duct
    duct();   
    cubez (100,100,100, 0,65,-50);
  }  
}

include <PRZutility.scad>
include <X_utils.scad>

function eff_hoffset() = 28;
arm_space = 58;
wire_space= 46;
diamNut3  = 6.1;
effvoffset= 0; //effector vertical articulation (ball center) offset from bottom effector plane (positive->up) . not taken into account here where ref plane is ball center

ep_duct = 1.2; // duct thickness (not used everywhere)

topsup = 12; //top of hotend support
fanht  = 15-22.5;
finht  = 17; // height of  the finned part
topfin = 8.5; //Distance between the fin top part and the support top
washerthk=1.5; // washer for hotend insulation
hotpos = -finht-topfin-1+washerthk; //relative position of the hotend attach plane
// spacing atop the fins is equal to washerthk
//echo (hotpos=hotpos);

bottomsup=hotpos+topsup; //absolute position of the hotend attach plane

$fn=34; // precision

thkx    = 11; // effector thickness
ballOff = 37; // offset of kinematic ball
ballVt  = 2.5;  // vertical elevation of kinematic ball over reference plane
balldist = 3.85; // for ball dia 6 mm and cyl dia 5
balldistv= 3.85; // for ball dia 6 mm

efflow = 9; // distance effector base/reference plane (for this data set reference plane is ball axis)
diapad = dia_ball+4;

module rot120 (angstart=0){
  for(i=[0,120,240]) rotate([0,0,i+angstart]) children();
}

module effsq() { // effector main structure
  module cutcube(ballSocketExt) {
    tsl (-arm_space/2, eff_hoffset())
      rotz(-45) //???
        rot(0,-35) 
           cubez (50,50,50,0,0,ballSocketExt);
  }
  difference() { 
    union() {
      difference() {
        union() {
          rot120()  
            cubez (arm_space,10.7,thkx, 0,eff_hoffset()-0.5,effvoffset-efflow);
          rot120(30)  // kinetic cylinders supports
            hull() {
              dmirrory() 
                cylx (9,4, ballOff+4, balldist, ballVt-balldistv);
              cubez (10,26,thkx-1, ballOff,0,effvoffset-efflow);
              dmirrory()
                rotz(-30)
                  cylz (diapad, thkx-3,arm_space/2,eff_hoffset()-0.1,effvoffset-efflow+0.01);
            }  
        } //::: then whats removed :::
        hull() 
          rot120()
            dmirrorx() {
              cylz (-10,33, 13,eff_hoffset()-5,-5);   
              cylz (-10,33, arm_space/2-6.2,eff_hoffset()-9,-5);   
            }
        rot120()  // arms
          dmirrorx() 
            tsl (arm_space/2,eff_hoffset()) {
              sphere((dia_ball+ballplay)/2);
              rot(-35) { // wire cones
                *cconez (2,7,-3,-25, -arm_space/2+wire_space/2, 0,-7.5);  
                cconez (2,12.5,6,-8, -arm_space/2+wire_space/2);
              }
              rot(-35,0) 
                hull() 
                  dmirrorx()   // add ballSocketExt 
                    cyly (-5,20, 3,5,2.5+ballSocketExt);
            }
      }  
      // added after to avoid conflict with wire cones
    } // then second removal  
    rot120(30) { // kinetic cylinders
      hull() 
        dmirrory() {
          cylx (-5,8, ballOff,balldist, ballVt-balldistv);    
          cylx (-5,8,ballOff,balldist, ballVt-balldistv+6);    
        } 
      dmirrory()  
        cylx (-3,22, ballOff-1,balldist, ballVt-balldistv);
      tsl (ballOff, 0,ballVt)   
        sphere(dia_ball/2+2.2);    
    }    
  }    
  rot120(30) {  // spring attach
    difference()  {  
      hull() {
        cubez (8, 3,3.5, ballOff-5, 0,-efflow);  
        cubez (8, 3,5, ballOff-1, 0,-efflow);  
      }  
      cyly (-2.6,11, ballOff-6,0,-efflow);
    }  
    cylz (7.5,0.6, ballOff-11.2,0, -efflow);    
  }        
}  


module hotsup() { // hotend support
  ductht  = topsup-17;
  hts = 41;
  dthk = 2*ep_duct;
  gaskthk = 1.5;
  module centhole() {
    hull() {
      cylz(27,-5, 0,0, bottomsup);
      dmirrorx(){
        cylz(23,-1,   2,0, bottomsup-10);
        cylz(18.5,-2, 2  ,0, topsup-40);
      }  
    }
    cubez (40,40,-40, 0,-15,topsup-25); 
    cylx (-37,80, 0,-10, topsup+hotpos-2, 60); 
    rot (-15)
      cubez (50,50,-20, 0,0,topsup-36); 
    dmirrorx()
      rotz (24)  //hotend screw room
        cconez (8,3, -4,4,  12,0,bottomsup);
  }
  difference() { 
    union() {
      difference() { //part duct
        union() {
          tsl (0,17,topsup) // fan screw holder
            dmirrorx() 
              hull() {
                 cylz(6,-5, 10,10);
                 cylz(1,-5, 10,6);
                 cylz(1,-5, 5,11);
              }
          hull() {
            cylz (26,-1, 0,17,topsup);
            dmirrorx() {
              cylz (12,-3,  13.5,11.5,topsup -10); 
              cylz (10,-3,   13.5,20,topsup -10); 
              
              cylz (12,-6,   13,11,topsup -18); //?? cut internals accordingly
              cylz (10,-6,   9,21,topsup -18); 
              
              cylz (7, -0.1, 14, 9,topsup -hts+10); 
              cylz (15,-0.1, 8.5,17,topsup -hts+10); 
              
              cylz (26,-1,   6,9,topsup -hts+5); 
              cylz (20,-1,   5,6,topsup -hts); 
            }
          }
          
        } //::: then whats removed :::
        hull() {
          cylz (23,-0.5, 0,17,topsup+0.1);
          dmirrorx() {
            cylz (12-dthk-0.2,-3,  13.5,11.5,topsup -10.5); 
            cylz (10-dthk-0.2,-3,   13.5,20,topsup -10.5); 
              
            cylz (12-dthk,-6,   13,12.5,topsup -18); //?? cut internals accordingly
            cylz (10-dthk,-6,   9,21,topsup -18); 
              
            cylz (7-dthk-1,-0.1, 14,9,topsup -hts+10); 
            cylz (15-dthk,-0.1,  8.5,17,topsup -hts+10); 
            
            cylz (26-dthk,-9,  6,9,topsup -hts+13); 
            cylz (20-dthk,-9,  5,6,topsup -hts+7.9); 
          }
        }
        centhole();  
      } //part duct
      difference() { // central part
        union() {
          intersection() {
            cylx (-40,38,   0,-10, bottomsup-2, 60);
            hull() {  
              cyly (-38,99,  0,0, bottomsup, 60);
              cyly (-38,99,  0,0, bottomsup-4, 60);
            }  
          }  
          hull() {
            cylz(30,-5, 0,0, bottomsup-0.1);
            dmirrorx(){
              cylz(26,-1,   2,0, topsup-35);
              cylz(21.5,-1, 2,0, topsup-40);
            }  
          }
          hull() {
            cylz (30,1.5, 0,0,bottomsup,    50);
            cylz (20,1.5, 0,0,bottomsup+10, 50);
          }  
        } // then whats removed
        centhole();  
        dmirrorx() {
          rot (-12,0,18)
            cubez (40,40,-40, 9.5,-19.3,topsup);          }
      }
      dmirrorx() { // 
            difference() {  // arms
              hull() {
                rotz(-30)           
                  cylz (7.5,-5.8, ballOff,0,topsup);
                cylz (1,-0.1,   10.7,10.8,topsup);
                cylz (1,1,      15.5,5.5,topsup-12);
                cylz (1,0.1,    10,3.3, topsup-13.3);
                cylz (1,-12,    12.5,-11.5,topsup);
                cylz (1,-1,    9,-2,topsup);
              }
              cylz (23.2,-15,  0,-11.8,topsup+0.1);
              cylz (2,-33, 23,-11,topsup-5); // continuity of the hole with outside
              hull() {
                rotz(-30)           
                  cylz (7.5,-3, ballOff-7,1,topsup-1.5);
                cylz (0.1,-9, 15,5,topsup-1.5);
                cylz (0.1,-11, 7,5,topsup-1.5);
                cylz (0.1,-9, 12.5,-10.5,topsup-1.5);
              }
            }
          }  
     * rot120(90)  // spring attach  
        difference()  {  
          hull() {
            cubez (8.5, 3,-3,   ballOff+5, 0,topsup);  
            cubez (5,   3,-5.5, ballOff+1, 0,topsup);  
          }  
          cyly (-2,11, ballOff+6.7,0,topsup);
        } 
      dmirrorx() // stop rubber spring
          rotz (-30) {
            cubez (2,20,-3, ballOff-5,    0.6,topsup);  
            cubez (5,13,-2, ballOff-5-3.5,0.6,topsup);  
          }
        
      cubez (18,2,-3, 0,ballOff-4,topsup);     
      rotz(90)  // ball support, side part duct
        hull() {
          cylz (8,-7.5,   ballOff,0,topsup);  
          cubez (1,13,-7, ballOff-8.5,0,topsup);  
        }
      cubez  (30,10,-1.3, 0,-12+5,topsup);  
      rot120(90)  // ball pylons
        cylz (7.5,-topsup+ballVt+2, ballOff,0,topsup);
       
      tsl (0,17,topsup) dmirrorx() { // redo fan screw holder in part cooling duct
        difference() {
          hull() {
            cylz(5.6,-6,  10,-10);  
            cylz(1,-6,    7,-11.5);  
            cylz(1,  -18,  10,-12);  
          }  
          cylz(2.5,-6, 10,-10, 0.1);  
        } 
        difference() {
          hull() {
            cylz(6,-5,  10,10);  
            cylz(0.5, -10, 10,9.5);  
          }  
          cylz(2.5,-6,  10,10, 0.1);  
        } 
      }  
      hotend_screws ();  
      //dmirrorx() cylz (5.5,-6, 7.5,-6, topsup);  // cable attach
    } //::: then whats removed :::
    cylz (17.5,-55, 0,0, topsup-topfin); // fin space
    tsl (0,0,ductht)
      duct_ht_outlethole();
    tsl (0,17,topsup+0.1)
      dmirrorx() dmirrory() cylz(2.4,-7, 10,10,1); // fan attach holes
    rot120(90) 
      cylz (-3,99,  ballOff); // pylon holes
    bowden_space();
    hotend_screws (true);
    dmirrorx() cylz (2,-6.5, 6.5,-6, topsup+1);  // cable attach holes
  } 
  duct();  
}


module hotend_screws (hole=false) { // absolute position
  di = (hole)?3.2:7;  
  lg = (hole)?55:25; 
  rc = (hole)?2:0;  
  
  difference() {
    union() {
      tsl (0,0,topsup-25)
        rot (8)
          dmirrorx() 
            rotz (24)  
              hull() {
                cylz (di,lg+2, 12,0,-1);
                if (!hole) {
                  cylz (1,lg+3, 9, 5, -1.5);
                  cylz (1,lg+3, 14,2.3, -1.5);
                  cylz (1,lg+2, 9, -3.5, -1);
                }  
              } 
      difference() {  
        dmirrorx() {   
          tsl (10.6,-5.6,topsup-25-rc-1)
            rot (0,5) cylz (di,lg);
         // rotz (-28) cylz (di,lg,  12,0,topsup-25-rc); // ref of position
        }  
        if (!hole)    
          cubez (20, 10,lg+2,  0,-6, topsup-25-1);
      }
    }  
    if (!hole)   // cut top/bottom pylon faces 
      duplz (-25-10)
        cubez (50,50,10,0,0,topsup);  
  }  
  *if (!hole)   // for duct  
    dmirrorx()     
      rotz (-28) 
        cylz (5,lg,  12,0,topsup-25-rc);
}


module duct() { // hotend duct - absolute position
  // there is a space of 1mm atop fins
  ht=topsup-17; // poorly done - bad reference plane - shall have use hotpos
  lctop=17;
  fanht=4.5; // relative to ht
  delta = washerthk-1; // space 1mm atop fins - hotend lowered by washer
  tsl (0,0,ht) {
    difference() {
      union() {
        hull() { // inlet
          tsl (0,-12,fanht) // fan screw holder
            dmirrorz() 
              hull() 
                dmirrorx() 
                  cyly(4,5, 10.5,0,10.5);  
          cylz (20,-finht, 0,0,lctop-topfin+delta); // 1 space atop fins
        }
        cubez (22,8,-8,  0,1.8,lctop); // between fans
        hull() { // outlet
          cylz (15.5,-1,  0,0,lctop-topfin);
          cubez (15.5,1,-1.5, 0,8,lctop-topfin-15.5+delta);
          dmirrorx() {
            cyly(2,1, 6.4,26.7,10);
            cyly(2,1, 6.4,24.7,-8);
            cyly(2,1, 2,23.5, -13);  
          }
          cubey (1.4,30,1, 0,0,lctop-0.5);
        }
      } //::: then whats removed :::
      tsl (0,-12,fanht) // fan screw 
        dmirrorz() dmirrorx() 
          cyly(2.4,6, 10,-0.1,10);  
      difference() { // inlet removal
        union() {
          hull() { 
            cubez (15.5,1, -finht,  0,-6, lctop-topfin);
            cyly (23, -0.5,  0,-11.6,fanht);
            dmirrorx() 
              cyly (1, -0.5, 6,-11.6,fanht-10);
          }
          hull() { 
            cubez (16.3,1, -finht-1,  0,-6, lctop-topfin);
            cylz (17.5,-finht-1,  0,0, lctop-topfin);
          }
        }
        hull() { // inlet: removed from removal -> positive
          cylz (17,-topfin,   0,0,  topsup-ht);
          cubez (20,1,-3.5,   0,-12,topsup-ht);
        }
      }
      duct_ht_outlethole();
      hull() {// cut bottom
        cubez (16,5,-2, 0,8.5,lctop-topfin-17+delta);
        cubez (5,1,-2,  0,30,lctop-topfin-23-2);
      }
      cylz (17.5,-55, 0,0, lctop-topfin); // fin space
    *  cylz (24,-19+washerthk, 0,0, lctop+hotpos); // bottom hotend place ?
      
      tsl (0,-13,fanht)  // fan attach holes
        dmirrorx() dmirrorz() cyly(2.4,-7, 10,0,10); 
      tsl (0,0,-ht) {
        bowden_space();
        hotend_screws (true);
        dmirrorx() cylz (2,-6.5, 6.5,-6, topsup+1);  // cable attach holes
      }  
    }
  }
  cubez (15,4,0.8, 0,8.2,topsup+hotpos+0.5);  // flat for good bridging - to be removed with cutter   
  hull() {// flat for good bridging 
    cubez (17.5,0.5,2.8, 0,-11.75,topsup+hotpos-0.3);  
    cubez (15,1,1, 0,-8,topsup+hotpos+0.25);  
  }  
  difference () { // cone above fins
    cconez (8,17, -topfin,0, 0,0,topsup);
    bowden_space();
  } 
}

module bowden_space() {
  cconez (4.2,6,4.5,-5, 0,0,topsup-4.4); //bowden_space
}

module duct_ht_outlethole() {
  lctop=17;
  delta = washerthk-1; // space 1mm atop fins - hotend lowered by washer
  //cylz  (17,-15.2, 0,0,lctop-topfin);
  hull() { // outlet
    cylz  (13.2,-2, 0,0,lctop-topfin-0.5);
    cubez (13,1,-2,0,11.5,lctop-topfin-13.5+delta);
    dmirrorx() {
      cyly(0.5,1,  6.2,  28.5,9.65);
      cyly(0.5,1,  6.2,  28,   -8.2);
      cyly(0.5,1,  2,  25.5,-12.8);  
      rot(-16)   // cut outlet flat for better bridging
        rotz (10.5) 
          cyly(1,28,  5.48,0,1);
    }
  }
  hull() {// cut center
    cylz  (13,-15.5+delta, 0,0,lctop-topfin-0.5);
    cubez (13,1,-2,0,   11.5,lctop-topfin-13.5+delta);
  } 
}

module hotend() {
  rotz(-30)
    tsl (-17,0,topsup) // part fan
      build_fan(25,10);
  rotz(-30)
    tsl (12,0,topsup-12.5) // hotend fan
      rot (0,90) build_fan(25,10);
  color ("grey") {
    tsl (0,0,topsup){
      cylz (17,-18, 0,0, -topfin-0.5);  
      cylz (19,-1.2, 0,0,-18-topfin-0.5);  
      cconez (4,1,-1, 16, 0,0, -18-topfin-0.5);  
      rotz (-75)
        cubez (16,14,8, 4.5,2.8, -30-topfin-0.5);
    }  
  }
}

module acc() { // accessories viewing
  color("silver") {
    rot120() { // arms
    *  cylx (-3,arm_space,  0,eff_hoffset());
      dmirrorx() {
         tsl (arm_space/2,eff_hoffset()) {
           sphere(3);
           rot (0,-15) cylz (3,100, 0,0,3);
           rot (0,15) cylz (3,100, 0,0,3);
         } 
         tsl (wire_space/2,eff_hoffset()) {
           rot (0,-15) cylz (1,100);
           rot (0,15) cylz (1,100);
         }  
       }   
    }
    rot120(30) { // support system
      tsl (ballOff, 0,ballVt)   
        sphere(3); 
      dmirrory()  // v with standoff
        tsl (ballOff,balldist, ballVt-balldistv)
          rot (15) cylx (-5,8);    
    }  
  }  
} 

module cablem() {
  difference() {
    union() {
      hull() {
        cubez (24,9.5,2, 0,3);
        cubez (24,11,9, 0,3.5, 3);
        cubez (10,1,12, 0,-6); 
        cubez (20,1,12, 0,-4); 
      } 
      dmirrorx() 
        cylz (7,12, 6.5,-4.5, 0); 
    } // then whats removed 
    hull()   
      duplz (8) 
        cylx (-6.2,66, 0,3.5,5.5);
    dmirrorx() {
      cylz (-3.2,66, 6.5,-4.5);
      cylz (-8.1,66,  14,-5);
    }  
    cylz (-8,66, 0,-8); 
  }  
  *cylx (-6.5,66, 0,1,6.5);
}

module cablemx() { // no longer used ??
  difference() {
    union() {
      cubez (25,16,13, 0,0.5);
      hull() {
        dmirrorx() 
          cylz (7,11, 17.5,-4.5, 0); 
        cubez (30,7,11, 0,-3.1);  
      }  
    } // then whats removed 
    hull()   
      duplz (8) 
        cylx (-6.2,66, 0,3.5,6);
    dmirrorx() {
      cylz (-3.2,66, 17.5,-4.5);
    }  
    hull()
      duplz (10)
        dmirrorx() cyly (-10,7, 10,-5,7.5);   
      
    cubez (29,10,10, 0,0,10);
    cylz (-30,66, 0,-18); 
  }  
  *cylx (-6.5,66, 0,1,6.5);
}

module cablem2() {
  difference() {
    cubez (10,21,8.2); 
    dmirrory()
      hull()   
        duplz (5.5) 
          cylx (-6,66, 0,5.2,5.5);
    cylz (-3.2,66);
  }  
  *cylx (-6,66, 0,5.2,5.5);
}


//============= misc. stuff =============================

module hotend_mockup() { // just for tests - not needed
  difference(){ 
    union() {
      cylz (17,-18, 0,0, -topfin-0.5, 50);  
      cylz (19,-1.2, 0,0,-18-topfin-0.5, 50);  
    }
    cylz (-3.6, 66);  
  }  
}
* hotend_mockup();