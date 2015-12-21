Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1450723855.5616.15.camel@intel.com>
References: <1450603122-7205-1-git-send-email-vishal@kernel.org>
	<1450603122-7205-4-git-send-email-vishal@kernel.org>
	<CAPcyv4je_6LPzfULJrGdkDRnc0mzc_ftd=t9942N2UO9rQZe0A@mail.gmail.com>
	<1450723855.5616.15.camel@intel.com>
Date: Mon, 21 Dec 2015 11:10:49 -0800
Message-ID: <CAPcyv4jm6LTZR25xZJpVkjUPn2=Uu3XDOYtQ0GXo=kD2xLcoHA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pmem: Use the poison list to expose badblocks
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linda.knippers@hpe.com" <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 21, 2015 at 10:50 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Sun, 2015-12-20 at 17:20 -0800, Dan Williams wrote:
>> On Sun, Dec 20, 2015 at 1:18 AM,  <vishal@kernel.org> wrote:
>> > From: Vishal Verma <vishal.l.verma@intel.com>
>> >
>> > Enable the gendisk badblocks feature for pmem namespaces.
>> > If the pmem namespace being created has any known poison associated
>> > with
>> > its physical address space, convert the poison ranges to bad sectors
>> > exposed using the badblocks interface.
>> >
>> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> > ---
>> >  drivers/nvdimm/pmem.c | 124
>> > ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 124 insertions(+)
>>
>> I think we should move this new functionality to the core because
>> there is not much pmem driver specific.  It's all generic nvdimm-core
>> and block-core functionality.  The only missing information the core
>> routine needs is the gendisk and a data offset (if sector-zero is at
>> an offset from the base address range of the namespace).  Something
>> like:
>>
>> nvdimm_namespace_disk_poison(struct nd_namespace_common *ndns,
>>     resource_size_t offset, struct gendisk *disk)
>
> This should be easy to do, however isn't it a bit counter-intuitive to
> move this into core? The lower level drivers pmem/blk/btt are all owners
> of their respective gendisks, and so doesn't it make more sense for them
> to be in control of manipulating their gendisk data. Also, I can see
> moving them if this was a common operation, but only pmem will ever need
> to do this..
>
> I'm not too strongly opposed to this however - the one thing that did
> feel a bit awkward being in pmem was that we ask core for a struct
> list_head and then walk it ourselves - pmem doesn't normally know about
> the internals of nvdimm_bus, but with this we implicitly make it aware.

Yeah, it's borderline, but teaching pmem how to walk a list that the
core built up is what triggered the suggestion.  It's true that the
pmem driver owns its gendisk, but that's why it gets to make the
decision to call the library helper or not.
