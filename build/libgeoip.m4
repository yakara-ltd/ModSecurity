dnl Check for GEOIP Libraries
dnl CHECK_GEOIP(ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
dnl Sets:
dnl  GEOIP_CFLAGS
dnl  GEOIP_LDADD
dnl  GEOIP_LDFLAGS
dnl  GEOIP_LIBS
dnl  GEOIP_VERSION

AC_DEFUN([PROG_GEOIP],
[dnl

AC_REQUIRE([PKG_PROG_PKG_CONFIG])

GEOIP_CONFIG=""
GEOIP_VERSION=""
GEOIP_CFLAGS=""
GEOIP_CPPFLAGS=""
GEOIP_LDADD=""
GEOIP_LDFLAGS=""
GEOIP_PKGNAMES="geoip2 geoip GeoIP"
GEOIP_SONAMES="so la sl dll dylib"

AC_ARG_WITH(
    geoip,
    [AC_HELP_STRING([--with-geoip=PATH],[Path to geoip prefix])]
    ,, with_geoip=yes)

AS_CASE(["${with_geoip}"],
  [no], [test_paths=],
  [yes], [test_paths="/usr/local/libgeoip /usr/local/geoip /usr/local /opt/libgeoip /opt/geoip /opt /usr /opt/local/include /opt/local /usr/lib /usr/local/lib /usr/lib64"],
  [test_paths="${with_geoip}"])

AC_MSG_NOTICE([looking for geoip at: ${test_paths}])

    dnl Hack to just try to find the lib and include
    AC_MSG_CHECKING([for geoip install])
    for x in ${test_paths}; do
        for y in ${GEOIP_SONAMES}; do
           for z in ${GEOIP_PKGNAMES}; do
               if test -e "${x}/lib/lib${z}.${y}"; then
                   geoip_lib_path="${x}/lib/"
                   geoip_lib_name="${z}"
                   geoip_lib_file="${x}/lib/${z}.${y}"
                   break
               fi
               if test -e "${x}/lib/${z}.${y}"; then
                   geoip_lib_path="${x}/lib/"
                   geoip_lib_name="${z}"
                   geoip_lib_file="${x}/lib/${z}.${y}"
                   break
               fi
               if test -e "${x}/lib${z}.${y}"; then
                   geoip_lib_path="${x}/"
                   geoip_lib_name="${z}"
                   geoip_lib_file="${x}/lib/${z}.${y}"
                   break
               fi
               if test -e "${x}/${z}.${y}"; then
                   geoip_lib_path="${x}/"
                   geoip_lib_name="${z}"
                   geoip_lib_file="${x}/lib/${z}.${y}"
                   break
               fi
            done
           if test -n "$geoip_lib_path"; then
               break
           fi
        done
        if test -n "$geoip_lib_path"; then
            break
        fi
    done
    for x in ${test_paths}; do
        if test -e "${x}/include/GeoIPCity.h"; then
            geoip_inc_path="${x}/include"
            break
        elif test -e "${x}/GeoIPCity.h"; then
            geoip_inc_path="${x}"
            break
        fi
    done

if test -n "${geoip_lib_path}" -a -n "${geoip_inc_path}"; then
    GEOIP_CONFIG=""
    AC_MSG_RESULT([${geoip_lib_path} ${geoip_inc_path}])
    GEOIP_VERSION="2"
    GEOIP_CFLAGS="-I${geoip_inc_path}"
    GEOIP_LDADD="-l${geoip_lib_name}"
    GEOIP_LDFLAGS="-L${geoip_lib_path}"
else
    GEOIP_VERSION=""
    AC_MSG_RESULT([no])
fi

AC_SUBST(GEOIP_CFLAGS)
AC_SUBST(GEOIP_VERSION)
AC_SUBST(GEOIP_LDADD)
AC_SUBST(GEOIP_LIBS)
AC_SUBST(GEOIP_LDFLAGS)

    if test -z "${GEOIP_VERSION}"; then
      ifelse([$2], , AC_MSG_ERROR([*** geoip library not found]), $2)
    else
      AC_MSG_NOTICE([using geoip v${GEOIP_VERSION}])
      GEOIP_CFLAGS="-DWITH_GEOIP ${GEOIP_CFLAGS}"
      ifelse([$1], , , $1) 
    fi 
])
