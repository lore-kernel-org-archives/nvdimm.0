Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH] libnvdimm/dimm: Add a no-BLK quirk based on NVDIMM family
Date: Sun, 3 Feb 2019 17:40:34 +0000
Message-ID: <PU1P153MB0169D0DA7D2C41CDAF94153BBF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <154915640488.3541628.4947340559510114602.stgit@dwillia2-desk3.amr.corp.intel.com>
 <201902032214.9a8kjJLO%fengguang.wu@intel.com>
In-Reply-To: <201902032214.9a8kjJLO%fengguang.wu@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> From: kbuild test robot <lkp@intel.com>
> Sent: Sunday, February 3, 2019 6:38 AM
>  ...
> Hi Dan,
>=20
> I love your patch! Yet something to improve:
>=20
> [auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
> [also build test ERROR on v5.0-rc4 next-20190201]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help
> improve the system]
> ...
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-8 (Debian 8.2.0-14) 8.2.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=3Dx86_64
>=20
> All errors (new ones prefixed by >>):
>=20
>    drivers/acpi/nfit/core.c: In function 'acpi_nfit_register_dimms':
> >> drivers/acpi/nfit/core.c:2003:27: error: 'NVDIMM_FAMILY_HYPERV'
> undeclared (first use in this function); did you mean 'NVDIMM_FAMILY_HPE1=
'?
>       if (nfit_mem->family =3D=3D NVDIMM_FAMILY_HYPERV)
>                               ^~~~~~~~~~~~~~~~~~~~
>                               NVDIMM_FAMILY_HPE1
>    drivers/acpi/nfit/core.c:2003:27: note: each undeclared identifier is
> reported only once for each function it appears in

This is a false alarm, too. The patch is only for
https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=3Dli=
bnvdimm-pending
where we have the dependant commit:
1194c4133195 ("nfit: Add Hyper-V NVDIMM DSM command set to white list")

Thanks,
-- Dexuan
