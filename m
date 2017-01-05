Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2ABEE81957
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jan 2017 16:20:04 -0800 (PST)
Subject: [ndctl PATCH] ndctl: support machines without numa
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jan 2017 16:15:57 -0800
Message-ID: <148357532903.9100.4272827749663933501.stgit@dwillia2-desk3.amr.corp.intel.com>
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

From: Diego Dompe <dompe@hpe.com>

Currently when using ndctl in machines that do not have numa, the ndctl
command fails because it fails to find the numa_node attribute in
systems.

Just assume the default, zero, in these cases rather than fail.

Link: https://github.com/pmem/ndctl/pull/9
[djbw: minor style fixups]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Diego, if this reworked version looks good to you I'll add your
"Signed-off-by: Diego Dompe <dompe@hpe.com>" to the tags. Let me know.
Thanks for the fix!

 ndctl/lib/libndctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ea3111eb6c93..8240235dff5c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2780,9 +2780,8 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
 	ndns->raw_mode = strtoul(buf, NULL, 0);
 
 	sprintf(path, "%s/numa_node", ndns_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	ndns->numa_node = strtol(buf, NULL, 0);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		ndns->numa_node = strtol(buf, NULL, 0);
 
 	switch (ndns->type) {
 	case ND_DEVICE_NAMESPACE_BLK:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
