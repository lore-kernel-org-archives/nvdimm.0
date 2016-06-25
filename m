Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 36BBD1A1DEE
 for <linux-nvdimm@lists.01.org>; Sat, 25 Jun 2016 10:42:13 -0700 (PDT)
Subject: [PATCH 0/2] ZONE_DEVICE cleanups
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 25 Jun 2016 10:40:57 -0700
Message-ID: <146687645727.39261.14620086569655191314.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Minor cleanups for CONFIG_ZONE_DEVICE.

Andrew, killing the CONFIG_EXPERT dependency might be worth applying for
4.7, but otherwise these can wait for 4.8. These have received a "build
success" notification from the kbuild robot over 58 configs.  Please
apply, or ack and I'll queue them with the rest of the libnvdimm-for-4.8
updates.

---

Dan Williams (2):
      mm: CONFIG_ZONE_DEVICE stop depending on CONFIG_EXPERT
      mm: cleanup ifdef guards for vmem_altmap


 include/linux/memremap.h |    2 +-
 kernel/memremap.c        |    8 --------
 mm/Kconfig               |    2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
