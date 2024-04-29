Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790957EF02
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410286; cv=none; b=rbroAJ41GBZmuyPZqf5kufXh1/7DAImm4cgINCdCdbyQ1JRKhct4QgYftLSjbuMCR0f5l6ISQFMdgdoP/3XR2cwBzfbIH1+g/SeOVDq3DFizQUI4iepErBlYckCOaN+kY0DSPlOgY36lrN0nvUYQeUuExRKP5ONUytWbA/oChQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410286; c=relaxed/simple;
	bh=406UyyCNXuQMSCeHMNLWEMWlQ3MJe0W5p67vimEObXY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MsH/XTb5POPRWoTqyeLoCoFBFaeOz95Y9gpmdOg273So1Zgc37IAuWU4wqfgZiAQWh25O7WfY4HEM5igLq5jvdXJtXxIIY2W0zKkEl8QSM88mWbofuo8m+C8Skyco1iYq9ofRKRJIuYmCbIIyWo2EcpeDxbHn3k/b6VlqtjL8wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoM8/mzN; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoM8/mzN"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6ee3a7cb9f1so560865a34.1
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410283; x=1715015083; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rgRul3U5v9acsobhaA3nd7aLEZVuwb++QdqBbnvaYQA=;
        b=KoM8/mzNDA01P1TgllqtzsZmQjXo9s1IGGWkL8Axy/ixpCwL2xjhwfpFV0Cm/6D4JG
         9jGqqJC1AOQR4kFt6Ix37SK+gveW5du+17iW9zgIWCT3wOjsySaJs/az9gm4mgXyUw6t
         lDcggJGB4E23XmT+bTUc1viK2iTXhLvVQMeUzx0BW3V4QebO1BLWK790fePlvCmczTXM
         TnGR05gbcN5x8AEKqpAhrCS0Yg8YdCPOeo2SaCZFWfWVDaUjp5GV+E1WWSLKm4GsmqNf
         ky0KDkEAnx94qtY7WmGBUjzaXsxzTLbBecHFkue42coj+ZJDZ8q78oCpT1kdE7DwM690
         HaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410283; x=1715015083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgRul3U5v9acsobhaA3nd7aLEZVuwb++QdqBbnvaYQA=;
        b=t9l+oemPto176z3JpgxMvMARl/zoI91Oq/fslN6o57hsnxSDMbZoMC7w64+bFjX2YG
         20HrvohEflQ5AHuygKWe5cTSjWm8I1yuzQkIFL8Fl21sh5R70vOTKC+DAdMHPGU6+4T2
         J2hGUr4c7CiipcyYrUlwYCErHjHWw8YSslUPKWiLjS3raRvey7PSdNKrX8wFStHKvFQP
         bAuFJFIHwHsQS5ujGw6msfSUD0Qy6JTMWD800Xr00CDCCube2L/Ye2Zz/wXBAXrWY/9m
         OlurZTuDUm1VcW4HxTYgs3BTJ9DtA68YWI27Colz50OPrZDznBDd/0lAadncDOJgr396
         JiJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQjgQy9qq9ns21sVLCH1bvPGAdGXuVxSEd674RY+/msNu8Vp7//wRhukhjuPGyCR0VTnFczsMEFrLZGgwOOgFuHldHYWiR
X-Gm-Message-State: AOJu0YwlECGEZveSiuMht+V2BqiaetQVEU9Arrqz5DH6JT91jz8KUepn
	6GUsCpddqPd9+yRurtMR/4Vpjan8jyO2lPiEl6Ze26Ntc84vAHf3
X-Google-Smtp-Source: AGHT+IFxPSSRzmHNvqw0KC8EJtbzVdvh4LgLWNJl5h5R7jiMGR0wrT/ik+s7kGuGqfjVdLGzzxHIjA==
X-Received: by 2002:a9d:5f04:0:b0:6eb:70c6:5aa4 with SMTP id f4-20020a9d5f04000000b006eb70c65aa4mr13203764oti.14.1714410283334;
        Mon, 29 Apr 2024 10:04:43 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.04.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:04:43 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John Groves <jgroves@micron.com>,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	John Groves <john@groves.net>
Subject: [RFC PATCH v2 00/12] Introduce the famfs shared-memory file system
Date: Mon, 29 Apr 2024 12:04:16 -0500
Message-Id: <cover.1714409084.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set introduces famfs[1] - a special-purpose fs-dax file system
for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
CXL-specific in anyway way.

* Famfs creates a simple access method for storing and sharing data in
  sharable memory. The memory is exposed and accessed as memory-mappable
  dax files.
* Famfs supports multiple hosts mounting the same file system from the
  same memory (something existing fs-dax file systems don't do).
* A famfs file system can be created on a /dev/dax device in devdax mode,
  which rests on dax functionality added in patches 2-7 of this series.

The famfs kernel file system is part the famfs framework; additional
components in user space[2] handle metadata and direct the famfs kernel
module to instantiate files that map to specific memory. The famfs user
space has documentation and a reasonably thorough test suite.

The famfs kernel module never accesses the shared memory directly (either
data or metadata). Because of this, shared memory managed by the famfs
framework does not create a RAS "blast radius" problem that should be able
to crash or de-stabilize the kernel. Poison or timeouts in famfs memory
can be expected to kill apps via SIGBUS and cause mounts to be disabled
due to memory failure notifications.

Famfs does not attempt to solve concurrency or coherency problems for apps,
although it does solve these problems in regard to its own data structures.
Apps may encounter hard concurrency problems, but there are use cases that
are imminently useful and uncomplicated from a concurrency perspective:
serial sharing is one (only one host at a time has access), and read-only
concurrent sharing is another (all hosts can read-cache without worry).

Contents:

* famfs kernel documentation [patch 1]. Note that evolving famfs user
  documentation is at [2]
* dev_dax_iomap patchset [patches 2-7] - This enables fs-dax to use the
  iomap interface via a character /dev/dax device (e.g. /dev/dax0.0). For
  historical reasons the iomap infrastructure was enabled only for
  /dev/pmem devices (which are dax block devices). As famfs is the first
  fs-dax file system that works on /dev/dax, this patch series fills in
  the bare minimum infrastructure to enable iomap api usage with /dev/dax.
* famfs patchset [patches 8-12] - this introduces the kernel component of
  famfs.

Note that there is a developing consensus that /dev/dax requires
some fundamental re-factoring (e.g. [3]) that is related but outside the
scope of this series.

Some observations about using sharable memory

* It does not make sense to online sharable memory as system-ram.
  System-ram gets zeroed when it is onlined, so sharing is basically
  nonsense.
* It does not make sense to put struct page's in sharable memory, because
  those can't be shared. However, separately providing non-sharable
  capacity to be used for struct page's might be a sensible approach if the
  size of struct page array for sharable memory is too large to put in
  conventional system-ram (albeit with possible RAS implications).
* Sharable memory is pmem-like, in that a host is likely to connect in
  order to gain access to data that is already in the memory. Moreover
  the power domain for shared memory is separate for that of the server.
  Having observed that, famfs is not intended for persistent storage. It is
  intended for sharing data sets in memory during a time frame where the
  memory and the compute nodes are expected to remain operational - such
  as during a clustered data analytics job.

Could we do this with FUSE?

The key performance requirement for famfs is efficient handling of VMA
faults. This requires caching the complete dax extent lists for all active
files so faults can be handled without upcalls, which FUSE does not do.
It would probably be possible to put this capability FUSE, but we think
that keeping famfs separate from FUSE is the simpler approach.

We will be discussing this topic at LSFMM 2024 [5] in a topic called "Famfs:
new userspace filesystem driver vs. improving FUSE/DAX" - but other famfs
related discussion will also be welcome!

This patch set is available as a branch at [6]

References

[1] https://lpc.events/event/17/contributions/1455/
[2] https://github.com/cxl-micron-reskit/famfs
[3] https://lore.kernel.org/all/166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com/
[4] https://www.computeexpresslink.org/download-the-specification
[5] https://events.linuxfoundation.org/lsfmmbpf/program/schedule-at-a-glance/
[6] https://github.com/cxl-micron-reskit/famfs-linux/tree/famfs-v2


Changes since RFC v1:


* This patch series is a from-scratch refactor of the original. The code
  that maps a file to a dax device is almost identical, but a lot of
  cleanup has been done.
* The get_tree and backing device handling code has been ripped up and
  re-done (in the get-tree case, based on suggestions from Christian
  Brauner - thanks Christian; I hope I haven't done any new dumb stuff!)
  (Note this code has been extensively tested; after all known error cases
  famfs can be umounted and the module can be unloaded)
* Famfs now 'shuts down' if the dax device reports any memory errors. I/O
  and faults start reporting SIGBUS. Famfs detects memory errors via an
  iomap_ops->notify failure call from the devdax layer. This has been tested
  and appears to disable the famfs file system while leaving it able to
  dismount cleanly.
* Dropped fault counters
* Dropped support for symlinks wtihin a famfs file system; we don't think
  supporting symlinks makes sense with famfs, and it has some undesirable
  side effects, so it's out.
* Dropped support for mknod within a famfs file system (other than regular
  files and directories)
* Famfs magic number moved to magic.h
* Famfs ioctl opcodes now documented in
  Documentation/userspace-api/ioctl/ioctl-number.rst
* Dodgy kerneldoc comments cleaned up or removed; hopefully none added...
* Kconfig formatting cleaned up
* Dropped /dev/pmem support. Prior patch series would mount on either
  /dev/pmem or /dev/dax devices. This is unnecessary complexity since
  /ddev/pmem devices can be converted to /dev/dax. Famfs is, however, the
  first file system we know of that mounts from a character device.
* Famfs no longer does a filp_open() of the dax device. It finds the
  device by its dev_t and uses fs_dax_get() to effect exclusivity.
* Added a read-only module param famfs_kabi_version for checkout
  that user space was compiled for the same ABI version
* The famfs kernel module (the code in fs/famfs plus the uapi file
  famfs_ioctl.c dropped from 1030 lines of code in v1 to 760 in v2,
  according to "cloc".
* Fixed issues reported by the kernel test robot
* Many minor improvements in response to v1 code reviews


John Groves (12):
  famfs: Introduce famfs documentation
  dev_dax_iomap: Move dax_pgoff_to_phys() from device.c to bus.c
  dev_dax_iomap: Add fs_dax_get() func to prepare dax for fs-dax usage
  dev_dax_iomap: Save the kva from memremap
  dev_dax_iomap: Add dax_operations for use by fs-dax on devdax
  dev_dax_iomap: export dax_dev_get()
  famfs prep: Add fs/super.c:kill_char_super()
  famfs: module operations & fs_context
  famfs: Introduce inode_operations and super_operations
  famfs: Introduce file_operations read/write
  famfs: Introduce mmap and VM fault handling
  famfs: famfs_ioctl and core file-to-memory mapping logic & iomap_ops

 Documentation/filesystems/famfs.rst           | 135 ++++
 Documentation/filesystems/index.rst           |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |  11 +
 drivers/dax/Kconfig                           |   6 +
 drivers/dax/bus.c                             | 144 ++++-
 drivers/dax/dax-private.h                     |   1 +
 drivers/dax/device.c                          |  38 +-
 drivers/dax/super.c                           |  33 +-
 fs/Kconfig                                    |   2 +
 fs/Makefile                                   |   1 +
 fs/famfs/Kconfig                              |  10 +
 fs/famfs/Makefile                             |   5 +
 fs/famfs/famfs_file.c                         | 605 ++++++++++++++++++
 fs/famfs/famfs_inode.c                        | 452 +++++++++++++
 fs/famfs/famfs_internal.h                     |  52 ++
 fs/namei.c                                    |   1 +
 fs/super.c                                    |   9 +
 include/linux/dax.h                           |   6 +
 include/linux/fs.h                            |   1 +
 include/uapi/linux/famfs_ioctl.h              |  61 ++
 include/uapi/linux/magic.h                    |   1 +
 22 files changed, 1547 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/filesystems/famfs.rst
 create mode 100644 fs/famfs/Kconfig
 create mode 100644 fs/famfs/Makefile
 create mode 100644 fs/famfs/famfs_file.c
 create mode 100644 fs/famfs/famfs_inode.c
 create mode 100644 fs/famfs/famfs_internal.h
 create mode 100644 include/uapi/linux/famfs_ioctl.h


base-commit: ed30a4a51bb196781c8058073ea720133a65596f
-- 
2.43.0

