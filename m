Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5537E1D9.6010609@hp.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1429644912.17259.31.camel@misato.fc.hp.com>
	<CAPcyv4iHHRUg4q2cT0MHQGx1VV=F8qh3bbBvU_CXr7wuO0Ccww@mail.gmail.com>
	<1429646156.17259.39.camel@misato.fc.hp.com>
	<CAPcyv4gx7f90Kf+4h4drSSz+q54+ezJPtGRH7TwYcAudhvjmHw@mail.gmail.com>
	<1429720742.15952.30.camel@misato.fc.hp.com>
	<CAPcyv4h1kYH7-ia8J8bBpmRY89LXe3TnvQPGc2SuxqyEF9MQEw@mail.gmail.com>
	<5537E1D9.6010609@hp.com>
Date: Wed, 22 Apr 2015 11:20:44 -0700
Message-ID: <CAPcyv4jNL-R_zHt2=O-sD+hqsL-a7mP7Tmi0t9H0StKxaFsgUg@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH 04/21] nd: create an 'nd_bus' from an 'nfit_desc'
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hp.com>
Cc: Toshi Kani <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 22, 2015 at 11:00 AM, Linda Knippers <linda.knippers@hp.com> wrote:
> On 4/22/2015 1:03 PM, Dan Williams wrote:
>> On Wed, Apr 22, 2015 at 9:39 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>>> On Tue, 2015-04-21 at 13:35 -0700, Dan Williams wrote:
>>>> On Tue, Apr 21, 2015 at 12:55 PM, Toshi Kani <toshi.kani@hp.com> wrote:
>>>>> On Tue, 2015-04-21 at 12:58 -0700, Dan Williams wrote:
>>>>>> On Tue, Apr 21, 2015 at 12:35 PM, Toshi Kani <toshi.kani@hp.com> wrote:
>>>>>>> On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
>>>>>>>  :
>>>>>>>> +
>>>>>>>> +static int nd_mem_init(struct nd_bus *nd_bus)
>>>>>>>> +{
>>>>>>>> +     struct nd_spa *nd_spa;
>>>>>>>> +
>>>>>>>> +     /*
>>>>>>>> +      * For each SPA-DCR address range find its corresponding
>>>>>>>> +      * MEMDEV(s).  From each MEMDEV find the corresponding DCR.
>>>>>>>> +      * Then, try to find a SPA-BDW and a corresponding BDW that
>>>>>>>> +      * references the DCR.  Throw it all into an nd_mem object.
>>>>>>>> +      * Note, that BDWs are optional.
>>>>>>>> +      */
>>>>>>>> +     list_for_each_entry(nd_spa, &nd_bus->spas, list) {
>>>>>>>> +             u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
>>>>>>>> +             int type = nfit_spa_type(nd_spa->nfit_spa);
>>>>>>>> +             struct nd_mem *nd_mem, *found;
>>>>>>>> +             struct nd_memdev *nd_memdev;
>>>>>>>> +             u16 dcr_index;
>>>>>>>> +
>>>>>>>> +             if (type != NFIT_SPA_DCR)
>>>>>>>> +                     continue;
>>>>>>>
>>>>>>> This function requires NFIT_SPA_DCR, SPA Range Structure with NVDIMM
>>>>>>> Control Region GUID, for initializing an nd_mem object.  However,
>>>>>>> battery-backed DIMMs do not have such control region SPA.  IIUC, the
>>>>>>> NFIT spec does not require NFIT_SPA_DCR.
>>>>>>>
>>>>>>> Can you change this function to work with NFIT_SPA_PM as well?
>>>>>>
>>>>>> NFIT_SPA_PM ranges are handled separately from nd_mem_init().  See
>>>>>> nd_region_create() in patch 10.
>>>>>
>>>>> If nd_mem_init() does not initialize nd_mem objects, nd_bus_probe() in
>>>>> core.c fails in nd_bus_init_interleave_sets() and skips all subsequent
>>>>> nd_bus_xxx() calls.  So, nd_region_create() won't be called.
>>>>>
>>>>> nd_bus_init_interleave_sets() fails because init_interleave_set()
>>>>> returns -ENODEV if (!nd_mem).
>>>>
>>>> Ah, ok  your test case is specifying PMEM backed by memory device
>>>> info.  We have a test case for simple ranges (nfit_test1_setup()), but
>>>> it doesn't hit this bug because it does not specify any memory-device
>>>> tables.
>>>
>>> Yes, we have NFIT table with SPA range (PM), memory device to SPA, and
>>> NVDIMM control region structures.  With the memory device to SPA
>>> structure, this code requires full sets of information, including the
>>> namespace label data in _DSM [1], which is outside of ACPI 6.0 and is
>>> optional.  Battery-backed DIMMs do not have such label data.
>>
>> This is what "nd_namespace_io" devices are for, they do not require labels.
>>
>> Question, if you don't have labels and you don't have DSMs then why
>> publish a MEMDEV table at all?  Why not simply publish an anonymous
>> range?  See nfit_test1_setup().
>
> The MEMDEV table provides useful information, and there may be _DSMs,
> perhaps just not the same _DSM as some other devices.
>
>>> It needs
>>> to work with NFIT table with these structures without this _DSM or with
>>> a different type of _DSM which this code may or may not need to support.
>>> It should also check Region Format Interface Code (RFIC) in the NVDIMM
>>> control region structure before assuming this _DSM is present to
>>> implement RFIC 0x0201.
>>
>> Ok I can look into adding this check, but I don't think it is
>> necessary if you simply refrain from publishing a MEMDEV entry.
>
> But we need the MEMDEV. And as Toshi mentions, we could have other
> RFICs with other _DSMs than your example.  That's why there is an RFIC.

Wait, point of clarification, DCRs (dimm-control-regions) have RFICs,
not MEMDEVs (memory-device-to-spa-mapping).  Toshi's original report
was that an NFIT with a SPA+MEMDEV was failing to enable a PMEM
device.  That specific problem can be fixed by either deleting the
MEMDEV, or adding a DCR.

Of course, if you add a DCR with a different intended DSM layout than
the DSM-example-interface the driver will need to add support for
handling that case.
