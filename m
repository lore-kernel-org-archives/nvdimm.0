Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB63021B02845
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:34:06 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 23254AC020C
 for <linux-nvdimm@lists.01.org>; Sat, 14 Jul 2018 08:34:01 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v13 3/5] ndctl,
 monitor: add the unit file of systemd for ndctl-monitor service
Date: Sat, 14 Jul 2018 08:33:48 +0900
Message-Id: <20180713233350.7148-4-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
References: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: tokunaga.keiich@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

This patch adds the systemd unit file for ndctl-monitor service.
The systemd unit directory can be configured by setting environment
variable "--with-systemd-unit-dir[=DIR]".

A monitor daemon can be started as a system service:
   # systemctl start ndctl-monitor.service

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 autogen.sh                  |  3 ++-
 configure.ac                | 22 ++++++++++++++++++++++
 ndctl.spec.in               |  2 ++
 ndctl/Makefile.am           |  4 ++++
 ndctl/ndctl-monitor.service |  7 +++++++
 5 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl-monitor.service

diff --git a/autogen.sh b/autogen.sh
index 2a52688..21b0e25 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -17,7 +17,8 @@ libdir() {
 
 args="--prefix=/usr \
 --sysconfdir=/etc \
---libdir=$(libdir /usr/lib)"
+--libdir=$(libdir /usr/lib) \
+--with-systemd-unit-dir"
 
 echo
 echo "----------------------------------------------------------------"
diff --git a/configure.ac b/configure.ac
index ff0096d..e242334 100644
--- a/configure.ac
+++ b/configure.ac
@@ -143,6 +143,27 @@ AC_CHECK_FUNCS([ \
 	secure_getenv\
 ])
 
+PKG_PROG_PKG_CONFIG
+AC_ARG_WITH([systemd-unit-dir],
+	AS_HELP_STRING([--with-systemd-unit-dir[=DIR]],
+		[Directory for systemd service files]),
+	[],
+	[with_systemd_unit_dir=yes])
+
+if test "x$with_systemd_unit_dir" = "xyes"; then
+	def_systemd_unit_dir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)
+	if test "x$def_systemd_unit_dir" = "x"; then
+		AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])
+		with_systemd_unit_dir=no
+	else
+		with_systemd_unit_dir="$def_systemd_unit_dir"
+	fi
+fi
+
+AS_IF([test "x$with_systemd_unit_dir" != "xno"],
+	[AC_SUBST([systemd_unitdir], [$with_systemd_unit_dir])])
+AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test "x$with_systemd_unit_dir" != "xno"])
+
 my_CFLAGS="\
 -D DEF_CONF_FILE='\"${sysconfdir}/ndctl/monitor.conf\"' \
 -Wall \
@@ -185,6 +206,7 @@ AC_MSG_RESULT([
         sysconfdir:             ${sysconfdir}
         libdir:                 ${libdir}
         includedir:             ${includedir}
+	systemd-unit-dir:	${systemd_unitdir}
 
         compiler:               ${CC}
         cflags:                 ${CFLAGS}
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 41a1d59..17152c1 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -20,6 +20,7 @@ BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
+BuildRequires:	systemd
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -117,6 +118,7 @@ make check
 %{_mandir}/man1/ndctl*
 %{bashcompdir}/
 %{_sysconfdir}/ndctl/monitor.conf
+%{_unitdir}/ndctl-monitor.service
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 58b747a..0f9bb43 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -47,3 +47,7 @@ monitor_config_file = monitor.conf
 monitor_configdir = $(sysconfdir)/ndctl/
 monitor_config_DATA = $(monitor_config_file)
 EXTRA_DIST += $(monitor_config_file)
+
+if ENABLE_SYSTEMD_UNIT_DIR
+systemd_unit_DATA = ndctl-monitor.service
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
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
