Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E46D209831F7
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 16:00:15 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/4] ndctl,
 monitor: Add a config-file section to the man page
Date: Thu, 19 Jul 2018 16:59:55 -0600
Message-Id: <20180719225958.6814-2-vishal.l.verma@intel.com>
In-Reply-To: <20180719225958.6814-1-vishal.l.verma@intel.com>
References: <20180719225958.6814-1-vishal.l.verma@intel.com>
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

The ndctl monitor man page was missing documentation for the
--config-file option. Add it, explaining that the option overrides the
system default config file.

Fixes: 02ce9c6bab41 ("ndctl, documentation: add man page for monitor")
Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-monitor.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/ndctl/ndctl-monitor.txt b/Documentation/ndctl/ndctl-monitor.txt
index 872cd6e..762073e 100644
--- a/Documentation/ndctl/ndctl-monitor.txt
+++ b/Documentation/ndctl/ndctl-monitor.txt
@@ -69,6 +69,11 @@ OPTIONS
 --log=<file | syslog | standard>::
 	Output notifications to <file>, syslog or standard output.
 
+-c::
+--config-file=::
+	Provide the config file to use. This overrides the default config
+	typically found in /etc/ndctl/
+
 --daemon::
 	Run a monitor as a daemon.
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
