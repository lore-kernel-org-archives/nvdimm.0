Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 591731A1DF2
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:13:20 -0700 (PDT)
Subject: [PATCH 0/4] device-dax prepare for dynamic resize / allocate
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:09:28 -0700
Message-ID: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for dynamic resize / allocation support:

- convert device-dax instances to reserve memory ranges from their
  parent region

- produce a 'seed' device instance to accept new allocation requests

---


Dan Williams (4):
      dax: check resource alignment at dax region/device create
      dax: add region-available-size attribute
      dax: convert devm_create_dax_dev to PTR_ERR
      dax: register seed device


 drivers/dax/dax.c  |  208 ++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/dax/dax.h  |    5 +
 drivers/dax/pmem.c |    5 +
 3 files changed, 196 insertions(+), 22 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
