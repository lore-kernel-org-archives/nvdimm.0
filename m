Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7018F21A143C1
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 22:16:20 -0700 (PDT)
Subject: [PATCH 0/3] libnvdimm: export supported page size alignments
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 22:12:17 -0700
Message-ID: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This series is a minor rework of Oliver's original patch:
https://patchwork.kernel.org/patch/9811257/

It allows userspace to discover the system huge and gigantic page sizes
for aligning devices to support larger than PAGE_SIZE mappings for dax.

---

Dan Williams (2):
      libnvdimm: rename nd_sector_size_{show,store} to nd_size_select_{show,store}
      libnvdimm, pfn, dax: limit namespace alignments to the supported set

Oliver O'Halloran (1):
      libnvdimm, pfn, dax: show supported dax/pfn region alignments in sysfs


 drivers/nvdimm/btt_devs.c       |    4 ++--
 drivers/nvdimm/core.c           |   10 +++++----
 drivers/nvdimm/namespace_devs.c |    6 +++--
 drivers/nvdimm/nd.h             |    6 +++--
 drivers/nvdimm/pfn_devs.c       |   43 ++++++++++++++++++++++++---------------
 5 files changed, 39 insertions(+), 30 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
