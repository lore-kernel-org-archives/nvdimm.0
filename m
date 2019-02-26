Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDAB8211CD9C0
 for <linux-nvdimm@lists.01.org>; Tue, 26 Feb 2019 15:13:40 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4] nvdimm, btt: fix LBA masking during 'free list' population
Date: Tue, 26 Feb 2019 16:13:31 -0700
Message-Id: <20190226231331.8730-1-vishal.l.verma@intel.com>
In-Reply-To: <CAPcyv4g_FJkDa+0M9p-JwkwLLCkSr=NEw=-GAYnJ0NDD7Sbk2g@mail.gmail.com>
References: <CAPcyv4g_FJkDa+0M9p-JwkwLLCkSr=NEw=-GAYnJ0NDD7Sbk2g@mail.gmail.com>
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
Cc: pbarbuda@microsoft.com
List-ID: <linux-nvdimm@lists.01.org>

The Linux BTT implementation assumes that log entries will never have
the 'zero' flag set, and indeed it never sets that flag for log entries
itself.

However, the UEFI spec is ambiguous on the exact format of the LBA field
of a log entry, specifically as to whether it should include the
additional flag bits or not. While a zero bit doesn't make sense in the
context of a log entry, other BTT implementations might still have it set.

If an implementation does happen to have it set, we would happily read
it in as the next block to write to for writes. Since a high bit is set,
it pushes the block number out of the range of an 'arena', and we fail
such a write with an EIO.

Follow the robustness principle, and tolerate such implementations by
stripping out the zero flag when populating the free list during
initialization. Additionally, use the same stripped out entries for
detection of incomplete writes and map restoration that happens at this
stage.

Add a sysfs file 'log_zero_flags' that indicates the ability to accept
such a layout to userspace applications. This enables 'ndctl
check-namespace' to recognize whether the kernel is able to handle zero
flags, or whether it should attempt a fix-up under the --repair option.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dexuan Cui <decui@microsoft.com>
Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v4: Have the sysfs attribute read a 'Y' to match boolean flag attributes

 drivers/nvdimm/btt.c      | 22 +++++++++++++++++-----
 drivers/nvdimm/btt_devs.c |  8 ++++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index cd4fa87ea48c..294c48e45e74 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -542,8 +542,8 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 static int btt_freelist_init(struct arena_info *arena)
 {
 	int new, ret;
-	u32 i, map_entry;
 	struct log_entry log_new;
+	u32 i, map_entry, log_oldmap, log_newmap;
 
 	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
 					GFP_KERNEL);
@@ -555,16 +555,21 @@ static int btt_freelist_init(struct arena_info *arena)
 		if (new < 0)
 			return new;
 
+		/* old and new map entries with any flags stripped out */
+		log_oldmap = ent_lba(le32_to_cpu(log_new.old_map));
+		log_newmap = ent_lba(le32_to_cpu(log_new.new_map));
+
 		/* sub points to the next one to be overwritten */
 		arena->freelist[i].sub = 1 - new;
 		arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
-		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
+		arena->freelist[i].block = log_oldmap;
 
 		/*
 		 * FIXME: if error clearing fails during init, we want to make
 		 * the BTT read-only
 		 */
 		if (ent_e_flag(log_new.old_map)) {
+			set_e_flag(arena->freelist[i].block);
 			ret = arena_clear_freelist_error(arena, i);
 			if (ret)
 				dev_err_ratelimited(to_dev(arena),
@@ -572,7 +577,7 @@ static int btt_freelist_init(struct arena_info *arena)
 		}
 
 		/* This implies a newly created or untouched flog entry */
-		if (log_new.old_map == log_new.new_map)
+		if (log_oldmap == log_newmap)
 			continue;
 
 		/* Check if map recovery is needed */
@@ -580,8 +585,15 @@ static int btt_freelist_init(struct arena_info *arena)
 				NULL, NULL, 0);
 		if (ret)
 			return ret;
-		if ((le32_to_cpu(log_new.new_map) != map_entry) &&
-				(le32_to_cpu(log_new.old_map) == map_entry)) {
+
+		/*
+		 * The map_entry from btt_read_map is stripped of any flag bits,
+		 * so use the stripped out versions from the log as well for
+		 * testing whether recovery is needed. For restoration, use the
+		 * 'raw' version of the log entries as that captured what we
+		 * were going to write originally.
+		 */
+		if ((log_newmap != map_entry) && (log_oldmap == map_entry)) {
 			/*
 			 * Last transaction wrote the flog, but wasn't able
 			 * to complete the map write. So fix up the map.
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 795ad4ff35ca..b72a303176c7 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -159,11 +159,19 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t log_zero_flags_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Y\n");
+}
+static DEVICE_ATTR_RO(log_zero_flags);
+
 static struct attribute *nd_btt_attributes[] = {
 	&dev_attr_sector_size.attr,
 	&dev_attr_namespace.attr,
 	&dev_attr_uuid.attr,
 	&dev_attr_size.attr,
+	&dev_attr_log_zero_flags.attr,
 	NULL,
 };
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
