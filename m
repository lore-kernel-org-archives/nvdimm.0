Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665D2C9C
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=fKwV65Fx615k5LuIXkLcfiAVy//BhvLpTdyb0R61khg=; b=UBIrT7SYvmrOGapKs/IMJGZMJP
	rULomygyaaC55QDvs3eY68CeMZN8/C+Un5dhwOktX57xJXfoja7le1xanp8IT24T92jgKNogsi73U
	Vs9CL78FLc7OFzeln9OiPi/7vaiOEWqV6C55F6pZVXdbLeEo8ldf619JOUh2kLdEvFbEbfs4LZxZ3
	5qvQi9MVLtXFESagqUxWxaF5WV+V5JcZMy4pHRWVG/clCxw7rfcEHb30WuSh5pYSBuzRIj8PeF+Sn
	rhE6DpzHH+K5CChoU7tggXhlh61KLf/GmLxZLyL2cNDul5XrR+6rl7Cq4CkAIe4DZ9r8zj1m7ij2G
	Wyu4LoIQ==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3sV-002rks-4y; Thu, 10 Feb 2022 07:28:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: start sorting out the ZONE_DEVICE refcount mess v2
Date: Thu, 10 Feb 2022 08:28:01 +0100
Message-Id: <20220210072828.2930359-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series removes the offset by one refcount for ZONE_DEVICE pages
that are freed back to the driver owning them, which is just device
private ones for now, but also the planned device coherent pages
and the ehanced p2p ones pending.

It does not address the fsdax pages yet, which will be attacked in a
follow on series.

Note that if we want to get the p2p series rebased on top of this
we'll need a git branch for this series.  I could offer to host one.

A git tree is available here:

    git://git.infradead.org/users/hch/misc.git pgmap-refcount

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/pgmap-refcount

Changes since v1:
 - add a missing memremap.h include in memcontrol.c
 - include rebased versions of the device coherent support and
   device coherent migration support series as well as additional
   cleanup patches

Diffstt:
 arch/arm64/mm/mmu.c                      |    1 
 arch/powerpc/kvm/book3s_hv_uvmem.c       |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   35 -
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |    1 
 drivers/gpu/drm/drm_cache.c              |    2 
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    3 
 drivers/gpu/drm/nouveau/nouveau_svm.c    |    1 
 drivers/infiniband/core/rw.c             |    1 
 drivers/nvdimm/pmem.h                    |    1 
 drivers/nvme/host/pci.c                  |    1 
 drivers/nvme/target/io-cmd-bdev.c        |    1 
 fs/Kconfig                               |    2 
 fs/fuse/virtio_fs.c                      |    1 
 include/linux/hmm.h                      |    9 
 include/linux/memremap.h                 |   36 +
 include/linux/migrate.h                  |    1 
 include/linux/mm.h                       |   59 --
 lib/test_hmm.c                           |  353 ++++++++++---
 lib/test_hmm_uapi.h                      |   22 
 mm/Kconfig                               |    7 
 mm/Makefile                              |    1 
 mm/gup.c                                 |  127 +++-
 mm/internal.h                            |    3 
 mm/memcontrol.c                          |   19 
 mm/memory-failure.c                      |    8 
 mm/memremap.c                            |   75 +-
 mm/migrate.c                             |  763 ----------------------------
 mm/migrate_device.c                      |  822 +++++++++++++++++++++++++++++++
 mm/rmap.c                                |    5 
 mm/swap.c                                |   49 -
 tools/testing/selftests/vm/Makefile      |    2 
 tools/testing/selftests/vm/hmm-tests.c   |  204 ++++++-
 tools/testing/selftests/vm/test_hmm.sh   |   24 
 33 files changed, 1552 insertions(+), 1088 deletions(-)
