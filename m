Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [RFC PATCH v2 3/3] dm: expand valid types for dm-ioctl
Date: Wed, 21 Nov 2018 11:27:02 +0800
Message-Id: <20181121032702.3048-4-yehs2007@zoho.com>
In-Reply-To: <20181121032702.3048-1-yehs2007@zoho.com>
References: <20181121032702.3048-1-yehs2007@zoho.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dan.j.williams@intel.com, willy@infradead.org, zwisler@kernel.org, jack@suse.cz, dave.jiang@intel.com, vishal.l.verma@intel.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, chengnt@lenovo.com, Huaisheng Ye <yehs1@lenovo.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

If use DAX way to mount the origin device of dm_snapshot, when
merging back snapshot to origin, system call table_load during the
construction of snapshot-merge will try to detect new dm_table's type
equals to the existed md's type or not.
The existed type equals to DM_TYPE_DAX_BIO_BASED, but the new created
type belongs to DM_TYPE_BIO_BASED. So, we need to expand valid_type in
function is_valid_type.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a27016e..158d657 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1295,7 +1295,8 @@ static int populate_table(struct dm_table *table,
 static bool is_valid_type(enum dm_queue_mode cur, enum dm_queue_mode new)
 {
 	if (cur == new ||
-	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
+	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED) ||
+	    (cur == DM_TYPE_DAX_BIO_BASED && new == DM_TYPE_BIO_BASED))
 		return true;
 
 	return false;
-- 
1.8.3.1
