Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CD55210ED103
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 17:40:58 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl: fix potential null dereference in the smart
 error handler
Date: Fri, 10 Aug 2018 18:40:52 -0600
Message-Id: <20180811004053.15392-1-vishal.l.verma@intel.com>
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

Static analysis reports that can potentially dereference a NULL pointer
in the smart cmd error handler. This can particular instance won't ever
be hit in practice as the handler is only registered for smart commands,
and smart commands are currently only DIMM commands, and will always
have a dimm object. However for completeness, and to avoid future
errors, we should perform a NULL check in the handler anyway.

Cc: Keith Busch <keith.busch@intel.com>
Fixes: ba17700bf227 ("ndctl, intel: Fallback to smart cached shutdown_count")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 00c65a5..b1254bb 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -67,6 +67,9 @@ static int intel_smart_handle_error(struct ndctl_cmd *cmd)
 	char *path = NULL, shutdown_count[16] = {};
 	int fd, rc = cmd->status;
 
+	if (!dimm)
+		return 0;
+
 	if (asprintf(&path, DEF_TMPFS_DIR "/%s/usc",
 		     ndctl_dimm_get_devname(dimm)) < 0)
 		return rc;
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
