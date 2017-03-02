Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D78A821F5
 for <linux-nvdimm@lists.01.org>; Thu,  2 Mar 2017 14:18:12 -0800 (PST)
Subject: [PATCH] ndctl, create-namespace: include dax info in operation result
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 02 Mar 2017 14:13:00 -0800
Message-ID: <148849278046.1340.5376913871314870093.stgit@dwillia2-desk3.amr.corp.intel.com>
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

When modifying or creating a namespace in "dax" mode, include the
device-dax information so that resulting character device is included in
the output.

Before:
# ndctl create-namespace --reconfig=namespace1.0 --mode=dax --force
{
  "dev":"namespace1.0",
  "mode":"dax",
  "size":4225761280,
  "uuid":"55082055-70f8-40eb-b131-d59f6f537df5"
}

After:
# ndctl create-namespace --reconfig=namespace1.0 --mode=dax --force
{
  "dev":"namespace1.0",
  "mode":"dax",
  "size":4225761280,
  "uuid":"1ccc310a-04af-4a57-88a4-6011c2825b95",
  "daxregion":{
    "id":1,
    "size":4225761280,
    "align":2097152,
    "devices":[
      {
        "chardev":"dax1.0",
        "size":4225761280
      }
    ]
  }
}

Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 46d651e86153..05575c50446d 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -361,7 +361,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		struct json_object *jndns = util_namespace_to_json(ndns, 0, 0);
+		struct json_object *jndns = util_namespace_to_json(ndns, 0, 1);
 
 		if (jndns)
 			printf("%s\n", json_object_to_json_string_ext(jndns,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
