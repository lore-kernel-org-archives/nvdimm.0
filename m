Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D877022198F54
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 09:44:28 -0800 (PST)
Date: Thu, 21 Dec 2017 09:46:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfsprogs PATCH v2 2/3] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171221174602.GV12613@magnolia>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-3-ross.zwisler@linux.intel.com>
 <20171221170908.GT12613@magnolia>
 <20171221174110.GD2158@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171221174110.GD2158@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 21, 2017 at 10:41:10AM -0700, Ross Zwisler wrote:
> On Thu, Dec 21, 2017 at 09:09:08AM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 05, 2017 at 04:56:50PM -0700, Ross Zwisler wrote:
> 
> > > @@ -195,6 +200,13 @@ mmap_f(
> > >  		case 'x':
> > >  			prot |= PROT_EXEC;
> > >  			break;
> > > +		case 'S':
> > > +			flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> > > +			if (!flags) {
> > 
> > Heh, subtle. :)
> > 
> > /me wonders if it'd be better to do this explicitly:
> > 
> > #ifdef HAVE_MAP_SYNC
> > 	flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> > #else
> > 	printf("MAP_SYNC not supported\n");
> > 	return 1;
> > #endif
> > 
> > ...though it's ugly.
> 
> Yea, I was trying to avoid #ifdefery.  If you prefer this, though, I'm happy
> to change it.  Or maybe a comment would be enough?
> 
> /*
>  * If MAP_SYNC and MAP_SHARED_VALIDATE aren't defined in the system headers we
>  * will have defined them both as 0.
>  */
> 
> ?

Works for me.

> 
> > > +				printf("MAP_SYNC not supported\n");
> > > +				return 0;
> > 
> > Are we supposed to be returning nonzero values for failing commands?
> 
> I don't think so.  All the other error conditions in this function also return
> 0.  I think the important thing is that 'exitcode' is set to 1 at the
> beginning of the function per Dave's patch,
> 
> https://www.spinics.net/lists/linux-xfs/msg13605.html
> 
> which I pulled into my baseline:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/refs/?h=map_sync_v3
> 
> So, I likewise leave 'exitcode' as 1, bail out with a return code of 0, and
> then you get the overall failure return of 1 from xfs_io at the shell.

Ok.

> > > @@ -764,7 +764,7 @@ Each (sec, nsec) pair constitutes a single timestamp value.
> > >  
> > >  .SH MEMORY MAPPED I/O COMMANDS
> > >  .TP
> > > -.BI "mmap [ " N " | [[ \-rwx ] [\-s " size " ] " "offset length " ]]
> > > +.BI "mmap [ " N " | [[ \-rwxS ] [\-s " size " ] " "offset length " ]]
> > >  With no arguments,
> > >  .B mmap
> > >  shows the current mappings. Specifying a single numeric argument
> > > @@ -780,6 +780,10 @@ PROT_WRITE
> > >  .RB ( \-w ),
> > >  and PROT_EXEC
> > >  .RB ( \-x ).
> > > +The mapping will be created with the MAP_SHARED flag by default, or with the
> > > +Linux specific (MAP_SYNC | MAP_SHARED_VALIDATE) flags if
> > 
> > I assume I'll be able to look up exactly what MAP_SYNC provides in the mmap
> > manpage, right?
> 
> Yep, Jan updated the man page for both MAP_SYNC and MAP_SHARED_VALIDATE:
> https://lists.01.org/pipermail/linux-nvdimm/2017-November/013158.html

Will have a look.

> Thank you for the review.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
