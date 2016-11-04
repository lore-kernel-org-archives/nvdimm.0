Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0FA081D3E
 for <linux-nvdimm@lists.01.org>; Thu,  3 Nov 2016 21:20:06 -0700 (PDT)
Date: Fri, 4 Nov 2016 05:20:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/11] ext4: Factor out checks from ext4_file_write_iter()
Message-ID: <20161104042003.GN24234@quack2.suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-2-git-send-email-jack@suse.cz>
 <20161103210440.GA27351@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161103210440.GA27351@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 03-11-16 15:04:40, Ross Zwisler wrote:
> On Tue, Nov 01, 2016 at 10:06:11PM +0100, Jan Kara wrote:
> > +	/*
> > +	 * 'err==len' means that all of blocks has been preallocated no matter
> > +	 * they are initialized or not.  For excluding unwritten extents, we
> > +	 * need to check m_flags.
> 
> Does it make sense to clean up this comment, since you're moving it anyway?
> 
> i.e.:
> 
>   'err==len' means that all of the blocks have been preallocated, regardless
>   of whether they have been initialized or not.  To exclude unwritten extents
>   we need to check m_flags.

OK, done. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
