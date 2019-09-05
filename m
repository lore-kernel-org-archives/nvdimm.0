From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [PATCH v9 0/7] Mark the namespace disabled on pfn superblock mismatch
Date: Thu,  5 Sep 2019 21:15:56 +0530
Message-ID: <20190905154603.10349-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

We add new members to pfn superblock (PAGE_SIZE and struct page size) in this series.
This is now checked while initializing the namespace. If we find a mismatch we mark
the namespace disabled.

This series also handle configs where hugepage support is not enabled by default.
This can result in different align restrictions for dax namespace. We mark the
dax namespace disabled if we find the alignment not supported.

Changes from v8:
* updated patch 7 for addressing review feedback

Changes from v6:
* Formatting changes

Changes from v5:
* Split patch 3
* Update commit message
* Add MAX_STRUCT_PAGE_SIZE with value 64 and use that when allocating reserve block
* Add BUILD_BUG_ON if we find sizeof(struct page) > 64



Aneesh Kumar K.V (6):
  libnvdimm/pmem: Advance namespace seed for specific probe errors
  libnvdimm/pfn_dev: Add a build check to make sure we notice when
    struct page size change
  libnvdimm/pfn_dev: Add page size and struct page size to pfn
    superblock
  libnvdimm/label: Remove the dpa align check
  libnvdimm: Use PAGE_SIZE instead of SZ_4K for align check
  libnvdimm/dax: Pick the right alignment default when creating dax
    devices

Dan Williams (1):
  libnvdimm/region: Rewrite _probe_success() to _advance_seeds()

 drivers/nvdimm/bus.c            |   8 +--
 drivers/nvdimm/label.c          |   5 --
 drivers/nvdimm/namespace_devs.c |  40 +++++++++---
 drivers/nvdimm/nd-core.h        |   3 +-
 drivers/nvdimm/nd.h             |  10 +--
 drivers/nvdimm/pfn.h            |   5 +-
 drivers/nvdimm/pfn_devs.c       | 110 +++++++++++++++++++++++++-------
 drivers/nvdimm/pmem.c           |  29 +++++++--
 drivers/nvdimm/region_devs.c    |  76 ++++------------------
 include/linux/huge_mm.h         |   7 +-
 10 files changed, 176 insertions(+), 117 deletions(-)

-- 
2.21.0
