Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <568EF1AA.6070001@hpe.com>
References: <1451010103-11462-1-git-send-email-vishal.l.verma@intel.com>
	<1451010103-11462-3-git-send-email-vishal.l.verma@intel.com>
	<568ED633.8020702@hpe.com>
	<CAPcyv4g-z1Ua_uHHwSTeKfpf5ABHr5V+R3_SmFfPxZix2u8NAQ@mail.gmail.com>
	<568EF1AA.6070001@hpe.com>
Date: Thu, 7 Jan 2016 15:22:00 -0800
Message-ID: <CAPcyv4i1dKrhEJkFWmLAmVRBi=tJUOT0WhxjGh-SVnbvFBuxpQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libnvdimm: Add a poison list and export badblocks
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 7, 2016 at 3:15 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 1/7/2016 5:49 PM, Dan Williams wrote:
>> On Thu, Jan 7, 2016 at 1:18 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>
>>> On 12/24/2015 9:21 PM, Vishal Verma wrote:
>>>> During region creation, perform Address Range Scrubs (ARS) for the SPA
>>>> (System Physical Address) ranges to retrieve known poison locations from
>>>> firmware. Add a new data structure 'nd_poison' which is used as a list
>>>> in nvdimm_bus to store these poison locations.
>>>>
>>>> When creating a pmem namespace, if there is any known poison associated
>>>> with its physical address space, convert the poison ranges to bad sectors
>>>> that are exposed using the badblocks interface.
>>>>
>>>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>>>> ---
>>>>  drivers/acpi/nfit.c       | 203 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>  drivers/nvdimm/core.c     | 187 ++++++++++++++++++++++++++++++++++++++++++
>>>>  drivers/nvdimm/nd-core.h  |   3 +
>>>>  drivers/nvdimm/nd.h       |   6 ++
>>>>  drivers/nvdimm/pmem.c     |   6 ++
>>>>  include/linux/libnvdimm.h |   1 +
>>>>  6 files changed, 406 insertions(+)
>>>>
>>>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>>>
>>> Why are the ARS function in acpi/nfit.c rather than in the core?
>>> I realize that the interfaces are/will be defined in the ACPI spec but
>>> it's not really part of the NFIT.
>>>
>>> Why isn't this part of the nvdimm core, where the calls are made?
>>
>> True.  acpi_nfit_find_poison() could easily become
>> nvdimm_bus_find_poison() and move to the core.  However we only need
>> to take that step when / if another nvdimm bus type show up that isn't
>> nfit defined.  For now only nfit-defined nvdimms have a concept of
>> ARS.
>
> Why not go ahead and move it now?
>
> I agree that ARS is related to NFIT, but practically everything else
> in the core is as well.  It doesn't seem to belongs in nfit.c.  I
> didn't even notice that's where it was since the subject line says
> "libnvdimm".

Should be straightforward, will do.

>>>> index aa45d48..ad6d8c6 100644
>>>> --- a/drivers/acpi/nfit.c
>>>> +++ b/drivers/acpi/nfit.c
>>>> @@ -15,6 +15,7 @@
[..]
>>> I think you should get status, start, wait for completion, then process
>>> records, at least that's how I read the example DSM spec and other
>>> specs.  It says "You must first issue a Query ARS Status command...".
>>
>> We do the lead-in ars_status check above...
>
> Oh right, I missed that.
>
> The way the locking works, the registration of regions are serialized so we
> can't never have overlapping calls to this function, right?  A comment
> about how this is synchronized might be helpful since the lock is many
> functions away.

Sounds good.
