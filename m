Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8026917A2E8;
	Sun, 21 Jun 2026 13:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046987; cv=pass; b=bHJGbAFUr2cVt+CMGIj3rqyNmPb2YBPu/VbxweAfn8WqpOWJJNj++36yuNsGIgbfFzrQot3ZSxUlK2MkbMCWsDLj9218X16iCxd6umWjP/KXyioiYxeye8bIT/ltyV3HwxWDMRxfjtLSMqkckhohgrLaNZSakuu3C3bo7xGpqm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046987; c=relaxed/simple;
	bh=012LOvq2mAiIt0P22vBJj86VrDu7pgM9ps7fZapv+U0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jjo0l0LNQ2plkFpOlQl+LaozqwOQR/CBKErWAkEK+vaXlHkKSxBwmYwYSCqJVSJMgWnII69+mIEAhLJ6Iw5+ihW25FdMKfTKoZ7Tuu0l2XUe9oIFG+dPcBg9uXCUsDCquLr3HFiHECYCUbcd0rbpqe3tg8e7orHqnKxU6kW42k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=SspWvs+9; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="SspWvs+9"
ARC-Seal: i=1; a=rsa-sha256; t=1782046984; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Q4BbWnTZSR2/qxi6RcEqpPgeFgYI4nXLKUc6iTHAdCCJg9rX1uDhSQKI/tHKr+ARZKP40EsxbNpTPthZWHGuyLUz0UUgJLhX3nhALmsgOHRx8rczySL6Og8/dHnFdjAb6OB9LwwkNfwIPAxj5KFz4BDI1C3GfivmRcgDZ8A8H/o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782046984; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ja/FcbOROc1liB6+50q+4uXX8H/4tHMK/uAiZNPGBZw=; 
	b=Ko7VdHo07aymbj4wGkFxrR8Jx7Y0KRk+PF1w4rKVnZaachzAg/CD5gtMppF9w3mn8C4z5jYNHNR6CHrmRKVCQr5jg+KjQ0Kbr4xXsNN9z+4Fe9bA3E47RMgNAqwgaLD1zJOJPhq6rSpgloOkC0HfjWVuKYubFL2rl2oRtn0uAS8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782046984;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ja/FcbOROc1liB6+50q+4uXX8H/4tHMK/uAiZNPGBZw=;
	b=SspWvs+9QLOU4nSNE4Jx5lMiNj0/a5E5FXoaVG9CSDn14FA+4jK9fRgM4JMEhJFp
	aUr4xy8ev/c5+Pw6rK4Rx1oLl+cC8MGft0zkfgO1R1upuCuAdr5YjtAaDHvaqlHH1fX
	hb1HkZAVmRdkhG3NVmu+My7Q/wIZMrB8uBw9LR5k=
Received: by mx.zohomail.com with SMTPS id 178204698133186.4693239621107;
	Sun, 21 Jun 2026 06:03:01 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/12] nvdimm: virtio_pmem: fix request lifetime and converge broken queue failures
Date: Sun, 21 Jun 2026 21:02:31 +0800
Message-ID: <20260621130246.2973254-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

The nvdimm flush helper currently converts any non-zero provider flush
callback error to -EIO. That hides useful errno values from providers. For
example, virtio-pmem may fail flush allocation with -ENOMEM, but that is
currently reported as -EIO by nvdimm_flush().

The raw failure seen in the local mkfs sanity test was:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

The first five patches keep provider flush errors intact, make
pmem_submit_bio() honor a failed REQ_PREFLUSH before copying data, keep
dataless bios out of the data loop, and avoid allocating a child flush bio
for virtio-pmem REQ_FUA handling. REQ_PREFLUSH and REQ_FUA are now issued
synchronously from pmem_submit_bio(). After that, virtio-pmem only allocates
its request object for the actual provider flush, and that allocation uses
GFP_NOIO so reclaim does not recurse into filesystem or block IO.

The rest of the series addresses virtio-pmem request lifetime and broken
virtqueue handling. The virtio-pmem flush path uses a virtqueue cookie/token
to carry a per-request context through completion. Under broken virtqueue /
notify failure conditions, the submitter can return and free the request
object while the host/backend may still complete the published request. The
IRQ completion handler then dereferences freed memory when waking waiters,
which is reported by KASAN as a slab-use-after-free and may manifest as lock
corruption (e.g. "BUG: spinlock already unlocked") without KASAN.

In addition, the flush path has two wait sites: one for virtqueue descriptor
availability (-ENOSPC from virtqueue_add_sgs()) and one for request
completion. If the virtqueue becomes broken, forward progress is no longer
guaranteed and these waiters may sleep indefinitely unless the driver
converges the failure and wakes all wait sites. This version also orders
response publication with release/acquire, keeps DMA_FROM_DEVICE response
storage away from CPU-owned request fields, and wakes the in-flight
completion waiter when a queue is marked broken.

This series addresses these issues:

1/12 nvdimm: preserve flush callback errors
Return provider flush callback errors directly from nvdimm_flush().

2/12 nvdimm: pmem: keep PREFLUSH before data writes
Run REQ_PREFLUSH synchronously before copying data and fail the bio if the
flush fails.

3/12 nvdimm: pmem: guard data loop for dataless bios
Keep flush-only bios out of the data copy loop.

4/12 nvdimm: virtio_pmem: stop allocating child flush bio
Flush REQ_FUA synchronously instead of allocating a chained child bio.

5/12 nvdimm: virtio_pmem: use GFP_NOIO for flush requests
Use GFP_NOIO for the virtio-pmem request allocation.

6/12 nvdimm: virtio_pmem: always wake -ENOSPC waiters
Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
token completion.

7/12 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
wq_buf_avail).

8/12 nvdimm: virtio_pmem: refcount requests for token lifetime
Refcount request objects so the token lifetime spans the window where it is
reachable through the virtqueue until completion/drain drops the virtqueue
reference.

9/12 nvdimm: virtio_pmem: publish done with release/acquire
Order response publication before the submitter observes request completion.

10/12 nvdimm: virtio_pmem: isolate DMA request buffers
Keep the DMA_FROM_DEVICE response buffer away from CPU-owned request fields.

11/12 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Track a device-level broken state to converge broken/notify failures to -EIO:
wake -ENOSPC waiters, wake the in-flight completion waiter, fail-fast new
requests, and report errors after the queue is marked broken.

12/12 nvdimm: virtio_pmem: drain requests in freeze
Drain outstanding requests in freeze() after resetting the device so waiters
do not sleep indefinitely and virtqueue_detach_unused_buf() only runs on a
quiesced queue.

The original repros were on QEMU x86_64 with a virtio-pmem device exported
as /dev/pmem0. For this v6 reroll, the series applies to v7.1-rc7 and to
local next/master at 4fa3f5fabb30 ("Add linux-next specific files for
20260616").

Thanks,
Li Chen

Changelog:
v5->v6:
- Address Sashiko review feedback:
  - Add a data-loop guard for dataless bios in pmem_submit_bio().
  - Replace the child flush bio allocation with synchronous FUA flushing.
  - Keep GFP_NOIO only for the virtio-pmem request allocation.
  - Publish request completion with release/acquire ordering.
  - Isolate the DMA_FROM_DEVICE response buffer from CPU-owned fields.
  - Wake the in-flight host-completion waiter when marking the queue broken.
- Clear req_vq after del_vqs() and make drain tolerate a NULL queue.
v4->v5:
- Address review feedback about REQ_PREFLUSH ordering and active virtqueue
  detach.
- Add 2/8 so a failed REQ_PREFLUSH fails the bio before any data copy, and
  make REQ_PREFLUSH use a synchronous provider flush instead of a deferred
  child bio.
- Rework broken-queue handling so runtime failure marking only stops new
  submissions and wakes local -ENOSPC waiters; used/unused token draining is
  done after device reset in remove() and freeze().
- Remove the broken-state shortcut from the host-completion wait so the
  submitter never reads an uninitialized response field.
- Keep the raw broken-virtqueue dmesg in 7/8 while updating the teardown
  rationale.
- Renumber the old virtio-pmem fixes after the new pmem PREFLUSH patch.
v3->v4:
- Rebased the series onto v7.1-rc7 so it applies cleanly to Linux 7.1-rc7.
- Update the allocation site in 6/7 from kmalloc(sizeof(*req_data),
  GFP_KERNEL) to kmalloc_obj(*req_data) to match current nvdimm code.
- Add 1/7 to preserve provider flush callback errors in nvdimm_flush().
- Include the GFP_NOIO child flush bio allocation fix as 2/7.
- Renumber the old request lifetime and broken virtqueue fixes after the two
  new flush error patches.
v2->v3:
- Split patch 1 as suggested by Pankaj Gupta: keep the waiter wakeup
  ordering change in 1/5 and move READ_ONCE()/WRITE_ONCE() updates to
  2/5 (no functional change intended).
- Add log report to commit msg.
- Fold the export fix into 4/5 to keep the series bisectable when
  CONFIG_VIRTIO_PMEM=m.
v1->v2:
- Add the export patch to fix compile issue.

Links:
v5: https://lore.kernel.org/all/20260617122442.2118957-1-me@linux.beauty/
v4: https://lore.kernel.org/all/20260609120726.1714780-1-me@linux.beauty/
v3: https://lore.kernel.org/all/20260226025712.2236279-1-me@linux.beauty/#t
v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/
v1: https://www.spinics.net/lists/kernel/msg5974818.html

Li Chen (12):
  nvdimm: preserve flush callback errors
  nvdimm: pmem: keep PREFLUSH before data writes
  nvdimm: pmem: guard data loop for dataless bios
  nvdimm: virtio_pmem: stop allocating child flush bio
  nvdimm: virtio_pmem: use GFP_NOIO for flush requests
  nvdimm: virtio_pmem: always wake -ENOSPC waiters
  nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
  nvdimm: virtio_pmem: refcount requests for token lifetime
  nvdimm: virtio_pmem: publish done with release/acquire
  nvdimm: virtio_pmem: isolate DMA request buffers
  nvdimm: virtio_pmem: converge broken virtqueue to -EIO
  nvdimm: virtio_pmem: drain requests in freeze

 drivers/nvdimm/nd_virtio.c   | 224 +++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.c        |  52 ++++----
 drivers/nvdimm/region_devs.c |   6 +-
 drivers/nvdimm/virtio_pmem.c |  51 +++++++-
 drivers/nvdimm/virtio_pmem.h |  18 ++-
 5 files changed, 270 insertions(+), 81 deletions(-)

-- 
2.52.0
