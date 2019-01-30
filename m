Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] nfit: acpi_nfit_ctl(): check out_obj->type in the right place
Date: Wed, 30 Jan 2019 01:23:01 +0000
Message-ID: <PU1P153MB01694923DF3280E5828E2BE2BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: Josh Poulson <jopoulso@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, KY Srinivasan <kys@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>


In the case of ND_CMD_CALL, we should also check out_obj->type.

The patch uses out_obj->type, which is a short alias to
out_obj->package.type.

Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command mar=
shaling mechanism")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/acpi/nfit/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 0a49c57334cc..1fa378435dd2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -554,6 +554,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_des=
c, struct nvdimm *nvdimm,
 		return -EINVAL;
 	}
=20
+	if (out_obj->type !=3D ACPI_TYPE_BUFFER) {
+		dev_dbg(dev, "%s unexpected output object type cmd: %s type: %d\n",
+				dimm_name, cmd_name, out_obj->type);
+		rc =3D -EINVAL;
+		goto out;
+	}
+
 	if (call_pkg) {
 		call_pkg->nd_fw_size =3D out_obj->buffer.length;
 		memcpy(call_pkg->nd_payload + call_pkg->nd_size_in,
@@ -572,13 +579,6 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_des=
c, struct nvdimm *nvdimm,
 		return 0;
 	}
=20
-	if (out_obj->package.type !=3D ACPI_TYPE_BUFFER) {
-		dev_dbg(dev, "%s unexpected output object type cmd: %s type: %d\n",
-				dimm_name, cmd_name, out_obj->type);
-		rc =3D -EINVAL;
-		goto out;
-	}
-
 	dev_dbg(dev, "%s cmd: %s output length: %d\n", dimm_name,
 			cmd_name, out_obj->buffer.length);
 	print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4, 4,
--=20
2.19.1
