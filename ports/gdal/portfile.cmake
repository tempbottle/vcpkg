if (TRIPLET_SYSTEM_ARCH MATCHES "arm")
    message(FATAL_ERROR "ARM is currently not supported.")
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    message(FATAL_ERROR "GDAL's nmake buildsystem does not support building static libraries")
elseif(VCPKG_CRT_LINKAGE STREQUAL "static")
    message(FATAL_ERROR "GDAL's nmake buildsystem does not support static crt linkage")
endif()

include(vcpkg_common_functions)

vcpkg_download_distfile(ARCHIVE
    URLS "http://download.osgeo.org/gdal/2.2.2/gdal222.zip"
    FILENAME "gdal222.zip"
    SHA512 b886238a7915c97f4acec5920dabe959d1ab15a8be0bc31ba0d05ad69d1d7d96f864faf0aa82921fa1a1b40b733744202b86f2f45ff63d6518cd18a53f3544a8
    )

# Extract source into architecture specific directory, because GDALs' nmake based build currently does not
# support out of source builds.
set(SOURCE_PATH_DEBUG   ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-debug/gdal-2.2.2)
set(SOURCE_PATH_RELEASE ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-release/gdal-2.2.2)

foreach(BUILD_TYPE debug release)
    file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-${BUILD_TYPE})
    vcpkg_extract_source_archive(${ARCHIVE} ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-${BUILD_TYPE})
    vcpkg_apply_patches(
        SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src-${TARGET_TRIPLET}-${BUILD_TYPE}/gdal-2.2.2
        PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/0001-Add-variable-CXX_CRT_FLAGS-to-allow-for-selection-of.patch
        ${CMAKE_CURRENT_LIST_DIR}/0002-Ensures-inclusion-of-PDB-in-release-dll-if-so-reques.patch
        ${CMAKE_CURRENT_LIST_DIR}/0003-Fix-openjpeg-include.patch
        ${CMAKE_CURRENT_LIST_DIR}/no-mysql-global-h.patch
        ${CMAKE_CURRENT_LIST_DIR}/no-mysql-sys-h.patch
        ${CMAKE_CURRENT_LIST_DIR}/no-my-bool.patch
    )
endforeach()

find_program(NMAKE nmake REQUIRED)

file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" NATIVE_PACKAGES_DIR)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/share/gdal" NATIVE_DATA_DIR)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/share/gdal/html" NATIVE_HTML_DIR)

# Setup proj4 libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" PROJ_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/proj.lib" PROJ_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/projd.lib" PROJ_LIBRARY_DBG)

# Setup libpng libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" PNG_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libpng16.lib" PNG_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libpng16d.lib" PNG_LIBRARY_DBG)

# Setup geos libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" GEOS_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/geos_c.lib" GEOS_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/geos_cd.lib" GEOS_LIBRARY_DBG)

# Setup expat libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" EXPAT_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/expat.lib" EXPAT_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/expat.lib" EXPAT_LIBRARY_DBG)

# Setup curl libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" CURL_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libcurl.lib" CURL_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libcurl.lib" CURL_LIBRARY_DBG)

# Setup sqlite3 libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" SQLITE_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/sqlite3.lib" SQLITE_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/sqlite3.lib" SQLITE_LIBRARY_DBG)

# Setup MySQL libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include/mysql" MYSQL_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libmysql.lib" MYSQL_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libmysql.lib" MYSQL_LIBRARY_DBG)

# Setup PostgreSQL libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" PGSQL_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libpq.lib" PGSQL_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libpqd.lib" PGSQL_LIBRARY_DBG)

# Setup OpenJPEG libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" OPENJPEG_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/openjp2.lib" OPENJPEG_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/openjp2.lib" OPENJPEG_LIBRARY_DBG)

# Setup WebP libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" WEBP_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/webp.lib" WEBP_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/webpd.lib" WEBP_LIBRARY_DBG)

# Setup libxml2 libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" XML2_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/libxml2.lib" XML2_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/libxml2.lib" XML2_LIBRARY_DBG)

# Setup liblzma libraries + include path
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/include" LZMA_INCLUDE_DIR)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/lib/lzma.lib" LZMA_LIBRARY_REL)
file(TO_NATIVE_PATH "${CURRENT_INSTALLED_DIR}/debug/lib/lzma.lib" LZMA_LIBRARY_DBG)

set(NMAKE_OPTIONS
    GDAL_HOME=${NATIVE_PACKAGES_DIR}
    DATADIR=${NATIVE_DATA_DIR}
    HTMLDIR=${NATIVE_HTML_DIR}
    GEOS_DIR=${GEOS_INCLUDE_DIR}
    "GEOS_CFLAGS=-I${GEOS_INCLUDE_DIR} -DHAVE_GEOS"
    PROJ_INCLUDE=-I${PROJ_INCLUDE_DIR}
    EXPAT_DIR=${EXPAT_INCLUDE_DIR}
    EXPAT_INCLUDE=-I${EXPAT_INCLUDE_DIR}
    CURL_INC=-I${CURL_INCLUDE_DIR}
    SQLITE_INC=-I${SQLITE_INCLUDE_DIR}
    MYSQL_INC_DIR=${MYSQL_INCLUDE_DIR}
    PG_INC_DIR=${PGSQL_INCLUDE_DIR}
    OPENJPEG_ENABLED=YES
    OPENJPEG_CFLAGS=-I${OPENJPEG_INCLUDE_DIR}
    OPENJPEG_VERSION=20100
    WEBP_ENABLED=YES
    WEBP_CFLAGS=-I${WEBP_INCLUDE_DIR}
    LIBXML2_INC=-I${XML2_INCLUDE_DIR}
    PNG_EXTERNAL_LIB=1
    PNGDIR=${PNG_INCLUDE_DIR}
    MSVC_VER=1900
)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    list(APPEND NMAKE_OPTIONS WIN64=YES)
endif()

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    list(APPEND NMAKE_OPTIONS PROJ_FLAGS=-DPROJ_STATIC)
else()
    # Enables PDBs for release and debug builds
    list(APPEND NMAKE_OPTIONS WITH_PDB=1)
endif()

if (VCPKG_CRT_LINKAGE STREQUAL static)
    set(LINKAGE_FLAGS "/MT")
else()
    set(LINKAGE_FLAGS "/MD")
endif()

set(NMAKE_OPTIONS_REL
    "${NMAKE_OPTIONS}"
    CXX_CRT_FLAGS=${LINKAGE_FLAGS}
    PROJ_LIBRARY=${PROJ_LIBRARY_REL}
    PNG_LIB=${PNG_LIBRARY_REL}
    GEOS_LIB=${GEOS_LIBRARY_REL}
    EXPAT_LIB=${EXPAT_LIBRARY_REL}
    "CURL_LIB=${CURL_LIBRARY_REL} wsock32.lib wldap32.lib winmm.lib"
    SQLITE_LIB=${SQLITE_LIBRARY_REL}
    MYSQL_LIB=${MYSQL_LIBRARY_REL}
    PG_LIB=${PGSQL_LIBRARY_REL}
    OPENJPEG_LIB=${OPENJPEG_LIBRARY_REL}
    WEBP_LIBS=${WEBP_LIBRARY_REL}
    LIBXML2_LIB=${XML2_LIBRARY_REL}
)

set(NMAKE_OPTIONS_DBG
    "${NMAKE_OPTIONS}"
    CXX_CRT_FLAGS="${LINKAGE_FLAGS}d"
    PROJ_LIBRARY=${PROJ_LIBRARY_DBG}
    PNG_LIB=${PNG_LIBRARY_DBG}
    GEOS_LIB=${GEOS_LIBRARY_DBG}
    EXPAT_LIB=${EXPAT_LIBRARY_DBG}
    "CURL_LIB=${CURL_LIBRARY_DBG} wsock32.lib wldap32.lib winmm.lib"
    SQLITE_LIB=${SQLITE_LIBRARY_DBG}
    MYSQL_LIB=${MYSQL_LIBRARY_DBG}
    PG_LIB=${PGSQL_LIBRARY_DBG}
    OPENJPEG_LIB=${OPENJPEG_LIBRARY_DBG}
    WEBP_LIBS=${WEBP_LIBRARY_DBG}
    LIBXML2_LIB=${XML2_LIBRARY_DBG}
    DEBUG=1
)
################
# Release build
################
message(STATUS "Building ${TARGET_TRIPLET}-rel")
vcpkg_execute_required_process(
    COMMAND ${NMAKE} -f makefile.vc
    "${NMAKE_OPTIONS_REL}"
    WORKING_DIRECTORY ${SOURCE_PATH_RELEASE}
    LOGNAME nmake-build-${TARGET_TRIPLET}-release
)
message(STATUS "Building ${TARGET_TRIPLET}-rel done")

################
# Debug build
################
message(STATUS "Building ${TARGET_TRIPLET}-dbg")
vcpkg_execute_required_process(
  COMMAND ${NMAKE} /G -f makefile.vc
  "${NMAKE_OPTIONS_DBG}"
  WORKING_DIRECTORY ${SOURCE_PATH_DEBUG}
  LOGNAME nmake-build-${TARGET_TRIPLET}-debug
)
message(STATUS "Building ${TARGET_TRIPLET}-dbg done")

message(STATUS "Packaging ${TARGET_TRIPLET}")
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/gdal/html)

vcpkg_execute_required_process(
  COMMAND ${NMAKE} -f makefile.vc
  "${NMAKE_OPTIONS_REL}"
  "install"
  "devinstall"
  WORKING_DIRECTORY ${SOURCE_PATH_RELEASE}
  LOGNAME nmake-install-${TARGET_TRIPLET}
)

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
  file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/gdal_i.lib)
  file(COPY ${SOURCE_PATH_DEBUG}/gdal.lib   DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
  file(COPY ${SOURCE_PATH_RELEASE}/gdal.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
  file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/gdal.lib ${CURRENT_PACKAGES_DIR}/debug/lib/gdald.lib)
else()
  file(GLOB EXE_FILES ${CURRENT_PACKAGES_DIR}/bin/*.exe)
  file(REMOVE ${EXE_FILES} ${CURRENT_PACKAGES_DIR}/lib/gdal.lib)
  file(COPY ${SOURCE_PATH_DEBUG}/gdal202.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
  file(COPY ${SOURCE_PATH_DEBUG}/gdal_i.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
  file(RENAME ${CURRENT_PACKAGES_DIR}/lib/gdal_i.lib ${CURRENT_PACKAGES_DIR}/lib/gdal.lib)
  file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/gdal_i.lib ${CURRENT_PACKAGES_DIR}/debug/lib/gdald.lib)
endif()

# Copy over PDBs
vcpkg_copy_pdbs()

# Handle copyright
file(RENAME ${CURRENT_PACKAGES_DIR}/share/gdal/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/gdal/copyright)

message(STATUS "Packaging ${TARGET_TRIPLET} done")
