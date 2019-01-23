Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] nfit: add Hyper-V NVDIMM DSM command set to white list
Date: Wed, 23 Jan 2019 20:51:13 +0000
Message-ID: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>
List-ID: <linux-nvdimm@lists.01.org>


Add the Hyper-V _DSM command set to the white list of NVDIMM command
sets.

This command set is documented at http://www.uefi.org/RFIC_LIST
(see the link to "Virtual NVDIMM 0x1901" on the page).

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

I'm going to change the user-space utility "ndctl" to support Hyper-V Virtu=
al NVDIMM.
This kernel patch is required first.

 drivers/acpi/nfit/core.c   | 5 ++++-
 drivers/acpi/nfit/nfit.h   | 6 +++++-
 include/uapi/linux/ndctl.h | 1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 011d3db19c80..fb48cb17a519 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1840,7 +1840,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *=
acpi_desc,
 	dev_set_drvdata(&adev_dimm->dev, nfit_mem);
=20
 	/*
-	 * Until standardization materializes we need to consider 4
+	 * Until standardization materializes we need to consider 5
 	 * different command sets.  Note, that checking for function0 (bit0)
 	 * tells us if any commands are reachable through this GUID.
 	 */
@@ -1865,6 +1865,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *=
acpi_desc,
 			dsm_mask &=3D ~(1 << 8);
 	} else if (nfit_mem->family =3D=3D NVDIMM_FAMILY_MSFT) {
 		dsm_mask =3D 0xffffffff;
+	} else if (nfit_mem->family =3D=3D NVDIMM_FAMILY_HYPERV) {
+		dsm_mask =3D 0x1f;
 	} else {
 		dev_dbg(dev, "unknown dimm command family\n");
 		nfit_mem->family =3D -1;
@@ -3707,6 +3709,7 @@ static __init int nfit_init(void)
 	guid_parse(UUID_NFIT_DIMM_N_HPE1, &nfit_uuid[NFIT_DEV_DIMM_N_HPE1]);
 	guid_parse(UUID_NFIT_DIMM_N_HPE2, &nfit_uuid[NFIT_DEV_DIMM_N_HPE2]);
 	guid_parse(UUID_NFIT_DIMM_N_MSFT, &nfit_uuid[NFIT_DEV_DIMM_N_MSFT]);
+	guid_parse(UUID_NFIT_DIMM_N_HYPERV, &nfit_uuid[NFIT_DEV_DIMM_N_HYPERV]);
=20
 	nfit_wq =3D create_singlethread_workqueue("nfit");
 	if (!nfit_wq)
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 33691aecfcee..9194022f29f3 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -34,11 +34,14 @@
 /* https://msdn.microsoft.com/library/windows/hardware/mt604741 */
 #define UUID_NFIT_DIMM_N_MSFT "1ee68b36-d4bd-4a1a-9a16-4f8e53d46e05"
=20
+/* http://www.uefi.org/RFIC_LIST */
+#define UUID_NFIT_DIMM_N_HYPERV "5746c5f2-a9a2-4264-ad0e-e4ddc9e09e80"
+
 #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
=20
-#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_MSFT
+#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_HYPERV
=20
 #define NVDIMM_STANDARD_CMDMASK \
 (1 << ND_CMD_SMART | 1 << ND_CMD_SMART_THRESHOLD | 1 << ND_CMD_DIMM_FLAGS =
\
@@ -94,6 +97,7 @@ enum nfit_uuids {
 	NFIT_DEV_DIMM_N_HPE1 =3D NVDIMM_FAMILY_HPE1,
 	NFIT_DEV_DIMM_N_HPE2 =3D NVDIMM_FAMILY_HPE2,
 	NFIT_DEV_DIMM_N_MSFT =3D NVDIMM_FAMILY_MSFT,
+	NFIT_DEV_DIMM_N_HYPERV =3D NVDIMM_FAMILY_HYPERV,
 	NFIT_SPA_VOLATILE,
 	NFIT_SPA_PM,
 	NFIT_SPA_DCR,
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index f57c9e434d2d..de5d90212409 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -243,6 +243,7 @@ struct nd_cmd_pkg {
 #define NVDIMM_FAMILY_HPE1 1
 #define NVDIMM_FAMILY_HPE2 2
 #define NVDIMM_FAMILY_MSFT 3
+#define NVDIMM_FAMILY_HYPERV 4
=20
 #define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
 					struct nd_cmd_pkg)
--=20
2.19.1
