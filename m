Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0708.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::708])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED41D80345
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 18:13:58 -0800 (PST)
Subject: Re: [PATCH 2/3] Allow specifying a default DSM family
References: <cover.1488844291.git.linda.knippers@hpe.com>
 <1773e8607ae49fefbb288509603a0db353a72d91.1488844291.git.linda.knippers@hpe.com>
 <CAPcyv4gmSTTwnUcfGmsvyp8XSL2Zs9ayXjDrz6XakDhp-rMTbg@mail.gmail.com>
 <58BE0E06.7020309@hpe.com>
 <CAPcyv4ivbmCdvRhC_ETWBumP7-UA71Lv3va96s34RQPqOLGNdA@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58BE1760.3010603@hpe.com>
Date: Mon, 6 Mar 2017 21:13:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ivbmCdvRhC_ETWBumP7-UA71Lv3va96s34RQPqOLGNdA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 03/06/2017 08:56 PM, Dan Williams wrote:
> On Mon, Mar 6, 2017 at 5:33 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> On 03/06/2017 07:39 PM, Dan Williams wrote:
>>> On Mon, Mar 6, 2017 at 4:25 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>> Provide the ability to request a default DSM family. If it is not
>>>> supported, then fall back to the normal discovery order.
>>>>
>>>> This is helpful for testing platforms that support multiple DSM families.
>>>> It will also allow administrators to request the DSM family that their
>>>> management tools support, which may not be the first one found using
>>>> the current discovery order.
>>>>
>>>> Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
>>>> ---
>>>>  drivers/acpi/nfit/core.c | 26 ++++++++++++++++++++++----
>>>>  1 file changed, 22 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>>>> index 97d42ff..78c46a7 100644
>>>> --- a/drivers/acpi/nfit/core.c
>>>> +++ b/drivers/acpi/nfit/core.c
>>>> @@ -55,6 +55,11 @@
>>>>  module_param(override_dsm_mask, ulong, S_IRUGO);
>>>>  MODULE_PARM_DESC(override_dsm_mask, "Bitmask of allowed NVDIMM DSM functions");
>>>>
>>>> +static int default_dsm_family = -1;
>>>> +module_param(default_dsm_family, int, S_IRUGO);
>>>> +MODULE_PARM_DESC(default_dsm_family,
>>>> +               "Try this DSM type first when identifying NVDIMM family");
>>>> +
>>>>  LIST_HEAD(acpi_descs);
>>>>  DEFINE_MUTEX(acpi_desc_lock);
>>>>
>>>> @@ -1371,7 +1376,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>>>>         struct device *dev = acpi_desc->dev;
>>>>         unsigned long dsm_mask;
>>>>         const u8 *uuid;
>>>> -       int i;
>>>> +       int i = -1;
>>>>
>>>>         /* nfit test assumes 1:1 relationship between commands and dsms */
>>>>         nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
>>>> @@ -1399,10 +1404,23 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>>>>          * Until standardization materializes we need to consider 4
>>>>          * different command sets.  Note, that checking for function0 (bit0)
>>>>          * tells us if any commands are reachable through this uuid.
>>>> +        * First check for a requested default.
>>>>          */
>>>> -       for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
>>>> -               if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
>>>> -                       break;
>>>> +       if (default_dsm_family >= NVDIMM_FAMILY_INTEL &&
>>>> +                       default_dsm_family <= NVDIMM_FAMILY_MSFT) {
>>>> +               if (acpi_check_dsm(adev_dimm->handle,
>>>> +                               to_nfit_uuid(default_dsm_family), 1, 1))
>>>> +                       i = default_dsm_family;
>>>> +               else
>>>> +                       dev_dbg(dev, "default_dsm_family %d not supported\n",
>>>> +                               default_dsm_family);
>>>> +       }
>>>> +       if (i == -1) {
>>>> +               for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
>>>> +                       if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i),
>>>> +                                       1, 1))
>>>> +                               break;
>>>> +       }
>>>
>>> I think we can make this simpler and more deterministic with a "force"
>>> option? Something like:
>>>
>>> @@ -1397,8 +1397,12 @@ static int acpi_nfit_add_dimm(struct
>>> acpi_nfit_desc *acpi_desc,
>>>          * tells us if any commands are reachable through this uuid.
>>>          */
>>>         for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
>>> -               if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
>>> -                       break;
>>> +               if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1)) {
>>> +                       if (force_dsm_family < 0)
>>> +                               break;
>>> +                       else if (i == force_dsm_family)
>>> +                               break;
>>> +               }
>>>
>>>         /* limit the supported commands to those that are publicly documented */
>>>         nfit_mem->family = i;
>>>
>>> ...because the user specifying the override should know ahead of time
>>> if that family is available, and we should fail the detection
>>> otherwise.
>>
>> It's more complicated when you have a mixture of NVDIMM types, where not all
>> NVDIMMs support the same families.  For example, you could have an Intel
>> NVDIMM in the same system as an HPE NVDIMM-N.  The reason I called it
>> "default" is because it should be the default for all devices that support
>> that family but I didn't want other types of NVDIMMs to end up with
>> no family at all.
>>
> 
> Ok, but I still think we can make the logic a bit simpler. I'm
> reacting to the new "if (i == -1)" branch and 2 locations where we
> call "acpi_check_dsm()". How about this to centralize everything?
> 
> @@ -1397,11 +1397,15 @@ static int acpi_nfit_add_dimm(struct
> acpi_nfit_desc *acpi_desc,
>          * tells us if any commands are reachable through this uuid.
>          */
>         for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
> -               if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
> -                       break;
> +               if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1)) {
> +                       if (family < 0 || i == default_dsm_family) {
> +                               family = i;
> +                               break;
> +                       }
> +               }
> 
>         /* limit the supported commands to those that are publicly documented */
> -       nfit_mem->family = i;
> +       nfit_mem->family = family;
>         if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
>                 dsm_mask = 0x3fe;
>                 if (disable_vendor_specific)
> 

I think that will work.  I'll test it in the morning.

Thanks for the feedback. I wasn't crazy about the code myself.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
