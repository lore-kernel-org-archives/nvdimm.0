Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823FB39F165;
	Wed, 17 Jun 2026 12:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699107; cv=pass; b=egT9WUpFRjQzYbGJaFjDVjFGaszu7Iy9TlBDRO3X0RDpn6w5P54Bn+tx33YJVK/KrxMCX1qjsn4WmvDnzNDx4Toca6VcpzUCP2z+u64MCTJhMbNna1Nh6YGexONQ2ygsRaaySiyFq9Wsf2Omx3mFrsl33zmHBWXWuIz5EaebBiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699107; c=relaxed/simple;
	bh=GYZIvWuSU497vs0BQz5zNai2q/KrKZ1e/kS9w008mYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KjY1lxZIooyxNwWdgXogQzr6CmSJccGkXKDOMQdBvjFhsi8x6IXxyW8Xqk5YDV/pgHd0/TIE8A9PvVoWHvkQSBLaptKCo8ohVNqanlV2kd4/P6j18MnvBL1sKoTZCyHnw3silb5DWERGCqZmximBlqThm1w/EnOBsG/dqcQD6yU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=MD686hPT; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="MD686hPT"
ARC-Seal: i=1; a=rsa-sha256; t=1781699100; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ltTlsHQvzKsDBZJMLkThghHGO+PGHCxVuBeSXwVYStQeW9ruOQF4CDv5kZ/Zyb8UEr+5JjAZvAOF8C66CRWYT4K2STVmqsHHvdcexztc9lMrCQmDtrFtOSa9/iUYIo1XVaUQjRDMD+kdGENMdF/BWhER4cHaOMh1+J2BLDf8NWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699100; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZfDTtj2RptnizowLK53Xpqwng82ahoR0A+AXwfDPC+k=; 
	b=ixZgNukCP7ywficyj3LUsNYQvUDGwKDHrSh+815/np74Dxo7RypuGxtGPKhFVcuCcgB2Kne3mf2ZuSKvxkuYIiUhY2CZrZTexKqpyXQQvvSKQg6VmpXCwThLx2CEke3w7p3gvVgvMPQ9vWwi2HjaXosISKRd62JAkPh4nHABsqU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699100;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ZfDTtj2RptnizowLK53Xpqwng82ahoR0A+AXwfDPC+k=;
	b=MD686hPTl4+/U13GlqFVZ7/TDXulPuEdVixbSHtEyQTdh/hFFR2RH6DR1QpQA7PY
	jjOaLAUMdu32bidJn0MHdIRp/Vg9GNRiB6vyHa/kmg5q5vQSxc6KdhtFy2x0iqhYbXq
	S7+AD/2Uvle955mtOso64PJWAqyDd6pyNLqsY8CU=
Received: by mx.zohomail.com with SMTPS id 1781699098022441.7253379893517;
	Wed, 17 Jun 2026 05:24:58 -0700 (PDT)
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
Subject: [PATCH v5 0/8] nvdimm: virtio_pmem: fix request lifetime and converge broken queue failures
Date: Wed, 17 Jun 2026 20:24:32 +0800
Message-ID: <20260617122442.2118957-1-me@linux.beauty>
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
example, virtio-pmem may fail child flush bio allocation with -ENOMEM, but
that is currently reported as -EIO by nvdimm_flush().

The raw failure seen in the local mkfs sanity test was:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

The first three patches keep provider flush errors intact, make
pmem_submit_bio() honor a failed REQ_PREFLUSH before copying data, and use
GFP_NOIO for virtio-pmem child flush bio allocation. REQ_PREFLUSH is now
issued synchronously before the data copy. The asynchronous child flush bio is
still used for REQ_FUA, where the data copy has already completed and the
parent bio can be chained to the flush completion.

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
converges the failure and wakes all wait sites.

This series addresses these issues:

1/8 nvdimm: preserve flush callback errors
Return provider flush callback errors directly from nvdimm_flush().

2/8 nvdimm: pmem: keep PREFLUSH before data writes
Run REQ_PREFLUSH synchronously before copying data and fail the bio if the
flush fails.

3/8 nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
Use GFP_NOIO for the child flush bio allocation.

4/8 nvdimm: virtio_pmem: always wake -ENOSPC waiters
Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
token completion.

5/8 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
wq_buf_avail).

6/8 nvdimm: virtio_pmem: refcount requests for token lifetime
Refcount request objects so the token lifetime spans the window where it is
reachable through the virtqueue until completion/drain drops the virtqueue
reference.

7/8 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Track a device-level broken state to converge broken/notify failures to -EIO:
wake -ENOSPC waiters, fail-fast new requests, and report errors for completed
tokens after the queue is marked broken.

8/8 nvdimm: virtio_pmem: drain requests in freeze
Drain outstanding requests in freeze() after resetting the device so waiters
do not sleep indefinitely and virtqueue_detach_unused_buf() only runs on a
quiesced queue.

The original repros were on QEMU x86_64 with a virtio-pmem device exported
as /dev/pmem0. For this v5 reroll, I checked that the series applies to
v7.1-rc7 and to next/master at 8d6dbbbe3ba6 ("Add linux-next specific files
for 20260615"). Each commit builds with CONFIG_VIRTIO_PMEM=m, and the series
passes checkpatch.

Thanks,
Li Chen

Changelog:
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
- Add log report to commit msg
- Fold the export fix into 4/5 to keep the series bisectable when
  CONFIG_VIRTIO_PMEM=m.
v1->v2: add the export patch to fix compile issue.

Links:
v4: https://lore.kernel.org/all/20260609120726.1714780-1-me@linux.beauty/
v3: https://lore.kernel.org/all/20260226025712.2236279-1-me@linux.beauty/#t
v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/
v1: https://www.spinics.net/lists/kernel/msg5974818.html

Li Chen (8):
  nvdimm: preserve flush callback errors
  nvdimm: pmem: keep PREFLUSH before data writes
  nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
  nvdimm: virtio_pmem: always wake -ENOSPC waiters
  nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
  nvdimm: virtio_pmem: refcount requests for token lifetime
  nvdimm: virtio_pmem: converge broken virtqueue to -EIO
  nvdimm: virtio_pmem: drain requests in freeze

 drivers/nvdimm/nd_virtio.c   | 163 ++++++++++++++++++++++++++++-------
 drivers/nvdimm/pmem.c        |  12 ++-
 drivers/nvdimm/region_devs.c |   6 +-
 drivers/nvdimm/virtio_pmem.c |  28 +++++-
 drivers/nvdimm/virtio_pmem.h |   7 ++
 5 files changed, 178 insertions(+), 38 deletions(-)

-- 
2.52.0
