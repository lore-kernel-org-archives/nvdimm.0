Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF9F321D0918F
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 11:21:55 -0700 (PDT)
Date: Mon, 31 Jul 2017 11:23:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] fs, xfs: introduce S_IOMAP_IMMUTABLE
Message-ID: <20170731182352.GE4477@magnolia>
References: <150135740948.35318.10730072114996910905.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150135741519.35318.16765137368329971936.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1501516968.579311.1058393288.0714478A@webmail.messagingengine.com>
 <CAPcyv4h_YWaAXG5pfkOJ0M74i5yEke1SoC3ESErTh41hngtG-w@mail.gmail.com>
 <1501518747.586018.1058450568.4B6F28FB@webmail.messagingengine.com>
 <1501522933.602272.1058529880.6C4A2D98@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1501522933.602272.1058529880.6C4A2D98@webmail.messagingengine.com>
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
To: Colin Walters <walters@verbum.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 01:42:13PM -0400, Colin Walters wrote:
> 
> 
> On Mon, Jul 31, 2017, at 12:32 PM, Colin Walters wrote:
> > On Mon, Jul 31, 2017, at 12:29 PM, Dan Williams wrote:
> > > 
> > > How is S_CONTENTS_IMMUTABLE different than S_IMMUTABLE?
> > 
> > We still want the ability to make hardlinks.
> 
> Also of course, symmetrically, to unlink.   If we used S_IMMUTABLE for /etc/sudoers,
> it'd still be racy since one would have to transiently remove the flag in order
> to replace it with a new version.
> 
> Related to this topic is the fact that S_IMMUTABLE is itself mutable; I
> think once S_IMMUTABLE_CONTENTS is set, it would not be able to made
> mutable again.  
> 
> Also I just remembered that since then memfd_create() and more notably
> fcntl(F_ADD_SEALS) landed - in fact it already has flags for what we want
> here AFAICS.  Your S_IOMAP_IMMUTABLE is fcntl(F_ADD_SEALS, F_SEAL_SHRINK | F_SEAL_GROW)

I don't think F_SEAL_{SHRINK,GROW} prevents reflinking or CoW of file data,
which are two things that cannot happen under S_IOMAP_IMMUTABLE that
aren't size changes.  From the implementation it looks like shrink and
grow are only supposed to disallow changes to i_size, not i_blocks (or
the file block map).

Then again, I suppose F_SEAL_* only work on shmem, so maybe it simply
isn't defined for any other filesystem...?  e.g. it doesn't prohibit
reflink, but the only fs implementing seals doesn't support reflink.

<shrug>

Seals cannot be removed, which is too strict for the S_IOMAP_IMMUTABLE
user cases being presented.

> and mine just adds in F_SEAL_WRITE.  I think there was some discussion
> of the seals for persistent files when memfd_create() landed, but I can't
> find it offhand.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
