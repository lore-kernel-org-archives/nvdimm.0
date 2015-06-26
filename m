Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1435280115.11808.374.camel@misato.fc.hp.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	<20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	<1435254317.11808.327.camel@misato.fc.hp.com>
	<1435257283.13411.4.camel@intel.com>
	<CAPcyv4jhDc1+TGyo4J6vC7bRBaGbfAXyLP2qB9X5DAJRBhCRyQ@mail.gmail.com>
	<1435269103.11808.349.camel@misato.fc.hp.com>
	<CAPcyv4gqgbEVWDKR4e8=Uaz1As4FxY4-8VHWKZfQ-vtc2wOs3g@mail.gmail.com>
	<1435270287.11808.352.camel@misato.fc.hp.com>
	<CAPcyv4hzUA71G8bmUt7OLXx0GMX-36gqQ-WHOjA7sj9z4pudCA@mail.gmail.com>
	<1435272910.11808.356.camel@misato.fc.hp.com>
	<1435275750.18090.5.camel@intel.com>
	<1435280115.11808.374.camel@misato.fc.hp.com>
Date: Thu, 25 Jun 2015 18:08:48 -0700
Message-ID: <CAA9_cmf84L1JE_4Om36TzJR6DTU_OiTWGsNF+u+pb5TRTCj5NA@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 25, 2015 at 5:55 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2015-06-25 at 23:42 +0000, Williams, Dan J wrote:
>> On Thu, 2015-06-25 at 16:55 -0600, Toshi Kani wrote:
>> > On Thu, 2015-06-25 at 15:34 -0700, Dan Williams wrote:
>> > > On Thu, Jun 25, 2015 at 3:11 PM, Toshi Kani <toshi.kani@hp.com> wrote:
>> > > > On Thu, 2015-06-25 at 15:00 -0700, Dan Williams wrote:
>> > > > Yes, I see no problem with bound BTTs and their device files.  So, how
>> > > > do we bind BTT with this new version?
>> > > >
>> > >
>> > > # cd /sys/bus/nd/devices
>> > > # uuidgen > btt6/uuid
>> > > # echo 4096 > btt6/sector_size
>> > > # echo namespace6.0 > btt6/namespace
>> > > # echo namespace6.0 > ../drivers/nd_pmem/unbind
>> > > # echo btt6 > ../drivers/nd_pmem/bind
>> > >
>> > > After reboot, when the system sees namespace6.0 again it will notice
>> > > the btt instance and attach bttX instead.  The net effect is that now
>> > > you'll only ever have /dev/pmem6 or /dev/pmem6s, never both at the
>> > > same time that was a side effect of the stacking approach.
>> > >
>> > > I'll post the patch that updates libndctl and the unit tests shortly
>> >
>> > Maybe I am missing something, but I am getting errors on my system.  (I
>> > used btt0 since there is no btt6.)
>> >
>> > # cat bind.sh
>> > set -x
>> > cd /sys/bus/nd/devices
>> > uuidgen > btt0/uuid
>> > echo 4096 > btt0/sector_size
>> > echo namespace0.0 > btt0/namespace
>> > echo namespace0.0 > ../drivers/nd_pmem/unbind
>> > echo btt0 > ../drivers/nd_pmem/bind
>> >
>> > # sh bind.sh
>> > + cd /sys/bus/nd/devices
>> > + uuidgen
>> > + echo 4096
>> > + echo namespace0.0
>> > bind.sh: line 6: echo: write error: Device or resource busy
>> > + echo namespace0.0
>> > bind.sh: line 7: echo: write error: No such device
>> > + echo btt0
>> > bind.sh: line 8: echo: write error: No such device
>> >
>> > # dmesg
>> >  :
>> > [12513.839162] nd btt0: uuid_store: result: 0 wrote:
>> > b32cd195-9aae-4c54-a5ac-49adb50a8a98
>> > [12513.880286] nd btt0: sector_size_store: result: 0 wrote: 4096
>> > [12513.909494] nd btt0: namespace0.0 already claimed
>> > [12513.933364] nd btt0: namespace_store: result: -16 wrote: namespace0.0
>> > [12513.966808]  ndbus0: nd_pmem.probe(btt0) = -19
>> >
>>
>> So this turned out to be a perfect example of why we might want to have
>> the region-id in the btt device name just like namespaces, because btt0
>> was actually bound to namespace4.0 on Toshi's system.  The following
>> update, that I will fold in to the series, fixes this.  Note that the
>> association of btt id to to namespace is still non-deterministic.  I.e.
>> btt0.1 could be assigned as the btt for namespace0.0, but at least when
>> looking at /sys/bus/nd/devices it will be clear which btts belong to
>> which regions.
>>
>> # ls /sys/bus/nd/devices
>> btt0.0  btt3.0  btt6.0        namespace2.0  namespace5.0  nmem1  nmem4    region2  region5
>> btt1.0  btt4.0  namespace0.0  namespace3.0  namespace6.0  nmem2  region0  region3  region6
>> btt2.0  btt5.0  namespace1.0  namespace4.0  nmem0         nmem3  region1  region4
>
> Yes, this works nicely. :-)
>
> Now, how do I unbind BTT?  I did the following as a guess, but BTT got
> reattached again before I have a chance to delete the metadata, which I
> need /dev/pmemN.
>
> NUM=1
> cd /sys/bus/nd/devices
> echo ""  > btt${NUM}.1/namespace
> echo btt${NUM}.1 > ../drivers/nd_pmem/unbind

echo 1 > namespace${NUM}.0/force_raw

> echo namespace${NUM}.0 > ../drivers/nd_pmem/bind
>
