Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07BC881F87
 for <linux-nvdimm@lists.01.org>; Wed,  1 Feb 2017 01:21:42 -0800 (PST)
Received: by mail-oi0-x234.google.com with SMTP id j15so230508002oih.2
 for <linux-nvdimm@lists.01.org>; Wed, 01 Feb 2017 01:21:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170201081020.GD29170@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148559261791.11180.12085685820239925499.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170130123226.GD9043@lst.de>
 <CAPcyv4iARmZQSBybJ1iJhwkndVxSe62rk4hjP1T9prBuOqVQ-A@mail.gmail.com>
 <20170201081020.GD29170@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 1 Feb 2017 01:21:40 -0800
Message-ID: <CAPcyv4g419yOyH_UnMAxMUpxjEbAWDbL2NAG4ScfF+iNHdLfAQ@mail.gmail.com>
Subject: Re: [RFC PATCH 10/17] block: introduce bdev_dax_direct_access()
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
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 1, 2017 at 12:10 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jan 30, 2017 at 10:16:29AM -0800, Dan Williams wrote:
>> Ok, now that dax_map_atomic() is gone, it's much easier to remove
>> struct blk_dax_ctl.
>>
>> We can also move the partition alignment checks to be a one-time check
>> at bdev_dax_capable() time and kill bdev_dax_direct_access() in favor
>> of calling dax_direct_access() directly.
>
> Yes, please.
>
>> >> +     if ((sector + DIV_ROUND_UP(dax->size, 512))
>> >> +                     > part_nr_sects_read(bdev->bd_part))
>> >> +             return -ERANGE;
>> >> +     sector += get_start_sect(bdev);
>> >> +     return dax_direct_access(dax_inode, sector * 512, &dax->addr,
>> >> +                     &dax->pfn, dax->size);
>> >
>> > And please switch to using bytes as the granularity given that we're
>> > deadling with byte addressable memory.
>>
>> dax_direct_access() does take a byte aligned physical address, but it
>> needs to be at least page aligned since we are returning a pfn_t...
>>
>> Hmm, perhaps the input should be raw page frame number. We could
>> reduce one of the arguments by making the current 'pfn_t *' parameter
>> an in/out-parameter.
>
> In/Out parameters are always a bit problematic in terms of API clarity.
> And updating a device-relative address with an absolute physical one
> sounds like an odd API for sure.

Yes, it does, and I thought better of it shortly after sending that. How about:

long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
unsigned long nr_pages, void **kaddr, pfn_t *pfn)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
