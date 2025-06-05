Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8640B1EB5CE;
	Thu,  5 Jun 2025 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749133433; cv=none; b=dI9S8SdEW71/LDVKYEsKg+KWB9iNr5qVJ4edpwJoDS6aoP+1+og1JxhBmQ/Gap9zrCjK9FxsR2U98c3g0Rz0Fct7Pg+Eb/XOpsw609dsYm/5MtvhKM0aDPsY8Yz0KD2gn2JGWIOKCWmyVx8kPUK8oLHGpR3Wqmi6OlYpjB8zEwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749133433; c=relaxed/simple;
	bh=TdGonRu2CP9wmNv36VaNXN5SJd7fDe1WKLdw6M4RQcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ng8afXANV7o77Njk2OyvMSps8Ph0SzJFCZKZKeJSkn7h9E1I++sSKTHNDDQAtp/ndHxh1CStZC/5NdKTt43TbyRuB4N9TqPmkYNQ3kSranq4nnFQytfmG3Y2TM0LbZ1HiQLleamwWI9DXQ5QUqoAGuqaAittlukxhCHFsP8We0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lH7Z4DBw; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lH7Z4DBw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749133418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TiuGB6Udmi6CtNlTJQ+UzrVJuLBs5/tk4UZYmqS+F4o=;
	b=lH7Z4DBw1WmJ/FEgE+syjxGOPkMum3fuiB9DTRdt/Ep6G2VTlxcmLBMy4tyHW6pyX8MVdZ
	s5zkK7KNHtGT+3TpXu5/rV/9JJJBHxsGKzui65rbavdeGIFqzzRt0LOfR0YXYXkYxOe1K7
	MkW25ahj59xvMSEZiXU5SQvdLfdVtu8=
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
Subject: [RFC v2 00/11] dm-pcache – persistent-memory cache for block devices
Date: Thu,  5 Jun 2025 14:22:55 +0000
Message-Id: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Mikulas and all,

This is *RFC v2* of the *pcache* series, a persistent-memory backed cache.
Compared with *RFC v1* 
<https://lore.kernel.org/lkml/20250414014505.20477-1-dongsheng.yang@linux.dev/>  
the most important change is that the whole cache has been *ported to
the Device-Mapper framework* and is now exposed as a regular DM target.

Code:
    https://github.com/DataTravelGuide/linux/tree/dm-pcache

Full RFC v2 test results:
    https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/results.html

    All 962 xfstests cases passed successfully under four different
pcache configurations.

    One of the detailed xfstests run:
        https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/test-results/02-._pcache.py_PcacheTest.test_run-crc-enable-gc-gc0-test_script-xfstests-a515/debug.log

Below is a quick tour through the three layers of the implementation,
followed by an example invocation.

----------------------------------------------------------------------
1. pmem access layer
----------------------------------------------------------------------

* All reads use *copy_mc_to_kernel()* so that uncorrectable media
  errors are detected and reported.
* All writes go through *memcpy_flushcache()* to guarantee durability
  on real persistent memory.

----------------------------------------------------------------------
2. cache-logic layer (segments / keys / workers)
----------------------------------------------------------------------

Main features
  - 16 MiB pmem segments, log-structured allocation.
  - Multi-subtree RB-tree index for high parallelism.
  - Optional per-entry *CRC32* on cached data.
  - Background *write-back* worker and watermark-driven *GC*.
  - Crash-safe replay: key-sets are scanned from *key_tail* on start-up.

Current limitations
  - Only *write-back* mode implemented.
  - Only FIFO cache invalidate; other (LRU, ARC...) planned.

----------------------------------------------------------------------
3. dm-pcache target integration
----------------------------------------------------------------------

* Table line  
    `pcache <pmem_dev> <origin_dev> writeback <true|false>`
* Features advertised to DM:
  - `ti->flush_supported = true`, so *PREFLUSH* and *FUA* are honoured
    (they force all open key-sets to close and data to be durable).
* Not yet supported:
  - Discard / TRIM.
  - dynamic `dmsetup reload`.

Runtime controls
  - `dmsetup message <dev> 0 gc_percent <0-90>` adjusts the GC trigger.

Status line reports super-block flags, segment counts, GC threshold and
the three tail/head pointers (see the RST document for details).

----------------------------------------------------------------------
Example
----------------------------------------------------------------------
# 1. create a pmem and ssd
pmem=/dev/pmem0
ssd=/dev/sdb

# 2. map a pcache device in front.
dmsetup create pcache_sdb --table \
  "0 $(blockdev --getsz $ssd) pcache $pmem $ssd writeback true"

# 3. format and mount
mkfs.ext4 /dev/mapper/pcache_sdb
mount /dev/mapper/pcache_sdb /mnt

# 4. tune GC to 80 %
dmsetup message pcache_sdb 0 gc_percent 80

# 5. monitor
watch -n1 'dmsetup status pcache_sdb'

Testing:
    The test suite for pcache is hosted in the dtg-tests project, built
on top of the Avocado Framework. It includes currently:
        - Management-related test cases for pcache devices.
        - Data verification and validation tests.
        - Complete execution of xfstests suite under multiple
          configurations.

Thanx
Dongsheng

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

 .../admin-guide/device-mapper/dm-pcache.rst   | 200 ++++
 MAINTAINERS                                   |   9 +
 drivers/md/Kconfig                            |   2 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-pcache/Kconfig                  |  17 +
 drivers/md/dm-pcache/Makefile                 |   3 +
 drivers/md/dm-pcache/backing_dev.c            | 305 ++++++
 drivers/md/dm-pcache/backing_dev.h            |  84 ++
 drivers/md/dm-pcache/cache.c                  | 443 +++++++++
 drivers/md/dm-pcache/cache.h                  | 601 ++++++++++++
 drivers/md/dm-pcache/cache_dev.c              | 310 ++++++
 drivers/md/dm-pcache/cache_dev.h              |  70 ++
 drivers/md/dm-pcache/cache_gc.c               | 170 ++++
 drivers/md/dm-pcache/cache_key.c              | 907 ++++++++++++++++++
 drivers/md/dm-pcache/cache_req.c              | 810 ++++++++++++++++
 drivers/md/dm-pcache/cache_segment.c          | 300 ++++++
 drivers/md/dm-pcache/cache_writeback.c        | 239 +++++
 drivers/md/dm-pcache/dm_pcache.c              | 388 ++++++++
 drivers/md/dm-pcache/dm_pcache.h              |  61 ++
 drivers/md/dm-pcache/pcache_internal.h        | 116 +++
 drivers/md/dm-pcache/segment.c                |  63 ++
 drivers/md/dm-pcache/segment.h                |  74 ++
 22 files changed, 5173 insertions(+)
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
2.34.1

