Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5CFA1A1E2C
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 04:55:41 -0700 (PDT)
Date: Fri, 29 Jul 2016 13:55:38 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: HPE SMART data retreival
Message-ID: <20160729115538.hkhywboarkmzb6ti@c203.arch.suse.de>
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
 <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
 <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
 <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linda Knippers <linda.knippers@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 28, 2016 at 01:43:17PM -0400, Linda Knippers wrote:

[...]

> > +acpi_nfit_decode_dsm_mask_from_hpe2(unsigned long dsm_mask)
> > +{
> > +	unsigned long cmd_mask =3D 0;
> > +
> > +	if (test_bit(1, &dsm_mask))
> > +		set_bit(ND_CMD_SMART, &dsm_mask);
> > +	if (test_bit(2, &dsm_mask))
> > +		set_bit(ND_CMD_SMART_THRESHOLD, &dsm_mask);
> > +	if (test_bit(4, &dsm_mask))
> > +		set_bit(ND_CMD_DIMM_FLAGS, &dsm_mask);
> > +	if (test_bit(6, &dsm_mask))
> > +		set_bit(ND_CMD_VENDOR_EFFECT_LOG_SIZE, &dsm_mask);
> > +	if (test_bit(7, &dsm_mask))
> > +		set_bit(ND_CMD_VENDOR_EFFECT_LOG, &dsm_mask);
> > +	if (test_bit(8, &dsm_mask))
> > +		set_bit(ND_CMD_VENDOR, &dsm_mask);
> > +
> =

> You're actually setting dsm_mask, not cmd_mask above.

*duh* good catch.

> =

> I'm not sure I see the value of re-using the ND_CMD_* values that are
> defined for the Intel DSM where they happen to be the same as for other
> DSM vs. just defining a new set of values that match each DSM implementat=
ion.
> =

> Or are you trying to map ND_CMD_SMART from user space into the function
> number that implements that command for the particular DSM?
> =

> I think the only way to hid the implementation differences, including
> the function differences, from user space would be to define generic
> functions with generic output buffers that can represent all of the
> data returned by any of the DSMs in a standard format.
> =


I'd like to go down the "map what can be mapped and create new commands
for things we don't have yet" road. And yes I've been looking into the
Microsoft DSM spec just to discover they define 31 methods and I'm not
sure if we can map them. This is why I wrote the patches in a "draw on the
whiteboard" style so you and Dan can comment early enough.

> > +	return cmd_mask;
> > +}
> > +
> > +static unsigned long (*decoder_funcs[])(unsigned long dsm_mask) =3D {
> > +	[NVDIMM_FAMILY_INTEL] =3D acpi_nfit_decode_dsm_mask_from_intel,
> > +	[NVDIMM_FAMILY_HPE1] =3D acpi_nfit_decode_dsm_mask_from_hpe1,
> > +	[NVDIMM_FAMILY_HPE2] =3D acpi_nfit_decode_dsm_mask_from_hpe2,
> =

> I think Dan just pushed the code for yet another family.
> =


Yes I know, but my development tree doesn't have it merged yet.

Anyways, how about this approach (for NFIT_FAMILY_HPE1, NFIT_FAMILY_INTEL a=
lso
started)?

I think this is the way we should go to a) handle pre-standard differences =
in
the kernel and b) don't end up with massively bloated object files as that
have code for multiple DSM specs all in one file.

/*
 * Copyright(c) 2016 SUSE Linux GmbH. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 */
#include <linux/module.h>
#include <linux/acpi.h>
#include <linux/nvdimm.h>

#include "dsm_filter.h"


static int
nfit_hpe1_acpi_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nv=
dimm,
		   unsigned int cmd, void *buf, unsigned int buf_len,
		   int *cmd_rc)
{
	/* do magic here */
}

static unsigned long nfit_hpe1_get_command_mask(unsigned long dsm_mask)
{
	unsigned long cmd_mask =3D 0;

	if (test_bit(1, &dsm_mask))
		set_bit(ND_CMD_SMART, &cmd_mask);
	if (test_bit(2, &dsm_mask))
		set_bit(ND_CMD_SMART_THRESHOLD, &cmd_mask);

	return cmd_mask;
}

static nfit_dsm_ops hpe1_dsm_ops =3D {
	.get_command_mask =3D nfit_hpe1_get_command_mask,
	.acpi_nfit_ctl =3D nfit_hpe1_acpi_ctl,
};

static in nfit_hpe1_probe(struct nfit_dsm_device *ddev, const u8 *uuid)
{
	return 0;
}

static void nfit_hpe1_remove(struct nfit_dsm_device *ddev)
{
	return;
}

static u8 *nfit_hpe1_uuids[16] =3D {
	"9002c334-acf3-4c0e-9642-a235f0d53bc6",
	0,
};
MODULE_DEVICE_TABLE(nfit_dsm, nfit_hpe1_uuids);

static struct nfit_dsm_driver hpe1_dsm_driver =3D {
	.driver =3D {
		.name =3D "nfit_dsm_hpe1",
		.owner =3D THIS_MODULE,
	},
	.probe =3D nfit_hpe1_probe,
	.remove =3D nfit_hpe1_remove,
	.uuids =3D nfit_hpe1_uuids,
};

static int __init nfit_dsm_hpe1_init(void)
{
	return nfit_register_dsm_filter(&hpe1_dsm_driver);
}
module_init(nfit_dsm_hpe1_init);

static void __exit nfit_dsm_hpe1_exit(void)
{
	nfit_unregister_dsm_filter(&hpe1_dsm_driver);
}
module_exit(nfit_dsm_hpe1_exit);

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Johannes Thumshirn <jthumshirn@suse.de>");
MODULE_DESCRIPTION("NFIT DSM filter driver for HPE Type 1 NVDIMMs");

What's missing in here is a) the glue code to drivers/acpi/nfit.c and b) the
implementations of HPE1 DSMs.

Once I have these two I'll post a RFC patch series to the ML, but in the
meanwhile I'm already open to comments.

The glue code to nfit will be a bus so we have all the nice and shiny .prob=
e()
.remove() .uevent() and what not.

Thanks,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
