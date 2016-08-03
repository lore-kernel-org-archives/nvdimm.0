Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 1EECD1A1DF8
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 15:57:51 -0700 (PDT)
Subject: [4.6 stable PATCH 0/2] libnvdimm: fix initialization vs autodetect
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 15:55:26 -0700
Message-ID: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: stable@vger.kernel.org
Cc: Micah Parrish <micah.parrish@hpe.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 1ee6667cd8d1 "libnvdimm, pfn, dax: fix initialization vs
autodetect for mode + alignment" originally tagged for -stable does not
apply cleanly to 4.6.  This backport pulls in commit 45a0dac04511
"libnvdimm, dax: record the specified alignment of a dax-device
instance" as a pre-requisite.

The result has been verfied to pass the ndctl unit tests.

---

Dan Williams (2):
      libnvdimm, dax: record the specified alignment of a dax-device instance
      libnvdimm, pfn, dax: fix initialization vs autodetect for mode + alignment


 drivers/nvdimm/pfn.h      |    4 +++
 drivers/nvdimm/pfn_devs.c |   53 +++++++++++++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.c     |    4 ++-
 3 files changed, 49 insertions(+), 12 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
