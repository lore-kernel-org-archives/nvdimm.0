Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE8E82279CF0A
 for <linux-nvdimm@lists.01.org>; Sun,  6 May 2018 22:10:23 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 3D6EFAC01B1
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 14:10:16 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v6 3/4] ndctl, monitor: add default configuration file
Date: Mon,  7 May 2018 14:09:25 +0900
Message-Id: <20180507050926.17243-4-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
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
List-ID: <linux-nvdimm@lists.01.org>

This patch adds the default configuration file of ndctl monitor.
Users can change the configuration by editing this file or by
using [--config-file=<file>] option to override this one.
The monitor started by systemd follows the configuration in this file.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/Makefile.am  |  5 +++++
 ndctl/monitor.conf | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)
 create mode 100644 ndctl/monitor.conf

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 7dbf223..ae3d894 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -42,3 +42,8 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/multi-pmem.c \
 		 ../test/core.c
 endif
+
+monitor_config_file = monitor.conf
+monitor_configdir = /etc/ndctl/
+monitor_config_DATA = $(monitor_config_file)
+EXTRA_DIST += $(monitor_config_file)
diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf
new file mode 100644
index 0000000..13ad7b0
--- /dev/null
+++ b/ndctl/monitor.conf
@@ -0,0 +1,37 @@
+# This is the main ndctl monitor configuration file. It contains the
+# configuration directives that give ndctl monitor instructions.
+# You can change the configuration of ndctl monitor by editing this
+# file or by using [--config-file=<file>] option to override this one.
+# The changed value will work after restart ndctl monitor service.
+
+# In this file, lines starting with a hash (#) are comments.
+# The configurations shold follow <key> = <value> style.
+# Multiple space-seperated values are allowed, but except the following
+# charecters: : # ? / \ % " '
+
+# The dimms to monitor are filtered via dimm's name by setting key "dimm".
+# If this value is different from the value of [--dimm=<value>] option,
+# both of the values will work.
+# dimm = all
+
+# The dimms to monitor are filtered via its parent bus by setting key "bus".
+# If this value is different from the value of [--bus=<value>] option,
+# both of the values will work.
+# bus = all
+
+# The dimms to monitor are filtered via region by setting key "region".
+# If this value is different from the value of [--namespace=<value>] option,
+# both of the values will work.
+# region = all
+
+# The dimms to monitor are filtered via namespace by setting key "namespace".
+# If this value is different from the value of [--namespace=<value>] option,
+# both of the values will work.
+# namespace = all
+
+# Users can choose to output the notifications to syslog (logfile=syslog),
+# stderr (logfile=stderr) or to write into a special file (logfile=<file>)
+# by setting key "logfile".
+# If this value is in conflict with the value of [--logfile=<value>] option,
+# this value will be ignored.
+# logfile = /var/log/ndctl/monitor.log
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
