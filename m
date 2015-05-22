Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A91FBF3@G9W0745.americas.hpqcorp.net>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150520205727.32249.79684.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A91FBF3@G9W0745.americas.hpqcorp.net>
Date: Fri, 22 May 2015 11:51:18 -0700
Message-ID: <CAPcyv4jrxUjqKygB1zcJTELMmL+fxFHrnttW31H41O=owGSwgw@mail.gmail.com>
Subject: Re: [PATCH v3 14/21] libnd: blk labels and namespace instantiation
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "neilb@suse.de" <neilb@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 22, 2015 at 11:37 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Wednesday, May 20, 2015 3:57 PM
>> To: axboe@kernel.dk
>> Cc: linux-nvdimm@lists.01.org; neilb@suse.de; gregkh@linuxfoundation.org;
>> linux-kernel@vger.kernel.org; hch@lst.de; linux-acpi@vger.kernel.org;
>> mingo@kernel.org
>> Subject: [PATCH v3 14/21] libnd: blk labels and namespace instantiation
>>
> ...
>> @@ -1029,6 +1244,173 @@ static struct device **create_namespace_pmem(struct
>> nd_region *nd_region)
>>       return NULL;
>>  }
>>
>> +struct resource *nsblk_add_resource(struct nd_region *nd_region,
>> +             struct nd_dimm_drvdata *ndd, struct nd_namespace_blk *nsblk,
>> +             resource_size_t start)
>> +{
>> +     struct nd_label_id label_id;
>> +     struct resource *res;
>> +
>> +     nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
>> +     nsblk->res = krealloc(nsblk->res,
>> +                     sizeof(void *) * (nsblk->num_resources + 1),
>> +                     GFP_KERNEL);
>> +     if (!nsblk->res)
>> +             return NULL;
>
> scripts/checkpatch.pl doesn't like that:
> WARNING: Reusing the krealloc arg is almost always a bug
> #1411: FILE: drivers/block/nd/namespace_devs.c:1411:
> +       nsblk->res = krealloc(nsblk->res,
>
> The reasoning (https://lkml.org/lkml/2013/3/14/558) is:
>
> "If krealloc() returns NULL, it *doesn't* free the original. So any
> code of the form 'foo = krealloc(foo, …);' is almost certainly a bug."
>

Ok, will fix that up.
