Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 1/3] libnvdimm: fix mode determination for e820 devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jan 2016 10:42:08 -0800
Message-ID: <20160130184208.17558.35647.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160130184203.17558.30413.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Correctly display "safe" mode when a btt is established on a e820/memmap
defined pmem namespace.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 8ebfcaae3f5a..9edf7eb7d17c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1277,10 +1277,12 @@ static ssize_t mode_show(struct device *dev,
 
 	device_lock(dev);
 	claim = ndns->claim;
-	if (pmem_should_map_pages(dev) || (claim && is_nd_pfn(claim)))
-		mode = "memory";
-	else if (claim && is_nd_btt(claim))
+	if (claim && is_nd_btt(claim))
 		mode = "safe";
+	else if (claim && is_nd_pfn(claim))
+		mode = "memory";
+	else if (!claim && pmem_should_map_pages(dev))
+		mode = "memory";
 	else
 		mode = "raw";
 	rc = sprintf(buf, "%s\n", mode);
