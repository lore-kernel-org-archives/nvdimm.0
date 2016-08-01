Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on072d.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::72d])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D08A1A1E48
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 13:57:41 -0700 (PDT)
Subject: Re: HPE SMART data retreival
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
 <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
 <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
 <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
 <20160729115538.hkhywboarkmzb6ti@c203.arch.suse.de>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <de71bb80-d0be-d5b7-39ed-dd24f53cc2e9@hpe.com>
Date: Mon, 1 Aug 2016 16:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <20160729115538.hkhywboarkmzb6ti@c203.arch.suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 7/29/2016 7:55 AM, Johannes Thumshirn wrote:
> On Thu, Jul 28, 2016 at 01:43:17PM -0400, Linda Knippers wrote:
> 
> [...]
>>
>> I'm not sure I see the value of re-using the ND_CMD_* values that are
>> defined for the Intel DSM where they happen to be the same as for other
>> DSM vs. just defining a new set of values that match each DSM implementation.
>>
>> Or are you trying to map ND_CMD_SMART from user space into the function
>> number that implements that command for the particular DSM?
>>
>> I think the only way to hid the implementation differences, including
>> the function differences, from user space would be to define generic
>> functions with generic output buffers that can represent all of the
>> data returned by any of the DSMs in a standard format.
>>
> 
> I'd like to go down the "map what can be mapped and create new commands
> for things we don't have yet" road. And yes I've been looking into the
> Microsoft DSM spec just to discover they define 31 methods and I'm not
> sure if we can map them. This is why I wrote the patches in a "draw on the
> whiteboard" style so you and Dan can comment early enough.
> 
>>> +	return cmd_mask;
>>> +}
>>> +
>>> +static unsigned long (*decoder_funcs[])(unsigned long dsm_mask) = {
>>> +	[NVDIMM_FAMILY_INTEL] = acpi_nfit_decode_dsm_mask_from_intel,
>>> +	[NVDIMM_FAMILY_HPE1] = acpi_nfit_decode_dsm_mask_from_hpe1,
>>> +	[NVDIMM_FAMILY_HPE2] = acpi_nfit_decode_dsm_mask_from_hpe2,
>>
>> I think Dan just pushed the code for yet another family.
>>
> 
> Yes I know, but my development tree doesn't have it merged yet.
> 
> Anyways, how about this approach (for NFIT_FAMILY_HPE1, NFIT_FAMILY_INTEL also
> started)?
> 
> I think this is the way we should go to a) handle pre-standard differences in
> the kernel and b) don't end up with massively bloated object files as that
> have code for multiple DSM specs all in one file.
> 
> /*
>  * Copyright(c) 2016 SUSE Linux GmbH. All rights reserved.
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of version 2 of the GNU General Public License as
>  * published by the Free Software Foundation.
>  *
>  * This program is distributed in the hope that it will be useful, but
>  * WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>  * General Public License for more details.
>  */
> #include <linux/module.h>
> #include <linux/acpi.h>
> #include <linux/nvdimm.h>
> 
> #include "dsm_filter.h"
> 
> 
> static int
> nfit_hpe1_acpi_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
> 		   unsigned int cmd, void *buf, unsigned int buf_len,
> 		   int *cmd_rc)
> {
> 	/* do magic here */
> }
> 
> static unsigned long nfit_hpe1_get_command_mask(unsigned long dsm_mask)
> {
> 	unsigned long cmd_mask = 0;
> 
> 	if (test_bit(1, &dsm_mask))
> 		set_bit(ND_CMD_SMART, &cmd_mask);
> 	if (test_bit(2, &dsm_mask))
> 		set_bit(ND_CMD_SMART_THRESHOLD, &cmd_mask);
> 
> 	return cmd_mask;
> }
> 
> static nfit_dsm_ops hpe1_dsm_ops = {
> 	.get_command_mask = nfit_hpe1_get_command_mask,
> 	.acpi_nfit_ctl = nfit_hpe1_acpi_ctl,
> };
> 
> static in nfit_hpe1_probe(struct nfit_dsm_device *ddev, const u8 *uuid)
> {
> 	return 0;
> }
> 
> static void nfit_hpe1_remove(struct nfit_dsm_device *ddev)
> {
> 	return;
> }
> 
> static u8 *nfit_hpe1_uuids[16] = {
> 	"9002c334-acf3-4c0e-9642-a235f0d53bc6",
> 	0,
> };
> MODULE_DEVICE_TABLE(nfit_dsm, nfit_hpe1_uuids);
> 
> static struct nfit_dsm_driver hpe1_dsm_driver = {
> 	.driver = {
> 		.name = "nfit_dsm_hpe1",
> 		.owner = THIS_MODULE,
> 	},
> 	.probe = nfit_hpe1_probe,
> 	.remove = nfit_hpe1_remove,
> 	.uuids = nfit_hpe1_uuids,
> };
> 
> static int __init nfit_dsm_hpe1_init(void)
> {
> 	return nfit_register_dsm_filter(&hpe1_dsm_driver);
> }
> module_init(nfit_dsm_hpe1_init);
> 
> static void __exit nfit_dsm_hpe1_exit(void)
> {
> 	nfit_unregister_dsm_filter(&hpe1_dsm_driver);
> }
> module_exit(nfit_dsm_hpe1_exit);
> 
> MODULE_LICENSE("GPL v2");
> MODULE_AUTHOR("Johannes Thumshirn <jthumshirn@suse.de>");
> MODULE_DESCRIPTION("NFIT DSM filter driver for HPE Type 1 NVDIMMs");
> 
> What's missing in here is a) the glue code to drivers/acpi/nfit.c and b) the
> implementations of HPE1 DSMs.
> 
> Once I have these two I'll post a RFC patch series to the ML, but in the
> meanwhile I'm already open to comments.
> 
> The glue code to nfit will be a bus so we have all the nice and shiny .probe()
> .remove() .uevent() and what not.

There are some things I like about this approach.  What I like most is
that it add modularity.  I think that when the ACPI tables for NVDIMM
devices were designed, the idea was that you could have different types
of NVDIMMs with different capabilities and management requirements, and
have generic as well as device-specific software.  Section 9.20.5
describes the different fields that might be used to distinguish the
hardware and load device or vendor-specific drivers.  We don't have
flexibility in the current code.  Perhaps it makes sense to evolve our
current code base to one where the root functions are in the Generic NVDIMM
management driver and we have vendor-specific management drivers for the
non-root device DSMs.  I don't know if we need that for the other driver
types but management is becoming more complicated without them.

-- ljk
> 
> Thanks,
> 	Johannes
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
