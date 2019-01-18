Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D698211B509C
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 12:44:06 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 Documentation: Allow for Makefile variables in Documentation
Date: Fri, 18 Jan 2019 13:43:57 -0700
Message-Id: <20190118204357.7282-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We were starting to accumulate automake variables such as configureation
file paths that were also referenced in Documentation man pages.
However, until now, the man pages simply hard coded these paths to their
default values. If a distribution were to configure such a path to
something other than the default, the man pages would be out of sync
with the reality.

Arrange for Makefile variables to be piped into an 'attrs.adoc' target
(the variables to be piped in this manner still ahve to be listed
explicitly). The different asciidoc(tor) source files can then include
attrs.adoc to use these variables.

Finally, convert instances of '/etc/ndctl/monitor.conf' in the monitor
documentation to use this new facility.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/Makefile.am       | 10 +++++++++-
 Documentation/ndctl/ndctl-monitor.txt | 16 ++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index a30b139..7e17f20 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -51,6 +51,13 @@ man1_MANS = \
 
 CLEANFILES = $(man1_MANS)
 
+.ONESHELL:
+attrs.adoc: $(srcdir)/Makefile.am
+	$(AM_V_GEN) cat <<- EOF >$@
+		:ndctl_monitorconfdir: $(ndctl_monitorconfdir)
+		:ndctl_monitorconf: $(ndctl_monitorconf)
+		EOF
+
 XML_DEPS = \
 	../../version.m4 \
 	Makefile \
@@ -63,7 +70,8 @@ XML_DEPS = \
 	xable-namespace-options.txt \
 	ars-description.txt \
 	labels-description.txt \
-	labels-options.txt
+	labels-options.txt \
+	attrs.adoc
 
 RM ?= rm -f
 
diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
index 363c398..2239f04 100644
--- a/Documentation/ndctl/ndctl-monitor.txt
+++ b/Documentation/ndctl/ndctl-monitor.txt
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+include::attrs.adoc[]
+
 ndctl-monitor(1)
 ================
 
@@ -19,11 +21,13 @@ objects and dumping the json format notifications to syslog, standard
 output or a logfile.
 
 The objects to monitor and smart events to notify can be selected by
-setting options and/or the default configuration file
-(/etc/ndctl/monitor.conf). Both of the values in configuration file
-and in options will work. If there is a conflict, the values in
-options will override the values in configuration file. The changed
-values in configuration file will work after the monitor is restarted.
+setting options and/or the configuration file at
+{ndctl_monitorconfdir}/{ndctl_monitorconf}
+
+Both, the values in configuration file and in options will work. If
+there is a conflict, the values in options will override the values in
+the configuration file. Any updated values in the configuration file will
+take effect only after the monitor process is restarted.
 
 EXAMPLES
 --------
@@ -83,7 +87,7 @@ will not work if "--daemon" is specified.
 -c::
 --config-file=::
 	Provide the config file to use. This overrides the default config
-	typically found in /etc/ndctl/
+	typically found in {ndctl_monitorconfdir}
 
 --daemon::
 	Run a monitor as a daemon.
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
