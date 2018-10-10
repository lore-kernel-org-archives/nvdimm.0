Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34CC321962301
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:36:23 -0700 (PDT)
Subject: [nvdimm PATCH 0/6] Label initialization time optimizations
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 10 Oct 2018 16:36:15 -0700
Message-ID: <20181010233428.12228.26106.stgit@localhost.localdomain>
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
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org
Cc: alexander.h.duyck@linux.intel.com, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This patch set is intended to improve NVDIMM label read times by first
increasing the upper limit on the label read/write size, and then
reducing the number of reads by making use of the free label bitmap in
the index to determine what labels are actually populated and only read
those labels. In my testing on a system populated with 24 NVDIMM modules
I see the total label init time drop from about 24 seconds down to 2 to
3 seconds. 

In the process of coding this up I came across a few minor issues that
I felt should be addressed so I have added a few patches for those fixes
along the way.

---

Alexander Duyck (5):
      nvdimm: Sanity check labeloff
      nvdimm: Clarify comment in sizeof_namespace_index
      nvdimm: Remove empty if statement
      nvdimm: Split label init out from the logic for getting config data
      nvdimm: Use namespace index data to reduce number of label reads needed

Dan Williams (1):
      libnvdimm, dimm: Maximize label transfer size


 drivers/nvdimm/dimm.c      |    6 --
 drivers/nvdimm/dimm_devs.c |   60 +++++++------------
 drivers/nvdimm/label.c     |  142 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/nvdimm/label.h     |    4 -
 drivers/nvdimm/nd.h        |    2 +
 5 files changed, 163 insertions(+), 51 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
