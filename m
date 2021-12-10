Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0172EA8
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175696; x=1670711696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1mF7fuki2httY+xJgcD1DM+zShxMRgwABsSLE5qoSZw=;
  b=hW6Hc0An91IyJJu+aM2jrVB7xs3fVNaW5H1N3T+2SNg0ac8STCSxjEGd
   CGbVWozboc+puyhgQsP/EyPDYgCEPS70RAjocFNFqMetu2v1+ZOqB0CSv
   lgbqFSKwr4bsBW0yPHGnOLQpDGVmlg1mFt7NP98jLvnrlFW6AMILbLW5q
   AQ677OOAnS7I8AHNXrX6BOqKrboUg0nZ+OMx/w7LEer7NGOngOpG2qjUV
   sQsgXp6Trocpu6iA0gpatVlBx74HMRO8WFrvrWf0UvAgb5PiL+CIXVK7R
   vfm34HrHw+yvkIpxba4oXfJ1OHdGO3gVKn185S3Dj8tOGpMUKqS3fc3W9
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="301843380"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="301843380"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113698"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v3 10/11] daxctl: add systemd service and udev rule for automatic reconfiguration
Date: Fri, 10 Dec 2021 15:34:39 -0700
Message-Id: <20211210223440.3946603-11-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4206; h=from:subject; bh=1mF7fuki2httY+xJgcD1DM+zShxMRgwABsSLE5qoSZw=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbrzHMPbVWkMWd+4K7zYPZPI6lS5fwh99t4vy39PY8gc4c B2OejlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExk4y9GhnmbhHe6Hk5XlTqb6S58LC 1qhe+p4vcuJhXXln57zvuPx57hr0Shz6vi1f2h6z43MPaoRr/JOe2z8ME1w97XU3j81RdMZgMA
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
index 39ad0d4..33cff60 100644
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
index 5cebb6c..36dfc55 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -28,3 +28,10 @@ daxctl_LDADD =\
 	$(KMOD_LIBS) \
 	$(JSON_LIBS) \
 	-liniparser
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
index b46bd74..642670a 100644
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

