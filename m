Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F16981F87
 for <linux-nvdimm@lists.01.org>; Wed,  1 Feb 2017 00:10:22 -0800 (PST)
Date: Wed, 1 Feb 2017 09:10:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 10/17] block: introduce bdev_dax_direct_access()
Message-ID: <20170201081020.GD29170@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148559261791.11180.12085685820239925499.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170130123226.GD9043@lst.de>
 <CAPcyv4iARmZQSBybJ1iJhwkndVxSe62rk4hjP1T9prBuOqVQ-A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iARmZQSBybJ1iJhwkndVxSe62rk4hjP1T9prBuOqVQ-A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 30, 2017 at 10:16:29AM -0800, Dan Williams wrote:
> Ok, now that dax_map_atomic() is gone, it's much easier to remove
> struct blk_dax_ctl.
> 
> We can also move the partition alignment checks to be a one-time check
> at bdev_dax_capable() time and kill bdev_dax_direct_access() in favor
> of calling dax_direct_access() directly.

Yes, please.

> >> +     if ((sector + DIV_ROUND_UP(dax->size, 512))
> >> +                     > part_nr_sects_read(bdev->bd_part))
> >> +             return -ERANGE;
> >> +     sector += get_start_sect(bdev);
> >> +     return dax_direct_access(dax_inode, sector * 512, &dax->addr,
> >> +                     &dax->pfn, dax->size);
> >
> > And please switch to using bytes as the granularity given that we're
> > deadling with byte addressable memory.
> 
> dax_direct_access() does take a byte aligned physical address, but it
> needs to be at least page aligned since we are returning a pfn_t...
> 
> Hmm, perhaps the input should be raw page frame number. We could
> reduce one of the arguments by making the current 'pfn_t *' parameter
> an in/out-parameter.

In/Out parameters are always a bit problematic in terms of API clarity.
And updating a device-relative address with an absolute physical one
sounds like an odd API for sure.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
