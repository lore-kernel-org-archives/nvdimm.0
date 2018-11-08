Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6ECE22118DC32
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 13:27:04 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] ndctl: fix zero-labels to handle firmware error properly
Date: Thu,  8 Nov 2018 14:26:59 -0700
Message-Id: <20181108212659.15570-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ndctl zero-labels completes with a large number of zeroed nmems when
it fails to do zeroing on a protected NVDIMM.

  # ndctl zero-labels nmem1
  zeroed 65504 nmems

do_cmd() called from ndctl_dimm_zero_labels() sets a transfer size to
rc when FW status is non-zero.  This transfer size gets mistreated as
zeroed nmems count in the end.

Fix ndctl_dimm_zero_labels() to handle this FW error case properly.

Reported-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/dimm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 5e41734..79e2ca0 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -537,8 +537,12 @@ NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
 		goto out_write;
 	}
 	rc = ndctl_cmd_submit(cmd_write);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
+	if (rc < 0)
 		goto out_write;
+	if (ndctl_cmd_get_firmware_status(cmd_write)) {
+		rc = -ENXIO;
+		goto out_write;
+	}
 
 	/*
 	 * If the dimm is already disabled the kernel is not holding a cached
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
