Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 2/3] libnvdimm, pfn: fix restoring memmap location
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jan 2016 10:42:14 -0800
Message-ID: <20160130184213.17558.33552.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This path was missed when turning on the memmap in pmem support.  Permit
'pmem' as a valid location for the map.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 0cc9048b86e2..ae81a2f1da50 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -301,10 +301,8 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 
 	switch (le32_to_cpu(pfn_sb->mode)) {
 	case PFN_MODE_RAM:
-		break;
 	case PFN_MODE_PMEM:
-		/* TODO: allocate from PMEM support */
-		return -ENOTTY;
+		break;
 	default:
 		return -ENXIO;
 	}
