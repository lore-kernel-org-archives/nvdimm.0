Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 0/2] Fix BTT data corruptions after crash
Date: Thu, 11 Feb 2016 14:24:15 -0700
Message-Id: <1455225857-12039-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Data corruption issues were observed in tests which initiated a system
crash/reset while accessing BTT devices.  This problem is reproducible.

The BTT driver calls pmem_rw_bytes() to update data in pmem devices.
This interface calls __copy_user_nocache(), which uses non-temporal
stores so that the stores to pmem are persistent.

__copy_user_nocache() uses non-temporal stores when a request size is
8 bytes or larger (and is aligned by 8 bytes).  The BTT driver updates
the BTT map table, which entry size is 4 bytes.  Therefore, updates to
the map table entries remain cached, and are not written to pmem after
a crash.  Since the BTT driver makes previous blocks free and uses them
for subsequent writes, the map table ends up pointing to blocks allocated
for other LBAs after a crash.

Patch 1 cleans up __copy_user_nocache() before making changes.
Patch 2 makes __copy_user_nocache() handle 4-byte nocache copy.

---
v3:
 - Add a cleanup patch to rename numeric labels to descriptively named
   labels with .L. (Ingo Molnar, Borislav Petkov)
v2:
 - Add comments (Ingo Molnar).
---
Toshi Kani (2):
 1/2 x86/lib/copy_user_64.S: cleanup __copy_user_nocache()
 2/2 x86/lib/copy_user_64.S: Handle 4-byte nocache copy

---
 arch/x86/lib/copy_user_64.S | 142 +++++++++++++++++++++++++++++++-------------
 1 file changed, 101 insertions(+), 41 deletions(-)
