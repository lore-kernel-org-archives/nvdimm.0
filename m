Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A612D2493;
	Thu, 25 Dec 2025 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766636974; cv=pass; b=YqnulMp9xL92G8yqEV+JiO6iZVFZV2AQ+C7/g74V9OasWk6PRY6gtQqv77iONlLTsQMkEipSrVDJQg3vE+6dS+W36hU4esTp7TR4YTjrvbP+M74aDRbm2l/VvaEqVhLXZFq72U8f9POR189tj/JDBuR/nX9fPxPqu/roogrUa4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766636974; c=relaxed/simple;
	bh=iS6Ww5ogJLT/fPRgvPD1UT8+Fm12IbhPJ+Dqxh6tNIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FTpZhWnfkqYBFsENvp7rESjltoxgaRPBEiXRwGneLgN1V8md58KYAMkX23mfr5qE6PFe8B+65epiEfsWt/V2HRrb/rq/nyA8dXvv/1D7wKEfMN6vUPfLmyaCPafTV3casv7n4/CZf8laJiBdbTFLlM7FJidGIRGXrpPaC/1Z9+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=sjsonEnk; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="sjsonEnk"
ARC-Seal: i=1; a=rsa-sha256; t=1766636964; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CBQEVSNnQ6aDEYbR7hE0ZmSMO8tDXVdZZeqtkOUh2StwPUKTZCDFwWYLOz8DL1URyKBoJypvwoabdiYuBVHhstUjzVPNdPBJ707MWxglybEVdD5Fx79tRcsSfJ4+OTq5SS+QJZrHBDoetoUoOoMbm5mMMfeHRcPg5vIaw175aEU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636964; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zgEGlt7a//oxYDZqnPqtX/qw7fztUbdoAlr5501ZNDE=; 
	b=ED9dtC3dKZf+9mhuLdThmLvdiDFSDBL3K98i5IiKTaFKALsPa6UtcCZ/zKL9nQeM7962c3UsJHxlseLAqtKJkOkekGGT00eZfBfkYwqM14rE+MyHVIsBNT8ElkFHV0Sb++VcOW40HhvoHGaI1sJXwIUiIljZv0Eg5oiHkqbrZz4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636964;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=zgEGlt7a//oxYDZqnPqtX/qw7fztUbdoAlr5501ZNDE=;
	b=sjsonEnk9JLR20oC6lLB6CVEfOtOC2zWO83wvFt1k+0fIeXD3+lD7pvMcwmRhqUY
	vff1olel9ghjMzJE0W7YH1LTCx8ylaW+SE2NIRD2+BZlK6u7QW18zTQ9t4qVDqsV4ep
	VOz+FSqaVWBw85Rb4xIWCCgCe5ZHP3EpZy5kNAsU=
Received: by mx.zohomail.com with SMTPS id 1766636961796446.1801334309754;
	Wed, 24 Dec 2025 20:29:21 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/4] nvdimm: virtio_pmem: fix request lifetime and converge broken queue failures
Date: Thu, 25 Dec 2025 12:29:08 +0800
Message-ID: <20251225042915.334117-1-me@linux.beauty>
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
Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled
from token completion, and use READ_ONCE()/WRITE_ONCE() for wait
flags.

2/5 nvdimm: virtio_pmem: refcount requests for token lifetime
Refcount request objects so the token lifetime spans the window
where it is reachable through the virtqueue until completion/drain
drops the virtqueue reference.

3/5 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Track a device-level broken state to converge broken/notify
failures to -EIO: wake all waiters and drain/detach outstanding
requests to complete them with an error, and fail-fast new
requests.

4/5 nvdimm: virtio_pmem: drain requests in freeze
Drain outstanding requests in freeze() before tearing down
virtqueues so waiters do not sleep indefinitely.

5/5 nvdimm: nd_virtio: export virtio_pmem_mark_broken_and_drain
Export symbol to fix compile issue.

Testing was done on QEMU x86_64 with a virtio-pmem device exported as
/dev/pmem0, formatted with ext4 (-O fast_commit), mounted with DAX, and
stressed with fsync-heavy workloads.

Changelog:
v1->v2: add patch 5 to fix compile issue.

v1: https://www.spinics.net/lists/kernel/msg5974818.html

Thanks,
Li Chen

Li Chen (5):
  nvdimm: virtio_pmem: always wake -ENOSPC waiters
  nvdimm: virtio_pmem: refcount requests for token lifetime
  nvdimm: virtio_pmem: converge broken virtqueue to -EIO
  nvdimm: virtio_pmem: drain requests in freeze
  nvdimm: nd_virtio: export virtio_pmem_mark_broken_and_drain

 drivers/nvdimm/nd_virtio.c   | 135 +++++++++++++++++++++++++++++------
 drivers/nvdimm/virtio_pmem.c |  14 ++++
 drivers/nvdimm/virtio_pmem.h |   6 ++
 3 files changed, 134 insertions(+), 21 deletions(-)

-- 
2.52.0

