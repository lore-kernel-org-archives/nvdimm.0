Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 538302194D387
 for <linux-nvdimm@lists.01.org>; Sun, 20 Jan 2019 16:51:11 -0800 (PST)
Date: Mon, 21 Jan 2019 08:50:46 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH] libnvdimm, pfn: not allocate nd_pfn->pfn_sb if already
 allocated
Message-ID: <20190121005046.GB4544@richard>
References: <20190118033544.3980-1-richardw.yang@linux.intel.com>
 <CAPcyv4jOA-S=Z-0mCUW7d4+6gwHNEe1egaFrbyNq5UJL7Uz=Ow@mail.gmail.com>
 <20190118050333.GA4233@richard>
 <CAPcyv4j6Ud_cMkJneN13tv4_WjdAWM41RUhAOJsPPupZ-5KNmg@mail.gmail.com>
 <20190118073117.GA4628@richard>
 <CAPcyv4h+yJjBMfetF3ecxSHySgWjSWBH+Li9JWBZZSruqFBnLg@mail.gmail.com>
 <CAPcyv4ji+=145SNWWc+9Po8XuzuXjSJQhEU2SwgpMR8stiA_kA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ji+=145SNWWc+9Po8XuzuXjSJQhEU2SwgpMR8stiA_kA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 18, 2019 at 10:59:23AM -0800, Dan Williams wrote:
>On Fri, Jan 18, 2019 at 12:38 AM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> On Thu, Jan 17, 2019 at 11:31 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>> >
>> > On Thu, Jan 17, 2019 at 09:05:54PM -0800, Dan Williams wrote:
>> > >On Thu, Jan 17, 2019 at 9:03 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>> > >>
>> > >> On Thu, Jan 17, 2019 at 08:31:56PM -0800, Dan Williams wrote:
>> > >> >On Thu, Jan 17, 2019 at 7:36 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>> > >> >>
>> > >> >> In current implementation, we might re-allocate nd_pfn->pfn_sb.
>> > >> >>
>> > >> >> For example:
>> > >> >>
>> > >> >>     nd_dax_probe()
>> > >> >>         nd_pfn->pfn_sb = devm_kzalloc()
>> > >> >>
>> > >> >>     dax_pmem_probe()
>> > >> >>         nvdimm_setup_pfn()
>> > >> >>             nd_pfn_init()
>> > >> >>                 nd_pfn->pfn_sb = devm_kzalloc()
>> > >> >>
>> > >> >> This patch checks nd_pfn->pfn_sb before allocating it in nd_pfn_init().
>> > >> >
>> > >> >Ugh, this patch is unfortunately uncovering a deeper problem.
>> > >> >nvdimm_setup_pfn() should not be calling nd_pfn_init(). This
>> > >> >effectively is always re-initializing the info-block, benign but
>> > >> >unnecessary. Instead it needs to be using nd_pfn_validate() followed
>> > >> >by an __nvdimm_setup_pfn() in the dax_pmem_probe() path.
>> > >> >
>> > >> >Good find!
>> > >>
>> > >> So we should fix this like:
>> > >>
>> > >> dax_pmem_probe()
>> > >>     nd_pfn_validate()
>> > >>     __nvdimm_setup_pfn()
>> > >>
>> > >> Is my understanding correct?
>> > >
>> > >Yes, at first glance, but it would need a deeper review and testing.
>> > >The usage of nvdimm_setup_pfn() in drivers/nvdimm/pmem.c needs a
>> > >similar fixup.
>> >
>> > I went through the code again and found I may remove the allocation in
>> > nd_pfn_init().
>> >
>> > Below is my analysis.
>> >
>> > nvdimm_setup_pfn() is invoked in two places:
>> >
>> >   * dax_pmem_probe()
>> >   * pmem_attach_disk(), when it is_nd_pfn()
>> >
>> > And before these two function called, corresponding device should be allocated
>> > and created. And we can see these two corresponding places to create the
>> > devices are:
>> >
>> >   * nd_dax_probe()
>> >   * nd_pfn_probe()
>> >
>> > Both of them allocate pfn_sb. This means it is not necessary to allocate it
>> > again when we do the probe function.
>> >
>> > Do you think it looks good to you?
>> >
>>
>> No it doesn't because the real issue is that we should not be
>> recreating the info block. So the fix is not avoiding the allocation,
>> the fix is avoiding nd_pfn_init() in the probe path altogether.
>
>I was wrong, thankfully! nd_pfn_init() *does* call nd_pfn_validate(),
>I was just overlooking it.
>
>I also don't see that this fix is needed. nd_dax_probe()
>devm-allocates pfn_sb and performs a validation. If the validation
>succeeds nd_dax_probe() returns 0 which creates a new device and then
>causes nd_pmem_probe() to fail. At that point devm frees the pfn_sb

If I am correct, nd_dax_probe() creates a device whose driver is
dax_pmem_driver. So the probe function is dax_pmem_probe.

Based on my test, one more pfn_sb is allocated in dax_pmem_probe and the
driver attached to the device successfully.

>allocation. The allocation is also freed if the validation step
>failed.

nd_pmem_probe() will be called on device created by nd_btt_probe() and
nd_pfn_probe(), if I am right.

So in which case these two driver will fail to to attach the device and
release the memory?

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
