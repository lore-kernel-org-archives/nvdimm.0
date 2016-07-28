Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on071a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe45::71a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 750561A1E27
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 10:43:25 -0700 (PDT)
Subject: Re: HPE SMART data retreival
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
 <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
 <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
Date: Thu, 28 Jul 2016 13:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
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



On 7/28/2016 5:45 AM, Johannes Thumshirn wrote:
> On Wed, Jul 27, 2016 at 02:23:51PM -0400, Linda Knippers wrote:
>> Hi Johannes,
>>
>> I hope Dan and Jerry also reply but I have recently started looking at
>> this too and have some comments below.
> 
> So if we two are looking into it we might want to work together so we don't do
> all the work twice.

Definitely!

> I've pasted my current work to export HPE DIMM commands at the bottom of the
> mail, but I don't like it very much (see below for a proposal of a more
> elegant way).
> 
>>
>> On 7/27/2016 6:35 AM, Johannes Thumshirn wrote:
>>> Hi Dan and Jerry,
>>>
>>> I'm currently looking into SMART data retrieval on HPE NVDIMMs.
>>>
>>> After the first obstacle (like getting cat
>>> /sys/class/nd/ndctl0/device/nmem0/commands reutrn smart so ndctl will issue
>>> the ioctl) I ran into a rather nasty problem. According to [1] HPEDIMMs
>>> need the input buffer specially crafted for SMART data, according to [2]
>>> Intel DIMMs don't.
>>
>> It is unfortunate that the DSM functions are different for different NVDIMM
>>
>> types.  There is a desire for standardization but for now this is what we have.
> 
> Sure, let's see what we can come up with to "fix" the situation.
> 
> I had a quick chat here internally at SUSE and one suggestion was to create
> something, let's call it "filter drivers", to support different DSMs for
> different NVDIMM families. I actually like the idea and if no-one objects I'll
> try to implement some kind of prototype for the "filter drivers".

I think a question we need to answer is what should be in the kernel vs. in user
space and what the interface between the two should look like.  The kernel
doesn't necessarily need to know that function 1 returns health information
and function 2 returns threshold information unless it needs the information
itself.  I think the intent of cmd_call was just as a pass-through mechanism
to keep from adding more code into the kernel.  We could create ndctl functions
instead.  I know this is different from how the original Intel DSM functions
are implemented but that could be considered legacy code to support existing
applications at this point.

For history, the first discussions about this approach were on the nvdimm
list back in November and it went from there.
https://lists.01.org/pipermail/linux-nvdimm/2015-November/002721.html

>>
>>> Adding translation functions for the DIMMs accepted commands is one thing and
>>> should be more or less trivial for all DIMMs (I'll post an RFC patch as soon
>>> as Linus merged Dan's 4.8 pull request so I can rebase it) but doing this
>>> type of conversation for each and every command for every defined vendor
>>> family for both the input and output buffers will drive us all mad I guess.
>>
>> In my opinion, I don't think we need ndctl to be able to issue every function
>> and decode every response but I would like to see the --health option to report
>> the "SMART and Health" data reported by functions 1 and 2.  I could be wrong
>> but I think that's all it does for the NVDIMMs that use the Intel example DSM.
> 
> That's what I think as well.
> 
>>
>> There are functions in libndctl that issue other DSMs but I don't think
>> those aren't used by the ndctl command itself.  Whether we need the other
>> functions in libndctl to work with non-Intel DSM devices is still TBD.
>>
>>> Especially from the distribution's POV I'm not to keen on having customers
>>> with some new NVDIMM family and we would need to re-implement all the
>>> translators again. Adding a new ID is one thing but translation tables are a
>>> totally different story.
>>>
>>> So the question is have I overlooked something and there is a clean and easy
>>> solution to this problem, or not.
>>
>> I don't think it's clean and easy today.  I think it needs to be made a bit
>> more modular to handle the NVDIMMs that have DSMs implemented using the
>> pass-through mode.
>>
>>> @Jerry have you tested SMART data retrieval with ndctl? Did it work for you?
>>
>> I tried it and it does not work.
> 
> Ok this at least rules out my own stupidity.
> 
> 
> As said, here's my current translation code, I'll try to implement the filter
> driver idea and report back to the ML once I have something working. The
> emphasis is on SMART and Health data currently but I'd like to expand it so we
> have most of the documented DSMs supported until we've found a standard way.

My comments above may change all this but I'll comment on the code anyway....
> 
> From 7572ea9aaae7382133da2afd972ee948adb9bf0f Mon Sep 17 00:00:00 2001
> From: Johannes Thumshirn <jthumshirn@suse.de>
> Date: Thu, 28 Jul 2016 09:07:13 +0200
> Subject: [PATCH] nfit: Read DSM Mask for HPE DIMMs as well
> 
> Currently the nfit driver only reads the DIMMs supported DSM mask for Intel
> DIMMs, so we end up with only "cmd_call" in sysfs' supported commands file
> /sys/class/nd/ndctlX/device/nmemX/commands.
> 
> Introduce some translation functions to map NVDIMM_FAMILY_HPE1 and
> NVDIMM_FAMILY_HPE2 to the currently implemented Intel commands.

Today, we have no platform that implements HPE2 without also implementing
HPE1. HPE1 will be found and used first by the current Linux code.
We may discontinue HPE2...still being discussed...so we might not need
the HPE2 functions.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/acpi/nfit.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index ddff49d..50a1b81 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1163,6 +1163,53 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  	return 0;
>  }
>  
> +static inline unsigned long
> +acpi_nfit_decode_dsm_mask_from_intel(unsigned long dsm_mask)
> +{
> +	return dsm_mask;
> +}
> +
> +static inline unsigned long
> +acpi_nfit_decode_dsm_mask_from_hpe1(unsigned long dsm_mask)
> +{
> +	unsigned long cmd_mask = 0;
> +
> +	if (test_bit(1, &dsm_mask))
> +		set_bit(ND_CMD_SMART, &cmd_mask);
> +	if (test_bit(2, &dsm_mask))
> +		set_bit(ND_CMD_SMART_THRESHOLD, &cmd_mask);
> +
> +	return cmd_mask;
> +}
> +
> +static inline unsigned long
> +acpi_nfit_decode_dsm_mask_from_hpe2(unsigned long dsm_mask)
> +{
> +	unsigned long cmd_mask = 0;
> +
> +	if (test_bit(1, &dsm_mask))
> +		set_bit(ND_CMD_SMART, &dsm_mask);
> +	if (test_bit(2, &dsm_mask))
> +		set_bit(ND_CMD_SMART_THRESHOLD, &dsm_mask);
> +	if (test_bit(4, &dsm_mask))
> +		set_bit(ND_CMD_DIMM_FLAGS, &dsm_mask);
> +	if (test_bit(6, &dsm_mask))
> +		set_bit(ND_CMD_VENDOR_EFFECT_LOG_SIZE, &dsm_mask);
> +	if (test_bit(7, &dsm_mask))
> +		set_bit(ND_CMD_VENDOR_EFFECT_LOG, &dsm_mask);
> +	if (test_bit(8, &dsm_mask))
> +		set_bit(ND_CMD_VENDOR, &dsm_mask);
> +

You're actually setting dsm_mask, not cmd_mask above.

I'm not sure I see the value of re-using the ND_CMD_* values that are
defined for the Intel DSM where they happen to be the same as for other
DSM vs. just defining a new set of values that match each DSM implementation.

Or are you trying to map ND_CMD_SMART from user space into the function
number that implements that command for the particular DSM?

I think the only way to hid the implementation differences, including
the function differences, from user space would be to define generic
functions with generic output buffers that can represent all of the
data returned by any of the DSMs in a standard format.

> +	return cmd_mask;
> +}
> +
> +static unsigned long (*decoder_funcs[])(unsigned long dsm_mask) = {
> +	[NVDIMM_FAMILY_INTEL] = acpi_nfit_decode_dsm_mask_from_intel,
> +	[NVDIMM_FAMILY_HPE1] = acpi_nfit_decode_dsm_mask_from_hpe1,
> +	[NVDIMM_FAMILY_HPE2] = acpi_nfit_decode_dsm_mask_from_hpe2,

I think Dan just pushed the code for yet another family.

> +};
> +
> +
>  static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  {
>  	struct nfit_mem *nfit_mem;
> @@ -1199,8 +1246,16 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  		 * userspace interface.
>  		 */
>  		cmd_mask = 1UL << ND_CMD_CALL;
> -		if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
> -			cmd_mask |= nfit_mem->dsm_mask;
> +		if (nfit_mem->family >= 0 &&
> +		    nfit_mem->family <= NVDIMM_FAMILY_HPE2) {
> +			int family = nfit_mem->family;
> +			unsigned long dsm_mask = nfit_mem->dsm_mask;
> +
> +			cmd_mask |= (*decoder_funcs[family])(dsm_mask);
> +		} else {
> +			dev_dbg(acpi_desc->dev, "Unknown NVDIMM Family %d\n",
> +				nfit_mem->family);
> +		}
>  
>  		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
>  				acpi_nfit_dimm_attribute_groups,
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
