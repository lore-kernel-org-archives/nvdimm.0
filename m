Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF7937648F;
	Sun,  9 Aug 2026 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786299708; cv=none; b=s/PKJBT0FVL93hPj4FsQbpL/BJmKzUEkddK6hB1+Rf99lURdMBNWVpEmjIhq4oslJn6AH3HvXQz5QWTsihvBr55Zn3mBM/f9lIbuFKWnBy72ITj2f5gsArbCPfcRFjj6kzcZRchIu5885npfiSWeSINwWDkky3huPJlBPZ/b1bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786299708; c=relaxed/simple;
	bh=J+30Nzlnc59X91Bo0RHuiOtOVXbqmP/Ow6OyZxvLSFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pTYHwZQywUMu+oPk8iRVtOTZDoiOwvbwcZyM4LU7V9e1JRQwvVgheAWXrgf9kf/6vAhJaoboIXejoRBcgG0m5w3IaUU4ZqKV4E3YoiiY4XZbHM/dgEKi3XY7542MlfqbBFXioa8hROH2b24B/OPLNnBIDt5s8i8TpFHfuOdOUR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=XF9w49Jg; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="XF9w49Jg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786299706; x=1817835706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ZohG5gy9QOsMsldJtnm8SZT4TUIYoDQX1T75IzNTaY=;
  b=XF9w49Jg0TUatCyo0JtIexDXOEdK/ZRpaenKjeAn87qrOXmaoJm1bbl7
   Ojpgw5a1pSOhP8BZ7GultCHpBq9RuvySKIdUkXM+6MWcrfVOMEdIfRF1N
   ipubHqzACmzv2H4vtZHXMbwe3oOZxtBObRo6ROIeSTxv7uPuuFIrRX1mH
   ZE5QayMST0npRvA61ikyeNmV7DG4AFagesSh9xvbrMQTOmja780ODKLXm
   BWyZBbP2dFdBpkjGGa8kNE4DLqOu4Dq4MB/gZGK8fHl7ivdKB8SgsVHAW
   Bf6ArCDR7mYZbQTy9mBYp4p+rILBzSqyHOBgEa9cIX/JvxNcXq4ST9dqJ
   Q==;
X-CSE-ConnectionGUID: MAxwrWlMTqK30MRFk/cRJw==
X-CSE-MsgGUID: p2nOzCqUTeSBkNvs1LVtow==
X-IronPort-AV: E=Sophos;i="6.25,214,1779148800"; 
   d="scan'208";a="25317679"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2026 18:21:42 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:26917]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.172:2525] with esmtp (Farcaster)
 id cdbce74b-36db-44c6-840a-130baee747a8; Sun, 9 Aug 2026 18:21:42 +0000 (UTC)
X-Farcaster-Flow-ID: cdbce74b-36db-44c6-840a-130baee747a8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Sun, 9 Aug 2026 18:21:42 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Sun, 9 Aug 2026 18:21:39 +0000
From: Alexander Graf <graf@amazon.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>
CC: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?=
	<eperezma@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, <virtualization@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, <linux-block@vger.kernel.org>, David Airlie
	<airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Dmitry Osipenko
	<dmitry.osipenko@collabora.com>, <dri-devel@lists.freedesktop.org>, "Pankaj
 Gupta" <pankaj.gupta.linux@gmail.com>, <nvdimm@lists.linux.dev>,
	<nh-open-source@amazon.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
Subject: [RFC PATCH 11/12] virtio: expose device memory buffer occupancy over debugfs
Date: Sun, 9 Aug 2026 18:20:09 +0000
Message-ID: <20260809182010.32931-12-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260809182010.32931-1-graf@amazon.com>
References: <20260809182010.32931-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Running out of room in the pool is routine for a device with a bounded
one: vring_map_errno() reports it as the -ENOSPC a full queue reports,
so the driver retries and carries on. The allocator must not log that at
any level a working device prints, or an undersized region turns into a
log flood. That leaves an operator nothing but unexplained throughput
loss to go on.

swiotlb can afford dev_warn_ratelimited() because exhaustion there is a
misconfiguration, and it exports io_tlb_used and io_tlb_used_hiwater
through debugfs, which a log line cannot do for a sampled quantity.
Follow it, plus one file swiotlb has no need for:

  dmb/pages              pages the allocator can hand out
  dmb/areas              pool areas the pool is divided into
  dmb/area_pages         pages one pool area covers
  dmb/used_pages         pages allocated now
  dmb/used_pages_hiwater the largest used_pages has been
  dmb/alloc_failed       buffer mappings the pool had no room for

used_pages_hiwater is the number to size a region against, because a
burst that fills the pool between two samples of used_pages leaves no
other trace. Writing 0 restarts the measurement from the occupancy now,
so a peak never reads below the used_pages read alongside it.

alloc_failed counts only the mapping path, so that a virtqueue area
rejected during vring_alloc_queue_split()'s search for a size that fits
does not make a correctly sized region look undersized.

There is no sysfs file, because a sysfs attribute is ABI and nothing
here should be. Every file and every counter behind one sits
under CONFIG_VIRTIO_DEBUG, so a production build carries none of them.

Assisted-by: Kiro:claude-opus-5 checkpatch sparse
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 .../driver-api/virtio/virtio-dmb.rst          |  52 ++++-
 drivers/virtio/virtio_dmb.c                   | 215 +++++++++++++++++-
 2 files changed, 262 insertions(+), 5 deletions(-)

diff --git a/Documentation/driver-api/virtio/virtio-dmb.rst b/Documentation/driver-api/virtio/virtio-dmb.rst
index 4cd23e25901f..610db080dee5 100644
--- a/Documentation/driver-api/virtio/virtio-dmb.rst
+++ b/Documentation/driver-api/virtio/virtio-dmb.rst
@@ -255,8 +255,10 @@ The last area is short unless ``area_pages`` divides ``pages``.  A region
 small enough for one area to cover behaves exactly as a single lock over
 the whole pool does, which includes every region up to 2 MiB on a 4 KiB
 page, and more than that on a guest with few possible CPUs.
-Both values are printed at probe time, so a device implementer can read
-back what a guest derived from the region it offered.
+Both values are printed at probe time and are readable under
+``CONFIG_VIRTIO_DEBUG`` in ``dmb/areas`` and ``dmb/area_pages``, so a
+device implementer can read back what a guest derived from the region it
+offered.
 
 A device cannot influence the count and should not try to: it is derived
 from the guest's page size, cacheline size and possible-CPU count, none of
@@ -619,7 +621,51 @@ a guest with three or more possible CPUs; a guest with one or two derives
 fewer, larger areas from the same region.
 The claimed range also appears in ``/proc/iomem`` as
 ``virtio-dmb``, but only where the claim was granted, and the ``shmid``
-appears nowhere else at all.
+appears nowhere else at all.  The three counts appear again in
+``dmb/pages``, ``dmb/areas`` and ``dmb/area_pages`` below.
+
+With ``CONFIG_VIRTIO_DEBUG`` the state of the region is also available
+under the device's virtio debugfs directory, in ``dmb/``.  The directory
+exists only while the device has a region, so a device that did not
+negotiate the feature has no ``dmb/`` at all.  These files are
+diagnostics and not ABI: their names, their contents and the one write
+they accept may change or go away.
+
+``pages``
+  how many pages the allocator can hand out.
+
+``areas``
+  how many pool areas the pool is divided into.
+
+``area_pages``
+  how many pages one pool area covers.  ``areas`` is
+  ``ceil(pages / area_pages)``, so the last area covers fewer unless
+  ``area_pages`` divides ``pages``.  Both are fixed when the region is
+  installed and are the same two values the probe-time message prints.
+
+``used_pages``
+  how many of them are allocated.  One counter maintained across all areas
+  rather than a sum of per-area figures read at different moments, so it
+  never reports a torn total; it is raised just outside the area lock, so a
+  read taken during a claim or a release can lag the bitmap by that claim.
+
+``used_pages_hiwater``
+  the largest ``used_pages`` has been.  This, rather than a sample of
+  ``used_pages``, is what a region should be sized against: a burst
+  that fills the region between two samples leaves no other trace.
+  Writing ``0`` restarts the measurement from the current occupancy.
+
+``alloc_failed``
+  how many buffer mappings the pool had no room for.  Because running
+  out of room is an ordinary condition it is not logged above debug
+  level, so this is the cheapest indication that a region is too small
+  for what is running on it: a non-zero value means the pool could not
+  fit a mapping the workload asked for, either because it is smaller
+  than the workload needs or because no single pool area held a long
+  enough run of free pages.  A virtqueue area that did not fit is not
+  counted here, since it is logged instead, and neither is a mapping
+  refused for exceeding the per-mapping cap, which ``max_mapping_size``
+  advertises.
 
 Notes for kernel code
 =====================
diff --git a/drivers/virtio/virtio_dmb.c b/drivers/virtio/virtio_dmb.c
index 42126f928bc0..fe556d585f24 100644
--- a/drivers/virtio/virtio_dmb.c
+++ b/drivers/virtio/virtio_dmb.c
@@ -20,10 +20,12 @@
  */
 
 #include <linux/align.h>
+#include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/bits.h>
 #include <linux/cache.h>
 #include <linux/cpumask.h>
+#include <linux/debugfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/highmem.h>
@@ -126,7 +128,12 @@ struct virtio_dmb_area {
  * @area_slots: slots one area covers, a power of two; the last area covers
  *	fewer when @nslots is not a multiple of it
  * @area_shift: ilog2(@area_slots), so slot >> @area_shift names its area
+ * @total_used: slots allocated across every area, exact; CONFIG_VIRTIO_DEBUG
+ * @used_hiwater: the largest @total_used has been since the last reset through
+ *	debugfs, or since init; CONFIG_VIRTIO_DEBUG
+ * @alloc_failed: buffer mappings the pool had no room for; CONFIG_VIRTIO_DEBUG
  * @shm_id: shared memory id the device reported for the region
+ * @debugfs_dir: directory holding this region's debugfs files
  */
 struct virtio_dmb {
 	struct virtio_device	*vdev;
@@ -145,7 +152,20 @@ struct virtio_dmb {
 	unsigned int		 nareas;
 	unsigned int		 area_slots;
 	unsigned int		 area_shift;
+#ifdef CONFIG_VIRTIO_DEBUG
+	/*
+	 * Exact occupancy for the two debugfs files, kept outside the area
+	 * locks.  A production build has neither: summing the per-area counts
+	 * would need every lock, and the hot path is what this file exists to
+	 * make cheap.  kernel/dma/swiotlb.c draws the same line at
+	 * CONFIG_DEBUG_FS.
+	 */
+	atomic_long_t		 total_used;
+	atomic_long_t		 used_hiwater;
+	atomic_long_t		 alloc_failed;
+#endif
 	u16			 shm_id;
+	struct dentry		*debugfs_dir;
 };
 
 /* First slot of area @i. */
@@ -210,6 +230,61 @@ static size_t virtio_dmb_max_mapping(const struct virtio_dmb *dmb)
 	return max_t(size_t, min(eighth, half_area), PAGE_SIZE);
 }
 
+#ifdef CONFIG_VIRTIO_DEBUG
+
+/*
+ * Exact global occupancy, kept outside every area lock.
+ *
+ * Summing the per-area counts would be imprecise, because no two of them are
+ * read under the same lock, and taking every lock to read one debugfs file
+ * would put a whole-pool serialisation back into a file whose only purpose is
+ * to observe.  An atomic add-return instead yields a value @total_used
+ * genuinely held, so raising the high-water mark to the largest such value
+ * makes both figures exact rather than approximate: two racing claims each
+ * observe a distinct real total and the larger wins.
+ *
+ * This is kernel/dma/swiotlb.c's inc_used_and_hiwater()/dec_used() pair, for
+ * the same reason and with the same empty stubs when the option is off.
+ */
+static void virtio_dmb_inc_used(struct virtio_dmb *dmb, unsigned int nr)
+{
+	long old_hiwater, new_used;
+
+	new_used = atomic_long_add_return(nr, &dmb->total_used);
+	old_hiwater = atomic_long_read(&dmb->used_hiwater);
+	do {
+		if (new_used <= old_hiwater)
+			break;
+	} while (!atomic_long_try_cmpxchg(&dmb->used_hiwater, &old_hiwater,
+					 new_used));
+}
+
+static void virtio_dmb_dec_used(struct virtio_dmb *dmb, unsigned int nr)
+{
+	atomic_long_sub(nr, &dmb->total_used);
+}
+
+static void virtio_dmb_inc_alloc_failed(struct virtio_dmb *dmb)
+{
+	atomic_long_inc(&dmb->alloc_failed);
+}
+
+#else /* !CONFIG_VIRTIO_DEBUG */
+
+static void virtio_dmb_inc_used(struct virtio_dmb *dmb, unsigned int nr)
+{
+}
+
+static void virtio_dmb_dec_used(struct virtio_dmb *dmb, unsigned int nr)
+{
+}
+
+static void virtio_dmb_inc_alloc_failed(struct virtio_dmb *dmb)
+{
+}
+
+#endif /* CONFIG_VIRTIO_DEBUG */
+
 /*
  * Claim @nr contiguous slots from area @i, or -ENOMEM when that one area
  * cannot satisfy the request.  Takes and drops that area's lock and touches
@@ -254,6 +329,12 @@ static long virtio_dmb_area_claim(struct virtio_dmb *dmb, unsigned int i,
 
 	spin_unlock_irqrestore(&area->lock, flags);
 
+	/*
+	 * Outside the lock, which is where swiotlb_search_pool_area() does it
+	 * too: it touches no area state, so holding one buys nothing.
+	 */
+	virtio_dmb_inc_used(dmb, nr);
+
 	return slot;
 
 not_found:
@@ -271,7 +352,9 @@ static long virtio_dmb_area_claim(struct virtio_dmb *dmb, unsigned int i,
  * buffer, and repolls instead.  Reporting it at any level a working device
  * would print would therefore be a log flood, and it is the only signal an
  * undersized region produces at all, so it is reported through dynamic debug
- * where it costs nothing until somebody asks for it.
+ * where it costs nothing until somebody asks for it.  The map_page() caller
+ * counts it as well, so that a debug build offers a sampled reader as well as
+ * a log.
  *
  * Next fit within one area, from a hint that advances past each claim and
  * rewinds to each release, beginning in the area belonging to the running CPU
@@ -390,6 +473,18 @@ static void virtio_dmb_release(struct virtio_dmb *dmb, unsigned int slot,
 	area->used -= nr;
 	area->index = slot - virtio_dmb_area_base(dmb, a);
 
+	spin_unlock_irqrestore(&area->lock, flags);
+
+	/*
+	 * Outside the lock, and deliberately not below the label: the guard
+	 * above rejects a range that is not wholly allocated, and only slots
+	 * that were counted in are counted out, so the total tracks the bitmap
+	 * rather than the caller's arithmetic.
+	 */
+	virtio_dmb_dec_used(dmb, nr);
+
+	return;
+
 out:
 	spin_unlock_irqrestore(&area->lock, flags);
 }
@@ -717,8 +812,22 @@ static dma_addr_t virtio_dmb_op_map_page(union virtio_map map,
 
 	nr = virtio_dmb_slots(size);
 	ret = virtio_dmb_claim(dmb, nr);
-	if (ret < 0)
+	if (ret < 0) {
+		/*
+		 * Counted here rather than in virtio_dmb_claim(), which
+		 * virtio_dmb_op_alloc() reaches as well.  A virtqueue area
+		 * that does not fit is a step of vring_alloc_queue_split()'s
+		 * search for a size that does, so counting it would have a
+		 * correctly sized region boot with a failure for every
+		 * attempt but the last, in the one file whose purpose is to
+		 * answer whether the region is too small for the traffic.  A
+		 * request over the per-mapping cap is not counted either: the
+		 * cap is what max_mapping_size() advertises, so exceeding it
+		 * is a caller bug rather than a property of the region.
+		 */
+		virtio_dmb_inc_alloc_failed(dmb);
 		return DMA_MAPPING_ERROR;
+	}
 	slot = ret;
 
 	virtio_dmb_record(dmb, slot, nr, size, src);
@@ -860,6 +969,105 @@ static const struct virtio_map_ops virtio_dmb_map_ops = {
 	.max_mapping_size	= virtio_dmb_op_max_mapping_size,
 };
 
+#ifdef CONFIG_VIRTIO_DEBUG
+
+static int virtio_dmb_used_get(void *data, u64 *val)
+{
+	struct virtio_dmb *dmb = data;
+
+	*val = atomic_long_read(&dmb->total_used);
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(virtio_dmb_used_fops, virtio_dmb_used_get, NULL,
+			 "%llu\n");
+
+static int virtio_dmb_hiwater_get(void *data, u64 *val)
+{
+	struct virtio_dmb *dmb = data;
+
+	*val = atomic_long_read(&dmb->used_hiwater);
+
+	return 0;
+}
+
+static int virtio_dmb_hiwater_set(void *data, u64 val)
+{
+	struct virtio_dmb *dmb = data;
+
+	/* Restarting the measurement is the only meaningful write. */
+	if (val)
+		return -EINVAL;
+
+	/*
+	 * Restart from what is allocated now rather than from zero, so that
+	 * the file never reports a peak below the occupancy it is read
+	 * alongside.
+	 */
+	atomic_long_set(&dmb->used_hiwater,
+			atomic_long_read(&dmb->total_used));
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(virtio_dmb_hiwater_fops, virtio_dmb_hiwater_get,
+			 virtio_dmb_hiwater_set, "%llu\n");
+
+static int virtio_dmb_alloc_failed_get(void *data, u64 *val)
+{
+	struct virtio_dmb *dmb = data;
+
+	*val = atomic_long_read(&dmb->alloc_failed);
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(virtio_dmb_alloc_failed_fops,
+			 virtio_dmb_alloc_failed_get, NULL, "%llu\n");
+
+/*
+ * The files go under the device's existing virtio debugfs directory, and exist
+ * only while the device has a region.  They describe one, so their presence is
+ * also the answer to whether the device is using the feature.
+ *
+ * Every file is served through DEFINE_DEBUGFS_ATTRIBUTE, either directly or by
+ * a debugfs_create_*() helper that uses it, so each read takes a reference
+ * that debugfs_remove_recursive() waits for.  That is what lets the caller
+ * free the state these files point at once the directory is gone.
+ */
+static void virtio_dmb_debugfs_init(struct virtio_dmb *dmb)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("dmb", dmb->vdev->debugfs_dir);
+	dmb->debugfs_dir = dir;
+
+	debugfs_create_u32("pages", 0400, dir, &dmb->nslots);
+	debugfs_create_u32("areas", 0400, dir, &dmb->nareas);
+	debugfs_create_u32("area_pages", 0400, dir, &dmb->area_slots);
+	debugfs_create_file("used_pages", 0400, dir, dmb,
+			    &virtio_dmb_used_fops);
+	debugfs_create_file("used_pages_hiwater", 0600, dir, dmb,
+			    &virtio_dmb_hiwater_fops);
+	debugfs_create_file("alloc_failed", 0400, dir, dmb,
+			    &virtio_dmb_alloc_failed_fops);
+}
+
+static void virtio_dmb_debugfs_exit(struct virtio_dmb *dmb)
+{
+	debugfs_remove_recursive(dmb->debugfs_dir);
+}
+
+#else /* !CONFIG_VIRTIO_DEBUG */
+
+static void virtio_dmb_debugfs_init(struct virtio_dmb *dmb)
+{
+}
+
+static void virtio_dmb_debugfs_exit(struct virtio_dmb *dmb)
+{
+}
+
+#endif /* CONFIG_VIRTIO_DEBUG */
+
 /*
  * Whether the device still has virtqueues.  vqs_list_lock is what protects
  * that list against a concurrent adder.  No caller here can race one, because
@@ -929,6 +1137,7 @@ void virtio_dmb_destroy(struct virtio_device *vdev)
 	vdev->map = dmb->prev_map;
 	vdev->vmap = dmb->prev_vmap;
 
+	virtio_dmb_debugfs_exit(dmb);
 	memunmap(dmb->map_va);
 	if (dmb->map_claimed)
 		release_mem_region(dmb->map_phys, dmb->map_len);
@@ -1278,6 +1487,8 @@ int virtio_dmb_init(struct virtio_device *vdev)
 	dmb->area_slots = area_slots;
 	dmb->area_shift = ilog2(area_slots);
 
+	virtio_dmb_debugfs_init(dmb);
+
 	/* Published last: until now nothing routes a mapping here. */
 	dmb->prev_map = vdev->map;
 	dmb->prev_vmap = vdev->vmap;
