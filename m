Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDD3149C6F;
	Sat, 20 Dec 2025 08:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766219694; cv=pass; b=NtQBFrAxBOxLcCqfJuM3K57Urt/Y39eYVO36cTXzzZrXd7xTTxFwIhwmprgitYjdO/p5I1Qf5VBMKpNh1VnsyRrUb89a1ApOJWlpit/0L0MlwYXz3yMS9JCE/+U4s3jwiVGS+L0smMAZHiLGPPy5fhQjdyDC5TI3Fy5KmPZOm3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766219694; c=relaxed/simple;
	bh=tpmznDHENt14jliH3f98TfEG5xIJdraNF2S7imFW8oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pg6Wr0iRitFjnFHa2qSIFiLJZbY8/k551kdxR+xXs2nC6q5qHrJcXajVojv7fOCp3NTPQ7VEE69BRFQdVYrfv1VQj9iUy66kwRX7awDLU4oE7KF3C54vomK+txCDKqNy6OIQR5SUaB1Xo+jExLu07wKVt6e9uGjQM01sKRBcMS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=a0pehQiJ; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="a0pehQiJ"
ARC-Seal: i=1; a=rsa-sha256; t=1766219690; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dF5DOJZvW9T1+n++zKIR/qU+ylHyqWmIHxYz9HudzE8Uzpq2JbuvFj98zlUsC1wVYV8ggCIo1bfKdNag7DUuLklGo277LTwDm3y0/Z3D1QGHCsRf96gkJ4BDKb9VFYXVxCt+3Mzrd0Rjw1rkc6zer3BeCfTRm5dAp3QWNiMzfI8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766219690; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=NbY02tEWsrbkqORjWtXi/s643Exsi2F0ZJnFu5fk5K0=; 
	b=fwz6SqCBPhug0Ea2PRPnTYqK0gCEgdvKxSVwoTuMobvHqVt9ZQ86jiy0dndRbtbijlR2XTx6yGS6nFucIwVUeEYbTgojGi+FU74/TxUsjLz1Jg4EZUIgadXh38N0Zn/lsi63MRAZ6bBnsRmzqfF/OssfIh1j2rjtZoVctFr5U9A=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766219690;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=NbY02tEWsrbkqORjWtXi/s643Exsi2F0ZJnFu5fk5K0=;
	b=a0pehQiJLhsjX7NF/0jOlYtz8NpVOvisl9jAZKpu396ujRkC5vlYWlsN3O/61G6A
	UgEhlst3Y4ERUYSWwm6Epy1uLzxQGZnt8sFscCx7v6jfo7WBGUE5BBn94+mDIIaj7Ev
	Dj4ArzIcz0UEIawGBFbKHaHtdrM3N00fD15d2iyU=
Received: by mx.zohomail.com with SMTPS id 1766219687958241.7354956964989;
	Sat, 20 Dec 2025 00:34:47 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] nvdimm: virtio_pmem: fix request lifetime and converge broken queue failures
Date: Sat, 20 Dec 2025 16:34:36 +0800
Message-ID: <20251220083441.313737-1-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
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

1/4 nvdimm: virtio_pmem: always wake -ENOSPC waiters
Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled
from token completion, and use READ_ONCE()/WRITE_ONCE() for wait
flags.

2/4 nvdimm: virtio_pmem: refcount requests for token lifetime
Refcount request objects so the token lifetime spans the window
where it is reachable through the virtqueue until completion/drain
drops the virtqueue reference.

3/4 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
Track a device-level broken state to converge broken/notify
failures to -EIO: wake all waiters and drain/detach outstanding
requests to complete them with an error, and fail-fast new
requests.

4/4 nvdimm: virtio_pmem: drain requests in freeze
Drain outstanding requests in freeze() before tearing down
virtqueues so waiters do not sleep indefinitely.

Testing was done on QEMU x86_64 with a virtio-pmem device exported as
/dev/pmem0, formatted with ext4 (-O fast_commit), mounted with DAX, and
stressed with fsync-heavy workloads.

Thanks,
Li Chen

Li Chen (4):
  nvdimm: virtio_pmem: always wake -ENOSPC waiters
  nvdimm: virtio_pmem: refcount requests for token lifetime
  nvdimm: virtio_pmem: converge broken virtqueue to -EIO
  nvdimm: virtio_pmem: drain requests in freeze

 drivers/nvdimm/nd_virtio.c   | 134 +++++++++++++++++++++++++++++------
 drivers/nvdimm/virtio_pmem.c |  14 ++++
 drivers/nvdimm/virtio_pmem.h |   6 ++
 3 files changed, 133 insertions(+), 21 deletions(-)

-- 
2.51.0

