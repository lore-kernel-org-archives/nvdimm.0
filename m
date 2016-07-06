Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73F2E1A1DFC
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jul 2016 10:35:29 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id r2so280483926oih.2
 for <linux-nvdimm@lists.01.org>; Wed, 06 Jul 2016 10:34:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160705090215.k7xlvjjx4uvfit2m@c203.arch.suse.de>
References: <20160623095204.32167-1-jthumshirn@suse.de>
 <20160705090215.k7xlvjjx4uvfit2m@c203.arch.suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Jul 2016 10:34:47 -0700
Message-ID: <CAPcyv4jRxPSFwSBNro=xV1dRtNwREd3pp+feP8F8Skk5G0fOtQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: initialize struct blk_integrity with 0
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 5, 2016 at 2:02 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Thu, Jun 23, 2016 at 11:52:04AM +0200, Johannes Thumshirn wrote:
>> Initialize struct blk_integrity with 0 as blk_integrity_register() takes the
>> then unitialized struct blk_integrity::flags and ORs it to the resulting block
>> integrity structure.
>>
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> ---
>>  drivers/nvdimm/core.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
>> index be89764..32e4fe2 100644
>> --- a/drivers/nvdimm/core.c
>> +++ b/drivers/nvdimm/core.c
>> @@ -601,7 +601,8 @@ int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
>>       if (meta_size == 0)
>>               return 0;
>>
>> -     bi.profile = NULL;
>> +     memset(&bi, 0, sizeof(bi));
>> +
>>       bi.tuple_size = meta_size;
>>       bi.tag_size = meta_size;
>>
>> --
>> 2.8.4
>>
>
> Dan,
>
> have you seen this one? I've found it in patchwork but didn't get a mail on
> the list either.

Thanks for the nudge, I missed this.  Applied now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
