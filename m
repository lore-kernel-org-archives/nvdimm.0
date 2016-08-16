Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 5C9551A1E0F
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:22 -0700 (PDT)
Subject: [PATCH 0/7] dax: unified host inode for device-dax mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:24:58 -0700
Message-ID: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

There are two scenarios where we need mappings of a /dev/dax device to
share a single host inode, invalidating mappings at device shutdown, and
coordinating resize of an actively mapped device.  This series addresses
the unmap-on-shutdown case and includes reworks, like the cdev api
conversion, to prepare for a dynamic resize / allocation capability.

Recall that device-DAX, introduced in v4.7 [1], is a mechanism to
provide deterministic mapping behavior for performance- /
feature-differentiated memory ranges.

[1]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ab68f2622136

---

Dan Williams (7):
      dax: cleanup needlessly global symbol warnings
      dax: reorder dax_fops function definitions
      dax: rename fops from dax_dev_ to dax_
      dax: embed a struct device in dax_dev
      dax: convert to the cdev api
      dax: define a unified inode/address_space for device-dax mappings
      dax: unmap/truncate on device shutdown


 drivers/dax/Kconfig        |    5 
 drivers/dax/dax.c          |  555 ++++++++++++++++++++++++++------------------
 drivers/dax/pmem.c         |    2 
 fs/char_dev.c              |    1 
 include/uapi/linux/magic.h |    1 
 5 files changed, 337 insertions(+), 227 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
