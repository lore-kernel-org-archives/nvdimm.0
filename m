Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E240D270552
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883685; cv=none; b=k1ztOz8pNmnmo8+VH+NYuqkuR+A6iFWRCXmIp8SMsnGcqLtQwbrCk+cMjM3qzxWdEIX3oMB5PpJNsT/jSetS30rg0uGzdbUwEwDuOOAryeP1QduIscUZ4vz1wYAiy0ELgVfC8OtRrazeCSeaLAZLdaYcAvOOqZGYa++S9tbW5wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883685; c=relaxed/simple;
	bh=7UcUR5lCvxDy0SLAVVFsa8ql0sLJma4x+kV9cH+1T88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLHJs2AOEv8lRgWS7I9vUztMNhDz9Q9R/djypIiLMT/hlW3cwX6ASiljKOQ38WOr7aLAtAP6rKjuIcFk8LVrP7JlZLt2+gfCqPHlfkrpfhzG1opITyONQ+aT3pfpiR8OG5sYCbVO0SjCMMX+yz4MtsT3sH0pl9ZIcgMpbMiYArk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B51031602AE;
	Thu, 19 Mar 2026 01:27:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf16.hostedemail.com (Postfix) with ESMTPA id 22F9A20024;
	Thu, 19 Mar 2026 01:27:48 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V8 0/8] dax: prepare for famfs
Date: Wed, 18 Mar 2026 20:27:37 -0500
Message-ID: <20260318202737.4344.dax@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318202722.4344.compound@groves.net>
References: <20260318202722.4344.compound@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: goagexkbybxceyutdtn58r57s9sd4d36
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 22F9A20024
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/b55gS/FmiRxS57BmrALX/2fxrLRnSGRs=
X-HE-Tag: 1773883668-129441
X-HE-Meta: U2FsdGVkX1/032cNReoyAV4Q2UIrwJg/wAObjC7/y62w+h+xi4QWVHFSIzEOXNwh06NuR/26/Os4UAleoyovylpkQ7k02My8adPYsgsgNjxk8tqU2i5yopoVAq03AemXZsurjXZnxBhf0qH2m+iS7OWuJ1pxC/inMiJnxxBOW5DIatDUvOCzQ8u/YCJzRE9+wHJXPwxm9KyO4j+8JGrdLgNOLYSL9WtsOCjvUXlwaPeTysFFQJj9iX7G+ackF+a2eCUbYl3HCFIFMD4bYMPXy7cCoU0zGRtuH6wNaL0O6J2cPbt2UlCIGNWEA7QEbYou9J836UUEgBxOfjHLl+42o3j6RTNCo1xuAzEnjdRVHrf2l6DuyxZFN49n5AftQTEIpZk3wW9VlPMBqsBL/S9I8raRrckbHZ7Aa3x2NckWNDz3kXUOxdXKqlcnH8GEwuSa/h2W9tQ/7tSI8jkMJofq3jAGBQdv6PAMWwNdm74lIc9df+uaYhUurG4WVATfc3QEYmKkCXc873Q=

This patch series along with the bundled patches to fuse are available
as a git tag at [0].

Changes v7 -> v8
- dax: Added a devm action to clear folio state when unbinding fsdev.c
  (thanks Allison)
- Added a missing device_lock() in fs_dax_get() (thanks Dave)
- Re-factored some __free blocks for inline declaration
- Used FIELD_PREP where appropriate
- Minor doc edits

Description:

This patch series introduces the required dax support for famfs.
Previous versions of the famfs series included both dax and fuse patches.
This series separates them into separate patch series' (and the fuse
series dependends on this dax series).

The famfs user space code can be found at [1]

Dax Overview:

This series introduces a new "famfs mode" of devdax, whose driver is
drivers/dax/fsdev.c. This driver supports dax_iomap_rw() and
dax_iomap_fault() calls against a character dax instance. A dax device
now can be converted among three modes: 'system-ram', 'devdax' and
'famfs' via daxctl or sysfs (e.g. unbind devdax and bind famfs instead).

In famfs mode, a dax device initializes its pages consistent with the
fsdaxmode of pmem. Raw read/write/mmap are not supported in this mode,
but famfs is happy in this mode - using dax_iomap_rw() for read/write and
dax_iomap_fault() for mmap faults.


Changes v6 -> v7
- Fixed a regression in famfs_interleave_fileofs_to_daxofs() that
  was reported by Intel's kernel test robot
- Added a check in __fsdev_dax_direct_access() for negative return
  from pgoff_to_phys(), which would indicate an out-of-range offset
- Fixed a bug in __famfs_meta_free(), where not all interleaved
  extents were freed
- Added chunksize alignment checks in famfs_fuse_meta_alloc() and
  famfs_interleave_fileofs_to_daxofs() as interleaved chunks must
  be PTE or PMD aligned
- Simplified famfs_file_init_dax() a bit
- Re-ran CM's kernel code review prompts on the entire series and
  fixed several minor issues

Changes v4 -> v5 -> v6
- None. Re-sending due to technical difficulties

Changes v3 [9] -> v4
- The patch "dax: prevent driver unbind while filesystem holds device"
  has been dropped. Dan Williams indicated that the favored behavior is
  for a file system to stop working if an underlying driver is unbound,
  rather than preventing the unbind.
- The patch "famfs_fuse: Famfs mount opt: -o shadow=<shadowpath>" has
  been dropped. Found a way for the famfs user space to do without the
  -o opt (via getxattr).
- Squashed the fs/fuse/Kconfig patch into the first subsequent patch
  that needed the change
  ("famfs_fuse: Basic fuse kernel ABI enablement for famfs")
- Many review comments addressed.
- Addressed minor kerneldoc infractions reported by test robot.

Changes v2 [7] -> v3
- Dax: Completely new fsdev driver (drivers/dax/fsdev.c) replaces the
  dev_dax_iomap modifications to bus.c/device.c. Devdax devices can now
  be switched among 'devdax', 'famfs' and 'system-ram' modes via daxctl
  or sysfs.
- Dax: fsdev uses MEMORY_DEVICE_FS_DAX type and leaves folios at order-0
  (no vmemmap_shift), allowing fs-dax to manage folio lifecycles
  dynamically like pmem does.
- Dax: The "poisoned page" problem is properly fixed via
  fsdev_clear_folio_state(), which clears stale mapping/compound state
  when fsdev binds. The temporary WARN_ON_ONCE workaround in fs/dax.c
  has been removed.
- Dax: Added dax_set_ops() so fsdev can set dax_operations at bind time
  (and clear them on unbind), since the dax_device is created before we
  know which driver will bind.
- Dax: Added custom bind/unbind sysfs handlers; unbind return -EBUSY if a
  filesystem holds the device, preventing unbind while famfs is mounted.
- Fuse: Famfs mounts now require that the fuse server/daemon has
  CAP_SYS_RAWIO because they expose raw memory devices.
- Fuse: Added DAX address_space_operations with noop_dirty_folio since
  famfs is memory-backed with no writeback required.
- Rebased to latest kernels, fully compatible with Alistair Popple
  et. al's recent dax refactoring.
- Ran this series through Chris Mason's code review AI prompts to check
  for issues - several subtle problems found and fixed.
- Dropped RFC status - this version is intended to be mergeable.

Changes v1 [8] -> v2:

- The GET_FMAP message/response has been moved from LOOKUP to OPEN, as
  was the pretty much unanimous consensus.
- Made the response payload to GET_FMAP variable sized (patch 12)
- Dodgy kerneldoc comments cleaned up or removed.
- Fixed memory leak of fc->shadow in patch 11 (thanks Joanne)
- Dropped many pr_debug and pr_notice calls


References

[0] - https://github.com/jagalactic/linux/tree/famfs-v8 (this patch set)
[1] - https://famfs.org (famfs user space)
[2] - https://lore.kernel.org/linux-cxl/cover.1708709155.git.john@groves.net/
[3] - https://lore.kernel.org/linux-cxl/cover.1714409084.git.john@groves.net/
[4] - https://lwn.net/Articles/983105/ (lsfmm 2024)
[5] - https://lwn.net/Articles/1020170/ (lsfmm 2025)
[6] - https://lore.kernel.org/linux-cxl/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec4.1740713401.git-series.apopple@nvidia.com/
[7] - https://lore.kernel.org/linux-fsdevel/20250703185032.46568-1-john@groves.net/ (famfs fuse v2)
[8] - https://lore.kernel.org/linux-fsdevel/20250421013346.32530-1-john@groves.net/ (famfs fuse v1)
[9] - https://lore.kernel.org/linux-fsdevel/20260107153244.64703-1-john@groves.net/T/#mb2c868801be16eca82dab239a1d201628534aea7 (famfs fuse v3)

John Groves (8):
  dax: move dax_pgoff_to_phys from [drivers/dax/] device.c to bus.c
  dax: Factor out dax_folio_reset_order() helper
  dax: add fsdev.c driver for fs-dax on character dax
  dax: Save the kva from memremap
  dax: Add dax_operations for use by fs-dax on fsdev dax
  dax: Add dax_set_ops() for setting dax_operations at bind time
  dax: Add fs_dax_get() func to prepare dax for fs-dax usage
  dax: export dax_dev_get()

 MAINTAINERS               |   8 +
 drivers/dax/Makefile      |   6 +
 drivers/dax/bus.c         |  30 +++-
 drivers/dax/bus.h         |   3 +
 drivers/dax/dax-private.h |   3 +
 drivers/dax/device.c      |  23 ---
 drivers/dax/fsdev.c       | 353 ++++++++++++++++++++++++++++++++++++++
 drivers/dax/super.c       | 107 +++++++++++-
 fs/dax.c                  |  61 +++++--
 include/linux/dax.h       |  21 ++-
 10 files changed, 565 insertions(+), 50 deletions(-)
 create mode 100644 drivers/dax/fsdev.c


base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.53.0

