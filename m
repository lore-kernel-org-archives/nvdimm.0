Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 0/7] dax: I/O path enhancements
Date: Tue, 18 Aug 2015 11:14:41 -0600
Message-Id: <1439918088-32159-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Ameen Ali <ameenali023@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boaz Harrosh <boaz@plexistor.com>, Borislav Petkov <bp@suse.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Greg KH <gregkh@linuxfoundation.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@primarydata.com>, Jens Axboe <axboe@kernel.dk>, Jiri Slaby <jslaby@suse.com>, Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@linux.intel.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Michael Ellerman <mpe@ellerman.id.au>, Mike Snitzer <snitzer@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ming Lei <ming.lei@canonical.com>, Omar Sandoval <osandov@osandov.com>, Paul Mackerras <paulus@samba.org>, Sagi Grimberg <sagig@mellanox.com>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, Wolfram Sang <wsa@the-dreams.de>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-s390@vger.kernel.org, linux390@de.ibm.com, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The goal of this series is to enhance the DAX I/O path so that all operations
that store data (I/O writes, zeroing blocks, punching holes, etc.) properly
synchronize the stores to media using the PMEM API.  This ensures that the data
DAX is writing is durable on media before the operation completes.

Patches 1-4 are a few random cleanups.

Changes from v3 (all in patch 5):
 - moved <linux/uio.h> include from x86 pmem.h to linux/pmem.h (Christoph)
 - made some local void* variables where apporpriate to cut down on __force
   casts from __pmem (Christoph)
 - made a __iter_needs_pmem_wb() helper and added a TODO to move to
   non-temporal stores (Christoph)

Ross Zwisler (7):
  brd: make rd_size static
  pmem, x86: move x86 PMEM API to new pmem.h header
  pmem: remove layer when calling arch_has_wmb_pmem()
  pmem, x86: clean up conditional pmem includes
  pmem: add copy_from_iter_pmem() and clear_pmem()
  dax: update I/O path to do proper PMEM flushing
  pmem, dax: have direct_access use __pmem annotation

 Documentation/filesystems/Locking |   3 +-
 MAINTAINERS                       |   1 +
 arch/powerpc/sysdev/axonram.c     |   7 +-
 arch/x86/include/asm/cacheflush.h |  71 -----------------
 arch/x86/include/asm/pmem.h       | 158 ++++++++++++++++++++++++++++++++++++++
 drivers/block/brd.c               |   6 +-
 drivers/nvdimm/pmem.c             |   4 +-
 drivers/s390/block/dcssblk.c      |  10 ++-
 fs/block_dev.c                    |   2 +-
 fs/dax.c                          |  68 +++++++++-------
 include/linux/blkdev.h            |   8 +-
 include/linux/pmem.h              |  79 +++++++++++++++----
 12 files changed, 289 insertions(+), 128 deletions(-)
 create mode 100644 arch/x86/include/asm/pmem.h

-- 
2.1.0

