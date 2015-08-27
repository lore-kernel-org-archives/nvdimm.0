Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3] change aperture mapping from WC to WB
Date: Thu, 27 Aug 2015 13:14:19 -0600
Message-Id: <1440702860-17363-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, x86@kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The patch formerly known as `nd_blk: add support for "read flush" DSM flag'.

I changed the patch title and updated the description to place more emphasis on
the real purpose of the change, which is to move the BLK aperture mapping to
WB.  Really the implementation of the "read flush" flag was just to enable this
mapping change.

Ross Zwisler (1):
  nd_blk: change aperture mapping from WC to WB

 arch/x86/Kconfig                  |  1 +
 arch/x86/include/asm/cacheflush.h |  2 ++
 arch/x86/include/asm/io.h         |  2 --
 arch/x86/include/asm/pmem.h       |  2 ++
 drivers/acpi/Kconfig              |  1 +
 drivers/acpi/nfit.c               | 55 ++++++++++++++++++++++-----------------
 drivers/acpi/nfit.h               | 16 ++++++++----
 lib/Kconfig                       |  3 +++
 tools/testing/nvdimm/Kbuild       |  2 ++
 tools/testing/nvdimm/test/iomap.c | 30 +++++++++++++++++++--
 tools/testing/nvdimm/test/nfit.c  | 10 ++++---
 11 files changed, 88 insertions(+), 36 deletions(-)

-- 
2.1.0

