Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A39E1212E259E
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:58:18 -0700 (PDT)
Subject: [ndctl PATCH v2 25/26] ndctl/namespace: Continue region search on
 'missing seed' event
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:41:34 -0700
Message-ID: <156426369414.531577.11315264374951747460.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Consider a scenario where one region is in an error state but another is
not:

    # ndctl list -Ru
    [
      {
        "dev":"region3",
        "size":"127.00 GiB (136.37 GB)",
        "available_size":0,
        "max_available_extent":0,
        "type":"pmem",
        "persistence_domain":"unknown"
      },
      {
        "dev":"region2",
        "size":"127.00 GiB (136.37 GB)",
        "available_size":"127.00 GiB (136.37 GB)",
        "max_available_extent":"127.00 GiB (136.37 GB)",
        "type":"pmem",
        "iset_id":"0xba90120012b4dc",
        "persistence_domain":"unknown"
      }
    ]

    # ndctl create-namespace -m devdax -v
    [..]
    namespace_create:887: region3: no idle namespace seed
    failed to create namespace: No such device

Instead of failing when probing region3 for capacity, fallback to
region2.

    # ndctl create-namespace -m devdax
    {
      "dev":"namespace2.0",
      "mode":"devdax",
      "map":"dev",
      "size":"125.01 GiB (134.23 GB)",
      "uuid":"c3fa7d2f-6c20-4762-9aa8-627d06275e03",
      "daxregion":{
        "id":2,
        "size":"125.01 GiB (134.23 GB)",
        "align":2097152,
        "devices":[
          {
            "chardev":"dax2.0",
            "size":"125.01 GiB (134.23 GB)"
          }
        ]
      },
      "align":2097152
    }

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index f215f77a94e1..bbc9107c6baa 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -867,7 +867,7 @@ static int namespace_create(struct ndctl_region *region)
 	if (!ndns || is_namespace_active(ndns)) {
 		debug("%s: no %s namespace seed\n", devname,
 				ndns ? "idle" : "available");
-		return -ENODEV;
+		return -EAGAIN;
 	}
 
 	rc = setup_namespace(region, ndns, &p);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
