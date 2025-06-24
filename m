Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37369BA49
	for <nvdimm@lists.linux.dev>; Tue, 24 Jun 2025 07:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750750458; cv=none; b=GXCC5Q/Ittm1q9GdOph8Q/O8a5fyY2rWs1ws9sYzLDr/onjELxjLfxW/awe+OlNpcOubSDkL5JorjO8gyOvu4LepyERyUi34/Pok70/+f5YsvBY7P4nY47JewjbvLge7zh6S2exxidE1KFEewORKmeF/bGjw+AEVz8MrhDnNpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750750458; c=relaxed/simple;
	bh=ZGjLhU1aPnVRUxe4UTS7H9Ue8kRbCqGnj+Wp7TuisRs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jQRB+8XMRm8DxmLN026bpk+tQiKkf39O4qqDpoR/7/WyrAY/sRR10r55r5mKMCgHRj7Sx3k6cZ9tn60q5IUM+ZXU1nRDIitbYv232kxov5u9MJXfx4WRJFXN3se2UjPg3MHyOczZGT8B7BqqrKgOUX2ue1psuQmZ08W/6uXoys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xEDfWkSu; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xEDfWkSu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750750453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vg2iyvp4fqWHcV5mfOcpjoLqyrEUQCSh1ms+/k+GFIM=;
	b=xEDfWkSuHgTQw1g9LN5h31OOixeV1zBzSHhV9j86Rg0OCHrf8dSzvMlWy8yDJ1hosa7Z0i
	SY/nhvi/iQ9BzCe9qvQBiWLTQfwJcMUxzePckFZF1pKBLySmBQ8AaeUYvaLNlPdS7HnmDW
	VUyxzeSwM1TYxgvFPXNz6BY9i/NCXY4=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	Jonathan.Cameron@Huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v1 00/11] dm-pcache – persistent-memory cache for block devices
Date: Tue, 24 Jun 2025 07:33:47 +0000
Message-ID: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Mikulas,
	This is V1 for dm-pcache, please take a look.

Code:
    https://github.com/DataTravelGuide/linux tags/pcache_v1

Changelogs from RFC-V2:
	- use crc32c to replace crc32
	- only retry pcache_req when cache full, add pcache_req into defer_list,
	  and wait cache invalidation happen.
	- new format for pcache table, it is more easily extended with
	  new parameters later.
	- remove __packed.
	- use spin_lock_irq in req_complete_fn to replace
	  spin_lock_irqsave.
	- fix bug in backing_dev_bio_end with spin_lock_irqsave.
	- queue_work() inside spinlock.
	- introduce inline_bvecs in backing_dev_req.
	- use kmalloc_array for bvecs allocation.
	- calculate ->off with dm_target_offset() before use it.

Dongsheng Yang (11):
  dm-pcache: add pcache_internal.h
  dm-pcache: add backing device management
  dm-pcache: add cache device
  dm-pcache: add segment layer
  dm-pcache: add cache_segment
  dm-pcache: add cache_writeback
  dm-pcache: add cache_gc
  dm-pcache: add cache_key
  dm-pcache: add cache_req
  dm-pcache: add cache core
  dm-pcache: initial dm-pcache target

 .../admin-guide/device-mapper/dm-pcache.rst   | 201 ++++
 MAINTAINERS                                   |   8 +
 drivers/md/Kconfig                            |   2 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-pcache/Kconfig                  |  17 +
 drivers/md/dm-pcache/Makefile                 |   3 +
 drivers/md/dm-pcache/backing_dev.c            | 292 ++++++
 drivers/md/dm-pcache/backing_dev.h            |  88 ++
 drivers/md/dm-pcache/cache.c                  | 444 +++++++++
 drivers/md/dm-pcache/cache.h                  | 607 ++++++++++++
 drivers/md/dm-pcache/cache_dev.c              | 299 ++++++
 drivers/md/dm-pcache/cache_dev.h              |  70 ++
 drivers/md/dm-pcache/cache_gc.c               | 170 ++++
 drivers/md/dm-pcache/cache_key.c              | 907 ++++++++++++++++++
 drivers/md/dm-pcache/cache_req.c              | 810 ++++++++++++++++
 drivers/md/dm-pcache/cache_segment.c          | 293 ++++++
 drivers/md/dm-pcache/cache_writeback.c        | 276 ++++++
 drivers/md/dm-pcache/dm_pcache.c              | 467 +++++++++
 drivers/md/dm-pcache/dm_pcache.h              |  65 ++
 drivers/md/dm-pcache/pcache_internal.h        | 116 +++
 drivers/md/dm-pcache/segment.c                |  61 ++
 drivers/md/dm-pcache/segment.h                |  73 ++
 22 files changed, 5270 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-pcache.rst
 create mode 100644 drivers/md/dm-pcache/Kconfig
 create mode 100644 drivers/md/dm-pcache/Makefile
 create mode 100644 drivers/md/dm-pcache/backing_dev.c
 create mode 100644 drivers/md/dm-pcache/backing_dev.h
 create mode 100644 drivers/md/dm-pcache/cache.c
 create mode 100644 drivers/md/dm-pcache/cache.h
 create mode 100644 drivers/md/dm-pcache/cache_dev.c
 create mode 100644 drivers/md/dm-pcache/cache_dev.h
 create mode 100644 drivers/md/dm-pcache/cache_gc.c
 create mode 100644 drivers/md/dm-pcache/cache_key.c
 create mode 100644 drivers/md/dm-pcache/cache_req.c
 create mode 100644 drivers/md/dm-pcache/cache_segment.c
 create mode 100644 drivers/md/dm-pcache/cache_writeback.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.h
 create mode 100644 drivers/md/dm-pcache/pcache_internal.h
 create mode 100644 drivers/md/dm-pcache/segment.c
 create mode 100644 drivers/md/dm-pcache/segment.h

-- 
2.43.0

