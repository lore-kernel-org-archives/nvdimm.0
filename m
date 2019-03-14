Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com
 [IPv6:2607:f8b0:4864:20::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95F18211DC06F
 for <linux-nvdimm@lists.01.org>; Thu, 14 Mar 2019 00:35:04 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 67so3611621oif.10
 for <linux-nvdimm@lists.01.org>; Thu, 14 Mar 2019 00:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com>
 <20190311150947.GD19508@bombadil.infradead.org>
 <CAPcyv4jG5r2LOesxSx+Mdf+L_gQWqnhk+gKZyKAAPTHy1Drvqw@mail.gmail.com>
 <20190312043754.GD23020@dastard>
In-Reply-To: <20190312043754.GD23020@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Mar 2019 00:34:51 -0700
Message-ID: <CAPcyv4i+z0RT7rTw+4w-h8dOyscVk1g3F+cu2pKHqqJjTgU++A@mail.gmail.com>
Subject: Re: Hang / zombie process from Xarray page-fault conversion (bisected)
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "Barror, Robert" <robert.barror@intel.com>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 11, 2019 at 9:38 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Mar 11, 2019 at 08:35:05PM -0700, Dan Williams wrote:
> > On Mon, Mar 11, 2019 at 8:10 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Thu, Mar 07, 2019 at 10:16:17PM -0800, Dan Williams wrote:
> > > > Hi Willy,
> > > >
> > > > We're seeing a case where RocksDB hangs and becomes defunct when
> > > > trying to kill the process. v4.19 succeeds and v4.20 fails. Robert was
> > > > able to bisect this to commit b15cd800682f "dax: Convert page fault
> > > > handlers to XArray".
> > > >
> > > > I see some direct usage of xa_index and wonder if there are some more
> > > > pmd fixups to do?
> > > >
> > > > Other thoughts?
> > >
> > > I don't see why killing a process would have much to do with PMD
> > > misalignment.  The symptoms (hanging on a signal) smell much more like
> > > leaving a locked entry in the tree.  Is this easy to reproduce?  Can you
> > > get /proc/$pid/stack for a hung task?
> >
> > It's fairly easy to reproduce, I'll see if I can package up all the
> > dependencies into something that fails in a VM.
> >
> > It's limited to xfs, no failure on ext4 to date.
> >
> > The hung process appears to be:
> >
> >      kworker/53:1-xfs-sync/pmem0
>
> That's completely internal to XFS. Every 30s the work is triggered
> and it either does a log flush (if the fs is active) or it syncs the
> superblock to clean the log and idle the filesystem. It has nothing
> to do with user processes, and I don't see why killing a process has
> any effect on what it does...
>
> > ...and then the rest of the database processes grind to a halt from there.
> >
> > Robert was kind enough to capture /proc/$pid/stack, but nothing interesting:
> >
> > [<0>] worker_thread+0xb2/0x380
> > [<0>] kthread+0x112/0x130
> > [<0>] ret_from_fork+0x1f/0x40
> > [<0>] 0xffffffffffffffff
>
> Much more useful would be:
>
> # echo w > /proc/sysrq-trigger
>
> And post the entire output of dmesg.

Here it is:

https://gist.github.com/djbw/ca7117023305f325aca6f8ef30e11556

There are some process stuck indefinitely waiting to acquire an Xarray
entry lock.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
