Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A02F3632
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883881; cv=none; b=WcMP0qvA6r7DuWHKhxoE0liK2/pVYoJ+1mllUpoLrnOg0SQ/CM9EDeGx5d34ggvhIzzXvFfdwHAU+3N1LM4uYhLugesVKQyPDykeW0+m2jidBaLGgSXNWMljPM1rGf9XNGPAE+pGebtZbcmqCEkls0c0P7R7CBWT+fX+5Igo3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883881; c=relaxed/simple;
	bh=/NsYjFFJwnaYfAoDPcUjpecHLJg6gobiv2bpANNUuxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeZogY9t+tPUTWEDXhZCpl5X8ADKK0A447ebrsn+xlIaTLNdvkK0f4viqGXiQFCOp2oLfJnfJa+xP3MthPEIby8HNmH7cnJGsgzUobX7DaHia5SqzbGO61a4l6CxIVEO8Efltz94VH6+nKyuHDqKUbd/yPmSrkf5ZENm6M4ubKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9DD71602D7;
	Thu, 19 Mar 2026 01:31:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf04.hostedemail.com (Postfix) with ESMTPA id 31B0520027;
	Thu, 19 Mar 2026 01:30:57 +0000 (UTC)
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
Subject: [PATCH V8 00/10] famfs: port into fuse
Date: Wed, 18 Mar 2026 20:30:55 -0500
Message-ID: <20260318203054.4344.fuse@groves.net>
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
X-Stat-Signature: shpbts3f7ybyibm65bm7ghiksnai71rp
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 31B0520027
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18cv3ClWvjSbKYZiElrOQHq0dyXlJthrGw=
X-HE-Tag: 1773883857-710946
X-HE-Meta: U2FsdGVkX1+C3j6D/gDDjdVUWrKJDI6+QQc+ZdinBWbXqZ/oir1m7vOu9F5wKF+JhOYba1WiCGZLRo1BWvIfek9gFAY3+c4pGWlBJ6v+vm4G+AZYPC0ILLDIEpNjn2IEAnzQ/M/w1Wc9MEV3IGyRvbxKbGKzLLbYs7s3CRuqnl93J5qcyg14llJJKcIA5tLftwaQuPc9FFxwpb8w8eweGsB7NWs9WhLdad5H18zBN4oaDD8S0cGokyUrzngYUA8t0m92XNHHJQv+hcafUmpccEQPT4Rpr5wpvfqTEvh5KgtIqhWha4QqgWKQexc82NkHHMiBAeNNXhFXlnuzrUuQ8x7NTGXhBtU1zLIPJizIDTOWZwooqJVWgdWCGt2j2HECCsFtfWuoy5pkn7JnAf93Db1BKwWO5ang9JrOvejNMdojCOl7c5dHcyz9Yulc8NKGK0GpzZ4iNKqR8QvJik2wwBDWA3BuabqwH8pieES05IJny2RfbUjtCnfZOhpNUZEL5d0o1sDLBoo=

This patch series on top of the prerequisite patches to dax are
xavailable as a git tag at [0].

Changes v7 -> v8
Changes v7 -> v8
- Moved to inline __free declaration in fuse_get_fmap() and
  famfs_fuse_meta_alloc(), famfs_teardown()
- Adopted FIELD_PREP() macro rather than manual bitfield manipulation
- Minor doc edits
- I dropped adding magic numbers to include/uapi/linux/magic.h. That
  can be done later if appropriate

Description:

This patch series introduces famfs into the fuse file system framework.
Famfs depends on the bundled dax patch set.

The famfs user space code can be found at [1].

Fuse Overview:

Famfs started as a standalone file system, but this series is intended to
permanently supersede that implementation. At a high level, famfs adds
two new fuse server messages:

GET_FMAP   - Retrieves a famfs fmap (the file-to-dax map for a famfs
	     file)
GET_DAXDEV - Retrieves the details of a particular daxdev that was
	     referenced by an fmap

Famfs Overview

Famfs exposes shared memory as a file system. Famfs consumes shared
memory from dax devices, and provides memory-mappable files that map
directly to the memory - no page cache involvement. Famfs differs from
conventional file systems in fs-dax mode, in that it handles in-memory
metadata in a sharable way (which begins with never caching dirty shared
metadata).

Famfs started as a standalone file system [2,3], but the consensus at
LSFMM was that it should be ported into fuse [4,5].

The key performance requirement is that famfs must resolve mapping faults
without upcalls. This is achieved by fully caching the file-to-devdax
metadata for all active files. This is done via two fuse client/server
message/response pairs: GET_FMAP and GET_DAXDEV.

Famfs remains the first fs-dax file system that is backed by devdax
rather than pmem in fs-dax mode (hence the need for the new dax mode).

Notes

- When a file is opened in a famfs mount, the OPEN is followed by a
  GET_FMAP message and response. The "fmap" is the full file-to-dax
  mapping, allowing the fuse/famfs kernel code to handle
  read/write/fault without any upcalls.

- After each GET_FMAP, the fmap is checked for extents that reference
  previously-unknown daxdevs. Each such occurrence is handled with a
  GET_DAXDEV message and response.

- Daxdevs are stored in a table (which might become an xarray at some
  point). When entries are added to the table, we acquire exclusive
  access to the daxdev via the fs_dax_get() call (modeled after how
  fs-dax handles this with pmem devices). Famfs provides
  holder_operations to devdax, providing a notification path in the
  event of memory errors or forced reconfiguration.

- If devdax notifies famfs of memory errors on a dax device, famfs
  currently blocks all subsequent accesses to data on that device. The
  recovery is to re-initialize the memory and file system. Famfs is
  memory, not storage...

- Because famfs uses backing (devdax) devices, only privileged mounts are
  supported (i.e. the fuse server requires CAP_SYS_RAWIO).

- The famfs kernel code never accesses the memory directly - it only
  facilitates read, write and mmap on behalf of user processes, using
  fmap metadata provided by its privileged fuse server. As such, the
  RAS of the shared memory affects applications, but not the kernel.

- Famfs has backing device(s), but they are devdax (char) rather than
  block. Right now there is no way to tell the vfs layer that famfs has a
  char backing device (unless we say it's block, but it's not). Currently
  we use the standard anonymous fuse fs_type - but I'm not sure that's
  ultimately optimal (thoughts?)

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

John Groves (10):
  famfs_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
  famfs_fuse: Basic fuse kernel ABI enablement for famfs
  famfs_fuse: Plumb the GET_FMAP message/response
  famfs_fuse: Create files with famfs fmaps
  famfs_fuse: GET_DAXDEV message and daxdev_table
  famfs_fuse: Plumb dax iomap and fuse read/write/mmap
  famfs_fuse: Add holder_operations for dax notify_failure()
  famfs_fuse: Add DAX address_space_operations with noop_dirty_folio
  famfs_fuse: Add famfs fmap metadata documentation
  famfs_fuse: Add documentation

 Documentation/filesystems/famfs.rst |  142 ++++
 Documentation/filesystems/index.rst |    1 +
 MAINTAINERS                         |   10 +
 fs/fuse/Kconfig                     |   14 +
 fs/fuse/Makefile                    |    1 +
 fs/fuse/dir.c                       |    2 +-
 fs/fuse/famfs.c                     | 1180 +++++++++++++++++++++++++++
 fs/fuse/famfs_kfmap.h               |  167 ++++
 fs/fuse/file.c                      |   45 +-
 fs/fuse/fuse_i.h                    |  116 ++-
 fs/fuse/inode.c                     |   35 +-
 fs/fuse/iomode.c                    |    2 +-
 fs/namei.c                          |    1 +
 include/uapi/linux/fuse.h           |   88 ++
 14 files changed, 1791 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/filesystems/famfs.rst
 create mode 100644 fs/fuse/famfs.c
 create mode 100644 fs/fuse/famfs_kfmap.h


base-commit: 317638d995c2578f45c9dd0156cd509efff2a332
-- 
2.53.0

