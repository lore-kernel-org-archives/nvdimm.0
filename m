Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D8C31A1E4F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 07:21:28 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 0/2] iostat update for dax and libnvdimm
Date: Wed, 19 Oct 2016 08:19:42 -0600
Message-Id: <1476886784-24644-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This patch-set adds/updates iostat functions to DAX and
libnvdimm.

Patch 1 adds iostat support to the DAX read/write path since
it only measures metadata at this point.

Patch 2 updates nd_iostat_start() and nd_iostat_end() to use
the generic iostat interfaces.

v3:
 - Use generic_start_io_acct() and generic_end_io_acct() for
   both dax and libnvdimm. (Dave Chinner, Dan Williams)

v2:
 - Set a minimum of one sector. (Dan Williams)

---
Toshi Kani (2):
 1/2 DAX: enable iostat for read/write
 2/2 libnvdimm: use generic iostat interfaces

---
 drivers/nvdimm/core.c | 29 -----------------------------
 drivers/nvdimm/nd.h   | 11 +++++++++--
 fs/dax.c              | 15 +++++++++++++++
 3 files changed, 24 insertions(+), 31 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
