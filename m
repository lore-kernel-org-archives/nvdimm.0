Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 221E62119C88E
 for <linux-nvdimm@lists.01.org>; Wed, 12 Dec 2018 08:11:55 -0800 (PST)
Date: Thu, 13 Dec 2018 00:11:46 +0800
From: Huaisheng Ye <yehs2007@zoho.com>
Message-ID: <167a3303a01.11a848ab768799.5161498967766415143@zoho.com>
In-Reply-To: <20180831094255.GB11622@quack2.suse.cz>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz>
 <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
 <20180830233809.GH1572@dastard> <20180831094255.GB11622@quack2.suse.cz>
Subject: Re: Snapshot target and DAX-capable devices
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: yehs2007@zoho.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, chengnt <chengnt@lenovo.com>, Dave Chinner <david@fromorbit.com>, colyli <colyli@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

 ---- On Fri, 31 Aug 2018 17:42:55 +0800 Jan Kara <jack@suse.cz> wrote ---- 
 > On Fri 31-08-18 09:38:09, Dave Chinner wrote: 
 > > On Thu, Aug 30, 2018 at 03:47:32PM -0400, Mikulas Patocka wrote: 
 > > >  
 > > >  
 > > > On Thu, 30 Aug 2018, Jeff Moyer wrote: 
 > > >  
 > > > > Mike Snitzer <snitzer@redhat.com> writes: 
 > > > >  
 > > > > > Until we properly add DAX support to dm-snapshot I'm afraid we really do 
 > > > > > need to tolerate this "regression".  Since reality is the original 
 > > > > > support for snapshot of a DAX DM device never worked in a robust way. 
 > > > >  
 > > > > Agreed. 
 > > > >  
 > > > > -Jeff 
 > > >  
 > > > You can't support dax on snapshot - if someone maps a block and the block  
 > > > needs to be moved, then what? 
 > >  
 > > This is only a problem for access via mmap and page faults. 
 > >  
 > > At the filesystem level, it's no different to the existing direct IO 
 > > algorithm for read/write IO - we simply allocate new space, copy the 
 > > data we need to copy into the new space (may be no copy needed), and 
 > > then write the new data into the new space. I'm pretty sure that for 
 > > bio-based IO to dm-snapshot devices the algorithm will be exactly 
 > > the same. 
 > >  
 > > However, for direct access via mmap, we have to modify how the 
 > > userspace virtual address is mapped to the physical location. IOWs, 
 > > during the COW operation, we have to invalidate all existing user 
 > > mappings we have for that physical address. This means we have to do 
 > > an invalidation after the allocate/copy part of the COW operation. 
 > > 
 > > If we are doing this during a page fault, it means we'll probably 
 > > have to restart the page fault so it can look up the new physical 
 > > address associated with the faulting user address. After we've done 
 > > the invalidation, any new (or restarted) page fault finds the 
 > > location of new copy we just made, maps it into the user address 
 > > space, updates the ptes and we're all good. 
 > >  
 > > Well, that's the theory. We haven't implemented this for XFS yet, so 
 > > it might end up a little different, and we might yet hit unexpected 
 > > problems (it's DAX, that's what happens :/). 
 >  
 > Yes, that's outline of a plan :) 
 >  
 > > It's a whole different ballgame for a dm-snapshot device - block 
 > > devices are completely unaware of page faults to DAX file mappings. 
 >  
 > Actually, block devices are not completely unaware of DAX page faults - 
 > they will get ->direct_access callback for the fault range. It does not 
 > currently convey enough information - we also need to inform the block 
 > device whether it is read or write. But that's about all that's needed to 
 > add AFAICT. And by comparing returned PFN with the one we have stored in 
 > the radix tree (which we have if that file offset is mapped by anybody), 
 > the filesystem / DAX code can tell whether remapping happened and do the 
 > unmapping. 

Hi Jan,

I am trying to investigate how to make dm-snapshot to support DAX, and I
dropped a patchset to upstream for comments. Any suggestion is welcome.
# https://lkml.org/lkml/2018/11/21/281

In the beginning, I haven't considered the situation of mmap write faults.
>From Dan's reply and this email thread, now I have a more clear understanding.

The question is that, even the virtual dm block device has been informed that
the mmap may have write operations through PROT_WRITE, if userspace directly
operate the virtual address of origin device like memcpy, dm-snapshot doesn't
have chance to detect this behavior.
Although dm-snapshot can have chance to prepare a COW area to back up origin's
blocks within ->direct_access callback for the fault range, how can it to have
opportunity to read the data from origin device and save it to COW?

---
Cheers,
Huaisheng Ye

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
