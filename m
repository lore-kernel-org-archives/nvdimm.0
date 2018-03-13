Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34B7221E49053
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 13:23:53 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, list: fix namespace json object parenting
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Mar 2018 13:21:09 -0700
Message-ID: <152097246946.29587.17095835339672187253.stgit@dwillia2-desk3.amr.corp.intel.com>
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

When listing namespaces and regions a generic jplatform object is
created to house the regions array. However, commit f8cc6fee4e4d "ndctl,
list: refactor core topology walking into util_filter_walk()"
inadvertently added namespaces to that jplatform. Namespaces should only
be added to jplatform in the case when regions are not being listed.
Otherwise we get duplicated output and a double-put assertion as seen
below:

    # ndctl list -RNu
    {
      "regions":[
        {
          "dev":"region1",
          "size":"511.00 GiB (548.68 GB)",
          "available_size":0,
          "type":"pmem",
          "numa_node":0,
          "namespaces":[
            {
              "dev":"namespace1.0",
              "mode":"raw",
              "size":"511.00 GiB (548.68 GB)",
              "sector_size":512,
              "blockdev":"pmem1",
              "numa_node":0
            },
            {
              "dev":"namespace0.0",
              "mode":"fsdax",
              "size":"4.00 GiB (4.29 GB)",
              "sector_size":512,
              "blockdev":"pmem0",
              "numa_node":0
            }
          ]
        },
        {
          "dev":"region0",
          "size":"4.00 GiB (4.29 GB)",
          "available_size":0,
          "type":"pmem"
        }
      ],
      "namespaces":[
        {
          "dev":"namespace1.0",
          "mode":"raw",
          "size":"511.00 GiB (548.68 GB)",
          "sector_size":512,
          "blockdev":"pmem1",
          "numa_node":0
        },
        {
          "dev":"namespace0.0",
          "mode":"fsdax",
          "size":"4.00 GiB (4.29 GB)",
          "sector_size":512,
          "blockdev":"pmem0",
          "numa_node":0
        }
      ]
    }
    ndctl: json_object.c:188: json_object_put: Assertion `jso->_ref_count > 0' failed.
    Aborted (core dumped)

Fixes: f8cc6fee4e4d(" ndctl, list: refactor core topology walking...")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/list.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 0ca5b6dee5eb..0683bc8d6174 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -366,7 +366,7 @@ static int list_display(struct list_filter_arg *lfa)
 			json_object_object_add(jplatform, "dimms", jdimms);
 		if (jregions)
 			json_object_object_add(jplatform, "regions", jregions);
-		if (jnamespaces)
+		if (jnamespaces && !jregions)
 			json_object_object_add(jplatform, "namespaces",
 					jnamespaces);
 		printf("%s\n", json_object_to_json_string_ext(jplatform,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
