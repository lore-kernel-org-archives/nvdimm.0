Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F387733A9E1;
	Tue,  4 Aug 2026 06:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826416; cv=none; b=A1FIRkpVCkd5zJscITx1RhmUgp5jKIdxeRBGsndOcx9EJ7M6oG5qBawtHp1xpJ/krYHyxAEdSEG5xbuhSviE6we2vfP6FDPRrwiAaSP03qgLmezK7xiDqC8mIb7EHWMdXpJnZ1sv7hbHP4dSV+m+Tah9vQkl717TqoAAcX+2t7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826416; c=relaxed/simple;
	bh=fao//z/eP3KEIwqi5tYZ4oMAvgE0jCpV9ZpBd4OEW9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ncynyAznDuM3SOqnTIaFMGQZ4swApRV/T0sXLUni7Q3NJOPJKQ2oKOLlUWIzDiui/nU2ERVbChepJWGeXarGMxTOSx790RljMOTHb5t75OV6QSsPpN70COkLJfe+lhVuEx/oks32aSWWOEtJPIJgRTLwQMd5Xppqn8MoC8nXtCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRAkGd6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRAkGd6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0041F000E9;
	Tue,  4 Aug 2026 06:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785826414;
	bh=VWVPrEk+52tzx0Rhhgtr7Ya1aHTvGOt+4XML3uQJj9A=;
	h=From:To:Cc:Subject:Date;
	b=HRAkGd6gzVJgwfR6icTxqTgd1Rlu43ZNA5zZFtStBCAOynam6IMY9HCWb9GK8vJWd
	 uOdM+BvVgAgthosRUlVXAmHZPNwX3NKNZBL3gS4U9xL637R7mwZYDt4Z55SpWovOZ/
	 aR3E2g6qz5VEiUcs7c698FjI2cLGpjEq14wU4uydMzKLmKDwBvHJ6wdAVX4CMOxXBB
	 U9dcFBSrF01hZ9WglHLjp4m/kxWsAB2JgjMnlvXZvMCPnFPhta0yRXUXHcMkgebBuL
	 Jj2n24YgBPUHFVYa5tBY6fd0rNG1mkYCLFcAj0lup18MrF9wbomZHXXi0Q6D0Fk6VQ
	 Uadqdq7RKMMug==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Yu Kuai <yukuai@fygo.io>,
	Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Tue,  4 Aug 2026 14:53:10 +0800
Message-ID: <20260804065313.2092022-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This RFC is a preparatory series for the blkcg_mutex conversion proposed in
the blkcg_mutex RFC v2 series [1].  That series moves queue-local blkg
topology synchronization from q->queue_lock to q->blkcg_mutex.  A direct
conversion is awkward while bios store queue-local blkg references, because
bio allocation, bio_set_dev(), remap and clone paths can run in contexts
where creating a missing blkg must not sleep or is unnecessary.

This set makes the bio association queue-independent by storing the blkcg
in the bio instead of a blkg.  A blkg is looked up from the bio's blkcg and
current bdev only when blkcg policy or accounting code needs it.  The first
successful policy lookup pins the blkg with a bio-owned reference tracked by
BIO_BLKG_REF; the reference is dropped when the bio cgroup association is
cleared or when bio_set_dev() changes the lookup key.

Patch 1 adds accessors for the current bio cgroup state and factors out the
release path.  Patch 2 switches the stored bio association from blkg to blkcg,
adds lookup/create helpers for policy users, and converts the blkcg policies
and cloned-bio users.  Patch 3 moves async bio punt state from blkg to blkcg
so punted bios do not instantiate a queue-local blkg when no policy needs one.

This is v1 of this preparatory set; there is no previous version.

Related series:
  [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
      https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org

Yu Kuai (3):
  blk-cgroup: add helpers for bio cgroup state
  blk-cgroup: store blkcg in bio instead of blkg
  blk-cgroup: move async bio punt state to blkcg

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 block/bfq-cgroup.c                      |  14 +-
 block/bfq-iosched.c                     |  18 +-
 block/bio.c                             |  22 +--
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup.c                      | 251 +++++++++++++++---------
 block/blk-cgroup.h                      |  40 +++-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   2 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 drivers/nvdimm/nd_virtio.c              |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  20 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  10 +-
 22 files changed, 268 insertions(+), 172 deletions(-)

base-commit: f2690679ecf3a3151688ebef766dd2512ff95854
-- 
2.51.0
