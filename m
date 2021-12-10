Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0976D173
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 22:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639175686; x=1670711686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9n8FZ3IDAMmEhnF1cTeLEU+QX645E0K21EH3b42yk0g=;
  b=BIhYJDlGGJGU78f2Tw9AuwhOJ469S0UTs0iICl/HDOJ4uAXGmchgtcof
   vgEKQKpOuUnwSSXUOOUP0Z4RHr/O3WH27gdFcbLvNOepdJ4sQGWGX0xQE
   uk1eKfllaBVTsWe3Hl3izAwXKSA/5d7WPnnRH5I5IruejChZ6O8PnSueY
   03gPmxKzjVculyveXWBcapaC8FzWth4vWdqyt9MiGQWhd9StW8pF1eK+U
   0KzyuCY6nbaWnUDLS9pwgOt91ZeJDq6BYkX4UxxmTcJm285aQWccg5Bqe
   /LQAI9inJCH3hDlXHj9KkMq4vBkz3WwZc3/uDnm5DY1W+dNNVmQd8+iU5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="238261457"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="238261457"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="504113659"
Received: from fpchan-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 14:34:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	QI Fuli <qi.fuli@fujitsu.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 03/11] ndctl, config: add the default ndctl configuration file
Date: Fri, 10 Dec 2021 15:34:32 -0700
Message-Id: <20211210223440.3946603-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210223440.3946603-1-vishal.l.verma@intel.com>
References: <20211210223440.3946603-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4180; i=vishal.l.verma@intel.com; h=from:subject; bh=sBRcYTSZmw4YvrEhpP1oEOmBDKU0JX8rOdHLXa6WsJo=; b=owGbwMvMwCXGf25diOft7jLG02pJDImbr/5TWhL+QZGx4y6PtquN8LxPklteH9BXZetxr7084UZ8 o9z3jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEwkpIXhDy/PkqtGWxjqT9eL/4s95L Lv7I+WP1MW1/W8bOuW54j/5MPwv1aHk9t4jUuz/y++Ur/TPdsi963eEGTAb+AYeapkp+dBZgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

Install ndctl/ndctl.conf a default/example ndctl configuration file.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac      |  1 +
 ndctl/Makefile.am |  4 +++-
 ndctl/ndctl.conf  | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl.conf

diff --git a/configure.ac b/configure.ac
index a264af7..3f15a7b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -175,6 +175,7 @@ ndctl_confdir=${sysconfdir}/ndctl.conf.d
 ndctl_conf=ndctl.conf
 ndctl_monitorconf=monitor.conf
 AC_SUBST([ndctl_confdir])
+AC_SUBST([ndctl_conf])
 AC_SUBST([ndctl_monitorconf])
 
 daxctl_modprobe_datadir=${datadir}/daxctl
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 00d2612..4e99510 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -42,7 +42,7 @@ keys_configdir = $(ndctl_keysdir)
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
index 0000000..ebb4c66
--- /dev/null
+++ b/ndctl/ndctl.conf
@@ -0,0 +1,56 @@
+# This is the default ndctl configuration file. It contains the
+# configuration directives that give ndctl instructions.
+# Ndctl supports multiple configuration files. All files with the
+# .conf suffix under {sysconfdir}/ndctl.conf.d will be regarded as
+# valid ndctl configuration files.
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
+# when running monitor as a daemon.
+# log = /var/log/ndctl/monitor.log
-- 
2.33.1

