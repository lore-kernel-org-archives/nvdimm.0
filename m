Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
 [150.101.137.141]) by ml01.01.org (Postfix) with ESMTP id D40BC1A1E06
 for <linux-nvdimm@lists.01.org>; Sun, 31 Jul 2016 18:46:48 -0700 (PDT)
Date: Mon, 1 Aug 2016 11:46:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160801014645.GI16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard>
 <CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com>
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

On Fri, Jul 29, 2016 at 05:53:07PM -0700, Dan Williams wrote:
> On Fri, Jul 29, 2016 at 5:12 PM, Dave Chinner <david@fromorbit.com> wrote:
....
> > So what you are saying is that on and ADR machine, we have these
> > domains w.r.t. power fail:
> >
> > cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media
> >
> > |-------------volatile-------------------|-----persistent--------------|
> >
> > because anything that gets to the IMC is guaranteed to be flushed to
> > stable media on power fail.
> >
> > But on a posted-write-buffer system, we have this:
> >
> > cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media
> >
> > |-------------volatile-------------------------------------------|--persistent--|
> >
> > IOWs, only things already posted to the media via REQ_FLUSH are
> > considered stable on persistent media.  What happens in this case
> > when power fails during a media update? Incomplete writes?
> 
> Yes, power failure during a media update will end up with incomplete
> writes on an 8-byte boundary.

So we'd see that from the point of view of a torn single sector
write. Ok, so we better limit DAX to CRC enabled filesystems to
ensure these sorts of events are always caught by the filesystem.

> >> > Or have we somehow ended up with the fucked up situation where
> >> > dax_do_io() writes are (effectively) immediately persistent and
> >> > untracked by internal infrastructure, whilst mmap() writes
> >> > require internal dirty tracking and fsync() to flush caches via
> >> > writeback?
> >>
> >> dax_do_io() writes are not immediately persistent.  They bypass the
> >> cpu-cache and cpu-write-bufffer and are ready to be flushed to media
> >> by REQ_FLUSH or power-fail on an ADR system.
> >
> > IOWs, on an ADR system  write is /effectively/ immediately persistent
> > because if power fails ADR guarantees it will be flushed to stable
> > media, while on a posted write system it is volatile and will be
> > lost. Right?
> 
> Right.

Thanks for the clarification.

> > If we track the dirty blocks from write in the radix tree like we
> > for mmap, then we can just use a normal memcpy() in dax_do_io(),
> > getting rid of the slow cache bypass that is currently run. Radix
> > tree updates are much less expensive than a slow memcpy of large
> > amounts of data, ad fsync can then take care of persistence, just
> > like we do for mmap.
> 
> If we go this route to increase the amount of dirty-data tracking in
> the radix it raises the priority of one of the items on the backlog;
> namely, determine the crossover point where wbinvd of the entire cache
> is faster than a clflush / clwb loop.

Actually, I'd look at it from the other persepctive - at what point
does fine-grained dirty tracking run faster than the brute force
flush? If the gains are only marginal, then we need to question
whether fine grained tracking is worth the complexity at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
