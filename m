Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8550C209589C8
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 14:18:15 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] ndctl, util: in util_namespace_to_json,
 initialize bb_count to 0
Date: Thu,  3 Aug 2017 15:18:35 -0600
Message-Id: <20170803211835.18988-1-vishal.l.verma@intel.com>
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

If in the util_namespace_to_json -> dev_badblocks_to_json call chain, if
anything errors out before setting bb_count, bb_count will have an
uninitialized, random value.

This happens during namespace creation, as the namespaceX.Y/resource is
not available (as the namespace is disabled), and the various
util_<mode>_badblocks_to_json helpers fail due to a missing resource.

$ ndctl create-namespace --type=pmem --mode=sector
{
  "dev":"namespace7.0",
  "mode":"sector",
  "size":"62.91 MiB (65.97 MB)",
  "uuid":"ca26fe8e-3f9a-4e3f-bfb0-1e34714996a4",
  "sector_size":4096,
  "blockdev":"pmem7s",
  "badblock_count":22
}

$ ndctl list --namespace=namespace7.0
{
  "dev":"namespace7.0",
  "mode":"sector",
  "size":65966080,
  "uuid":"ca26fe8e-3f9a-4e3f-bfb0-1e34714996a4",
  "sector_size":4096,
  "blockdev":"pmem7s",
  "badblock_count":8
}

Fix this by initializing bb_count to 0.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/json.c b/util/json.c
index 80512bd..59bd272 100644
--- a/util/json.c
+++ b/util/json.c
@@ -541,7 +541,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	unsigned long long size = ULLONG_MAX;
 	enum ndctl_namespace_mode mode;
 	const char *bdev = NULL;
-	unsigned int bb_count;
+	unsigned int bb_count = 0;
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
 	struct ndctl_dax *dax;
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
