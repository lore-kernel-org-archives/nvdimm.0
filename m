Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH] nfit: add Hyper-V NVDIMM DSM command set to white list
Date: Sun, 27 Jan 2019 05:44:06 +0000
Message-ID: <BL0PR2101MB0914497BA7822B54B9B5A0F3D7950@BL0PR2101MB0914.namprd21.prod.outlook.com>
References: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dexuan Cui <decui@microsoft.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Dexuan Cui <decui@microsoft.com>  Sent: Wednesday, January 23, 2019 1=
2:51 PM
>=20
> Add the Hyper-V _DSM command set to the white list of NVDIMM command
> sets.
>=20
> This command set is documented at
> http://www.uefi.org/RFIC_LIST (see the link to "Virtual NVDIMM 0x1901" on=
 the page).
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>=20
> I'm going to change the user-space utility "ndctl" to support Hyper-V Vir=
tual NVDIMM.
> This kernel patch is required first.
>=20
>  drivers/acpi/nfit/core.c   | 5 ++++-
>  drivers/acpi/nfit/nfit.h   | 6 +++++-
>  include/uapi/linux/ndctl.h | 1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
>=20

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
