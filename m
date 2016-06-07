Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE1031A1EE5
 for <linux-nvdimm@lists.01.org>; Tue,  7 Jun 2016 11:15:50 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id e72so290048541oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 07 Jun 2016 11:15:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465322493.3504.143.camel@hpe.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146507357415.8347.2659418918775329626.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1465322493.3504.143.camel@hpe.com>
Date: Tue, 7 Jun 2016 11:15:30 -0700
Message-ID: <CAPcyv4jWJ8X=2+GmYcoc7SUocdwYrx+5zud5JgXSD6KfOgA8dA@mail.gmail.com>
Subject: Re: [PATCH 04/13] libnvdimm,
 nfit: move flush hint mapping to dimm driver
From: Dan Williams <dan.j.williams@intel.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 7, 2016 at 11:11 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Sat, 2016-06-04 at 13:52 -0700, Dan Williams wrote:
>  :
>> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
>> index 420e1a5e2250..5b6f85d00bb5 100644
>> --- a/drivers/nvdimm/region_devs.c
>> +++ b/drivers/nvdimm/region_devs.c
>> @@ -803,11 +803,29 @@ EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
>>   */
>>  void nvdimm_flush(struct nd_region *nd_region)
>>  {
>> +int i;
>> +
>>  /*
>> - * TODO: replace wmb_pmem() usage with flush hint writes where
>> - * available.
>> + * The first wmb() is needed to 'sfence' all previous writes
>> + * such that they are architecturally visible for the platform
>> + * buffer flush.  Note that we've already arranged for pmem
>> + * writes to avoid the cache via arch_memcpy_to_pmem().  The
>> + * final wmb() ensures ordering for the NVDIMM flush write.
>>   */
>> -wmb_pmem();
>> +wmb();
>> +for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +struct nvdimm_drvdata *ndd = to_ndd_unlocked(nd_mapping);
>> +
>> +/*
>> + * Note, nvdimm_drvdata guaranteed to be live since we
>> + * arrange for all associated regions to be disabled
>> + * before the dimm is disabled.
>> + */
>> +if (ndd->flush_wpq[0])
>
> Hi Dan,
>
> ndd is NULL on our system since nvdimm_probe() always fails
> in nvdimm_init_nsarea(), which then calls put_ndd() and
> nvdimm_drvdata_release().
>

Ah, thanks for the report!  I'll fix this.  We should only care about
labels being present when the DIMM has aliased BLK and PMEM capacity.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
