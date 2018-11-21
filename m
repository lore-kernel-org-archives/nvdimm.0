Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [RFC PATCH v2 2/3] dm: expand hc_map in mapped_device for lack of map
Date: Wed, 21 Nov 2018 11:27:01 +0800
Message-Id: <20181121032702.3048-3-yehs2007@zoho.com>
In-Reply-To: <20181121032702.3048-1-yehs2007@zoho.com>
References: <20181121032702.3048-1-yehs2007@zoho.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dan.j.williams@intel.com, willy@infradead.org, zwisler@kernel.org, jack@suse.cz, dave.jiang@intel.com, vishal.l.verma@intel.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, chengnt@lenovo.com, Huaisheng Ye <yehs1@lenovo.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Sometimes dm_swap_table couldn't be used in time.

For example, during the origin construction of
dm-snapshot, the sys_ioctl table_load will try to
detect the lower device origin-real whether support
direct access or not. But origin-real md's struct
dm-table pointer has not yet been assigned real address
in time by dev_suspend.

So I expand hc_map for get the address from struct
hash_cell directly in this case.

Here is the call trace, dm_dax_direct_access will call
dm_dax_get_live_target for get the struct dm_table pointer.

[  213.975827] Call Trace:
[  213.975832]  dump_stack+0x5a/0x73
[  213.975840]  dm_dax_direct_access+0x12b/0x1b0 [dm_mod]
[  213.975845]  dax_direct_access+0x2d/0x60
[  213.975848]  __bdev_dax_supported+0x162/0x2a0
[  213.975851]  ? dump_stack+0x5a/0x73
[  213.975859]  device_supports_dax+0x15/0x20 [dm_mod]
[  213.975867]  dm_table_supports_dax.isra.13+0x7d/0xa0 [dm_mod]
[  213.975875]  dm_table_complete+0x3fb/0x750 [dm_mod]
[  213.975883]  table_load+0x19a/0x390 [dm_mod]
[  213.975891]  ? retrieve_status+0x1c0/0x1c0 [dm_mod]
[  213.975898]  ctl_ioctl+0x1d8/0x450 [dm_mod]
[  213.975909]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[  213.975913]  do_vfs_ioctl+0xa9/0x620
[  213.975918]  ? syscall_trace_enter+0x1c9/0x2b0
[  213.975923]  ksys_ioctl+0x60/0x90
[  213.975927]  __x64_sys_ioctl+0x16/0x20
[  213.975931]  do_syscall_64+0x5b/0x180
[  213.975936]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-core.h  |  1 +
 drivers/md/dm-ioctl.c |  1 +
 drivers/md/dm.c       | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 224d445..5577d90 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -40,6 +40,7 @@ struct mapped_device {
 	 * dereference.
 	 */
 	void __rcu *map;
+	struct dm_table *hc_map;
 
 	unsigned long flags;
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f666778..a27016e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1365,6 +1365,7 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (hc->new_map)
 		old_map = hc->new_map;
 	hc->new_map = t;
+	hc->md->hc_map = hc->new_map;
 	up_write(&_hash_lock);
 
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c510179..19b48bb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1080,6 +1080,21 @@ static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
 	struct dm_target *ti;
 
 	map = dm_get_live_table(md, srcu_idx);
+	if (!map) {
+		/* Sometimes dm_swap_table couldn't be used in time.
+		 *
+		 * For example, during the origin construction of
+		 * dm-snapshot, the sys_ioctl table_load will try to
+		 * detect the lower device origin-real whether support
+		 * direct access or not. But origin-real device md's struct
+		 * dm-table pointer has not yet been assigned real address.
+		 * So hc_map has been used for get the address from
+		 * struct hash_cell directly.
+		 */
+		DMINFO("failed to get map, use hc_map insteadly");
+		map = md->hc_map;
+	}
+
 	if (!map)
 		return NULL;
 
-- 
1.8.3.1
