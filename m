Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D70F20979D41
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 08:34:45 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 0/2] Namespace creation fixups
Date: Tue, 26 Jun 2018 09:37:33 -0600
Message-Id: <20180626153736.6770-1-keith.busch@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

This is a three-part fixup to the warning that occurs when the available
capacity is fragmented. When this occurs, the user may believe they can
create a larger namespace than is actually possible. This was resulting
in the following kernel warning:

  nd_region region0: allocation underrun: 0x0 of 0x1400000000 bytes
  WARNING: CPU: 32 PID: 1975 at drivers/nvdimm/namespace_devs.c:913 size_store+0x879/0x8d0 [libnvdimm]

The kernel side of this determines the maximum size by calculating the
largest contiguous extent that can be allocated. If the requested size
exceeds that, an error is returned early instead of reaching the
alarming kernel warning.

To make it possible for the user to know the maximum size it may
request, a new attribute is exported that shows the largest available
extent.

Finally, separate from this series, ndctl is updated to make use of this
new attribute when creating a namespace.

Keith Busch (2):
  libnvdimm: Use largest contiguous area for namespace size
  libnvdimm: Export max available extent

 drivers/nvdimm/dimm_devs.c      | 29 +++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c |  2 +-
 drivers/nvdimm/nd-core.h        |  3 +++
 drivers/nvdimm/region_devs.c    | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 1 deletion(-)

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
