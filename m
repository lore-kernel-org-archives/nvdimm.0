Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
 [150.101.137.141]) by ml01.01.org (Postfix) with ESMTP id E4D0F1A1E11
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 00:39:09 -0700 (PDT)
Date: Mon, 1 Aug 2016 17:39:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160801073906.GK16044@dastard>
References: <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard>
 <CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com>
 <20160801014645.GI16044@dastard> <86k2g15gh8.fsf@hiro.keithp.com>
 <20160801040737.GJ16044@dastard>
 <CAPcyv4jN5OvbPMA07w0vjBCBrGH-j2YsCjfvB3b6S6JJ_zUA=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jN5OvbPMA07w0vjBCBrGH-j2YsCjfvB3b6S6JJ_zUA=Q@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 31, 2016 at 09:39:38PM -0700, Dan Williams wrote:
> On Sun, Jul 31, 2016 at 9:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> > OTOH, DAX directly exposes the physical layout to the filesytem.
> > And because it's DAX-based pmem and not cached struct pages, we
> > can't run vm_map_ram() to virtually map the range we need to see as
> > a contiguous range, as we do in XFS for large objects such as directory
> > blocks and log buffers. For other large objects such as inode
> > clusters, we can directly map each page as the objects within the
> > clusters are page aligned and never overlap page boundaries, but
> > that only works for inode and dquot buffers. Hence DAX as it stands
> > makes it extremely difficult to "retrofit" DAX into all aspects of
> > existing fileystems because exposing physical discontiguities breaks
> > code that assumes they don't exist.
> 
> On this specific point about page remapping, the administrator can
> configure struct pages for pmem and you can detect whether they are
> present in the filesystem with pfn_t_has_page().  I.e. you could
> require pages be present for XFS, if that helps...

It's kinda silly to require struct pages for the entire pmem device
if they are only needed for accessing a (comparitively) small amount
of metadata.

Besides, now that I look at it more deeply, we can't use virtually
mapped pmem for the log buffers.  We can't allocate memory at the
point in time where we work out what LBA in the log we need to map
to physical pmem for the current log write.  Hence calls to
vm_map_ram() can't be used, and so that rules out using mapped page
based pmem for log buffers.

I'll probably have to rewrite the xlog_write() engine completely to
be able to handle discontiguous pages in the iclog buffers before we
can consider mapping them via DAX now, and I'm really not sure it's
worth the effort. I'd much prefer to spend time designing a native
pmem filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
