Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] Add explicit coredump filtering for DAX mappings
Date: Mon,  5 Oct 2015 16:33:35 -0600
Message-Id: <1444084417-19192-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add two new flags to the existing coredump mechanism for ELF files to allow
us to explicitly filter DAX mappings.  This is desirable because DAX
mappings, like hugetlb mappings, have the potential to be very large.

The coredump code relies on get_user_page() to populate the coredump file
with the appropriate data, and for DAX mappings this currently fails.  This
results in a hole being placed in the coredump file, so you end up reading
back zeros.  Once the get_user_pages() patch series from Dan Williams [1]
is merged, DAX core dumps will give real data.

I have a patch ready for core(5) to update the documentation on the new
filtering flags.  I'll send it out once this gets merged.

[1] http://thread.gmane.org/gmane.linux.kernel.mm/139026

Ross Zwisler (2):
  coredump: add DAX filtering for ELF coredumps
  coredump: add DAX filtering for FDPIC ELF coredumps

 Documentation/filesystems/proc.txt | 22 ++++++++++++----------
 fs/binfmt_elf.c                    | 10 ++++++++++
 fs/binfmt_elf_fdpic.c              | 15 +++++++++++++++
 include/linux/sched.h              |  4 +++-
 4 files changed, 40 insertions(+), 11 deletions(-)

-- 
2.1.0

