Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.209])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBC5520945D80
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 08:41:47 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [PATCH 0/5] Do not request a pointer kaddr when
 not required
Date: Tue, 24 Jul 2018 15:41:22 +0000
Message-ID: <TY2PR03MB33437169EF0F111DDF9C6A4A92550@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180724084510.6104-1-yehs2007@zoho.com>
 <20180724145013.GA19466@linux.intel.com>
In-Reply-To: <20180724145013.GA19466@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, NingTing Cheng <chengnt@lenovo.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "bart.vanassche@wdc.com" <bart.vanassche@wdc.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Sent: Tuesday, July 24, 2018 10:50 PM
> > Some functions within fs/dax and dax/super don't need to get kaddr from
> > direct_access. Assigning NULL to kaddr to ->direct_access() is more
> > straightforward and simple than offering a useless local pointer.
> >
> > So all direct_access() need to check the validity of second rank pointer
> > kaddr for NULL assignment. If kaddr equals to NULL, it doesn't need to
> > calculate its value.
> >
> > * This series are supplement to [PATCH v2 00/14]mm: Asynchronous +
> >   multithreaded memmap init for ZONE_DEVICE. [1]
> >
> > [1]: https://lkml.org/lkml/2018/7/16/828
> 
> This whole series looks good to me.  Just a few comments:
> 
> 1) Does this series actually depend on the "Asynchronous multithreaded mmap
> init for ZONE_DEVICE" series from Dan?  It seems totally independent to me?
> I reviewed yours by applying to linux/master, which worked fine.  I ask
> because Dan's series has been delayed to after v4.19, and if yours isn't
> actually dependent it could possibly go in sooner.

This series doesn't depend on Dan's 'Asynchronous multithreaded mmap init
for ZONE_DEVICE'. For the part as pfn, which overlaps Dan's original series.
Because I post them earlier than Dan's, Dan generously dropped the overlapping
from his series and adopted mine to the series of 'Asynchronous multithreaded'.
It is very thankful.

I knew Dan's series would be delayed, I can resend the series, both kaddr and pfn,
for faster merging to mainline.

> 2) I agree with Christian's comment that the changelogs could be improved
> slightly.  Remember that the goal of the changelog isn't to describe *what*
> the code is doing, but *why*.  We can read that the code now checks if 'kaddr'
> is NULL, and if so we don't calculate it.  It's useful to say that callers may
> have no need for 'kaddr', so this patch is prep for allowing them to pass in
> NULL instead of having to pass in a pointer that they then just throw away.

Thanks for advice. I will follow your suggestion during next submission.

> 3) I think you should make one more change to kill the unused 'dummy_addr'
> variable in persistent_memory_claim().  That was the one last case of a dummy
> 'kaddr' type variable that I could find.

Yes, you are right. I haven't updated my code base to latest mainline, so couldn't
notice it. It seems there is a new created file here as dm-writecache.c.
Thanks for hints.

Cheers,
Huaisheng Ye


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
