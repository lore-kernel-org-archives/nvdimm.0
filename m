Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1380B2CA8
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:48 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804844"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804844"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:46 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310473"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:46 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 12/12] daxctl: add systemd service and udev rule for automatic reconfiguration
Date: Mon,  6 Dec 2021 15:28:30 -0700
Message-Id: <20211206222830.2266018-13-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4207; h=from:subject; bh=CwjCJ5OMhaZPhOB/59KJO8aVDvUQ4RNpyfO3a3jflO0=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+vry8/hqF9yfFPhx8l4WaflE+3lsFXcvtbZ81r1yMd77 8IusjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExE6w/Df9/ZDt+qvr5glk96bTJ96V HOt5oihdOyV/M+m7zYV9+9PZ7hf/i8W+23r8RFP5yUMknsZN0SJ0tP83tx2b+2ackkiCp3sAMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Install a systemd service that calls "daxctl-reconfigure-device
--check-config"  with a daxctl device passed in to it via the
environment.

Install a udev rule that is triggered for every daxctl device, and
triggers the above oneshot systemd service.

On boot, whenever a daxctl device is found, udev triggers a
device-specific systemd service called, for example:

  daxdev-reconfigure@-dev-dax0.0.service

This initiates a daxctl-reconfigure-device with a config lookup for the
'dax0.0' device. If the config has a '[reconfigure-device <unique_id>]'
section, it uses the information in that to set the operating mode of
the device.

If any device is in an unexpected status, 'journalctl' can be used to
view the reconfiguration log for that device, for example:

  journalctl --unit daxdev-reconfigure@-dev-dax0.0.service

Update the RPM spec file to include the newly added files to the RPM
build.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac                       | 9 ++++++++-
 daxctl/90-daxctl-device.rules      | 1 +
 daxctl/Makefile.am                 | 7 +++++++
 daxctl/daxdev-reconfigure@.service | 8 ++++++++
 ndctl.spec.in                      | 3 +++
 5 files changed, 27 insertions(+), 1 deletion(-)
 create mode 100644 daxctl/90-daxctl-device.rules
 create mode 100644 daxctl/daxdev-reconfigure@.service

diff --git a/configure.ac b/configure.ac
index e779b51..dcdc15f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -160,7 +160,7 @@ AC_CHECK_FUNCS([ \
 
 AC_ARG_WITH([systemd],
 	AS_HELP_STRING([--with-systemd],
-		[Enable systemd functionality (monitor). @<:@default=yes@:>@]),
+		[Enable systemd functionality. @<:@default=yes@:>@]),
 	[], [with_systemd=yes])
 
 if test "x$with_systemd" = "xyes"; then
@@ -186,6 +186,13 @@ daxctl_modprobe_data=daxctl.conf
 AC_SUBST([daxctl_modprobe_datadir])
 AC_SUBST([daxctl_modprobe_data])
 
+AC_ARG_WITH(udevrulesdir,
+    [AS_HELP_STRING([--with-udevrulesdir=DIR], [udev rules.d directory])],
+    [UDEVRULESDIR="$withval"],
+    [UDEVRULESDIR='${prefix}/lib/udev/rules.d']
+)
+AC_SUBST(UDEVRULESDIR)
+
 AC_ARG_WITH([keyutils],
 	    AS_HELP_STRING([--with-keyutils],
 			[Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rules
new file mode 100644
index 0000000..ee0670f
--- /dev/null
+++ b/daxctl/90-daxctl-device.rules
@@ -0,0 +1 @@
+ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd", ENV{SYSTEMD_WANTS}="daxdev-reconfigure@$env{DEVNAME}.service"
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index ac97cd1..6d41016 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -28,3 +28,10 @@ daxctl_LDADD =\
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
 	$(JSON_LIBS)
+
+udevrulesdir = $(UDEVRULESDIR)
+udevrules_DATA = 90-daxctl-device.rules
+
+if ENABLE_SYSTEMD_UNITS
+systemd_unit_DATA = daxdev-reconfigure@.service
+endif
diff --git a/daxctl/daxdev-reconfigure@.service b/daxctl/daxdev-reconfigure@.service
new file mode 100644
index 0000000..13d570c
--- /dev/null
+++ b/daxctl/daxdev-reconfigure@.service
@@ -0,0 +1,8 @@
+[Unit]
+Description=Automatic daxctl device reconfiguration
+Documentation=man:daxctl-reconfigure-device(1)
+
+[Service]
+Type=forking
+GuessMainPID=false
+ExecStart=/bin/sh -c "exec daxctl reconfigure-device --check-config %I"
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 07c36ec..2c33664 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -26,6 +26,7 @@ BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	pkgconfig(systemd)
 BuildRequires:	keyutils-libs-devel
+BuildRequires:	systemd-rpm-macros
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -126,6 +127,8 @@ make check
 %{_bindir}/daxctl
 %{_mandir}/man1/daxctl*
 %{_datadir}/daxctl/daxctl.conf
+%{_unitdir}/daxdev-reconfigure@.service
+%config %{_udevrulesdir}/90-daxctl-device.rules
 
 %files -n LNAME
 %defattr(-,root,root)
-- 
2.33.1

