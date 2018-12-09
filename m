Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B4B721199264
 for <linux-nvdimm@lists.01.org>; Sat,  8 Dec 2018 22:26:41 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] dax fixes for 4.20-rc6
Date: Sun, 9 Dec 2018 06:26:39 +0000
Message-ID: <6be0835bf256755375f3b5822bf70d74538d1d6e.camel@intel.com>
Content-Language: en-US
Content-ID: <28CE27909824804BA8532653A15FCF6F@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-4.20-rc6

...to receive the last of the known regression fixes and fallout from
the Xarray conversion of the filesystem-dax implementation. On the path
to debugging why the dax memory-failure injection test started failing
after the Xarray conversion a couple more fixes for the
dax_lock_mapping_entry(), now called dax_lock_page(), surfaced. Those
plus the bug that started the hunt are now addressed. These patches
have appeared in a -next release with no issues reported.

Note the touches to mm/memory-failure.c are just the conversion to the
new function signature for dax_lock_page().

---

The following changes since commit 2e6e902d185027f8e3cb8b7305238f7e35d6a436:

  Linux 4.20-rc4 (2018-11-25 14:19:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-4.20-rc6

for you to fetch changes up to 27359fd6e5f3c5db8fe544b63238b6170e8806d8:

  dax: Fix unlock mismatch with updated API (2018-12-04 21:32:00 -0800)

----------------------------------------------------------------
dax fixes 4.20-rc6

* Fix the Xarray conversion of fsdax to properly handle
dax_lock_mapping_entry() in the presense of pmd entries.

* Fix inode destruction racing a new lock request.

----------------------------------------------------------------
Matthew Wilcox (3):
      dax: Check page->mapping isn't NULL
      dax: Don't access a freed inode
      dax: Fix unlock mismatch with updated API

 fs/dax.c            | 55 ++++++++++++++++++++++++++++++++++++-----------------
 include/linux/dax.h | 14 ++++++++------
 mm/memory-failure.c |  6 ++++--
 3 files changed, 50 insertions(+), 25 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
