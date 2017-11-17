Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99C3B21B00DC1
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 13:39:50 -0800 (PST)
Date: Fri, 17 Nov 2017 14:44:00 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH 1/2] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171117214400.GB3910@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-2-ross.zwisler@linux.intel.com>
 <20171117204021.GO5119@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171117204021.GO5119@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 17, 2017 at 12:40:21PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 17, 2017 at 01:25:23PM -0700, Ross Zwisler wrote:
> > Add support for a new -S flag to xfs_io's mmap command.  This opens the
> > mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> > standard MAP_SHARED flag.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > ---
<>
> > diff --git a/include/linux.h b/include/linux.h
> > index 6ce344c..4ee03ed 100644
> > --- a/include/linux.h
> > +++ b/include/linux.h
> > @@ -327,4 +327,9 @@ fsmap_advance(
> >  #define HAVE_GETFSMAP
> >  #endif /* HAVE_GETFSMAP */
> >  
> > +#ifndef HAVE_MAP_SYNC
> > +#define MAP_SYNC 0x80000
> > +#define MAP_SHARED_VALIDATE 0x3
> > +#endif /* HAVE_MAP_SYNC */
> 
> Hmm, what's the point of ifndef/define if you have an configure.ac check?

I'm following the example of HAVE_GETFSMAP.  It does a check to see if the
headers have proper support in m4/package_libcdev.m4, then has code in this
file to provide defines if they aren't provided in the system.

> > diff --git a/io/mmap.c b/io/mmap.c
> > index 7a8150e..520b037 100644
> > --- a/io/mmap.c
> > +++ b/io/mmap.c
> > @@ -42,7 +42,7 @@ print_mapping(
> >  	int		index,
> >  	int		braces)
> >  {
> > -	unsigned char	buffer[8] = { 0 };
> > +	char		buffer[8] = { 0 };
> >  	int		i;
> >  
> >  	static struct {
> > @@ -57,6 +57,10 @@ print_mapping(
> >  
> >  	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
> >  		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
> > +
> > +	if (map->map_sync)
> > +		sprintf(&buffer[i], " S");
> 
> Does buffer need enlarging here?

Nope.  The buffer is 8 chars, and the 'rwx\0' string only uses 4.
"rwx S\0" uses 6, so we're still good to go.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
