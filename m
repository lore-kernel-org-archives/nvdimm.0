Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52B632007E7E3
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 08:07:08 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id o8-v6so4464626ota.12
 for <linux-nvdimm@lists.01.org>; Tue, 01 May 2018 08:07:08 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] ndctl, monitor: add the unit file of systemd for
 ndctl-monitor service
References: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
 <20180426113050.11424-5-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <4ee59ab2-7c2f-1444-5e27-fda231982b0d@gmail.com>
Date: Tue, 1 May 2018 11:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <20180426113050.11424-5-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello QI,

I think the systemd service is nice, however, it seems that it does
not work fine... because ndctl-monitor.service was not installed
to systemd dir.

On 04/26/2018 07:30 AM, QI Fuli wrote:
> This patch adds the systemd unit file for ndctl-monitor service.
> The systemd unit directory can be configured by setting environment
> variable "--with-systemd-unit-dir[=DIR]".
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> 
> ---
>  autogen.sh                  |  3 ++-
>  configure.ac                | 22 ++++++++++++++++++++++
>  ndctl/Makefile.am           |  4 ++++
>  ndctl/ndctl-monitor.service |  7 +++++++
>  4 files changed, 35 insertions(+), 1 deletion(-)
>  create mode 100644 ndctl/ndctl-monitor.service
> 
> diff --git a/autogen.sh b/autogen.sh
> index a23cf53..b226c7a 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -17,7 +17,8 @@ libdir() {
>  
>  args="--prefix=/usr \
>  --sysconfdir=/etc \
> ---libdir=$(libdir /usr/lib)"
> +--libdir=$(libdir /usr/lib) \
> +--with-systemd-unit-dir"
>  
>  echo
>  echo "----------------------------------------------------------------"
> diff --git a/configure.ac b/configure.ac
> index cddad16..60c6537 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -135,6 +135,27 @@ AC_CHECK_FUNCS([ \
>  	secure_getenv\
>  ])
>  
> +PKG_PROG_PKG_CONFIG
> +AC_ARG_WITH([systemd-unit-dir],
> +	AS_HELP_STRING([--with-systemd-unit-dir[=DIR]],
> +		[Directory for systemd service files]),
> +	[],
> +	[with_systemd_unit_dir=yes])
> +
> +if test "x$with_systemd_unit_dir" = "xyes"; then
> +	def_systemd_unit_dir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)
> +	if test "x$def_systemd_unit_dir" = "x"; then
> +		AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])
> +		with_systemd_unit_dir=no
> +	else
> +		with_systemd_unit_dir="$def_systemd_unit_dir"
> +	fi
> +fi
> +
> +AS_IF([test "x$with_systemd_unit_dir" != "xno"],
> +	[AC_SUBST([SYSTEMD_UNIT_DIR], [$with_systemd_unit_dir])])
> +AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test "x$with_systemd_unit_dir" != "xno"])
> +
>  my_CFLAGS="\
>  -Wall \
>  -Wchar-subscripts \
> @@ -172,6 +193,7 @@ AC_MSG_RESULT([
>          sysconfdir:             ${sysconfdir}
>          libdir:                 ${libdir}
>          includedir:             ${includedir}
> +	systemd-unit-dir:	${SYSTEMD_UNIT_DIR}
>  
>          compiler:               ${CC}
>          cflags:                 ${CFLAGS}
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index ae3d894..b3053d0 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -47,3 +47,7 @@ monitor_config_file = monitor.conf
>  monitor_configdir = /etc/ndctl/
>  monitor_config_DATA = $(monitor_config_file)
>  EXTRA_DIST += $(monitor_config_file)
> +
> +if ENABLE_SYSTEMD_UNIT_DIR
> +systemd_unitDATA = ndctl-monitor.service
> +endif

I'm not familiar with autoconf syntax, but I think the 'systemd_unitDATA'
may be wrong... *_DATA is correct, isn't it?
And, your autoconf code is a little different from the example of autoconf
guide for systemd [1]. It might be a good idea to use the example code simply
because it makes easy to find the systemd code for someone who try to
add systemd service in the future.

[1] https://www.freedesktop.org/software/systemd/man/daemon.html

> diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
> new file mode 100644
> index 0000000..44f9326
> --- /dev/null
> +++ b/ndctl/ndctl-monitor.service
> @@ -0,0 +1,7 @@
> +[Unit]
> +Description=Ndctl Monitor Daemon
> +
> +[Service]
> +Type=forking
> +ExecStart=/usr/bin/ndctl monitor --daemon
> +ExecStop=/bin/kill ${MAINPID}
> 

How about the following change?

---
 autogen.sh                  |  3 ++-
 configure.ac                | 15 +++++++++++++++
 ndctl/Makefile.am           |  4 ++++
 ndctl/ndctl-monitor.service |  7 +++++++
 4 files changed, 28 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl-monitor.service

diff --git a/autogen.sh b/autogen.sh
index a23cf53..bc58002 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -17,7 +17,8 @@ libdir() {
 
 args="--prefix=/usr \
 --sysconfdir=/etc \
---libdir=$(libdir /usr/lib)"
+--libdir=$(libdir /usr/lib) \
+--with-systemdsystemunitdir"
 
 echo
 echo "----------------------------------------------------------------"
diff --git a/configure.ac b/configure.ac
index 3eaac32..6fe054f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -122,6 +122,20 @@ AC_CHECK_FUNCS([ \
 	secure_getenv\
 ])
 
+AC_ARG_WITH([systemdsystemunitdir],
+	[AS_HELP_STRING([--with-systemdsystemunitdir=DIR], [Directory for systemd service files])],,
+		[with_systemdsystemunitdir=auto])
+AS_IF([test "x$with_systemdsystemunitdir" = "xyes" -o "x$with_systemdsystemunitdir" = "xauto"],
+	[def_systemdsystemunitdir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)
+	AS_IF([test "x$def_systemdsystemunitdir" = "x"],
+		[AS_IF([test "x$with_systemdsystemunitdir" = "xyes"],
+			[AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])])
+				with_systemdsystemunitdir=no],
+				[with_systemdsystemunitdir="$def_systemdsystemunitdir"])])
+AS_IF([test "x$with_systemdsystemunitdir" != "xno"],
+	[AC_SUBST([systemdsystemunitdir], [$with_systemdsystemunitdir])])
+AM_CONDITIONAL([HAVE_SYSTEMD], [test "x$with_systemdsystemunitdir" != "xno"])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
@@ -159,6 +173,7 @@ AC_MSG_RESULT([
         sysconfdir:             ${sysconfdir}
         libdir:                 ${libdir}
         includedir:             ${includedir}
+        systemdunitdir:         ${systemdsystemunitdir}
 
         compiler:               ${CC}
         cflags:                 ${CFLAGS}
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index ae3d894..6ee4726 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -47,3 +47,7 @@ monitor_config_file = monitor.conf
 monitor_configdir = /etc/ndctl/
 monitor_config_DATA = $(monitor_config_file)
 EXTRA_DIST += $(monitor_config_file)
+
+if HAVE_SYSTEMD
+systemdsystemunit_DATA = ndctl-monitor.service
+endif
diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
new file mode 100644
index 0000000..44f9326
--- /dev/null
+++ b/ndctl/ndctl-monitor.service
@@ -0,0 +1,7 @@
+[Unit]
+Description=Ndctl Monitor Daemon
+
+[Service]
+Type=forking
+ExecStart=/usr/bin/ndctl monitor --daemon
+ExecStop=/bin/kill ${MAINPID}
-- 
1.8.3.1

- Masa
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
