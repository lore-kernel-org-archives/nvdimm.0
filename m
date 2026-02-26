Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2680C2C859;
	Thu, 26 Feb 2026 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074652; cv=pass; b=NY/dU/GAsmnvVn9fbKppvrIaVgkuUNn0LtoiC0zJMOLpRQhY678ADGVjmp6HMmq643nOczlWPL/YVtjtfPQZjZQQvkrYbTFe5+3DlsVeo3249/4aGL8TLJRsazMXB+twJo9y4YfL2qKhXLIT/JOgxs9qaWpKsCj7QNPEqkDwOoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074652; c=relaxed/simple;
	bh=Nvl5+BLXE4QSPYNJLZ/LHWq9J3MJbTvwv1njecu/qLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xh+sW/VLlb49FevX0YJhu+Bwk2134U3+pWqswFT8zBVKziVdelq/01nmiGIUJ6by6gb2hsZp8ilTJBL/+UDOcLpA2M+hqfqkQ48BjGchWVWcIqDPGRH/wOQZY8BTEz69qmNQ0QWYPStuFpM/0WcboytEnphHYbFwlFEhN0Ru8qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=DLY+9g6C; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="DLY+9g6C"
ARC-Seal: i=1; a=rsa-sha256; t=1772074649; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=URIJ3qjHy0E4+WJtOFGDNxsXGn5W85BE+ULnyZkbZW2W6uf2wThua5jzh87inQQJRcG+bki+FNHL55qBvcUykITLXekhqP+T7uisUrY58iFzOMHlnIH/mgffllmb1NTYU0JMI75XqyA9E/KRFJ7hLEsuZB+REnS6r0Up4Qxz64E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772074649; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=72Rcpozf+MJlfnig7J0JZAqnOEBawja7Boz8Y+5/j+c=; 
	b=jt1f4/tb3yMQYORAVFPJd9vMaGlZPa0PRLARNH97VlfEgeDZ1Dih1sZWvDO1B/wKTFcRzMARyg2Kz6hou0aLierFfxsd9haI5i5+Np2Y/p3KlR4I8zB0JsxvlpN/Q2rQ+/8/iJpgUnbyCm/pruNsjQAg9Von5VJhfRlHPTSCAls=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772074649;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=72Rcpozf+MJlfnig7J0JZAqnOEBawja7Boz8Y+5/j+c=;
	b=DLY+9g6CRjG6SilqiGw4J+fQI8lDgt4BsIYCzabCprRk52NQjA+/8LsupchKA/7/
	vZD+Vv7G7EWxsdDCKeBcHlXmBips0cXr82y6LGAB+514yl8cGcx+UJ3JP4SheHS8myY
	Vs/BpXSGGaKCU/Ai8tBwjgqVXsqSunRyZ1sm+5JE=
Received: by mx.zohomail.com with SMTPS id 1772074646536524.4555180636507;
	Wed, 25 Feb 2026 18:57:26 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] nvdimm: virtio_pmem: fix request lifetime and converge broken queue failures
Date: Thu, 26 Feb 2026 10:57:05 +0800
Message-ID: <20260226025712.2236279-1-me@linux.beauty>
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

The virtio-pmem flush path uses a virtqueue cookie/token to carry a
per-request context through completion. Under broken virtqueue / notify
failure conditions, the submitter can return and free the request object
while the host/backend may still complete the published request. The IRQ
completion handler then dereferences freed memory when waking waiters,
which is reported by KASAN as a slab-use-after-free and may manifest as
lock corruption (e.g. "BUG: spinlock already unlocked") without KASAN.

In addition, the flush path has two wait sites: one for virtqueue
descriptor availability (-ENOSPC from virtqueue_add_sgs()) and one for
request completion. If the virtqueue becomes broken, forward progress is
no longer guaranteed and these waiters may sleep indefinitely unless the
driver converges the failure and wakes all wait sites.

This series addresses both issues:

1/5 nvdimm: virtio_pmem: always wake -ENOSPC waiters
Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
token completion.

2/5 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
wq_buf_avail).

3/5 nvdimm: virtio_pmem: refcount requests for token lifetime
Refcount request objects so the token lifetime spans the window where it
is reachable through the virtqueue until completion/drain drops the
virtqueue reference.

4/5 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Track a device-level broken state to converge broken/notify failures to
-EIO: wake all waiters and drain/detach outstanding requests to complete
them with an error, and fail-fast new requests.

5/5 nvdimm: virtio_pmem: drain requests in freeze
Drain outstanding requests in freeze() before tearing down virtqueues so
waiters do not sleep indefinitely.

Testing was done on QEMU x86_64 with a virtio-pmem device exported as
/dev/pmem0, formatted with ext4 (-O fast_commit), mounted with DAX, and
stressed with fsync-heavy workloads.

Thanks,
Li Chen

Changelog:
v2->v3:
- Split patch 1 as suggested by Pankaj Gupta: keep the waiter wakeup
  ordering change in 1/5 and move READ_ONCE()/WRITE_ONCE() updates to
  2/5 (no functional change intended).
- Add log report to commit msg
- Fold the export fix into 4/5 to keep the series bisectable when
  CONFIG_VIRTIO_PMEM=m.
v1->v2: add the export patch to fix compile issue.

Links:
v2: https://lore.kernel.org/all/20251225042915.334117-1-me@linux.beauty/

Li Chen (5):
  nvdimm: virtio_pmem: always wake -ENOSPC waiters
  nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
  nvdimm: virtio_pmem: refcount requests for token lifetime
  nvdimm: virtio_pmem: converge broken virtqueue to -EIO
  nvdimm: virtio_pmem: drain requests in freeze

 drivers/nvdimm/nd_virtio.c   | 137 +++++++++++++++++++++++++++++------
 drivers/nvdimm/virtio_pmem.c |  14 ++++
 drivers/nvdimm/virtio_pmem.h |   6 ++
 3 files changed, 136 insertions(+), 21 deletions(-)

-- 
2.52.0
