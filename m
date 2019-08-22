Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9B1A202110A3
 for <linux-nvdimm@lists.01.org>; Thu, 22 Aug 2019 13:37:49 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] libdaxctl: point to migrate-device-model for
 dax-class errors
Date: Thu, 22 Aug 2019 14:36:35 -0600
Message-Id: <20190822203635.17926-2-vishal.l.verma@intel.com>
In-Reply-To: <20190822203635.17926-1-vishal.l.verma@intel.com>
References: <20190822203635.17926-1-vishal.l.verma@intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

When a dax-bus vs. dax-class expectation causes a failure, such as when
reconfiguring device modes, print an error message directly pointing the
user to the daxctl-migrate-device-model command.

Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/lib/libdaxctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 44842b9..c0a859c 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -917,6 +917,7 @@ static int daxctl_dev_enable(struct daxctl_dev *dev, enum daxctl_dev_mode mode)
 
 	if (!device_model_is_dax_bus(dev)) {
 		err(ctx, "%s: error: device model is dax-class\n", devname);
+		err(ctx, "%s: see man daxctl-migrate-device-model\n", devname);
 		return -EOPNOTSUPP;
 	}
 
@@ -962,6 +963,7 @@ DAXCTL_EXPORT int daxctl_dev_disable(struct daxctl_dev *dev)
 
 	if (!device_model_is_dax_bus(dev)) {
 		err(ctx, "%s: error: device model is dax-class\n", devname);
+		err(ctx, "%s: see man daxctl-migrate-device-model\n", devname);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
