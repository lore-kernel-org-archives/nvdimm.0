Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] nfit: Collect shutdown status for NVDIMM_FAMILY_HYPERV
Date: Wed, 30 Jan 2019 18:48:40 +0000
Message-ID: <PU1P153MB01691690696D8F83FC1872C7BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: Josh Poulson <jopoulso@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, KY Srinivasan <kys@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>


See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901"):
"Get Unsafe Shutdown Count (Function Index 2)".

Let's expose the info to the userspace (e.g. ntctl) via sysfs.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/acpi/nfit/core.c   | 51 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/hyperv.h | 26 +++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 drivers/acpi/nfit/hyperv.h

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index d5a164b6833a..d504da34ce34 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -25,6 +25,7 @@
 #include <asm/cacheflush.h>
 #include <acpi/nfit.h>
 #include "intel.h"
+#include "hyperv.h"
 #include "nfit.h"
=20
 /*
@@ -1802,6 +1803,54 @@ __weak void nfit_intel_shutdown_status(struct nfit_m=
em *nfit_mem)
 	}
 }
=20
+__weak void nfit_hyperv_shutdown_status(struct nfit_mem *nfit_mem)
+{
+	struct device *dev =3D &nfit_mem->adev->dev;
+	struct nd_hyperv_shutdown_status status;
+	union acpi_object in_buf =3D {
+		.buffer.type =3D ACPI_TYPE_BUFFER,
+		.buffer.length =3D 0,
+	};
+	union acpi_object in_obj =3D {
+		.package.type =3D ACPI_TYPE_PACKAGE,
+		.package.count =3D 1,
+		.package.elements =3D &in_buf,
+	};
+	const u8 func =3D ND_HYPERV_GET_UNSAFE_SHUTDOWN_COUNT;
+	const guid_t *guid =3D to_nfit_uuid(nfit_mem->family);
+	u8 revid =3D nfit_dsm_revid(nfit_mem->family, func);
+	struct acpi_device *adev =3D nfit_mem->adev;
+	acpi_handle handle =3D adev->handle;
+	union acpi_object *out_obj;
+
+	if ((nfit_mem->dsm_mask & BIT(func)) =3D=3D 0)
+		return;
+
+	out_obj =3D acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
+	if (!out_obj || out_obj->type !=3D ACPI_TYPE_BUFFER
+		     || out_obj->buffer.length < sizeof(status)) {
+		dev_dbg(dev->parent,
+			"%s: failed to get Unsafe Shutdown Count\n",
+			dev_name(dev));
+		ACPI_FREE(out_obj);
+		return;
+	}
+
+	memcpy(&status, out_obj->buffer.pointer, sizeof(status));
+	ACPI_FREE(out_obj);
+
+	if (status.general_err !=3D 0) {
+		dev_dbg(dev->parent,
+			"%s: failed to get Unsafe Shutdown Count: err=3D0x%x\n",
+			dev_name(dev), status.status);
+		return;
+	}
+
+	set_bit(NFIT_MEM_DIRTY_COUNT, &nfit_mem->flags);
+	nfit_mem->dirty_shutdown =3D status.shutdown_count;
+}
+
+
 static void populate_shutdown_status(struct nfit_mem *nfit_mem)
 {
 	/*
@@ -1811,6 +1860,8 @@ static void populate_shutdown_status(struct nfit_mem =
*nfit_mem)
 	 */
 	if (nfit_mem->family =3D=3D NVDIMM_FAMILY_INTEL)
 		nfit_intel_shutdown_status(nfit_mem);
+	else if (nfit_mem->family =3D=3D NVDIMM_FAMILY_HYPERV)
+		nfit_hyperv_shutdown_status(nfit_mem);
 }
=20
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
diff --git a/drivers/acpi/nfit/hyperv.h b/drivers/acpi/nfit/hyperv.h
new file mode 100644
index 000000000000..c4a25b8624cc
--- /dev/null
+++ b/drivers/acpi/nfit/hyperv.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2019 Microsoft Corporation. All rights reserved.
+ * Hyper-V specific definitions for _DSM of Hyper-V Virtual NVDIMM
+ *
+ * See http://www.uefi.org/RFIC_LIST (Virtual NVDIMM 0x1901)
+ */
+#ifndef _NFIT_HYPERV_H_
+#define _NFIT_HYPERV_H_
+
+#define ND_HYPERV_GET_UNSAFE_SHUTDOWN_COUNT 2
+
+struct nd_hyperv_shutdown_status {
+	union {
+		u32 status;
+		struct {
+			u16 general_err;
+			u8  func_err;
+			u8  vendor_err;
+		};
+	};
+	u32 shutdown_count;
+} __packed;
+
+
+#endif
--=20
2.19.1
