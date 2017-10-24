Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95BF5203525F2
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 06:23:31 -0700 (PDT)
Date: Tue, 24 Oct 2017 15:27:13 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20171024132713.GD8556@quack2.suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-19-jack@suse.cz>
 <20171020214753.GA15733@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171020214753.GA15733@linux.intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 20-10-17 15:47:53, Ross Zwisler wrote:
> On Thu, Oct 19, 2017 at 02:58:17PM +0200, Jan Kara wrote:
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  man2/mmap.2 | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> > 
> > diff --git a/man2/mmap.2 b/man2/mmap.2
> > index 47c3148653be..598ff0c64f7f 100644
> > --- a/man2/mmap.2
> > +++ b/man2/mmap.2
> > @@ -125,6 +125,21 @@ are carried through to the underlying file.
> >  to the underlying file requires the use of
> >  .BR msync (2).)
> >  .TP
> > +.B MAP_SHARED_VALIDATE
> > +The same as
> > +.B MAP_SHARED
> > +except that
> > +.B MAP_SHARED
> > +mappings ignore unknown flags in
> > +.IR flags .
> > +In contrast when creating mapping of
> > +.B MAP_SHARED_VALIDATE
> > +mapping type, the kernel verifies all passed flags are known and fails the
> > +mapping with
> > +.BR EOPNOTSUPP
> > +otherwise. This mapping type is also required to be able to use some mapping
> > +flags.
> > +.TP
> 
> Some small nits:
> 
> I think you should maybe include a "(since Linux 4.15)" type note after the
> MAP_SHARED_VALIDATE header.  You also need to update the following line:
> 
>        Both of these flags are described in POSIX.1-2001 and POSIX.1-2008.
> 
> Which used to refer to MAP_SYNC and MAP_PRIVATE.

Thanks, I've fixed these.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
