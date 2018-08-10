Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BD8B210ED0ED
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 15:56:32 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 5/5] ndctl,
 test: fix a resource leak in check_smart_threshold
Date: Fri, 10 Aug 2018 16:56:24 -0600
Message-Id: <20180810225624.32383-6-vishal.l.verma@intel.com>
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

Static analysis reports that we leak ndctl_cmd in the above function.
Fix by adding the cmd_unref to the exit path in the
__check_smart_threshold macro.

Cc: Dan Williams <dan.j.williams@intel.com>
Fixes: 7fa8a6af6917 ("test, libndctl: fix SMART test assumptions")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/libndctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index edff0af..e36c1fb 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2250,6 +2250,7 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 				ndctl_dimm_get_handle(dimm), \
 				smart_t_data.field, \
 				ndctl_cmd_smart_threshold_get_##field(cmd)); \
+		ndctl_cmd_unref(cmd_set); \
 		ndctl_cmd_unref(cmd); \
 		return -ENXIO; \
 	} \
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
