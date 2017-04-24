Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 059F321954086
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 16:55:43 -0700 (PDT)
Subject: [PATCH v2 0/2] libnvdimm: export wpq flush interface
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 16:49:51 -0700
Message-ID: <149307779085.7155.436029631521340565.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* Clean up the changelog to clarify how this capability is expected to
  be used (Jeff)
* Make the attribute read / write to separate detection and flush
  triggering (Masayoshi)
* Add the flush hint detection crash fix

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009898.html

---

Quoting the changelog from patch2:

The nvdimm_flush() mechanism helps to reduce the impact of an ADR
(asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
platform WPQ (write-pending-queue) buffers when power is removed. The
nvdimm_flush() mechanism performs that same function on-demand.

When a pmem namespace is associated with a block device, an
nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
request. These requests are typically associated with filesystem
metadata updates. However, when a namespace is in device-dax mode,
userspace (think database metadata) needs another path to perform the
same flushing. In other words this is not required to make data
persistent, but in the case of metadata it allows for a smaller failure
domain in the unlikely event of an ADR failure.

---

Dan Williams (2):
      libnvdimm, region: fix flush hint detection crash
      libnvdimm, region: sysfs trigger for nvdimm_flush()


 drivers/nvdimm/region_devs.c |   52 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
