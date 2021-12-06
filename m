Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029F62CA8
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="261484506"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="261484506"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:43 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310431"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:42 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 04/12] ndctl, config: add the default ndctl configuration file
Date: Mon,  6 Dec 2021 15:28:22 -0700
Message-Id: <20211206222830.2266018-5-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4289; i=vishal.l.verma@intel.com; h=from:subject; bh=i5SzAjuKS7AdOmKikpy/Xy3eB+AxbULX34tPxzRIvI0=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+nr27glS7+avmnIgpqedhT8uysCVp1AsatN58Y8urpde rfXuKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwEQ+PGH4KyD//HqFAcdMxUnaOSfEDm 2cGH3N5uFCyQCTS92BH9abVDH89/3R0zljSqjoncAA8fY9O78sy+wVe7Bw/dxM7bbN0S3zWAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Install ndctl/ndctl.conf as the default ndctl configuration file.

Link: https://lore.kernel.org/r/20210824095106.104808-5-qi.fuli@fujitsu.com
Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac      |  2 ++
 ndctl/Makefile.am |  4 +++-
 ndctl/ndctl.conf  | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl.conf

diff --git a/configure.ac b/configure.ac
index 42a66e1..9e1c6db 100644
--- a/configure.ac
+++ b/configure.ac
@@ -172,8 +172,10 @@ AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
 ndctl_confdir=${sysconfdir}/ndctl
+ndctl_conf=ndctl.conf
 ndctl_monitorconf=monitor.conf
 AC_SUBST([ndctl_confdir])
+AC_SUBST([ndctl_conf])
 AC_SUBST([ndctl_monitorconf])
 
 daxctl_modprobe_datadir=${datadir}/daxctl
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 1caa031..fceb3ab 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -43,7 +43,7 @@ keys_configdir = $(ndctl_keysdir)
 keys_config_DATA = $(ndctl_keysreadme)
 endif
 
-EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service
+EXTRA_DIST += keys.readme monitor.conf ndctl-monitor.service ndctl.conf
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
@@ -74,6 +74,8 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 test.c
 endif
 
+ndctl_configdir = $(ndctl_confdir)
+ndctl_config_DATA = $(ndctl_conf)
 monitor_configdir = $(ndctl_confdir)
 monitor_config_DATA = $(ndctl_monitorconf)
 
diff --git a/ndctl/ndctl.conf b/ndctl/ndctl.conf
new file mode 100644
index 0000000..04d322d
--- /dev/null
+++ b/ndctl/ndctl.conf
@@ -0,0 +1,56 @@
+# This is the default ndctl configuration file. It contains the
+# configuration directives that give ndctl instructions.
+# Ndctl supports multiple configuration files. All files with the
+# .conf suffix under {sysconfdir}/ndctl can be regarded as ndctl
+# configuration files.
+
+# In this file, lines starting with a hash (#) are comments.
+# The configurations should be in a [section] and follow <key> = <value>
+# style. Multiple space-separated values are allowed, but except the
+# following characters: : ? / \ % " ' $ & ! * { } [ ] ( ) = < > @
+
+[core]
+# The values in [core] section work for all ndctl sub commands.
+# dimm = all
+# bus = all
+# region = all
+# namespace = all
+
+[monitor]
+# The values in [monitor] section work for ndctl monitor.
+# You can change the configuration of ndctl monitor by editing this
+# file or use [--config-file=<file>] option to override this one.
+# The changed value will work after restart ndctl monitor service.
+
+# The objects to monitor are filtered via dimm's name by setting key "dimm".
+# If this value is different from the value of [--dimm=<value>] option,
+# both of the values will work.
+# dimm = all
+
+# The objects to monitor are filtered via its parent bus by setting key "bus".
+# If this value is different from the value of [--bus=<value>] option,
+# both of the values will work.
+# bus = all
+
+# The objects to monitor are filtered via region by setting key "region".
+# If this value is different from the value of [--region=<value>] option,
+# both of the values will work.
+# region = all
+
+# The objects to monitor are filtered via namespace by setting key "namespace".
+# If this value is different from the value of [--namespace=<value>] option,
+# both of the values will work.
+# namespace = all
+
+# The DIMM events to monitor are filtered via event type by setting key
+# "dimm-event". If this value is different from the value of
+# [--dimm-event=<value>] option, both of the values will work.
+# dimm-event = all
+
+# Users can choose to output the notifications to syslog (log=syslog),
+# to standard output (log=standard) or to write into a special file (log=<file>)
+# by setting key "log". If this value is in conflict with the value of
+# [--log=<value>] option, this value will be ignored.
+# Note: Setting value to "standard" or relative path for <file> will not work
+# when running moniotr as a daemon.
+# log = /var/log/ndctl/monitor.log
-- 
2.33.1

