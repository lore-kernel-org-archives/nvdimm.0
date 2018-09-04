Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com
 [IPv6:2607:f8b0:4864:20::541])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F176521A09130
 for <linux-nvdimm@lists.01.org>; Tue,  4 Sep 2018 03:47:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f4-v6so1483441pgq.5
 for <linux-nvdimm@lists.01.org>; Tue, 04 Sep 2018 03:47:55 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH v2] libnvdimm,
 region_devs: stop NDD_ALIASING bit test if one test pass
Date: Tue,  4 Sep 2018 06:47:42 -0400
Message-Id: <1536058062-18894-1-git-send-email-oceanhehy@gmail.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

There is no need to finish entire loop to execute NDD_ALIASING bit test
against every nvdimm->flags. In practice, all the nd_mapping->nvdimm
have the same flags. So it's safe to return ND_DEVICE_NAMESPACE_PMEM
if the NDD_ALIASING bit is found inside the loop, while saving a few
cpu cycles.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
v1: https://lkml.org/lkml/2018/8/19/4
v2: Per Vishal's comments in patch v1, remove 'alias' variable. 
In the loop, just return ND_DEVICE_NAMESPACE_PMEM if the NDD_ALIASING bit is
found for any mapping. 
Outside the loop, simply return ND_DEVICE_NAMESPACE_IO. 

The following test pass on Lenovo ThinkSystem SR630 based on 4.19-rc1.
# ndctl create-namespace -r region0 -s 1g -t pmem -m fsdax
# ndctl create-namespace -r region0 -s 1g -t pmem -m sector
# ndctl create-namespace -r region0 -s 1g -t pmem -m devdax
# ndctl list
[
  {
    "dev":"namespace0.2",
    "mode":"devdax",
    "map":"dev",
    "size":1054867456,
    "uuid":"fc3a2126-9b8e-4ab4-baa4-a3ec7f62a326",
    "raw_uuid":"eadc6965-daee-48c5-a0ae-1865ee0c8573",
    "chardev":"dax0.2",
    "numa_node":0
  },
  {
    "dev":"namespace0.1",
    "mode":"sector",
    "size":1071616000,
    "uuid":"0d81d040-93a1-45c6-9791-3dbb7b5f89d2",
    "raw_uuid":"2b1b29e6-0510-4dcf-9902-43b77ccb9df5",
    "sector_size":4096,
    "blockdev":"pmem0.1s",
    "numa_node":0
  },
  {
    "dev":"namespace0.0",
    "mode":"fsdax",
    "map":"dev",
    "size":1054867456,
    "uuid":"cbff92ed-cd45-4d24-9353-7a56d42122b1",
    "raw_uuid":"f6ea1001-5ef0-4942-889a-99005079ab5d",
    "sector_size":512,
    "blockdev":"pmem0",
    "numa_node":0
  }
]

# reboot and OS could boot up normally
# ndctl destroy-namespace namespace0.2 -f
# ndctl destroy-namespace namespace0.1 -f
# ndctl destroy-namespace namespace0.0 -f

 drivers/nvdimm/region_devs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index fa37afc..16ee153 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -228,19 +228,18 @@ void nd_blk_region_set_provider_data(struct nd_blk_region *ndbr, void *data)
 int nd_region_to_nstype(struct nd_region *nd_region)
 {
 	if (is_memory(&nd_region->dev)) {
-		u16 i, alias;
+		u16 i;
 
-		for (i = 0, alias = 0; i < nd_region->ndr_mappings; i++) {
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 			struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
 			if (test_bit(NDD_ALIASING, &nvdimm->flags))
-				alias++;
+				return ND_DEVICE_NAMESPACE_PMEM;
 		}
-		if (alias)
-			return ND_DEVICE_NAMESPACE_PMEM;
-		else
-			return ND_DEVICE_NAMESPACE_IO;
+
+		return ND_DEVICE_NAMESPACE_IO;
+
 	} else if (is_nd_blk(&nd_region->dev)) {
 		return ND_DEVICE_NAMESPACE_BLK;
 	}
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
