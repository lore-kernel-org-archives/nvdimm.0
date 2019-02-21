Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 21 Feb 2019 09:23:53 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] libnvdimm, region: use struct_size() in kzalloc()
Message-ID: <20190221152353.GA14585@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <linux-nvdimm@lists.01.org>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

instance = kzalloc(sizeof(struct foo) + count * sizeof(struct boo), GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/nvdimm/region_devs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e2818f94f292..d36cb5df9683 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1020,10 +1020,9 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		}
 		region_buf = ndbr;
 	} else {
-		nd_region = kzalloc(sizeof(struct nd_region)
-				+ sizeof(struct nd_mapping)
-				* ndr_desc->num_mappings,
-				GFP_KERNEL);
+		nd_region = kzalloc(struct_size(nd_region, mapping,
+				    ndr_desc->num_mappings),
+				    GFP_KERNEL);
 		region_buf = nd_region;
 	}
 
-- 
2.20.1
