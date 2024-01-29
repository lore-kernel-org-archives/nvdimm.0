Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740EC157E66
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706562413; cv=none; b=YuWVSRLaJJlmxGsGg4oRr/Hbmt4Tlstq+9IoaV8H3rW3GQl0MEaJq+Bd/t8/6lcu6YdJnpVw+B/lwi+yO25g48Mujca6hj1AIpxIH7a5Mmmxy2Lth9V4/SkVmXDI6cOzcFrLrvKHEuCl2i1++TJ2SPIrRTY5BqJdXFHR1xJzkPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706562413; c=relaxed/simple;
	bh=K4VVElaY97sQQYGeAc34aX8mm/VX8BZpgLKGb7Mk6Jw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t35HuzsBAE9iN7PWAI8DNNF4T/UKCzin+ds2ZFRSOYdoRPBABwauinFIIo66KGpSlq3kxM/20bXMJj/5d30AUi1AXp1haTB8pH4D/u0aeUtsFXJHLh5TZXCxVfWDIIfmzyqBqkdDbe7KlxhiydJsjKDqSzYhWdpawdLsreAN0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=Lkdopncz; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="Lkdopncz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1706562409;
	bh=K4VVElaY97sQQYGeAc34aX8mm/VX8BZpgLKGb7Mk6Jw=;
	h=From:To:Cc:Subject:Date:From;
	b=Lkdopncz71c/Xl8mEy9+xgP1NtQ66UgWekcmwJxHLJvM0Aca1KjAyRvIf2eBppTfA
	 eZ8z0XfJkpuZOySPd7Yggh59oZyscBGePayQYNc5YKDttLWgiQipIpHSmwj57Wyr38
	 GTmJaOFafjQb5Z/imJKsaVn1B6/DwDPda8fOPrSPS7BM+U9u4Z0ZNa8kZjwU3phykv
	 5wvXn8+EQ4/w+kmzBGYd4HJy2x9lNF09xj6ciQy+Vd/bqBRlV72eADDunRpghi4Oa7
	 IFwDnQqDUgVhH5dED782CRDoSNZ/oc5o3bimfkdPxtSGoY0InQnXcc597lRHv5Bh20
	 yoNbHpGbs/bTw==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TP17s0mCGzVQZ;
	Mon, 29 Jan 2024 16:06:49 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [RFC PATCH 0/7] Introduce cache_is_aliasing() to fix DAX regression
Date: Mon, 29 Jan 2024 16:06:24 -0500
Message-Id: <20240129210631.193493-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit introduced in v5.13 prevents building FS_DAX on 32-bit ARM,
even on ARMv7 which does not have virtually aliased dcaches:

commit d92576f1167c ("dax: does not work correctly with virtual aliasing caches")

It used to work fine before: I have customers using dax over pmem on
ARMv7, but this regression will likely prevent them from upgrading their
kernel.

The root of the issue here is the fact that DAX was never designed to
handle virtually aliased dcache (VIVT and VIPT with aliased dcache). It
touches the pages through their linear mapping, which is not consistent
with the userspace mappings on virtually aliased dcaches. 

This patch series introduces cache_is_aliasing() with new Kconfig
options:

  * ARCH_HAS_CACHE_ALIASING
  * ARCH_HAS_CACHE_ALIASING_DYNAMIC

and implements it for all architectures. The "DYNAMIC" implementation
implements cache_is_aliasing() as a runtime check, which is what is
needed on architectures like 32-bit ARMV6 and ARMV6K.

With this we can basically narrow down the list of architectures which
are unsupported by DAX to those which are really affected.

Feedback is welcome,

Thanks,

Mathieu

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev

Mathieu Desnoyers (7):
  Introduce cache_is_aliasing() across all architectures
  dax: Fix incorrect list of cache aliasing architectures
  erofs: Use dax_is_supported()
  ext2: Use dax_is_supported()
  ext4: Use dax_is_supported()
  fuse: Introduce fuse_dax_is_supported()
  xfs: Use dax_is_supported()

 arch/arc/Kconfig                    |  1 +
 arch/arm/include/asm/cachetype.h    |  3 ++
 arch/arm/mm/Kconfig                 |  2 ++
 arch/csky/Kconfig                   |  1 +
 arch/m68k/Kconfig                   |  1 +
 arch/mips/Kconfig                   |  1 +
 arch/mips/include/asm/cachetype.h   |  9 +++++
 arch/nios2/Kconfig                  |  1 +
 arch/nios2/include/asm/cachetype.h  | 10 ++++++
 arch/parisc/Kconfig                 |  1 +
 arch/sh/Kconfig                     |  1 +
 arch/sparc/Kconfig                  |  1 +
 arch/sparc/include/asm/cachetype.h  | 14 ++++++++
 arch/xtensa/Kconfig                 |  1 +
 arch/xtensa/include/asm/cachetype.h | 10 ++++++
 fs/Kconfig                          |  2 +-
 fs/erofs/super.c                    | 10 +++---
 fs/ext2/super.c                     | 14 ++++----
 fs/ext4/super.c                     | 52 ++++++++++++++---------------
 fs/fuse/file.c                      |  2 +-
 fs/fuse/fuse_i.h                    | 36 +++++++++++++++++++-
 fs/fuse/inode.c                     | 47 +++++++++++++-------------
 fs/fuse/virtio_fs.c                 |  4 +--
 fs/xfs/xfs_super.c                  | 20 +++++++----
 include/linux/cacheinfo.h           |  8 +++++
 include/linux/dax.h                 |  9 +++++
 mm/Kconfig                          | 10 ++++++
 27 files changed, 198 insertions(+), 73 deletions(-)
 create mode 100644 arch/mips/include/asm/cachetype.h
 create mode 100644 arch/nios2/include/asm/cachetype.h
 create mode 100644 arch/sparc/include/asm/cachetype.h
 create mode 100644 arch/xtensa/include/asm/cachetype.h

-- 
2.39.2

