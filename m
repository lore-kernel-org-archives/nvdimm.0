Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A973B07@G9W0745.americas.hpqcorp.net>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A973B07@G9W0745.americas.hpqcorp.net>
Date: Mon, 8 Jun 2015 09:36:46 -0700
Message-ID: <CAPcyv4jeX+SMhoVh-wwuNozn5-E-4hfhH7H6RpqgsBnHq30Bmg@mail.gmail.com>
Subject: Re: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
 __pfn_t + kmap_atomic_pfn_t()
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "hpa@zytor.com" <hpa@zytor.com>, "david@fromorbit.com" <david@fromorbit.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "mingo@kernel.org" <mingo@kernel.org>, "tj@kernel.org" <tj@kernel.org>, "paulus@samba.org" <paulus@samba.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "hch@lst.de" <hch@lst.de>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 8, 2015 at 9:29 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
>> Of Dan Williams
>> Sent: Friday, June 05, 2015 3:19 PM
>> Subject: [PATCH v4 4/9] dax: fix mapping lifetime handling, convert to
>> __pfn_t + kmap_atomic_pfn_t()
> ...
>> diff --git a/arch/powerpc/sysdev/axonram.c
>> b/arch/powerpc/sysdev/axonram.c
>> index e8657d3bc588..20725006592e 100644
>> --- a/arch/powerpc/sysdev/axonram.c
>> +++ b/arch/powerpc/sysdev/axonram.c
> ...
>> @@ -165,9 +166,13 @@ static int axon_ram_probe(struct platform_device
>> *device)
>>  {
>>       static int axon_ram_bank_id = -1;
>>       struct axon_ram_bank *bank;
>> -     struct resource resource;
>> +     struct resource *resource;
>>       int rc = 0;
>>
>> +     resource = devm_kzalloc(&device->dev, sizeof(*resource),
>> GFP_KERNEL);
>> +     if (!resource)
>> +             return -ENOMEM;
>> +
>
> Since resource is now a pointer...
>
> ...
>> @@ -184,13 +189,13 @@ static int axon_ram_probe(struct platform_device
>> *device)
>>
>>       bank->device = device;
>>
>> -     if (of_address_to_resource(device->dev.of_node, 0, &resource) != 0)
>> {
>> +     if (of_address_to_resource(device->dev.of_node, 0, resource) != 0) {
>>               dev_err(&device->dev, "Cannot access device tree\n");
>>               rc = -EFAULT;
>>               goto failed;
>>       }
> ...
>
> ... I'd expect to see a devm_kfree call added after the failed label,
> like was  done here:

No, because unlike dccsblk the axon_ram driver actually adheres to the
device model, so it will be auto-freed on failed probe.  The dcssblk
implementation is not a proper "driver" so we don't get the
devres_release_all() until the device is unregistered.  That causes
the "resource" object to stick around longer than necessary unless we
force devm_kfree() it.
