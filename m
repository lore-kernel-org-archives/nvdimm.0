Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8600681EA0
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 09:02:03 -0800 (PST)
Subject: Re: [PATCH] libnvdimm: clear poison in mem map metadata
References: <147916930808.236748.8215175004635279925.stgit@djiang5-desk3.ch.intel.com>
 <1479400371.20881.151.camel@hpe.com>
 <fe91a799-6f62-0668-7824-701e2e18522b@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <9178d4d6-fff6-8b3a-649f-fe32f7fadabd@intel.com>
Date: Fri, 18 Nov 2016 10:02:08 -0700
MIME-Version: 1.0
In-Reply-To: <fe91a799-6f62-0668-7824-701e2e18522b@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 11/17/2016 10:25 AM, Dave Jiang wrote:
> On 11/17/2016 09:35 AM, Kani, Toshimitsu wrote:
>> On Mon, 2016-11-14 at 17:21 -0700, Dave Jiang wrote:
>>> Clearing out the poison in the metadata block of the namespace 
>>> before we use it. Range from start + 8k to pfn_sb->dataoff.
>>> 
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com> --- 
>>> drivers/nvdimm/pfn_devs.c |   24 ++++++++++++++++++++++++ 1
>>> file changed, 24 insertions(+)
>>> 
>>> diff --git a/drivers/nvdimm/pfn_devs.c 
>>> b/drivers/nvdimm/pfn_devs.c index cea8350..ff3b55d 100644 --- 
>>> a/drivers/nvdimm/pfn_devs.c +++ b/drivers/nvdimm/pfn_devs.c @@ 
>>> -527,11 +527,35 @@ static struct vmem_altmap 
>>> *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn, .base_pfn = 
>>> init_altmap_base(base), .reserve = init_altmap_reserve(base),
>>> }; +sector_t sector; +resource_size_t meta_start, meta_size;
>>> +long cleared; +unsigned int sz_align;
>>> 
>>> memcpy(res, &nsio->res, sizeof(*res)); res->start += start_pad;
>>>  res->end -= end_trunc;
>>> 
>>> +meta_start = res->start + SZ_8K; +meta_size = offset - 
>>> meta_start + 1; + +if (meta_start + meta_size > offset)
>>> +return ERR_PTR(-EINVAL); + +sector = meta_start >> 9;
>>> +sz_align = ALIGN(meta_size + (meta_start & (512 - 1)), 512);
> 
>> Should this be ALIGN_UP?
> 
> I guess that makes sense to me, are there any bad side effects if
> we round up? Dan? I think there are a few other places we should
> update if we make the change since this code was borrowed from
> somewhere else.

Actually ALIGN() already aligns up looks like.


> 
> 
>>> + +if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
>>> +if (IS_ALIGNED(meta_start, 512) && IS_ALIGNED(meta_size, 512))
>>> { +cleared = nvdimm_clear_poison(&nd_pfn->dev, +
>>> meta_start, meta_size); +badblocks_clear(&nsio->bb, sector,
>>> cleared
>>>>> 9);
> 
>> 'cleared' can be a negative error value, so I do not think you
>> can simply pass it to badblocks_clear().
> 
> Good catch! I'll fix.
> 
> 
>> Thanks, -Toshi
> 
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlgvNAgACgkQZBXE8WajuT4GLgEAp9E4u8yaKPUPy3Zv/VXUqpln
VzyJXofVi9Bpji2WJlIBAJ9dw7sinFc4fQLRZTb71BmMDhL0z90uCr5tTJpH/Ij5
=trfV
-----END PGP SIGNATURE-----
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
