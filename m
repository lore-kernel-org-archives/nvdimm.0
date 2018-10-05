Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A22A221161B0A
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 17:01:07 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl, monitor: in daemon mode,
 exit successfully if no DIMMs are found
Date: Thu,  4 Oct 2018 18:00:57 -0600
Message-Id: <20181005000057.30186-2-vishal.l.verma@intel.com>
In-Reply-To: <20181005000057.30186-1-vishal.l.verma@intel.com>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
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
Cc: Andreas Hasenack <andreas@canonical.com>
List-ID: <linux-nvdimm@lists.01.org>

When we are running as a daemon, it is preferred to exit successfully
when no DIMMs are found. When running in the foreground, retain an error
return so that the user can be notified that nothing was found to
monitor.

In the longer term, replace this with a libudev uevent monitor that will
look for DIMM addition/removal events, and update the running monitor(s)
if the DIMMs match the active filter spec.

Link: https://bugs.launchpad.net/ubuntu/+source/ndctl/+bug/1781268
Reported-by: Andreas Hasenack <andreas@canonical.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index b44f946..7bf2ba7 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -681,8 +681,9 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
 		goto out;
 
 	if (!mfa.num_dimm) {
-		err((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
-		rc = -ENXIO;
+		dbg((struct ndctl_ctx *)ctx, "no dimms to monitor\n");
+		if (!monitor.daemon)
+			rc = -ENXIO;
 		goto out;
 	}
 
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
