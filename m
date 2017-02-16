Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0ED6F820E7
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 13:57:54 -0800 (PST)
Subject: [PATCH v2 0/2] fix devm_memremap_pages() mem hotplug locking
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Feb 2017 13:53:48 -0800
Message-ID: <148728202805.38457.18028105614854319884.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, linux-mm@kvack.org, Ben Hutchings <ben@decadent.org.uk>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* Reflowed the patches on 4.10-rc8. The v1 series no longer applies
  to -mm now that the sub-section memory hotplug support has been
  deferred to 4.12 [2].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-February/008848.html
[2]: http://www.spinics.net/lists/linux-mm/msg121990.html

---

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
 kernel/memremap.c      |    6 ++++++
 mm/memory_hotplug.c    |    2 ++
 4 files changed, 14 insertions(+)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
