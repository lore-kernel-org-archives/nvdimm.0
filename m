Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D7EA21AE30DB
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:52:57 -0700 (PDT)
Subject: [PATCH 0/2] Minor fixups for nd_device_register
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 25 Sep 2018 13:52:56 -0700
Message-ID: <20180925204801.6182.73167.stgit@localhost.localdomain>
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
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This patch series addresses a couple minor issues in nd_device_register.

The first patch resolves an issue in which we weren't holding the parent
lock so it is possible the parent could have been released prior to us
taking care of initializing the device via the asynchronous init.

The second patch moves the initialization of the device node to the
earliest point where we can do it. By doing this we can avoid repeatedly
updating the node on each uevent. 

---

Alexander Duyck (2):
      nvdimm: Hold reference on parent while scheduling async init
      nvdimm: Set device node in nd_device_register


 drivers/nvdimm/bus.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
