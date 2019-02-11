Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.208])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2704C208EB3EF
 for <linux-nvdimm@lists.01.org>; Sun, 10 Feb 2019 22:47:33 -0800 (PST)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [PATCH v3 0/5] Optimize writecache when using
 pmem as cache
Date: Mon, 11 Feb 2019 06:47:06 +0000
Message-ID: <HK2PR03MB4418513AEBCD96612ED2CC9C92640@HK2PR03MB4418.apcprd03.prod.outlook.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
 <alpine.LRH.2.02.1902040606380.28217@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1902040606380.28217@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: zh-CN
MIME-Version: 1.0
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "snitzer@redhat.com" <snitzer@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, NingTing Cheng <chengnt@lenovo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> From: Mikulas Patocka <mpatocka@redhat.com>
> Sent: Monday, February 04, 2019 7:28 PM
> On Thu, 31 Jan 2019, Huaisheng Ye wrote:
> 
> > From: Huaisheng Ye <yehs1@lenovo.com>
> >
> > This patch set could be used for dm-writecache when use persistent
> > memory as cache data device.
> >
> > Patch 1 and 2 go towards removing unused parameter and codes which
> > actually doesn't really work.
> 
> I agree that there is some unused variables and code, but I would let it
> be as it is. The processors can write data to persistent memory either by
> using non-temporal stores (the movnti instruction) or by normal stores
> followed by the clwb instruction.
> 
> Currently, the movnti instruction is faster - however, it may be possible
> that with some newer processors, the clwb instruction could be faster -
> and in that case, we need the code that you have removed.
> 
> I would like to keep both flush strategies around (movnti and clwb), so
> that we can test how do they perform on various processors.
> Unfortunatelly, some upstream developers hate code with #ifdefs :-(
> 
> Note that compiler optimizations already remove the unused parameter and
> the impossible code behind "if (WC_MODE_PMEM(wc)) if (!WC_MODE_PMEM(wc))".

Hi Mikulas,

Thanks for your reply, now I could understand the code flow of dm-writecache better
than before.

In the process of playing around the code, I found that writecache_flush would try
to free earlier committed entry with lower seq-count. More seriously is that, writecache_flush
must check it for all entries which hasn't been committed. That's a lot of work to do when
there are many entries need to be flushed.

I have a plan for writecache_map to avoid using free entry when the committed writecache
has been hit. Does it make sense to simple the code flow, especially for saving additional rb-tree
node insertion and free steps?

Cheers,
Huaisheng Ye

> > Patch 3 and 4 are targeted at solving problem fn ctr failed to work
> > due to invalid magic or version, which is caused by the super block
> > of pmem has messy data stored.
> 
> LVM zeros the beginning of new logical volumes, so there should be no
> problem with it. If the user wants to use the writecache target without
> LVM, he should zero the superblock with dd if=/dev/zero of=/dev/pmem0
> bs=4k count=1
> 
> Note that other device mapper targets also follow this policy - for
> example see drivers/md/dm-snap-persistent.c:
>         if (le32_to_cpu(dh->magic) == 0) {
>                 *new_snapshot = 1;
>                 return 0;
>         }
> 
>         if (le32_to_cpu(dh->magic) != SNAP_MAGIC) {
>                 DMWARN("Invalid or corrupt snapshot");
>                 r = -ENXIO;
>                 goto bad;
>         }
> 
> So, I think there is no need for these patches - dm-writecache just does
> what others targets do.
> 
> > Patch 5 is used for getting the status of seq_count.
> 
> It may be accepted if other LVM team members find some use for this value.
> 
> Mikulas
> 
> > Changes Since v2:
> >         - seq_count is important for flush operations, output it within status
> >           for debugging and analyzing code behavior.
> > 	[1]: https://lkml.org/lkml/2019/1/3/43
> >         [2]: https://lkml.org/lkml/2019/1/9/6
> >
> > Huaisheng Ye (5):
> >   dm-writecache: remove unused size to writecache_flush_region
> >   dm-writecache: get rid of memory_data flush to writecache_flush_entry
> >   dm-writecache: expand pmem_reinit for struct dm_writecache
> >   Documentation/device-mapper: add optional parameter reinit
> >   dm-writecache: output seq_count within status
> >
> >  Documentation/device-mapper/writecache.txt |  4 ++++
> >  drivers/md/dm-writecache.c                 | 23 +++++++++++++----------
> >  2 files changed, 17 insertions(+), 10 deletions(-)
> >
> > --
> > 1.8.3.1
> >
> >
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
