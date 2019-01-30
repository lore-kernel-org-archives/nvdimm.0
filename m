Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] nfit: Document sysfs interface dirty_shutdown
Date: Wed, 30 Jan 2019 20:35:32 +0000
Message-ID: <PU1P153MB0169A031D0ED4BEEE272829ABF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Poulson <jopoulso@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, KY Srinivasan <kys@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>


The new sysfs node was added in Sep 2018 in:
commit 0ead11181fe0 ("acpi, nfit: Collect shutdown status")

Now let's document it.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 Documentation/ABI/testing/sysfs-bus-nfit | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-nfit b/Documentation/ABI/t=
esting/sysfs-bus-nfit
index a1cb44dcb908..bd6cde8c0ea9 100644
--- a/Documentation/ABI/testing/sysfs-bus-nfit
+++ b/Documentation/ABI/testing/sysfs-bus-nfit
@@ -153,6 +153,14 @@ Description:
 		subsystem controller vendor.
=20
=20
+What:		/sys/bus/nd/devices/nmemX/nfit/dirty_shutdown
+Date:		Sep, 2018
+KernelVersion:	v4.20
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Unsafe Shutdown Count for the NVDIMM device.
+
+
 What:		/sys/bus/nd/devices/ndbusX/nfit/revision
 Date:		Jun, 2015
 KernelVersion:	v4.2
--=20
2.19.1
