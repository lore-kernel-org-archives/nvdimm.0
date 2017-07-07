Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F25921CF25A6
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 16:51:48 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] libnvdimm: fix badblock range handling of ARS range
Date: Fri,  7 Jul 2017 17:44:26 -0600
Message-Id: <20170707234426.25136-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

__add_badblock_range() does not account sector alignment when
it sets 'num_sectors'.  Therefore, an ARS error record range
spanning across two sectors is set to a single sector length,
which leaves the 2nd sector unprotected.

Change __add_badblock_range() to set 'num_sectors' properly.

Fixes: 0caeef63e6d2f866d85bb507bf63e0ce8ec91cef
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/nvdimm/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 2dee908..932c3994 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -421,14 +421,15 @@ static void set_badblock(struct badblocks *bb, sector_t s, int num)
 static void __add_badblock_range(struct badblocks *bb, u64 ns_offset, u64 len)
 {
 	const unsigned int sector_size = 512;
-	sector_t start_sector;
+	sector_t start_sector, end_sector;
 	u64 num_sectors;
 	u32 rem;
 
 	start_sector = div_u64(ns_offset, sector_size);
-	num_sectors = div_u64_rem(len, sector_size, &rem);
+	end_sector = div_u64_rem(ns_offset + len, sector_size, &rem);
 	if (rem)
-		num_sectors++;
+		end_sector++;
+	num_sectors = end_sector - start_sector;
 
 	if (unlikely(num_sectors > (u64)INT_MAX)) {
 		u64 remaining = num_sectors;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
