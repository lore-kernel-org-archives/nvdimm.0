Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2CACA21161690
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 20:31:50 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/5] util/json: fix an error check for region resource
Date: Mon,  1 Oct 2018 21:31:38 -0600
Message-Id: <20181002033140.21295-3-vishal.l.verma@intel.com>
In-Reply-To: <20181002033140.21295-1-vishal.l.verma@intel.com>
References: <20181002033140.21295-1-vishal.l.verma@intel.com>
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

The return type of ndctl_region_get_resource() is 'unsigned long long',
and therefore the error checking for it should be done against
ULLONG_MAX. Fix an instance where we were checking against ULONG_MAX.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/json.c b/util/json.c
index 2d15859..30b56c3 100644
--- a/util/json.c
+++ b/util/json.c
@@ -470,7 +470,7 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 		/* get start address of region */
 		addr = ndctl_region_get_resource(region);
-		if (addr == ULONG_MAX)
+		if (addr == ULLONG_MAX)
 			goto err_array;
 
 		/* get address of bad block */
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
