Return-Path: <owner-linux-mm@kvack.org>
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v4] mm,dax: Fix data corruption due to mmap inconsistency
Date: Wed, 10 May 2017 10:54:15 +0200
Message-Id: <20170510085419.27601-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

this series fixes data corruption that can happen for DAX mounts when
page faults race with write(2) and as a result page tables get out of sync
with block mappings in the filesystem and thus data seen through mmap is
different from data seen through read(2).

The series passes testing with t_mmap_stale test program from Ross and also
other mmap related tests on DAX filesystem.

Andrew, can you please merge these patches? Thanks!

Changes since v3:
* Rebased on top of current Linus' tree due to non-trivial conflicts with
  added tracepoint

Changes since v2:
* Added reviewed-by tag from Ross

Changes since v1:
* Improved performance of unmapping pages
* Changed fault locking to fix another write vs fault race

								Honza

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
