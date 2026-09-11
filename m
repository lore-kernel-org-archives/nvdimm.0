Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DB0449B11
	for <nvdimm@lists.linux.dev>; Fri, 11 Sep 2026 08:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789115152; cv=none; b=suQEzHmtUAo5D9qnTIrFvYTWLPDtHjLdKKPe9HyO32HIo8/8V00ZvD03DC+mMLJUK6Owc2RmJ6sgqn+nd7IDDOPdE2DHTSgsMEAHeaMhrVWKV4VBSli5WsltxnYULpOA1kV7mg6Yn4NZtF0b6HOwc/gwIgV7T2jmtZHYEL9rEjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789115152; c=relaxed/simple;
	bh=k4LK5lbS3gaSrE0kwk0ec7AUi1syZRYY0+qgG0SlrdE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nvSUkbQhAGCq5YBvHcOHdErZCv53swcrvTMQG50lBEqCeHtLoLLxURCJw1/z00FQ/2n7Z4jzA9dCr4wz23EO2udiUYXnsM6t9TKUaG2wI+Q3lLvy9bd6o6KWhZoESMwa5W7Hpebirv1MNG3B4jYPdH5N9kxg9XZvP9/4nlA94GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WBCwYWu4; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBCwYWu4"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398c066106cso491588a91.1
        for <nvdimm@lists.linux.dev>; Fri, 11 Sep 2026 01:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789115149; x=1789719949; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hh1hhSShntFbj0qIbpZ5cz58KTjWdr8vsIozL/BHi18=;
        b=WBCwYWu4gCI3zi9MdBKRCKn9O0Fc+uHUvBz6VIGR/XU+PuDohfB3jVGEeRuqx2Le2J
         btNvDY6sbcVnuPq0CVbA57r/KNjOEePGLbw4e74C67vQLyPurSxZB4Bw4Av0/HWkpT5E
         72Aww+XUGEBFeRNlqsyTMZ1NzZuHJLfAJEf/I8ThlAiSVnFdbCG2b6nQlNOMkhvuJN3V
         rRKDC5LRN5koIbGZh0GciKzCCWTSRun1KMXBhPSHVLX3/+6HX7Cjh6d0E8XP4hH418PH
         hjWM0Sx2dA/ion/yTONjrDS5szfLHbH2tZz+ywHNotglWw/47O5WlW4d3NQ3QZVWLIny
         kjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789115149; x=1789719949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hh1hhSShntFbj0qIbpZ5cz58KTjWdr8vsIozL/BHi18=;
        b=GoJeyF1r2raC7bLdsdK3jgMDy1FdndKgXn8zJDI+1j15VKxY78WX2sBkhjegLCuz4w
         tz0J7yZDc+iZTqE3W/EcI1aep95GumlortLNHIjThtzD/Rma4rKb9lmkmpuP3NiyoTHm
         tQAzarBiBEXfo/0+4GzgP0RfLIq2UVKQ48qs9cqGXgJifZEyZDT5x4BGmvGD6Mwah/jO
         +3x8mg8ig06VufMkxzUfV9gEfYmwlLwy3b/rrLAbgw7CGdmUICtTx2ZQStqfv+YNuAho
         tABp0lwhmq4xhIHe0pr11dJrUkUTKj7PXkY4imiXOWpMIh8WQeLO9hcOsdd5wApyUYYi
         J+Yw==
X-Forwarded-Encrypted: i=1; AKwUvByTy6bQtPwF6W3K8uqWPhUBY54n8Y5lLR8AKom2Jw6povjIJKRM95cSdO+aVBvtl/WB3OsOp3c=@lists.linux.dev
X-Gm-Message-State: AFuF++kSHsWFX5ZSeyWv0rI4UAsVt98oRe/3RCuwWIDxKiFKLJCHBV8v
	29rDqw+YGrIrw8+x8ZvYXx1y4610F3V0rYXO2LXCcr0ors8uk+vXKlER
X-Gm-Gg: AYBFou0BoQpAgqw07ns0R7vfwZEEu9+sx/CA96ucsjXp0qR+wrHTcrmx0xaQqQB1g2G
	E6KUcNix0ujJMbR3lkUXTL2NMjXQYAZXWEY+JnL+XL/qLFLNUsO8EyYXuxuPX+/YvkJtdnKzZTt
	zZ0USxmT+nXFafuAVVTic4VdTESq2K7r698uyKR5zIKt57uoLzBXOMDQlv7QjBUEW/viyXjoxdx
	IKB50yWAAieAwbd/zGWJhQlM2l7UvMuJ9BD/CRAJIKxfcHdR1jVBuzkTYWClUT82pemyhRZ5pPu
	Z5FHe2vvngaiurhUsyjNbBoSqPuGjQmzdndLtZrGr3uhN6nFkmMiwW6DSfhQs6cZ5jME/Cx1OyR
	fGac5lfHz7WKhAj8+IsYEH8EYeRD/7hocHl+CUD5RIgL/lPd3q4WoZwNsIFwLXY1U82ncSORZpX
	UJe/LpXgil/twG93ZajYH/Dpm9PTxtzKn+9QdrbxXD1Gf4uRh1EaaUV/Fay1FkeaioCWt4C8iU2
	Nzx3L/+1mI5FnOhyfq2Ef3UJg==
X-Received: by 2002:a17:90b:4ad2:b0:398:9be6:f996 with SMTP id 98e67ed59e1d1-39d9c34a241mr4653694a91.21.1789115149333;
        Fri, 11 Sep 2026 01:25:49 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b8137fsm4795964c88.9.2026.09.11.01.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 01:25:48 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
Date: Fri, 11 Sep 2026 13:55:43 +0530
Message-ID: <20260911082543.473670-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and hands
it to devres only once device_add_disk() has succeeded.  Until that
point the probe path owns the disk itself, which is why every failure
after the allocation jumps to the out: label and puts it there.

The devm_init_badblocks() failure returns directly instead, so the disk
allocated a few lines earlier is never released.  Nothing releases it
afterwards either: the devres action that would have done so has not
been registered yet, so unbinding the namespace or destroying it does
not reach the disk, and it stays allocated along with its queue and its
bdev inode until the machine is rebooted.

devm_init_badblocks() only fails when a single page allocation fails, so
reaching this at all needs memory exhaustion during namespace probe, and
because device_add_disk() has not run there is nothing user visible left
behind: no device node, no sysfs entry, only the leaked memory.

Release the gendisk through the existing cleanup path on this failure.

Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
v2, all of it from Alison's review of v1:
 - retitled, and the changelog rewritten as background, problem, impact
   and resolution rather than a walk through the call sequence
 - says whether the disk is permanently leaked: it is, because the
   devres action has not been registered at that point, so no later
   unbind or destroy reaches it
 - says when the failure can be reached at all, and that nothing user
   visible is left behind
 - the Fixes: tag re-derived.  v1 blamed b95f5f4391fa, but the early
   return after the disk was allocated already existed before it; that
   commit only changed which call failed.  The leak starts at
   3dd60fb9d95d, which removed the pmem_release_queue devres action and
   the fsdax_pagemap_ops .cleanup that had been freeing the disk on
   these paths.  accf58afb689 then converted the addr and dax_dev
   returns to goto out, and this one was missed.
 - the object counts kept, but measured across four batch sizes so that
   the scaling is visible, and the shortfall you noticed explained

Found by an AI-assisted review of the error paths in pmem_attach_disk().

Tested on 7.3.0-rc2 in QEMU, with a legacy pmem region (memmap=1G!2G) and
a local debug patch forcing the devm_init_badblocks() branch, as it is
otherwise only reachable under memory exhaustion.  namespace0.0 was bound
and unbound repeatedly with the branch forced, counting bdev_cache in
/proc/slabinfo after a drop_caches and a settle:

    failed probes      32     64    128    256
    growth, unfixed   +24    +60   +120   +252
    growth, fixed     +12    +12    +12    +12

Without the patch the count tracks the number of failed probes, and the
unbind between attempts does not bring it back down, which is what makes
the leak permanent.  With the patch it is flat.  Both rows sit a little
under the probe count because SLUB's active_objs is an estimate, which is
the discrepancy you asked about in v1.  Clearing the debug flag and
binding again still gives a working /dev/pmem0.

v1: https://lore.kernel.org/all/20260824060113.2330468-1-hemanth.selam@gmail.com/

 drivers/nvdimm/pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..648fc7d66063 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	if (devm_init_badblocks(dev, &pmem->bb)) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.48.1

