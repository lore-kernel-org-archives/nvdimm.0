Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by ml01.01.org (Postfix) with ESMTP id 64DBD202E292C
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 04:20:46 -0700 (PDT)
From: Jia He <justin.he@arm.com>
Subject: [PATCH 0/2] Fix and support dax kmem on arm64
Date: Fri, 16 Aug 2019 19:18:42 +0800
Message-Id: <20190816111844.87442-1-justin.he@arm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Jia He <justin.he@arm.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch set is to fix some dax kmem driver issues and then it can 
support to use pmem as normal RAM in arm64 qemu guest.

Jia He (2):
  drivers/dax/kmem: use default numa_mem_id if target_node is invalid
  drivers/dax/kmem: give a warning if CONFIG_DEV_DAX_PMEM_COMPAT is
    enabled

 drivers/dax/kmem.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
