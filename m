Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12C7082071
 for <linux-nvdimm@lists.01.org>; Sun, 12 Feb 2017 14:38:17 -0800 (PST)
Subject: [PATCH 0/2] fix devm_memremap_pages() mem hotplug locking
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Feb 2017 14:34:11 -0800
Message-ID: <148693885124.16345.14319993365448440148.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Ben notes that commit f931ab479dd2 "mm: fix devm_memremap_pages crash,
use mem_hotplug_{begin, done}" is incomplete and broken. Writes to
mem_hotplug.active_writer need to be coordinated under the device
hotplug lock. Otherwise, we can potentially corrupt mem_hotplug.refcount
leading to soft lockups.

---

Dan Williams (2):
      mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin,done}
      mm: validate device_hotplug is held for memory hotplug


 drivers/base/core.c    |    5 +++++
 include/linux/device.h |    1 +
 kernel/memremap.c      |    5 +++++
 mm/memory_hotplug.c    |    2 ++
 4 files changed, 13 insertions(+)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
