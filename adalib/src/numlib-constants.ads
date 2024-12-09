-- Adapted from Gnu Scientific Library
-- https://www.gnu.org/software/gsl/

package numlib.constants is

   YOTTA  : constant Long_Float :=
     (1.0e24);  --  /usr/include/gsl/gsl_const_num.h:26
   ZETTA  : constant Long_Float :=
     (1.0e21);  --  /usr/include/gsl/gsl_const_num.h:27
   EXA    : constant Long_Float :=
     (1.0e18);  --  /usr/include/gsl/gsl_const_num.h:28
   PETA   : constant Long_Float :=
     (1.0e15);    --  /usr/include/gsl/gsl_const_num.h:29
   TERA_F : constant Long_Float :=
     (1.0e12);  --  /usr/include/gsl/gsl_const_num.h:30
   TERA   : constant            := 1_000_000_000_000;
   GIGA_F : constant Long_Float :=
     (1.0e9);  --  /usr/include/gsl/gsl_const_num.h:31
   GIGA   : constant            := 1_000_000_000;
   MEGA_F : constant Long_Float :=
     (1.0e6);  --  /usr/include/gsl/gsl_const_num.h:32
   MEGA   : constant            := 1_000_000;
   KILO_F : constant Long_Float :=
     (1.0e3);  --  /usr/include/gsl/gsl_const_num.h:33
   KILO  : constant            := 1_000;
   MILLI : constant Long_Float :=
     (1.0e-3);  --  /usr/include/gsl/gsl_const_num.h:34
   MICRO : constant Long_Float :=
     (1.0e-6);  --  /usr/include/gsl/gsl_const_num.h:35
   NANO  : constant Long_Float :=
     (1.0e-9);  --  /usr/include/gsl/gsl_const_num.h:36
   PICO  : constant Long_Float :=
     (1.0e-12);  --  /usr/include/gsl/gsl_const_num.h:37
   FEMTO : constant Long_Float :=
     (1.0e-15);  --  /usr/include/gsl/gsl_const_num.h:38
   ATTO  : constant Long_Float :=
     (1.0e-18);  --  /usr/include/gsl/gsl_const_num.h:39
   ZEPTO : constant Long_Float :=
     (1.0e-21);  --  /usr/include/gsl/gsl_const_num.h:40
   YOCTO : constant Long_Float :=
     (1.0e-24);  --  /usr/include/gsl/gsl_const_num.h:41

end numlib.constants;
