Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDAB11A1E56
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:12:50 -0700 (PDT)
Subject: [PATCH 0/2] libnvdimm: dynamic label support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:09:48 -0700
Message-ID: <147689338812.9946.11071407155879544366.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Allow label support to be dynamically enabled for PMEM regions that are
not aliased with BLK.  By default these PMEM regions are surfaced as a
single / label-less namespace.  However, if the backing dimm(s) for the
region support labels then PMEM sub-division support can be enabled by

  1/ disable the pmem region
  2/ write a valid namespace index block to the label area
  3/ re-enable the region and create a namespace

See the man page for the "ndctl init-labels" command.

---

Dan Williams (2):
      libnvdimm: allow a platform to force enable label support
      tools/testing/nvdimm: dynamic label support


 drivers/nvdimm/dimm.c            |    2 ++
 drivers/nvdimm/dimm_devs.c       |    7 +++++++
 drivers/nvdimm/nd.h              |    1 +
 tools/testing/nvdimm/test/nfit.c |   30 +++++++++++++++++++++++-------
 4 files changed, 33 insertions(+), 7 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
