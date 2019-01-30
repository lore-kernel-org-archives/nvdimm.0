Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH] nfit: Collect shutdown status for NVDIMM_FAMILY_HYPERV
Date: Wed, 30 Jan 2019 20:10:49 +0000
Message-ID: <PU1P153MB01698684AC3E12B2F3DD09AEBF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01691690696D8F83FC1872C7BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190130193752.GA21181@kroah.com>
 <PU1P153MB01696669DA81578B11734765BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01696669DA81578B11734765BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> Dexuan Cui
> Sent: Wednesday, January 30, 2019 12:03 PM
> To: Greg KH <gregkh@linuxfoundation.org>
> Cc: Josh Poulson <jopoulso@microsoft.com>; linux-nvdimm@lists.01.org;
> Haiyang Zhang <haiyangz@microsoft.com>;
> driverdev-devel@linuxdriverproject.org; Rafael J. Wysocki
> <rjw@rjwysocki.net>; linux-kernel@vger.kernel.org; Michael Kelley
> <mikelley@microsoft.com>; Sasha Levin <Alexander.Levin@microsoft.com>;
> linux-acpi@vger.kernel.org; Ross Zwisler <zwisler@kernel.org>; Stephen
> Hemminger <sthemmin@microsoft.com>; Len Brown <lenb@kernel.org>
> Subject: RE: [PATCH] nfit: Collect shutdown status for
> NVDIMM_FAMILY_HYPERV
>=20
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, January 30, 2019 11:38 AM
> >
> > On Wed, Jan 30, 2019 at 06:48:40PM +0000, Dexuan Cui wrote:
> > >
> > > Let's expose the info to the userspace (e.g. ntctl) via sysfs.
> >
> > If you add a new sysfs file, you need to add a new Documentation/ABI/
> > update as well :(
>=20
> It's an existing sysfs node, which was originally added by Dan in Sep 201=
8:
> /sys/bus/nd/devices/nmem0/nfit/dirty_shutdown.
>=20
> Before this patch, the node doesn't appear when Linux runs on Hyper-V,
> and with this patch, the node can appear now.
>=20
> However, indeed, the node and the other related nodes have not been
> documented in Documentation/ABI/testing/sysfs-bus-nfit yet.
> I suppose Dan would add that?
Actually the other nodes have been documented, and only the
"dirty_shutdown" is missed.=20

It should be straightfoward. Let me make a patch for this.

Thanks for the reminder, Greg!
=20
Thanks,
-- Dexuan
