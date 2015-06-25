Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1435254317.11808.327.camel@misato.fc.hp.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
	<20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
	<1435254317.11808.327.camel@misato.fc.hp.com>
Date: Thu, 25 Jun 2015 10:47:48 -0700
Message-ID: <CAPcyv4i81m8AC_FPzGiLMF7mszWMAM45T0Lia_y=YP75cND=JA@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 25, 2015 at 10:45 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2015-06-25 at 05:37 -0400, Dan Williams wrote:
>> From: Toshi Kani <toshi.kani@hp.com>
>>
>> ACPI NFIT table has System Physical Address Range Structure entries that
>> describe a proximity ID of each range when ACPI_NFIT_PROXIMITY_VALID is
>> set in the flags.
>>
>> Change acpi_nfit_register_region() to map a proximity ID to its node ID,
>> and set it to a new numa_node field of nd_region_desc, which is then
>> conveyed to the nd_region device.
>>
>> The device core arranges for btt and namespace devices to inherit their
>> node from their parent region.
>>
>> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
>> [djbw: move set_dev_node() from region 'probe' to 'create']
>
> Sorry, I failed to mention other issue, which led me call set_dev_node()
> in probe.  nd_async_device_register() calls device_add(), which does:
>
>         /* use parent numa_node */
>         if (parent)
>                 set_dev_node(dev, dev_to_node(parent));
>
> and overwrites numa_node to -1.  Since region's parent is ndbusN, we
> cannot set numa_node to the parent.  So, I had to set it in probe.

ah, ok.
