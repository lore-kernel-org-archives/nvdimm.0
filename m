Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4718D211B1FAF
 for <linux-nvdimm@lists.01.org>; Fri, 18 Jan 2019 17:00:00 -0800 (PST)
Subject: [PATCH] libnvdimm: Clarify nd_pfn_init() flow
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Jan 2019 16:47:23 -0800
Message-ID: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In recent days, 2 engineers, including the original author of
nd_pfn_init(), overlooked the internal call to nd_pfn_validate() and the
implications to memory allocation.

Clarify this situation to help anyone that reads through this code in
the future.

Reported-by: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/btt_devs.c |    5 +++++
 drivers/nvdimm/dax_devs.c |    5 +++++
 drivers/nvdimm/pfn_devs.c |   21 +++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 795ad4ff35ca..e0a6f2491e57 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -354,6 +354,11 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
 		put_device(btt_dev);
 	}
 
+	/*
+	 * Successful probe indicates to the caller that an nd_btt
+	 * personality device has been registered and the caller can
+	 * fail the probe of the baseline namespace device.
+	 */
 	return rc;
 }
 EXPORT_SYMBOL(nd_btt_probe);
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 0453f49dc708..65010d955fa7 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -136,6 +136,11 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 	} else
 		__nd_device_register(dax_dev);
 
+	/*
+	 * Successful probe indicates to the caller that a device-dax
+	 * personality device has been registered and the caller can
+	 * fail the probe of the baseline namespace device.
+	 */
 	return rc;
 }
 EXPORT_SYMBOL(nd_dax_probe);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 6f22272e8d80..a8783b5a76ba 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -576,6 +576,11 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 	} else
 		__nd_device_register(pfn_dev);
 
+	/*
+	 * Successful probe indicates to the caller that an nd_pfn
+	 * personality device has been registered and the caller can
+	 * fail the probe of the baseline namespace device.
+	 */
 	return rc;
 }
 EXPORT_SYMBOL(nd_pfn_probe);
@@ -706,6 +711,22 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		sig = DAX_SIG;
 	else
 		sig = PFN_SIG;
+
+	/*
+	 * Check for an existing 'pfn' superblock before writing a new
+	 * one. The intended flow is that on the first probe of an
+	 * nd_{pfn,dax} device the superblock is calculated and written
+	 * to the namespace. In this case nd_pfn_validate() returns
+	 * -ENODEV because no valid superblock exists currently.
+	 *
+	 * On subsequent probes nd_pfn_validate() will find a valid
+	 * superblock and return 0.
+	 *
+	 * If an assumption of the superblock has been violated, like a
+	 * change to the physical alignment of the namespace,
+	 * nd_pfn_validate() will return an error other than -ENODEV to
+	 * fail probing.
+	 */
 	rc = nd_pfn_validate(nd_pfn, sig);
 	if (rc != -ENODEV)
 		return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
