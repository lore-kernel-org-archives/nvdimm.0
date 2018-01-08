Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57B152222758C
 for <linux-nvdimm@lists.01.org>; Mon,  8 Jan 2018 12:20:43 -0800 (PST)
Date: Mon, 8 Jan 2018 21:25:48 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: revamp vmem_altmap / dev_pagemap handling V3
Message-ID: <20180108202548.GA1732@dhcp22.suse.cz>
References: <20171229075406.1936-1-hch@lst.de> <20180108112646.GA7204@lst.de>
 <CAPcyv4hHipDHP5LZCgym5szqiUSCxG9wQUbRO_qe8T+USaZi9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hHipDHP5LZCgym5szqiUSCxG9wQUbRO_qe8T+USaZi9Q@mail.gmail.com>
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
Cc: linux-nvdimm@lists.01.org, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 08-01-18 11:44:02, Dan Williams wrote:
> On Mon, Jan 8, 2018 at 3:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> > Any chance to get this fully reviewed and picked up before the
> > end of the merge window?
> 
> I'm fine carrying these through the nvdimm tree, but I'd need an ack
> from the mm folks for all the code touches related to arch_add_memory.

I am sorry to be slow here but I am out of time right now - yeah having
a lot of fun kaiser time. I didn't get to look at these patches at all
yet but the changelog suggests that you want to remove vmem_altmap.
I've had plans to (ab)use this for self hosted struct pages for memory
hotplug http://lkml.kernel.org/r/20170801124111.28881-1-mhocko@kernel.org
That work is stalled though because it is buggy and I was too busy to
finish that work. Anyway, if you believe that removing vmem_altmap is a
good step in general I will find another way. I wasn't really happy how
the whole thing is grafted to the memory hotplug and (ab)used it only
because it was handy and ready for reuse.

Anyway if you need a review of mm parts from me, you will have to wait
some more. If this requires some priority then go ahead and merge
it. Times are just too crazy right now.

Sorry about that.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
