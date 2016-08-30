From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: xfstests xfs fuzzers fail with DAX
Date: Mon, 29 Aug 2016 19:37:27 -0700
Message-ID: <20160830023727.GH22760@birch.djwong.org>
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
 <CAPcyv4g1CkMZoq+vHcyPZW3ME7Qr=6pW10BTxg2n+e+28+MFKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4g1CkMZoq+vHcyPZW3ME7Qr=6pW10BTxg2n+e+28+MFKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Aug 29, 2016 at 06:50:05PM -0700, Dan Williams wrote:
> [ Adding Darrick on the off chance that this triggers an "aha, of
> course it does!" ]

Aha!  Of course it does!!! :)

> Darrick these corruption tests you added to xfstests last year all
> fail the same way with DAX enabled.  They spew:
> 
>     "pwrite64: Structure needs cleaning"
> 
> ...reports that are cleaned up by running without "-o dax".

I think this happens because in non-dax mode, the pwrite is a buffered
write and so long as we can create a delalloc reservation, everything
is ok and nothing fails.  Whereas for dax we have to allocate the
blocks for the pwrite immediately, thereby triggering the cntbt
verifier error.

Proceeding from the assumption "DAX behaves a lot like DIO", all the
tests that rely on buffered mode semantics are going to choke if DAX
is turned on without them knowing about it.

> Alternatively you could sit back and watch me try to figure it out,
> that should be quite entertaining... as a start I'll try to pin down a
> stack trace when the error is returned.

As for how to fix this, probably the best option is to change line 98
to 'pwrite -W -S 0x62...' and update the output to include the
'structure needs cleaning' message.

Or get rid of the mount option and require explicitly turning on DAX
on a per-inode basis, which I think is where Dave is already going.

--D

> 
> 
> On Wed, Aug 3, 2016 at 7:45 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi,
> >
> > A few xfs fuzzers in xfstests fail with dax mount option, pass without dax.
> > They are xfs/086 xfs/088 xfs/089 xfs/091.
> >
> > xfstests to commit 4470ad4c7e  (Jul 26)
> > kernel   to commit dd95069545  (Jul 24)
> >
> > + ./check xfs/091
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
> >
> > xfs/091  104s
> > Ran: xfs/091
> > Passed all 1 tests
> >
> > + echo 'MOUNT_OPTIONS="-o dax"'
> > + ./check xfs/091
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> > MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
> >
> > xfs/091 104s ...  - output mismatch (see /root/xfstests/results//xfs/091.out.bad)
> >     --- tests/xfs/091.out       2016-07-18 02:57:47.670000000 -0400
> >     +++ /root/xfstests/results//xfs/091.out.bad 2016-08-03 22:38:14.948000000 -0400
> >     @@ -6,6 +6,70 @@
> >      + corrupt image
> >      + mount image
> >      + modify files
> >     +pwrite64: Structure needs cleaning
> >     +pwrite64: Structure needs cleaning
> >     +pwrite64: Structure needs cleaning
> >     +pwrite64: Structure needs cleaning
> >     ...
> >     (Run 'diff -u tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad'  to see the entire diff)
> > Ran: xfs/091
> > Failures: xfs/091
> > Failed 1 of 1 tests
> >
> > # diff -u xfstests/tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad
> > --- xfstests/tests/xfs/091.out  2016-07-18 02:57:47.670000000 -0400
> > +++ /root/xfstests/results//xfs/091.out.bad     2016-08-03 22:38:14.948000000 -0400
> > @@ -6,6 +6,70 @@
> >  + corrupt image
> >  + mount image
> >  + modify files
> > +pwrite64: Structure needs cleaning
> > <snip 62 more same lines>
> > +pwrite64: Structure needs cleaning
> >  + repair fs
> >  + mount image
> >  + chattr -R -i
> >
> >
> > Thanks,
> > Xiong
> >
> > _______________________________________________
> > Linux-nvdimm mailing list
> > Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> > https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
> _______________________________________________
> xfs mailing list
> xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> http://oss.sgi.com/mailman/listinfo/xfs
