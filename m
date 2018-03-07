Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B3EF21ED1C68
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 09:56:28 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] ndctl: don't print erroneous namespace numa_nodes
Date: Wed,  7 Mar 2018 11:02:35 -0700
Message-Id: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
List-ID: <linux-nvdimm@lists.01.org>

If the kernel has CONFIG_NUMA unset namespaces in sysfs will lack a
numa_node attribute.  In such cases ndctl will report a value of 0 for the
namespace numa_node in 'ndctl list'.  Instead of reporting potentially bad
data just hide the numa_node field if it is unsupported.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit f7d3de80a121 ("ndctl: support machines without numa")
---
 ndctl/lib/libndctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ed5a65b..b7180e8 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3008,6 +3008,8 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
 	sprintf(path, "%s/numa_node", ndns_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		ndns->numa_node = strtol(buf, NULL, 0);
+	else
+		ndns->numa_node = -1;
 
 	sprintf(path, "%s/holder_class", ndns_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
