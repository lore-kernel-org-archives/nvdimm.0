Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F199395D8E;
	Tue, 30 Jun 2026 09:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811444; cv=pass; b=TTQFVb0O87QYrdnJvgyIgtT6Ot24yGi5dY5oJtUOmngvdr6ibMIwqshoa6qORNhCk3vUmcST903mKk6RdpiQOKdAoPJ1+ZX/6h+hgfvPfzj5asZGwSZ8bhkbYJzr61Vv7pMJxRuDd2seC7eElKVOlSyD0yP8kaOpVOsklWbN030=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811444; c=relaxed/simple;
	bh=aCJR3OsyfhjtOZ4S1TnvcYa+RHEuZG/LtBUWcNg1f7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Un0WsGm1iLjZdFWD7U8N4XNBbrGy82lLG9nS7IKPio+KMHyL4DB1RL8oiNkmaRSVCtkzjNXPGh/EvVS6xzd8bRhAC8FM4+Q3rWsrZRSWLYGond6WpSX7r5Y0t0QCwe6rGpEQKtgqAjoIDU5TnGKDSF+FhBW+DkS91MhELltg844=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=aH/nw5rt; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="aH/nw5rt"
ARC-Seal: i=1; a=rsa-sha256; t=1782811438; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RTSPOqsU3ruYmR4C6fU9TRxn1ag9YOIUvH95Obsz3nplsKd88cyfpFSNjvzhPV25QIxPgykHXLl7fSznQbPy/YoygbNS06iPMJullNlJlpKczvoNiIiyFOb6iXizZNq5TogYcjss2TUJfHknXml+AKbysXHBwJ4nHYYh6QNvD3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811438; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WijgoF9Dul3mkkiRPC6Esz0tO9Ln7QES9luLkjdebrk=; 
	b=NocyU6BXv1GuUWVS079Fs/47PcAkpf56udqYiwg4IV13MCUcuSVACXkjeAW7x9VOvlJrDOPblqeK4rXC6j5Ivu/Hm7GWHFGKSOA9K76ysP/oUnuFBs8DpZ5CKxR0OtBPf5BZ73E4MhN5PQcz/Q5ERcZ+qQ9x35I4zaDk8FCTqyY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811437;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=WijgoF9Dul3mkkiRPC6Esz0tO9Ln7QES9luLkjdebrk=;
	b=aH/nw5rtgDzm8X7zeAjEzkpxL7u9QY8TorOqFl9Ji/8OpIjm42V9gVz2q4sNZamT
	T6D96URBDCNSdRwF5yeQYRjCc3r8yMv1UoQSQWh5bzWu6w7KS+ifdk6SFvVyu4946gT
	WuMUqCfQPzK85m6ogvzepBWE+C+jmiwddrt3ZNS0=
Received: by mx.zohomail.com with SMTPS id 1782811433585611.9453027209239;
	Tue, 30 Jun 2026 02:23:53 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/12] nvdimm: virtio_pmem: fix flush/request failure paths
Date: Tue, 30 Jun 2026 17:23:25 +0800
Message-ID: <20260630092338.2094628-1-me@linux.beauty>
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

This series started as a virtio-pmem request lifetime and broken virtqueue
fix, but the rerolls have picked up several related flush-path fixes found
during local testing and review. Since the series is now broader than the
original lifetime bug, this cover letter calls out where the patches came
from.

The nvdimm flush helper maps provider flush failures to -EIO. That should
remain the default for provider/backend failures because host-side errors are
still best reported as generic I/O errors to the guest. However, virtio-pmem
may also fail a guest-local flush request allocation with -ENOMEM before any
request is submitted to the host. Reporting that resource failure as -EIO
makes memory pressure look like media failure.

The raw failure seen in the local mkfs sanity test was:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

Patch 1 comes from that local failure, with the error policy narrowed after
Pankaj pointed out that host/backend provider errors should not all be exposed
directly to the guest. It now preserves only -ENOMEM and keeps other provider
flush failures mapped to -EIO.

Patches 2 and 3 come from review of the pmem flush path. Patch 2 keeps a
failed REQ_PREFLUSH from being overwritten after data copy, and patch 3 is the
dataless-bio guard added after the Sashiko review. Patch 4 comes from the
local child flush bio allocation failure, but v7 reworks the v6 synchronous
FUA approach after Pankaj noted that the old child flush bio path completed
asynchronously. This version removes the child bio while keeping parent bio
completion asynchronous: the provider returns NVDIMM_FLUSH_ASYNC, queues
ordered WQ_MEM_RECLAIM work, and completes the parent bio after
virtio_pmem_flush() finishes. Patch 5 is the remaining allocation-policy
follow-up for the actual virtio-pmem flush request object, not for a child
bio.

Patches 6 and 7 are the older waiter fixes. Patch 6 wakes one -ENOSPC waiter
for each reclaimed used buffer, and patch 7 makes the wait flags explicit
READ_ONCE()/WRITE_ONCE() accesses. Pankaj asked for those changes to be split
across patches, and patch 7 carries his Acked-by.

Patch 8 is the original KASAN use-after-free fix for the request token
lifetime. Patches 9 and 10 are follow-up hardening in the same completion
path: order response publication before the submitter reads resp.ret, and keep
the DMA_FROM_DEVICE response buffer away from CPU-owned request fields. Patch
11 addresses the broken virtqueue / notify failure path reported by LKP and
reproduced locally with fault injection. It also serializes async parent-bio
flush work against broken-state publication, so remove/freeze cannot drain the
workqueue before a racing FUA bio queues new completion work. Patch 12 handles
teardown: it drains requests across freeze/remove and also addresses the
Sashiko-reported req_vq-after-free/NULL-deref class by clearing req_vq after
del_vqs() and making the drain helper tolerate a NULL queue. It also stops the
submit path from checking req_vq after the broken state is visible.

The original repros were on QEMU x86_64 with a virtio-pmem device exported
as /dev/pmem0. For this v7 reroll, the series applies to v7.1-rc7.

Thanks,
Li Chen

Changelog:
v6->v7:
- Address Pankaj's feedback on nvdimm_flush() error policy.
- Preserve only -ENOMEM from provider flush callbacks and continue to map
  other provider/backend failures to -EIO.
- Address Pankaj's feedback on the FUA flush behavior: replace the v6
  synchronous FUA path with provider-owned asynchronous parent bio completion.
- Add NVDIMM_FLUSH_ASYNC and use ordered WQ_MEM_RECLAIM work to run
  virtio_pmem_flush() and complete the parent bio after the host flush.
- Keep GFP_NOIO for the virtio-pmem request allocation, but no longer describe
  it as a child bio allocation fix.
- Add Pankaj's Acked-by on the READ_ONCE()/WRITE_ONCE() patch.
- Serialize async parent-bio flush work against broken-state publication in
  the broken-virtqueue patch, so remove/freeze cannot drain the workqueue
  before a racing FUA bio queues new completion work.
- Fold the Sashiko-reported req_vq NULL-deref fix into the freeze/remove
  drain patch.
- Update commit messages and this cover letter to describe patch origins.
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
v6: https://lore.kernel.org/all/20260621130246.2973254-1-me@linux.beauty/
v5: https://lore.kernel.org/all/20260617122442.2118957-1-me@linux.beauty/
v4: https://lore.kernel.org/all/20260609120726.1714780-1-me@linux.beauty/
v3: https://lore.kernel.org/all/20260226025712.2236279-1-me@linux.beauty/#t
v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/
v1: https://www.spinics.net/lists/kernel/msg5974818.html

Li Chen (12):
  nvdimm: preserve flush callback -ENOMEM
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

 drivers/nvdimm/nd_virtio.c   | 265 +++++++++++++++++++++++++++++------
 drivers/nvdimm/pmem.c        |  51 ++++---
 drivers/nvdimm/region_devs.c |   5 +-
 drivers/nvdimm/virtio_pmem.c |  65 ++++++++-
 drivers/nvdimm/virtio_pmem.h |  22 ++-
 include/linux/libnvdimm.h    |   9 ++
 6 files changed, 343 insertions(+), 74 deletions(-)

-- 
2.52.0
