Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4473FD0
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:20 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009066"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009066"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577063019"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:09 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for auto-onlining
Date: Tue, 31 Aug 2021 03:04:59 -0600
Message-Id: <20210831090459.2306727-8-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4691; h=from:subject; bh=j+X/+rg444qIGQjoep96kvmDep35kpQaptDAf7tSmOg=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6H3Y8uGnO7pcvmykdoLW/LeCYz9J+j+xVHXl5wsvqnZKe VnV1lLIwiHEwyIopsvzd85HxmNz2fJ7ABEeYOaxMIEMYuDgFYCIeBowM038vLNQ8+umAfPPjP49tXZ 3rrAz2ffxws+TL5bwAkxv3bzAyTNr/n+dY7rfjMya3Hv6eHO6g6RIY8Phk1QvLK/HTmHh+sAMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Install a helper script that calls daxctl-reconfigure-device with the
new 'check-config' option for a given device. This is meant to be called
via a systemd service.

Install a systemd service that calls the above wrapper script with a
daxctl device passed in to it via the environment.

Install a udev rule that is triggered for every daxctl device, and
triggers the above oneshot systemd service.

Together, these three things work such that upon boot, whenever a daxctl
device is found, udev triggers a device-specific systemd service called,
for example:

  daxdev-reconfigure@-dev-dax0.0.service

This initiates a daxctl-reconfigure-device with a config lookup for the
'dax0.0' device. If the config has an '[auto-online <unique_id>]'
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
 configure.ac                       |  9 ++++++++-
 daxctl/90-daxctl-device.rules      |  1 +
 daxctl/Makefile.am                 | 10 ++++++++++
 daxctl/daxdev-auto-reconfigure.sh  |  3 +++
 daxctl/daxdev-reconfigure@.service |  8 ++++++++
 ndctl.spec.in                      |  3 +++
 6 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 daxctl/90-daxctl-device.rules
 create mode 100755 daxctl/daxdev-auto-reconfigure.sh
 create mode 100644 daxctl/daxdev-reconfigure@.service

diff --git a/configure.ac b/configure.ac
index 9e1c6db..df6ab10 100644
--- a/configure.ac
+++ b/configure.ac
@@ -160,7 +160,7 @@ AC_CHECK_FUNCS([ \
 
 AC_ARG_WITH([systemd],
 	AS_HELP_STRING([--with-systemd],
-		[Enable systemd functionality (monitor). @<:@default=yes@:>@]),
+		[Enable systemd functionality. @<:@default=yes@:>@]),
 	[], [with_systemd=yes])
 
 if test "x$with_systemd" = "xyes"; then
@@ -183,6 +183,13 @@ daxctl_modprobe_data=daxctl.conf
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
index f30c485..d53bdcf 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -28,3 +28,13 @@ daxctl_LDADD =\
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
 	$(JSON_LIBS)
+
+bin_SCRIPTS = daxdev-auto-reconfigure.sh
+CLEANFILES = $(bin_SCRIPTS)
+
+udevrulesdir = $(UDEVRULESDIR)
+udevrules_DATA = 90-daxctl-device.rules
+
+if ENABLE_SYSTEMD_UNITS
+systemd_unit_DATA = daxdev-reconfigure@.service
+endif
diff --git a/daxctl/daxdev-auto-reconfigure.sh b/daxctl/daxdev-auto-reconfigure.sh
new file mode 100755
index 0000000..f6da43f
--- /dev/null
+++ b/daxctl/daxdev-auto-reconfigure.sh
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+daxctl reconfigure-device --check-config "${1##*/}"
diff --git a/daxctl/daxdev-reconfigure@.service b/daxctl/daxdev-reconfigure@.service
new file mode 100644
index 0000000..451fef1
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
+ExecStart=/bin/sh -c "exec daxdev-auto-reconfigure.sh %I"
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 07c36ec..fd1a5ff 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -124,8 +124,11 @@ make check
 %defattr(-,root,root)
 %license LICENSES/preferred/GPL-2.0 LICENSES/other/MIT LICENSES/other/CC0-1.0
 %{_bindir}/daxctl
+%{_bindir}/daxdev-auto-reconfigure.sh
 %{_mandir}/man1/daxctl*
 %{_datadir}/daxctl/daxctl.conf
+%{_unitdir}/daxdev-reconfigure@.service
+%config %{_udevrulesdir}/90-daxctl-device.rules
 
 %files -n LNAME
 %defattr(-,root,root)
-- 
2.31.1

