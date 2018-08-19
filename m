Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C2BF210EE4F8
 for <linux-nvdimm@lists.01.org>; Sat, 18 Aug 2018 21:01:40 -0700 (PDT)
Received: by mail-qt0-x243.google.com with SMTP id m13-v6so12952458qth.1
 for <linux-nvdimm@lists.01.org>; Sat, 18 Aug 2018 21:01:40 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH] libnvdimm,
 region_devs: stop NDD_ALIASING bit test if one test pass
Date: Sun, 19 Aug 2018 00:01:28 -0400
Message-Id: <1534651288-30306-1-git-send-email-oceanhehy@gmail.com>
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
have the same flags.

Because the check of alias is "if (alias)" but not 
"if (alias == nd_region->ndr_mappings)", there is no function change while
just save a few cycles.  

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
A test to check if all the nd_mapping->nvdimm have the same flags, using 
Lenovo ThinkSystem SR630 and 4.18-rc6.

# ipmctl show -dimm

DimmID  Capacity        HealthState     ActionRequired  LockState       FWVersion
0x0021  125.7 GiB       Healthy         0               Disabled        01.00.00.4888
0x0121  125.7 GiB       Healthy         0               Disabled        01.00.00.4888
0x1021  125.7 GiB       Healthy         0               Disabled        01.00.00.4888
0x1121  125.7 GiB       Healthy         0               Disabled        01.00.00.4888

# ipmctl create -f -goal -socket 0x0 PersistentMemoryType=AppDirect

# ipmctl create -f -goal -socket 0x1 PersistentMemoryType=AppDirect

# reboot, to make goal configuration take effect.

# ndctl create-namespace -r region0 -s 100m -t pmem -m fsdax

# ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax

# reboot and find all the nd_mapping->nvdimm have the same flags.

 drivers/nvdimm/region_devs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ec3543b..fc3bc1c 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -234,8 +234,10 @@ int nd_region_to_nstype(struct nd_region *nd_region)
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 			struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
-			if (test_bit(NDD_ALIASING, &nvdimm->flags))
+			if (test_bit(NDD_ALIASING, &nvdimm->flags)) {
 				alias++;
+				break;
+			}
 		}
 		if (alias)
 			return ND_DEVICE_NAMESPACE_PMEM;
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
