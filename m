Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3FB1221A2B9A
 for <linux-nvdimm@lists.01.org>; Thu, 14 Dec 2017 16:21:39 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 1/2] libnvdimm, btt: add a couple of missing kernel-doc lines
Date: Thu, 14 Dec 2017 17:26:13 -0700
Message-Id: <20171215002614.25335-1-vishal.l.verma@intel.com>
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

Recent updates to btt.h neglected to add corresponding kernel-doc lines
for new structure members. Add them.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 578c2057524d..884fbbbdd18a 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -125,6 +125,7 @@ struct aligned_lock {
  * @list:		List head for list of arenas
  * @debugfs_dir:	Debugfs dentry
  * @flags:		Arena flags - may signify error states.
+ * @err_lock:		Mutex for synchronizing error clearing.
  *
  * arena_info is a per-arena handle. Once an arena is narrowed down for an
  * IO, this struct is passed around for the duration of the IO.
@@ -176,6 +177,7 @@ struct arena_info {
  * @init_lock:		Mutex used for the BTT initialization
  * @init_state:		Flag describing the initialization state for the BTT
  * @num_arenas:		Number of arenas in the BTT instance
+ * @phys_bb:		Pointer to the namespace's badblocks structure
  */
 struct btt {
 	struct gendisk *btt_disk;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
