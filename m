Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151002175127.GH107187@google.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150725023945.8664.34842.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151002175127.GH107187@google.com>
Date: Fri, 9 Oct 2015 14:33:22 -0700
Message-ID: <CAPcyv4hVNykjWbmdpm4rN3Kf7GNPzNXxxH0jriMe2fpjNJYukg@mail.gmail.com>
Subject: Re: [PATCH v2 19/25] pxa2xx-flash: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Norris <computersforpeace@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mtd@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 2, 2015 at 10:51 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> + linux-mtd
>
> On Fri, Jul 24, 2015 at 10:39:45PM -0400, Dan Williams wrote:
>> In preparation for deprecating ioremap_cache() convert its usage in
>> pxa2xx-flash to memremap.
>>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Brian Norris <computersforpeace@gmail.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/mtd/maps/pxa2xx-flash.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
>> index 12fa75df5008..758a8a7f86d9 100644
>> --- a/drivers/mtd/maps/pxa2xx-flash.c
>> +++ b/drivers/mtd/maps/pxa2xx-flash.c
>> @@ -71,8 +71,8 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
>>                      info->map.name);
>>               return -ENOMEM;
>>       }
>> -     info->map.cached =
>> -             ioremap_cache(info->map.phys, info->map.size);
>> +     info->map.cached = memremap(info->map.phys, info->map.size,
>> +                     MEMREMAP_CACHE);
>
> Should the corresponding iounmap() be changed too? Looks like a pretty
> thin wrapper right now, but it seems like the API would suggest we do
> this anyway.
>

Yes, thanks for that catch, addressed in the next rev.
