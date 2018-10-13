Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBEDB21A143EF
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 10:25:23 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] dax fixes for 4.19-rc8
Date: Sat, 13 Oct 2018 17:25:21 +0000
Message-ID: <8f47e3ce3cbe6e165701dbf665bb1770ca13d907.camel@intel.com>
Content-Language: en-US
Content-ID: <9D8F3DFE51B5FC4AA2AA7296A322A211@intel.com>
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
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Greg, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.19-rc8

...to receive (2) urgent dax fixes for 4.19-rc8. They have appeared in
a -next release.

However, note that commit d7782145e1ad ("filesystem-dax: Fix
dax_layout_busy_page() livelock") is immediately replaced with the
Xarray conversion targeting 4.20, so d7782145e1ad is the backport
suitable fix for the livelock for v4.19 and earlier.

Please pull, thanks!

---

The following changes since commit 17b57b1883c1285f3d0dc2266e8f79286a7bef38:

  Linux 4.19-rc6 (2018-09-30 07:15:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.19-rc8

for you to fetch changes up to 4628a64591e6cee181237060961e98c615c33966:

  mm: Preserve _PAGE_DEVMAP across mprotect() calls (2018-10-09 11:44:58 -0700)

----------------------------------------------------------------
libnvdimm/dax 4.19-rc8

* Fix a livelock in dax_layout_busy_page() present since v4.18. The
  lockup triggers when truncating an actively mapped huge page out of a
  mapping pinned for direct-I/O.

* Fix mprotect() clobbers of _PAGE_DEVMAP. Broken since v4.5 mprotect()
  clears this flag that is needed to communicate the liveness of device
  pages to the get_user_pages() path.

----------------------------------------------------------------
Dan Williams (1):
      filesystem-dax: Fix dax_layout_busy_page() livelock

Jan Kara (1):
      mm: Preserve _PAGE_DEVMAP across mprotect() calls

 arch/powerpc/include/asm/book3s/64/pgtable.h |  4 ++--
 arch/x86/include/asm/pgtable_types.h         |  2 +-
 fs/dax.c                                     | 13 +++++++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
