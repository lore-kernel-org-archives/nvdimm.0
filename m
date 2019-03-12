Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 849E8211DBE06
 for <linux-nvdimm@lists.01.org>; Tue, 12 Mar 2019 09:53:54 -0700 (PDT)
From: "Barror, Robert" <robert.barror@intel.com>
Subject: RE: Hang / zombie process from Xarray page-fault conversion (bisected)
Date: Tue, 12 Mar 2019 16:53:52 +0000
Message-ID: <04FD0F1E52B84F4ABF03487D5C82D4CA773CE75B@ORSMSX113.amr.corp.intel.com>
References: <CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com>
 <20190311150947.GD19508@bombadil.infradead.org>
 <CAPcyv4jG5r2LOesxSx+Mdf+L_gQWqnhk+gKZyKAAPTHy1Drvqw@mail.gmail.com>
 <20190312043754.GD23020@dastard>
In-Reply-To: <20190312043754.GD23020@dastard>
Content-Language: en-US
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
To: Dave Chinner <david@fromorbit.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Guys,

"> It's limited to xfs, no failure on ext4 to date", this is incorrect. I have been able to reproduce this issue with ext4. In order to do that, I need to run the full test (on both pmems in the system) and not the half test (only 1 pmem) that I use for inducing the hang under XFS. The test also runs considerably longer before failing with ext4 than XFS.

Thx bob


-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Monday, March 11, 2019 9:38 PM
To: Williams, Dan J <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>; Linux MM <linux-mm@kvack.org>; linux-nvdimm <linux-nvdimm@lists.01.org>; linux-fsdevel <linux-fsdevel@vger.kernel.org>; Barror, Robert <robert.barror@intel.com>
Subject: Re: Hang / zombie process from Xarray page-fault conversion (bisected)

On Mon, Mar 11, 2019 at 08:35:05PM -0700, Dan Williams wrote:
> On Mon, Mar 11, 2019 at 8:10 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Mar 07, 2019 at 10:16:17PM -0800, Dan Williams wrote:
> > > Hi Willy,
> > >
> > > We're seeing a case where RocksDB hangs and becomes defunct when 
> > > trying to kill the process. v4.19 succeeds and v4.20 fails. Robert 
> > > was able to bisect this to commit b15cd800682f "dax: Convert page 
> > > fault handlers to XArray".
> > >
> > > I see some direct usage of xa_index and wonder if there are some 
> > > more pmd fixups to do?
> > >
> > > Other thoughts?
> >
> > I don't see why killing a process would have much to do with PMD 
> > misalignment.  The symptoms (hanging on a signal) smell much more 
> > like leaving a locked entry in the tree.  Is this easy to reproduce?  
> > Can you get /proc/$pid/stack for a hung task?
> 
> It's fairly easy to reproduce, I'll see if I can package up all the 
> dependencies into something that fails in a VM.
> 
> It's limited to xfs, no failure on ext4 to date.
> 
> The hung process appears to be:
> 
>      kworker/53:1-xfs-sync/pmem0

That's completely internal to XFS. Every 30s the work is triggered and it either does a log flush (if the fs is active) or it syncs the superblock to clean the log and idle the filesystem. It has nothing to do with user processes, and I don't see why killing a process has any effect on what it does...

> ...and then the rest of the database processes grind to a halt from there.
> 
> Robert was kind enough to capture /proc/$pid/stack, but nothing interesting:
> 
> [<0>] worker_thread+0xb2/0x380
> [<0>] kthread+0x112/0x130
> [<0>] ret_from_fork+0x1f/0x40
> [<0>] 0xffffffffffffffff

Much more useful would be:

# echo w > /proc/sysrq-trigger

And post the entire output of dmesg.

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
