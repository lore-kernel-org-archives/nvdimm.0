Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78D6D2252CBAB
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 17:27:40 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fixes for 4.16-rc7
Date: Fri, 23 Mar 2018 00:34:10 +0000
Message-ID: <1521765242.9257.19.camel@intel.com>
Content-Language: en-US
Content-ID: <A20C5207B42157439D50FD9D053FAC95@intel.com>
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive 2 regression fixes, 2 bug fixes for older issues, 2
fixes for new functionality added this cycle that have userspace ABI
concerns, and a small cleanup. These have appeared in a linux-next
release and have a build success report from the 0day robot.

* The 4.16 rework of altmap handling led to some configurations leaking
page table allocations due to freeing from the altmap reservation
rather than the page allocator. The impact without the fix is leaked
memory and a WARN() message when tearing down libnvdimm namespaces. The
rework also missed a place where error handling code needed to be
removed that can lead to a crash if devm_memremap_pages() fails.

* acpi_map_pxm_to_node() had a latent bug whereby it could misidentify
the closest online node to a given proximity domain.

* Block integrity handling was reworked several kernels back to allow
calling add_disk() after setting up the integrity profile. The nd_btt
and nd_blk drivers are just now catching up to fix automatic partition
detection at driver load time.

* The new peristence_domain attribute, a platform indicator of whether
cpu caches are powerfail protected for example, is meant to be a single
value enum and not a set of flags. This oversight was caught while
reviewing new userspace code in libndctl to communicate the attribute.
Fix this new enabling up so that we are not stuck with an unwanted
userspace ABI.

The following changes since commit 661e50bc853209e41a5c14a290ca4decc43cbfd1:

  Linux 4.16-rc4 (2018-03-04 14:54:11 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to fe9a552e715dfe5167d52deb74ea16335896bdaf:

  libnvdimm, nfit: fix persistence domain reporting (2018-03-21 15:12:07 -0700)

----------------------------------------------------------------
Colin Ian King (1):
      libnvdimm: remove redundant assignment to pointer 'dev'

Dan Williams (4):
      x86, memremap: fix altmap accounting at free
      acpi, numa: fix pxm to online numa node associations
      libnvdimm, region: hide persistence_domain when unknown
      libnvdimm, nfit: fix persistence domain reporting

Oliver O'Halloran (1):
      kernel/memremap: Remove stale devres_free() call

Vishal Verma (1):
      libnvdimm, {btt, blk}: do integrity setup before add_disk()

 arch/x86/mm/init_64.c        | 60 +++++++++++++++++++++-----------------------
 drivers/acpi/nfit/core.c     | 10 +++++---
 drivers/acpi/numa.c          | 10 +++++---
 drivers/nvdimm/blk.c         |  3 +--
 drivers/nvdimm/btt.c         |  3 +--
 drivers/nvdimm/pfn_devs.c    |  2 +-
 drivers/nvdimm/region_devs.c | 17 ++++++++++---
 kernel/memremap.c            |  1 -
 8 files changed, 57 insertions(+), 49 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
