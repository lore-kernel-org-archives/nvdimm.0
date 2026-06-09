Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C36406261;
	Tue,  9 Jun 2026 12:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006875; cv=pass; b=ixeJhPjsHwi7MpRdChxXYfgFkDnXtjRRZVYmS1Z6Ef3Vm/AgCH7/8jy2fibk5Yx4CC0x9OJ5Lyaw9+9aZloSBwDWrcesXVwDyD0pNYQjkGSmXBc3ZclwRiteqSlsMRM2JBC5e7hMz2puncOriQOAQva2Fg8Aez3Rv/thbKgv970=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006875; c=relaxed/simple;
	bh=PuQkpSB6VVlHax4NFIXV8Byh4dgGWyEeHzEDs6+zyZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H0epafqPwLXZL7n/68rcNCcPqBs4x3ISfAp+IYwZaNyJ/WMn5iCSD3v4zkHEUzl2chDiwKiW3p3+ju12SxJgcMCfHEKHa08os5OUTxfq91yyOmVSTZ+Tas8p28wmd/hk4riyLb0XkFgrczUc9DSMCKG5w2W4ZSuXwvjMGPEyosk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=OryJ1yEz; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="OryJ1yEz"
ARC-Seal: i=1; a=rsa-sha256; t=1781006869; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BDlBuiZPmrhKiH9njlTpoP56ONAhaM80vTnWxUj5rQXF5MMgazFUCcaG41onYivLPJE6CrINMR3foOlHoxAhclE8za4/xmxIq97iMF0/Necfykw5eW14LVEuGgz5ce5B7GnRMxxGJ7i1r6y0nvlDz4RkhFmh69FU7SSZFj9xJDg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781006869; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=YKVbGfEaWBr0yEbDSBlVXVeEB4IahedrC1wGWoL470M=; 
	b=WzjCr1L+Me+ATKk+9J483KTD1x2N2yDkaQI0EyZOK8JKX5hTk9uCGHn700IKPJDhoTop+2vNhDAJ7d2Z6oSuhUAKy3pNCp7iJZchdqgsyPFY5ybyFtACJ+AmgH83HMdew2SQOuKeId+TVfVoxroHfrth+W6joKn7pdTETxhLp20=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781006869;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=YKVbGfEaWBr0yEbDSBlVXVeEB4IahedrC1wGWoL470M=;
	b=OryJ1yEz+ShfvO/tPOfLmH7q7bOFSBB8LCTluQBu6xMrtZ/CaVC8Y0tcKC/zCttD
	D5HkBWfCotS3XgSutaiLLEynWvrk6pSCwEL71mpK5zY8D86JcWZZXWo2+1M5sT0/URl
	r+9D8Dm3e2+XwzLcVao/LWGB0bnHg3A/bRrBAMYI=
Received: by mx.zohomail.com with SMTPS id 1781006864544861.9703854224489;
	Tue, 9 Jun 2026 05:07:44 -0700 (PDT)
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
Subject: [PATCH v4 0/7] nvdimm: virtio_pmem: fix request lifetime and converge broken queue failures
Date: Tue,  9 Jun 2026 20:07:14 +0800
Message-ID: <20260609120726.1714780-1-me@linux.beauty>
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

The first two patches keep provider flush errors intact and make the
virtio-pmem child flush bio allocation use GFP_NOIO. async_pmem_flush() can
allocate a child flush bio from filesystem flush and writeback paths;
GFP_NOIO is a better fit than GFP_ATOMIC there because the allocation may
sleep but must not recurse into filesystem I/O reclaim. With these changes,
the same mkfs sanity test reached mkfs_rc=0, mount_rc=0, and umount_rc=0.

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

1/7 nvdimm: preserve flush callback errors
Return provider flush callback errors directly from nvdimm_flush().

2/7 nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
Use GFP_NOIO for the child flush bio allocation.

3/7 nvdimm: virtio_pmem: always wake -ENOSPC waiters
Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
token completion.

4/7 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
wq_buf_avail).

5/7 nvdimm: virtio_pmem: refcount requests for token lifetime
Refcount request objects so the token lifetime spans the window where it is
reachable through the virtqueue until completion/drain drops the virtqueue
reference.

6/7 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Track a device-level broken state to converge broken/notify failures to -EIO:
wake all waiters and drain/detach outstanding requests to complete them with
an error, and fail-fast new requests.

7/7 nvdimm: virtio_pmem: drain requests in freeze
Drain outstanding requests in freeze() before tearing down virtqueues so
waiters do not sleep indefinitely.

Testing was done on QEMU x86_64 with a virtio-pmem device exported as
/dev/pmem0. This v4 series applies to v7.1-rc7, builds with
CONFIG_VIRTIO_PMEM=m, passes checkpatch, and passed the local repro checks
with a local-only virtqueue_kick() fault injection. I also checked that it
applies cleanly to next/master at 6e845bcb78c9 ("Add linux-next specific
files for 20260605").

Thanks,
Li Chen

Changelog:
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
v3: https://lore.kernel.org/all/20260226025712.2236279-1-me@linux.beauty/#t
v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/
v1: https://www.spinics.net/lists/kernel/msg5974818.html

Li Chen (7):
  nvdimm: preserve flush callback errors
  nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
  nvdimm: virtio_pmem: always wake -ENOSPC waiters
  nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
  nvdimm: virtio_pmem: refcount requests for token lifetime
  nvdimm: virtio_pmem: converge broken virtqueue to -EIO
  nvdimm: virtio_pmem: drain requests in freeze

 drivers/nvdimm/nd_virtio.c   | 139 +++++++++++++++++++++++++++++------
 drivers/nvdimm/region_devs.c |   6 +-
 drivers/nvdimm/virtio_pmem.c |  14 ++++
 drivers/nvdimm/virtio_pmem.h |   6 ++
 4 files changed, 139 insertions(+), 26 deletions(-)
-- 
2.52.0
