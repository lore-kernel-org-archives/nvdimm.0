Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5531F81FB5
 for <linux-nvdimm@lists.01.org>; Sun, 18 Dec 2016 15:28:44 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.10
Date: Sun, 18 Dec 2016 23:28:42 +0000
Message-ID: <1482103720.11354.20.camel@intel.com>
Content-Language: en-US
Content-ID: <CB8F124CA1F6C54595BD53031A053A87@intel.com>
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
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please full from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.10

...to receive the libnvdimm update for 4.10.

The libnvdimm pull request is relatively small this time around due to
some development topics being deferred to 4.11. However, Jan Kara has
been busy enhancing the DAX implementation to allow for the clearing of
radix-tree entries from the DAX dirty-cache-line tracking
implementation. While you have already merged the bulk of that work
from the mm, ext4, and xfs trees, a few straggling patches remain that
were awaiting some final review feedback. Rather than include those
patches on a random mid-merge-window baseline, I thought it would be
best to attempt to merge them for -rc2 after some testing on top of
-rc1.

I believe the pending backlog is the top 6 commits of this tree:

https://git.kernel.org/cgit/linux/kernel/git/jack/linux-fs.git/log/?h=d
ax

As for this pull request the bulk of it has been in -next for several
releases leading to one late fix being added (commit 868f036fee4b
("libnvdimm: fix mishandled nvdimm_clear_poison() return value")). It
has received a build success notification from the 0day-kbuild robot
and passes the latest libnvdimm unit tests.

---

The following changes since commit 325896ffdf90f7cbd59fb873b7ba20d60d1ddf3c:

  device-dax: fix private mapping restriction, permit read-only (2016-12-06 17:42:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.10

for you to fetch changes up to c44ef859ceff45db1c72f9ccbfae96843c4b1501:

  Merge branch 'for-4.10/libnvdimm' into libnvdimm-for-next (2016-12-17 15:08:10 -0800)

----------------------------------------------------------------
libnvdimm for 4.10

* Dynamic label support: To date namespace label support has been
limited to disambiguating cases where PMEM (direct load/store) and BLK
(mmio aperture) accessed-capacity alias on the same DIMM. Since 4.9 added
support for multiple namespaces per PMEM-region there is value to
support namespace labels even in the non-aliasing case. The presence of
a valid namespace index block force-enables label support when the
kernel would otherwise rely on region boundaries, and permits the region
to be sub-divided.

* Handle media errors in namespace metadata: Complement the error
handling for media errors in namespace data areas with support for
clearing errors on writes, and downgrading potential machine-check
exceptions to simple i/o errors on read.

* Device-DAX region attributes: Add 'align', 'id', and 'size' as
attributes for device-dax regions. In particular this enables userspace
tooling to generically size memory mapping and i/o operations. Prevent
userspace from growing assumptions / dependencies about the parent
device topology for a dax region. A libnvdimm namespace may not always
be the parent device of a dax region.

* Various cleanups and small fixes.

----------------------------------------------------------------
Dan Williams (8):
      libnvdimm: allow a platform to force enable label support
      tools/testing/nvdimm: dynamic label support
      libnvdimm: use consistent naming for request_mem_region()
      libnvdimm, pfn: fix align attribute
      libnvdimm: replace mutex_is_locked() warnings with lockdep_assert_held
      libnvdimm: fix mishandled nvdimm_clear_poison() return value
      dax: add region 'id', 'size', and 'align' attributes
      Merge branch 'for-4.10/libnvdimm' into libnvdimm-for-next

Dave Jiang (1):
      libnvdimm: check and clear poison before writing to pmem

Fabian Frederick (3):
      libnvdimm: remove else after return in nsio_rw_bytes()
      libnvdimm, namespace: avoid multiple sector calculations
      libnvdimm, namespace: use octal for permissions

Johannes Thumshirn (1):
      libnvdimm, e820: use module_platform_driver

Nicolas Iooss (2):
      nvdimm: use the right length of "pmem"
      libnvdimm, namespace: fix the type of name variable

Toshi Kani (1):
      libnvdimm: use generic iostat interfaces

 drivers/dax/dax.c                | 94 ++++++++++++++++++++++++++++++++++++++++
 drivers/dax/pmem.c               |  3 +-
 drivers/nvdimm/claim.c           | 46 ++++++++++++++------
 drivers/nvdimm/core.c            | 29 -------------
 drivers/nvdimm/dimm.c            |  2 +
 drivers/nvdimm/dimm_devs.c       |  7 +++
 drivers/nvdimm/e820.c            | 12 +----
 drivers/nvdimm/label.c           |  2 +-
 drivers/nvdimm/namespace_devs.c  |  8 ++--
 drivers/nvdimm/nd.h              | 12 ++++-
 drivers/nvdimm/pfn_devs.c        |  2 +-
 drivers/nvdimm/pmem.c            | 21 +++++----
 drivers/nvdimm/region_devs.c     |  2 +-
 tools/testing/nvdimm/test/nfit.c | 30 ++++++++++---
 14 files changed, 190 insertions(+), 80 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
