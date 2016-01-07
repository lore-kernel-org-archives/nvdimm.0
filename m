Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <568EF1AA.6070001@hpe.com>
Date: Thu, 07 Jan 2016 18:15:54 -0500
From: Linda Knippers <linda.knippers@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] libnvdimm: Add a poison list and export badblocks
References: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>	<1451010103-11462-3-git-send-email-vishal.l.verma@intel.com>	<568ED633.8020702@hpe.com> <CAPcyv4g-z1Ua_uHHwSTeKfpf5ABHr5V+R3_SmFfPxZix2u8NAQ@mail.gmail.com>
In-Reply-To: <CAPcyv4g-z1Ua_uHHwSTeKfpf5ABHr5V+R3_SmFfPxZix2u8NAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 1/7/2016 5:49 PM, Dan Williams wrote:
> On Thu, Jan 7, 2016 at 1:18 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>
>> On 12/24/2015 9:21 PM, Vishal Verma wrote:
>>> During region creation, perform Address Range Scrubs (ARS) for the SPA
>>> (System Physical Address) ranges to retrieve known poison locations from
>>> firmware. Add a new data structure 'nd_poison' which is used as a list
>>> in nvdimm_bus to store these poison locations.
>>>
>>> When creating a pmem namespace, if there is any known poison associated
>>> with its physical address space, convert the poison ranges to bad sectors
>>> that are exposed using the badblocks interface.
>>>
>>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>>> ---
>>>  drivers/acpi/nfit.c       | 203 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  drivers/nvdimm/core.c     | 187 ++++++++++++++++++++++++++++++++++++++++++
>>>  drivers/nvdimm/nd-core.h  |   3 +
>>>  drivers/nvdimm/nd.h       |   6 ++
>>>  drivers/nvdimm/pmem.c     |   6 ++
>>>  include/linux/libnvdimm.h |   1 +
>>>  6 files changed, 406 insertions(+)
>>>
>>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>>
>> Why are the ARS function in acpi/nfit.c rather than in the core?
>> I realize that the interfaces are/will be defined in the ACPI spec but
>> it's not really part of the NFIT.
>>
>> Why isn't this part of the nvdimm core, where the calls are made?
> 
> True.  acpi_nfit_find_poison() could easily become
> nvdimm_bus_find_poison() and move to the core.  However we only need
> to take that step when / if another nvdimm bus type show up that isn't
> nfit defined.  For now only nfit-defined nvdimms have a concept of
> ARS.

Why not go ahead and move it now?

I agree that ARS is related to NFIT, but practically everything else
in the core is as well.  It doesn't seem to belongs in nfit.c.  I
didn't even notice that's where it was since the subject line says
"libnvdimm".

> 
>>
>>> index aa45d48..ad6d8c6 100644
>>> --- a/drivers/acpi/nfit.c
>>> +++ b/drivers/acpi/nfit.c
>>> @@ -15,6 +15,7 @@
>>>  #include <linux/module.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/ndctl.h>
>>> +#include <linux/delay.h>
>>>  #include <linux/list.h>
>>>  #include <linux/acpi.h>
>>>  #include <linux/sort.h>
>>> @@ -1473,6 +1474,201 @@ static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
>>>       /* devm will free nfit_blk */
>>>  }
>>>
>>> +static int ars_get_cap(struct nvdimm_bus_descriptor *nd_desc,
>>> +             struct nd_cmd_ars_cap *cmd, u64 addr, u64 length)
>>> +{
>>> +     cmd->address = addr;
>>> +     cmd->length = length;
>>> +
>>> +     return nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, cmd,
>>> +                     sizeof(*cmd));
>>> +}
>>> +
>>> +static int ars_do_start(struct nvdimm_bus_descriptor *nd_desc,
>>> +             struct nd_cmd_ars_start *cmd, u64 addr, u64 length)
>>> +{
>>> +     int rc;
>>> +
>>> +     cmd->address = addr;
>>> +     cmd->length = length;
>>> +     cmd->type = ND_ARS_PERSISTENT;
>>> +
>>> +     while (1) {
>>> +             rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_START, cmd,
>>> +                             sizeof(*cmd));
>>> +             if (rc)
>>> +                     return rc;
>>> +             switch (cmd->status) {
>>> +             case 0:
>>> +                     return 0;
>>> +             case 1:
>>> +                     /* ARS unsupported, but we should never get here */
>>> +                     return 0;
>>> +             case 2:
>>> +                     return -EINVAL;
>>> +             case 3:
>>
>> Are these values in flux in the ACPI spec?  Would #defines help?
> 
> Yes that would be more readable...
> 
>>> +                     /* ARS is in progress */
>>> +                     msleep(1000);
>>> +                     break;
>>
>> Should this be considered an error (perhaps EAGAIN?) if an ARS
>> is in progress since you're supposed to check the status before
>> attempting to start one?  Do we really want to keep retrying
>> it, potentially forever, here?
> 
> We indeed need a timeout here.  I'll take a look at this and the above
> as Vishal is out for the rest of the week.
> 
> There's also plans for 4.6 to make ARS polling asynchronous to the
> rest of the nvdimm system coming up, but deemed too risky /
> complicated for intercepting 4.5.

Ok, makes sense.

> 
>>
>>> +             default:
>>> +                     return -ENXIO;
>>> +             }
>>> +     }
>>> +}
>>> +
>>> +static int ars_get_status(struct nvdimm_bus_descriptor *nd_desc,
>>> +             struct nd_cmd_ars_status *cmd)
>>> +{
>>> +     int rc;
>>> +
>>> +     while (1) {
>>> +             rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_STATUS, cmd,
>>> +                     sizeof(*cmd));
>>> +             if (rc || cmd->status & 0xffff)
>>> +                     return -ENXIO;
>>> +
>>> +             /* Check extended status (Upper two bytes) */
>>> +             switch (cmd->status >> 16) {
>>> +             case 0:
>>> +                     return 0;
>>> +             case 1:
>>> +                     /* ARS is in progress */
>>> +                     msleep(1000);
>>> +                     break;
>>
>> Why isn't ARS in progress a legitimate status to return,
>> especially if you're supposed to check if one is in progress
>> before starting one?
>>
>> You could have a different call to wait for completion if
>> that's what you want to do, but it wouldn't be called
>> ars_get_status().
> 
> Right, this is something to address when we make ARS fully asynchronous.
> 
>>
>>> +             case 2:
>>> +                     /* No ARS performed for the current boot */
>>> +                     return 0;
>>> +             default:
>>> +                     return -ENXIO;
>>> +             }
>>> +     }
>>> +}
>>> +
>>> +static int ars_status_process_records(struct nvdimm_bus *nvdimm_bus,
>>> +             struct nd_cmd_ars_status *ars_status, u64 start)
>>> +{
>>> +     int rc;
>>> +     u32 i;
>>> +
>>> +     /*
>>> +      * The address field returned by ars_status should be either
>>> +      * less than or equal to the address we last started ARS for.
>>> +      * The (start, length) returned by ars_status should also have
>>> +      * non-zero overlap with the range we started ARS for.
>>> +      * If this is not the case, bail.
>>> +      */
>>> +     if (ars_status->address > start ||
>>> +                     (ars_status->address + ars_status->length < start))
>>> +             return -ENXIO;
>>> +
>>> +     for (i = 0; i < ars_status->num_records; i++) {
>>> +             rc = nvdimm_bus_add_poison(nvdimm_bus,
>>> +                             ars_status->records[i].err_address,
>>> +                             ars_status->records[i].length);
>>> +             if (rc)
>>> +                     return rc;
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
>>> +             struct nd_region_desc *ndr_desc)
>>> +{
>>> +     struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
>>> +     struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
>>> +     struct nd_cmd_ars_status *ars_status = NULL;
>>> +     struct nd_cmd_ars_start *ars_start = NULL;
>>> +     struct nd_cmd_ars_cap *ars_cap = NULL;
>>> +     u64 start, len, cur, remaining;
>>> +     int rc;
>>> +
>>> +     ars_cap = kzalloc(sizeof(*ars_cap), GFP_KERNEL);
>>> +     if (!ars_cap)
>>> +             return -ENOMEM;
>>> +
>>> +     start = ndr_desc->res->start;
>>> +     len = ndr_desc->res->end - ndr_desc->res->start + 1;
>>> +
>>> +     rc = ars_get_cap(nd_desc, ars_cap, start, len);
>>> +     if (rc)
>>> +             goto out;
>>> +
>>> +     /*
>>> +      * If ARS is unsupported, or if the 'Persistent Memory Scrub' flag in
>>> +      * extended status is not set, skip this but continue initialization
>>> +      */
>>> +     if ((ars_cap->status & 0xffff) ||
>>> +             !(ars_cap->status >> 16 & ND_ARS_PERSISTENT)) {
>>> +             dev_warn(acpi_desc->dev,
>>> +                     "ARS unsupported (status: 0x%x), won't create an error list\n",
>>> +                     ars_cap->status);
>>> +             goto out;
>>> +     }
>>> +
>>> +     /*
>>> +      * Check if a full-range ARS has been run. If so, use those results
>>> +      * without having to start a new ARS.
>>> +      */
>>> +     ars_status = kzalloc(ars_cap->max_ars_out + sizeof(*ars_status),
>>> +                     GFP_KERNEL);
>>> +     if (!ars_status) {
>>> +             rc = -ENOMEM;
>>> +             goto out;
>>> +     }
>>> +
>>> +     rc = ars_get_status(nd_desc, ars_status);
>>> +     if (rc)
>>> +             goto out;
>>> +
>>> +     if (ars_status->address <= start &&
>>> +             (ars_status->address + ars_status->length >= start + len)) {
>>> +             rc = ars_status_process_records(nvdimm_bus, ars_status, start);
>>> +             goto out;
>>> +     }
>>> +
>>> +     /*
>>> +      * ARS_STATUS can overflow if the number of poison entries found is
>>> +      * greater than the maximum buffer size (ars_cap->max_ars_out)
>>> +      * To detect overflow, check if the length field of ars_status
>>> +      * is less than the length we supplied. If so, process the
>>> +      * error entries we got, adjust the start point, and start again
>>> +      */
>>> +     ars_start = kzalloc(sizeof(*ars_start), GFP_KERNEL);
>>> +     if (!ars_start)
>>> +             return -ENOMEM;
>>> +
>>> +     cur = start;
>>> +     remaining = len;
>>> +     do {
>>> +             u64 done, end;
>>> +
>>> +             rc = ars_do_start(nd_desc, ars_start, cur, remaining);
>>
>> I think you should get status, start, wait for completion, then process
>> records, at least that's how I read the example DSM spec and other
>> specs.  It says "You must first issue a Query ARS Status command...".
> 
> We do the lead-in ars_status check above...

Oh right, I missed that.

The way the locking works, the registration of regions are serialized so we
can't never have overlapping calls to this function, right?  A comment
about how this is synchronized might be helpful since the lock is many
functions away.

-- ljk

> 
>>
>>> +             if (rc)
>>> +                     goto out;
>>> +
>>> +             rc = ars_get_status(nd_desc, ars_status);
>>> +             if (rc)
>>> +                     goto out;
>>> +
>>> +             rc = ars_status_process_records(nvdimm_bus, ars_status, cur);
>>> +             if (rc)
>>> +                     goto out;
>>> +
>>> +             end = min(cur + remaining,
>>> +                     ars_status->address + ars_status->length);
>>> +             done = end - cur;
>>> +             cur += done;
>>> +             remaining -= done;
>>> +     } while (remaining);
>>> +
>>> + out:
>>> +     kfree(ars_cap);
>>> +     kfree(ars_start);
>>> +     kfree(ars_status);
>>> +     return rc;
>>> +}
>>> +
>>
>> I haven't looked at the rest of this, will try to later.
>>
> 
> Thanks Linda!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

