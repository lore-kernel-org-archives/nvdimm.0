Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 7/9] libnvdimm,
 pfn: fix nd_pfn_validate() return value handling
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:15:05 -0800
Message-ID: <20151215021505.37090.61896.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The -ENODEV case indicates that the info-block needs to established.
All other return codes cause nd_pfn_init() to abort.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index dc6866734f70..ab689bca727d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -238,7 +238,9 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn);
-	if (rc == 0 || rc == -EBUSY)
+	if (rc == -ENODEV)
+		/* no info block, do init */;
+	else
 		return rc;
 
 	nd_region = to_nd_region(nd_pfn->dev.parent);

