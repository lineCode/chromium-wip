# Created by: Florent Thoumie <flz@FreeBSD.org>
# $FreeBSD: head/www/chromium/Makefile 457431 2017-12-27 23:33:04Z jbeich $

PORTNAME=	chromium
PORTVERSION=	63.0.3239.108
CATEGORIES?=	www
MASTER_SITES=	https://commondatastorage.googleapis.com/chromium-browser-official/
DISTFILES=	${DISTNAME}${EXTRACT_SUFX}

MAINTAINER?=	chromium@FreeBSD.org
COMMENT?=	Google web browser based on WebKit

LICENSE=	BSD3CLAUSE LGPL21 MPL11
LICENSE_COMB=	multi

BUILD_DEPENDS=	python:lang/python \
		bash:shells/bash \
		${PYTHON_PKGNAMEPREFIX}Jinja2>0:devel/py-Jinja2@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}ply>0:devel/py-ply@${PY_FLAVOR} \

.if !defined(GN_ONLY)
BUILD_DEPENDS+=	gperf:devel/gperf \
		clang50:devel/llvm50 \
		yasm:devel/yasm \
		ffmpeg>=3.2.2,1:multimedia/ffmpeg \
		flock:sysutils/flock \
		node:www/node \
		${LOCALBASE}/include/linux/videodev2.h:multimedia/v4l_compat \
		${LOCALBASE}/share/usbids/usb.ids:misc/usbids \
		${PYTHON_PKGNAMEPREFIX}html5lib>0:www/py-html5lib@${PY_FLAVOR}
.endif

.if !defined(GN_ONLY)
LIB_DEPENDS=	libspeechd.so:accessibility/speech-dispatcher \
		libsnappy.so:archivers/snappy \
		libFLAC.so:audio/flac \
		libspeex.so:audio/speex \
		libdbus-1.so:devel/dbus \
		libdbus-glib-1.so:devel/dbus-glib \
		libicuuc.so:devel/icu \
		libjsoncpp.so:devel/jsoncpp \
		libevent.so:devel/libevent \
		libpci.so:devel/libpci \
		libnspr4.so:devel/nspr \
		libre2.so:devel/re2 \
		libcairo.so:graphics/cairo \
		libdrm.so:graphics/libdrm \
		libexif.so:graphics/libexif \
		libpng.so:graphics/png \
		libwebp.so:graphics/webp \
		libavcodec.so:multimedia/ffmpeg \
		libcups.so:print/cups \
		libfreetype.so:print/freetype2 \
		libharfbuzz.so:print/harfbuzz \
		libharfbuzz-icu.so:print/harfbuzz-icu \
		libgcrypt.so:security/libgcrypt \
		libgnome-keyring.so:security/libgnome-keyring \
		libnss3.so:security/nss \
		libexpat.so:textproc/expat2 \
		libxml2.so:textproc/libxml2 \
		libfontconfig.so:x11-fonts/fontconfig

RUN_DEPENDS=	xdg-open:devel/xdg-utils \
		droid-fonts-ttf>0:x11-fonts/droid-fonts-ttf

BROKEN_FreeBSD_11_aarch64=	components/safe_browsing_db/v4_rice.cc:120:18: use of overloaded operator '&' is ambiguous
BROKEN_FreeBSD_12_aarch64=	third_party/skia/src/core/SkCpu.cpp:84:27: use of undeclared identifier 'getauxval'
ONLY_FOR_ARCHS=			aarch64 amd64 i386

.endif

.if defined(GN_ONLY)
USES=		compiler:c++14-lang ninja pkgconfig python:2.7,build shebangfix tar:xz
.else
USES=		bison cpe desktop-file-utils jpeg ninja perl5 pkgconfig \
		python:2.7,build shebangfix tar:xz
.endif
MAKE_ARGS=	-C out/${BUILDTYPE}

.if !defined(GN_ONLY)
CPE_VENDOR=	google
CPE_PRODUCT=	chrome
USE_GL=		gl
USE_LDCONFIG=	${DATADIR}
USE_PERL5=	build
USE_XORG=	scrnsaverproto x11 xcb xcomposite xcursor xext xdamage xfixes xi \
		xproto xrandr xrender xscrnsaver xtst
USE_GNOME=	atk dconf glib20 gtk30 libxml2 libxslt
SHEBANG_FILES=	chrome/tools/build/linux/chrome-wrapper
ALL_TARGET=	chrome
INSTALLS_ICONS=	yes

CC=		clang50
CXX=		clang++50
.endif

EXTRA_PATCHES+=	${FILESDIR}/extra-patch-clang

# TODO bz@ : install libwidevinecdm.so (see third_party/widevine/cdm/BUILD.gn)
#
# Run "./out/${BUILDTYPE}/gn args out/${BUILDTYPE} --list" for all variables.
# Some parts don't have use_system_* flag, and can be turned on/off by using
# replace_gn_files.py script, some parts just turned on/off for target host
# OS "target_os == is_bsd", like libusb, libpci.
GN_ARGS+=	clang_use_chrome_plugins=false \
		enable_nacl=false \
		enable_one_click_signin=true \
		enable_remoting=false \
		enable_webrtc=true \
		fieldtrial_testing_like_official_build=true \
		is_clang=true \
		is_official_build=true \
		toolkit_views=true \
		treat_warnings_as_errors=false \
		use_allocator="none" \
		use_allocator_shim=false \
		use_aura=true \
		use_bundled_fontconfig=false \
		use_cups=true \
		use_custom_libcxx=false \
		use_gtk3=true \
		use_lld=true \
		use_sysroot=false \
		use_system_freetype=true \
		use_system_harfbuzz=true \
		use_system_libjpeg=true \
		use_system_sqlite=false \
		extra_cxxflags="-I${LOCALBASE}/include" \
		extra_ldflags="-L${LOCALBASE}/lib"
# TODO: investigate building with these options:
# use_system_icu use_system_minigbm
GN_BOOTSTRAP_FLAGS=	--no-clean --no-rebuild

# FreeBSD Chromium Api Key
# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
# Note: these are for FreeBSD use ONLY. For your own distribution,
# please get your own set of keys.
GN_ARGS+=	google_api_key="AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8" \
		google_default_client_id="996322985003.apps.googleusercontent.com" \
		google_default_client_secret="IR1za9-1VK0zZ0f_O8MVFicn"

.if !defined(GN_ONLY)
SUB_FILES=	chromium-browser.desktop chrome
SUB_LIST+=	COMMENT="${COMMENT}"

OPTIONS_DEFINE=	CODECS DEBUG DRIVER GCONF KERBEROS TEST
CODECS_DESC=	Compile and enable patented codecs like H.264
DRIVER_DESC=	Install chromedriver
OPTIONS_GROUP=		AUDIO
OPTIONS_GROUP_AUDIO=	ALSA PULSEAUDIO SNDIO

OPTIONS_DEFAULT=	ALSA CODECS DRIVER GCONF KERBEROS
OPTIONS_SUB=		yes

ALSA_LIB_DEPENDS=	libasound.so:audio/alsa-lib
ALSA_RUN_DEPENDS=	${LOCALBASE}/lib/alsa-lib/libasound_module_pcm_oss.so:audio/alsa-plugins \
			alsa-lib>=1.1.1_1:audio/alsa-lib
ALSA_VARS=		GN_ARGS+=use_alsa=true
ALSA_VARS_OFF=		GN_ARGS+=use_alsa=false

CODECS_VARS=		GN_ARGS+=ffmpeg_branding="Chrome" \
			GN_ARGS+=proprietary_codecs=true \
			GN_ARGS+=enable_hevc_demuxing=true
CODECS_VARS_OFF=	GN_ARGS+=ffmpeg_branding="Chromium" \
			GN_ARGS+=proprietary_codecs=false \
			GN_ARGS+=enable_hevc_demuxing=false

DEBUG_VARS=		BUILDTYPE=Debug \
			GN_ARGS+=is_debug=true \
			GN_BOOTSTRAP_FLAGS+=--debug \
			WANTSPACE="lots of free diskspace (~ 8.5GB)"
DEBUG_VARS_OFF=		BUILDTYPE=Release \
			GN_ARGS+=is_debug=false \
			GN_ARGS+=symbol_level=0 \
			GN_ARGS+=remove_webcore_debug_symbols=true \
			WANTSPACE="a fair amount of free diskspace (~ 3.7GB)"

DRIVER_MAKE_ARGS=	chromedriver

GCONF_USE=		GNOME=gconf2
GCONF_VARS=		GN_ARGS+=use_gconf=true
GCONF_VARS_OFF=		GN_ARGS+=use_gconf=false

KERBEROS_VARS=		GN_ARGS+=use_kerberos=true
KERBEROS_VARS_OFF=	GN_ARGS+=use_kerberos=false

PULSEAUDIO_LIB_DEPENDS=	libpulse.so:audio/pulseaudio
PULSEAUDIO_VARS=	GN_ARGS+=use_pulseaudio=true
PULSEAUDIO_VARS_OFF=	GN_ARGS+=use_pulseaudio=false

# With SNDIO=on we exclude audio_manager_linux from the build (see
# media/audio/BUILD.gn) and use audio_manager_openbsd which does not
# support falling back to ALSA or PulseAudio.
SNDIO_PREVENTS=		ALSA PULSEAUDIO
SNDIO_LIB_DEPENDS=	libsndio.so:audio/sndio
SNDIO_VARS=		GN_ARGS+=use_sndio=true
SNDIO_VARS_OFF=		GN_ARGS+=use_sndio=false

.endif

.include "Makefile.tests"
TEST_ALL_TARGET=	${TEST_TARGETS}
TEST_DISTFILES=		${PORTNAME}-${DISTVERSION}-testdata${EXTRACT_SUFX}

.include <bsd.port.options.mk>

# TODO: -isystem, would be just as ugly as this approach, but more reliably
# build would fail without C_INCLUDE_PATH/CPLUS_INCLUDE_PATH env var set.
MAKE_ENV+=	C_INCLUDE_PATH=${LOCALBASE}/include \
		CPLUS_INCLUDE_PATH=${LOCALBASE}/include

# Work around base r261801
.if ${OPSYS} == FreeBSD && ${OSVERSION} < 1100508
GN_ARGS+=	extra_cxxflags="-D_LIBCPP_TRIVIAL_PAIR_COPY_CTOR=1"
EXTRA_PATCHES+=	${FILESDIR}/extra-patch-libc++-old
.else
EXTRA_PATCHES+=	${FILESDIR}/extra-patch-libc++-new
.endif

.if ${ARCH} == aarch64
GN_ARGS+=	use_vulcanize=false
.endif

.if !defined(GN_ONLY)
pre-everything::
	@${ECHO_MSG}
	@${ECHO_MSG} "To build Chromium, you should have around 2GB of memory"
	@${ECHO_MSG} "and ${WANTSPACE}."
	@${ECHO_MSG}

post-patch-SNDIO-on:
	@${MKDIR} ${WRKSRC}/media/audio/sndio ${WRKSRC}/media/audio/openbsd
	@${CP} ${FILESDIR}/sndio_output.* ${WRKSRC}/media/audio/sndio
	@${CP} ${FILESDIR}/sndio_input.* ${WRKSRC}/media/audio/sndio
	@${CP} ${FILESDIR}/audio_manager_openbsd.* ${WRKSRC}/media/audio/openbsd

pre-configure:
	# We used to remove bundled libraries to be sure that chromium uses
	# system libraries and not shipped ones.
	# cd ${WRKSRC} && ${PYTHON_CMD} \
	#./build/linux/unbundle/remove_bundled_libraries.py [list of preserved]
	cd ${WRKSRC} && ${PYTHON_CMD} \
		./build/linux/unbundle/replace_gn_files.py --system-libraries \
		ffmpeg flac freetype harfbuzz-ng libdrm libevent libwebp libxml libxslt snappy yasm || ${FALSE}
.endif

do-configure:
	# GN generator bootstrapping and generating ninja files
	cd ${WRKSRC} && ${SETENV} CC=${CC} CXX=${CXX} LD=${CXX} \
		READELF=${READELF} AR=${AR} NM=${NM} ${PYTHON_CMD} \
		./tools/gn/bootstrap/bootstrap.py ${GN_BOOTSTRAP_FLAGS}
.if !defined(GN_ONLY)
	cd ${WRKSRC} && ${SETENV} ./out/${BUILDTYPE}/gn \
		gen --args='${GN_ARGS}' out/${BUILDTYPE}

	# Setup nodejs dependency
	@${MKDIR} ${WRKSRC}/third_party/node/freebsd/node-freebsd-x64/bin
	${LN} -sf ${LOCALBASE}/bin/node ${WRKSRC}/third_party/node/freebsd/node-freebsd-x64/bin/node
.endif

do-test-TEST-on:
.for t in ${TEST_TARGETS}
	cd ${WRKSRC}/out/${BUILDTYPE} && ${SETENV} LC_ALL=en_US.UTF-8 \
		./${t} --gtest_filter=-${EXCLUDE_${t}:ts:} || ${TRUE}
.endfor

.if !defined(GN_ONLY)
do-install:
	@${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_MAN} ${WRKSRC}/chrome/app/resources/manpage.1.in \
		${STAGEDIR}${MANPREFIX}/man/man1/chrome.1
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/*.service ${STAGEDIR}${DATADIR}
.for s in 22 24 48 64 128 256
	@${MKDIR} ${STAGEDIR}${PREFIX}/share/icons/hicolor/${s}x${s}/apps
	${INSTALL_DATA} ${WRKSRC}/chrome/app/theme/chromium/product_logo_${s}.png \
		${STAGEDIR}${PREFIX}/share/icons/hicolor/${s}x${s}/apps/chrome.png
.endfor
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/*.png ${STAGEDIR}${DATADIR}
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/*.pak ${STAGEDIR}${DATADIR}
.for d in protoc icudtl.dat mksnapshot natives_blob.bin snapshot_blob.bin
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/${d} ${STAGEDIR}${DATADIR}
.endfor
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/chrome \
		${STAGEDIR}${DATADIR}
	cd ${WRKSRC}/out/${BUILDTYPE} && \
		${COPYTREE_SHARE} "locales resources" ${STAGEDIR}${DATADIR}
	@${MKDIR} ${STAGEDIR}${DESKTOPDIR}
	${INSTALL_DATA} ${WRKDIR}/chromium-browser.desktop \
		${STAGEDIR}${DESKTOPDIR}
	${INSTALL_SCRIPT} ${WRKDIR}/chrome ${STAGEDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} ${WRKSRC}/chrome/tools/build/linux/chrome-wrapper \
		${STAGEDIR}${DATADIR}
.for f in libEGL.so libGLESv2.so
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/${f} ${STAGEDIR}${DATADIR}
.endfor
	@${MKDIR} ${STAGEDIR}${DATADIR}/swiftshader
.for g in libEGL.so libGLESv2.so
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/swiftshader/${g} \
		${STAGEDIR}${DATADIR}/swiftshader
.endfor

post-install-DEBUG-on:
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/*.so \
		${STAGEDIR}${DATADIR}
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/character_data_generator \
		${STAGEDIR}${DATADIR}

post-install-DRIVER-on:
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/chromedriver \
		${STAGEDIR}${PREFIX}/bin
.endif
.include <bsd.port.mk>
