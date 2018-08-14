Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 495AD21962301
 for <linux-nvdimm@lists.01.org>; Tue, 14 Aug 2018 16:06:04 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/3] ndctl,
 monitor: Fix formatting for --log in the man page
Date: Tue, 14 Aug 2018 17:05:53 -0600
Message-Id: <20180814230555.3498-1-vishal.l.verma@intel.com>
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

Change the --log option to be similar to other options-with-arguments,
such as --map.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Fixes: 8d2d75f76f1e ("ndctl, monitor: set default log destination to syslog if...")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-monitor.txt | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
index 9a8d76b..363c398 100644
--- a/Documentation/ndctl/ndctl-monitor.txt
+++ b/Documentation/ndctl/ndctl-monitor.txt
@@ -65,20 +65,17 @@ OPTIONS
 	A 'namespaceX.Y' device name, or namespace region plus id tuple
 	'X.Y'.
 
--l <file | syslog | standard>::
---log=<file | syslog | standard>::
+-l::
+--log=::
 	Send log messages to the specified destination.
-+
---
-<file>::
-	Send log messages to specified <file>. When fopen() is not able
-	to open <file>, log messages will be forwarded to syslog.
-syslog::
-	Send messages to syslog.
-standard::
-	Send messages to standard output.
---
-+
+	- "<file>":
+	  Send log messages to specified <file>. When fopen() is not able
+	  to open <file>, log messages will be forwarded to syslog.
+	- "syslog":
+	  Send messages to syslog.
+	- "standard":
+	  Send messages to standard output.
+
 The default log destination is 'syslog' if "--daemon" is specified,
 otherwise 'standard'. Note that standard and relative path for <file>
 will not work if "--daemon" is specified.
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
