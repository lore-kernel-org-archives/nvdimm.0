Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4697B210C1B6B
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 07:50:16 -0700 (PDT)
Date: Tue, 24 Jul 2018 08:50:13 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/5] Do not request a pointer kaddr when not required
Message-ID: <20180724145013.GA19466@linux.intel.com>
References: <20180724084510.6104-1-yehs2007@zoho.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180724084510.6104-1-yehs2007@zoho.com>
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
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, linux-nvdimm@lists.01.org, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 24, 2018 at 04:45:05PM +0800, Huaisheng Ye wrote:
> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> Some functions within fs/dax and dax/super don't need to get kaddr from
> direct_access. Assigning NULL to kaddr to ->direct_access() is more
> straightforward and simple than offering a useless local pointer.
> 
> So all direct_access() need to check the validity of second rank pointer
> kaddr for NULL assignment. If kaddr equals to NULL, it doesn't need to
> calculate its value.
> 
> * This series are supplement to [PATCH v2 00/14]mm: Asynchronous +
>   multithreaded memmap init for ZONE_DEVICE. [1]
> 
> [1]: https://lkml.org/lkml/2018/7/16/828

This whole series looks good to me.  Just a few comments:

1) Does this series actually depend on the "Asynchronous multithreaded mmap
init for ZONE_DEVICE" series from Dan?  It seems totally independent to me?
I reviewed yours by applying to linux/master, which worked fine.  I ask
because Dan's series has been delayed to after v4.19, and if yours isn't
actually dependent it could possibly go in sooner.

2) I agree with Christian's comment that the changelogs could be improved
slightly.  Remember that the goal of the changelog isn't to describe *what*
the code is doing, but *why*.  We can read that the code now checks if 'kaddr'
is NULL, and if so we don't calculate it.  It's useful to say that callers may
have no need for 'kaddr', so this patch is prep for allowing them to pass in
NULL instead of having to pass in a pointer that they then just throw away.

3) I think you should make one more change to kill the unused 'dummy_addr'
variable in persistent_memory_claim().  That was the one last case of a dummy
'kaddr' type variable that I could find.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
