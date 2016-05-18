Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 3919D1A1FB7
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 16:44:49 -0700 (PDT)
Subject: [PATCH 0/2] libnvdimm, dax: autodetect fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 16:43:57 -0700
Message-ID: <146361503689.37798.44566892348278285.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Now that the base device-DAX implementation is settling I am circling
back to further flesh out the ndctl unit tests.  These 2 fixes fell out
as a result.

---

Dan Williams (2):
      libnvdimm, dax: autodetect support
      libnvdimm, dax: fix alignment validation


 drivers/nvdimm/dax_devs.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h       |   11 +++++++++--
 drivers/nvdimm/pfn.h      |    1 +
 drivers/nvdimm/pfn_devs.c |   20 +++++++++++++-------
 drivers/nvdimm/pmem.c     |    3 ++-
 5 files changed, 60 insertions(+), 10 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
