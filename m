Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74C9B21CAD998
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 15:56:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/5] libndctl: fix a resource leak in
 ndctl_dimm_get_{{event_}flags, health}
Date: Fri, 10 Aug 2018 16:56:22 -0600
Message-Id: <20180810225624.32383-4-vishal.l.verma@intel.com>
In-Reply-To: <20180810225624.32383-1-vishal.l.verma@intel.com>
References: <20180810225624.32383-1-vishal.l.verma@intel.com>
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

Static analysis reports that we leak ndctl_cmd in the above functions.
Fix by adding proper cleanup paths.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Fixes: fdf6b6844ccf ("ndctl, monitor: add a new command - monitor")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ab47b27..226a577 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1649,6 +1649,7 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_health(struct ndctl_dimm *dimm)
 	}
 	if (ndctl_cmd_submit(cmd)) {
 		err(ctx, "%s: smart command failed\n", devname);
+		ndctl_cmd_unref(cmd);
 		return UINT_MAX;
 	}
 
@@ -1671,6 +1672,7 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_flags(struct ndctl_dimm *dimm)
 	}
 	if (ndctl_cmd_submit(cmd)) {
 		dbg(ctx, "%s: smart command failed\n", devname);
+		ndctl_cmd_unref(cmd);
 		return UINT_MAX;
 	}
 
@@ -1700,6 +1702,7 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_event_flags(struct ndctl_dimm *dimm)
 	}
 	if (ndctl_cmd_submit(cmd)) {
 		err(ctx, "%s: smart command failed\n", devname);
+		ndctl_cmd_unref(cmd);
 		return UINT_MAX;
 	}
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
