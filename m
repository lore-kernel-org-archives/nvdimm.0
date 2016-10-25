Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com
 [192.185.51.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D8C91A1E46
 for <linux-nvdimm@lists.01.org>; Tue, 25 Oct 2016 04:54:15 -0700 (PDT)
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
 by gateway24.websitewelcome.com (Postfix) with ESMTP id 50BD99CC0A05E
 for <linux-nvdimm@lists.01.org>; Tue, 25 Oct 2016 06:54:14 -0500 (CDT)
Date: Tue, 25 Oct 2016 05:54:09 -0600
From: Stephen Bates <sbates@raithlin.com>
Subject: Re: [PATCH 1/3] memremap.c : Add support for ZONE_DEVICE IO memory
 with struct pages.
Message-ID: <20161025115409.GB14986@cgy1-donard.priv.deltatee.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <1476826937-20665-2-git-send-email-sbates@raithlin.com>
 <CAPcyv4gmiqMNb+Q88Mf-9fFb4z4uAfWbbEWrv42OBH8838SSPQ@mail.gmail.com>
 <20161019184028.GB16550@cgy1-donard.priv.deltatee.com>
 <CAPcyv4iTFpZ1b74Wf+qWe9=Annp+-OCy+pFMS7Fo7quUFwhM4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iTFpZ1b74Wf+qWe9=Annp+-OCy+pFMS7Fo7quUFwhM4g@mail.gmail.com>
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
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, sbates@raithin.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, haggaie@mellanox.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 19, 2016 at 01:01:06PM -0700, Dan Williams wrote:
> >>
> >> In the cover letter, "[PATCH 0/3] iopmem : A block device for PCIe
> >> memory",  it mentions that the lack of I/O coherency is a known issue
> >> and users of this functionality need to be cognizant of the pitfalls.
> >> If that is the case why do we need support for different cpu mapping
> >> types than the default write-back cache setting?  It's up to the
> >> application to handle cache cpu flushing similar to what we require of
> >> device-dax users in the persistent memory case.
> >
> > Some of the iopmem hardware we have tested has certain alignment
> > restrictions on BAR accesses. At the very least we require write
> > combine mappings for these. We then felt it appropriate to add the
> > other mappings for the sake of completeness.
>
> If the device can support write-combine then it can support bursts, so
> I wonder why it couldn't support read bursts for cache fills...

Dan

You make a good point. We did some testing on this and for the HW we
have access too we did see that a standard WB mapping worked.
Interestly though the local access performance was much slower than
for the WC mapping. We also noticed the PAT entries we not marked
correctly in the WB case. I am trying to get access to some other HW
for more testing.

Grepping for the address of interest:

In WB mode it's:

uncached-minus @ 0x381f80000000-0x381fc0000000

In WC mode it's:

write-combining @ 0x381f80000000-0x381fc0000000

Cheers

Stephen
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
