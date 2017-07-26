Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37C9F21D0FE0B
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 16:35:40 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 3/6] btt: ensure that flags were also unchanged during a
 map_read
Date: Wed, 26 Jul 2017 17:35:43 -0600
Message-Id: <20170726233546.29052-4-vishal.l.verma@intel.com>
In-Reply-To: <20170726233546.29052-1-vishal.l.verma@intel.com>
References: <20170726233546.29052-1-vishal.l.verma@intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In btt_map_read, we read the map twice to make sure that the map entry
didn't change after we added it to the read tracking table. In
anticipation of expanding the use of the error bit, also make sure that
the error and zero flags are constant across the two map reads.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 8842baa..374ae62 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1032,6 +1032,7 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		 */
 		while (1) {
 			u32 new_map;
+			int new_t, new_e;
 
 			if (t_flag) {
 				zero_fill_data(page, off, cur_len);
@@ -1050,15 +1051,18 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			 */
 			barrier();
 
-			ret = btt_map_read(arena, premap, &new_map, &t_flag,
-						&e_flag, NVDIMM_IO_ATOMIC);
+			ret = btt_map_read(arena, premap, &new_map, &new_t,
+						&new_e, NVDIMM_IO_ATOMIC);
 			if (ret)
 				goto out_rtt;
 
-			if (postmap == new_map)
+			if ((postmap == new_map) && (t_flag == new_t) &&
+					(e_flag == new_e))
 				break;
 
 			postmap = new_map;
+			t_flag = new_t;
+			e_flag = new_e;
 		}
 
 		ret = btt_data_read(arena, page, off, postmap, cur_len);
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
