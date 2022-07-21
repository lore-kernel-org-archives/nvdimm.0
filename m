Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9174680
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 16:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF13AC3411E;
	Thu, 21 Jul 2022 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658420169;
	bh=xT5f1D+KeSdKXSDNm+AUgoa/PxUGHb8D2uIkXaaJ8r8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G0KmWUlqGa5+AtGttq0KZFE93GP8nIQ9JjRfym54liu33f3YWZSpewiGCU83FsCyY
	 RPFw9Gi6DTS1pqtkG8WtOb7Z8+vOoJPp8Bs2aS9vycQFY1SDIiP6XlBT6Mwyla0ocM
	 x9oeVFZ68PtQK7ENQXdBNtaFZOPWBPxEPZO1ThLgkk9lRjc98etddbcystvffjVAkM
	 SZtd6WMRCTzOXK17cfKgvCrhEoO7BEuCnOmiI1AKasRrtz8rxVFZUTtHHlHI1D375m
	 rxtTJ3VzUaQujbO1UOZKQ2BpuTFmrPQ6eVAqAUgLLBPZus2jiaUPBvkcCl0e38ksTW
	 X94REWNqMvC8Q==
Date: Thu, 21 Jul 2022 09:16:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Message-ID: <Ytl7yJJL1fdC006S@magnolia>
References: <20220609143435.393724-1-ruansy.fnst@fujitsu.com>
 <Yr5AV5HaleJXMmUm@magnolia>
 <74b0a034-8c77-5136-3fbd-4affb841edcb@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74b0a034-8c77-5136-3fbd-4affb841edcb@fujitsu.com>

On Thu, Jul 21, 2022 at 02:06:10PM +0000, ruansy.fnst@fujitsu.com wrote:
> 在 2022/7/1 8:31, Darrick J. Wong 写道:
> > On Thu, Jun 09, 2022 at 10:34:35PM +0800, Shiyang Ruan wrote:
> >> Failure notification is not supported on partitions.  So, when we mount
> >> a reflink enabled xfs on a partition with dax option, let it fail with
> >> -EINVAL code.
> >>
> >> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > 
> > Looks good to me, though I think this patch applies to ... wherever all
> > those rmap+reflink+dax patches went.  I think that's akpm's tree, right?
> > 
> > Ideally this would go in through there to keep the pieces together, but
> > I don't mind tossing this in at the end of the 5.20 merge window if akpm
> > is unwilling.
> 
> BTW, since these patches (dax&reflink&rmap + THIS + pmem-unbind) are 
> waiting to be merged, is it time to think about "removing the 
> experimental tag" again?  :)

It's probably time to take up that question again.

Yesterday I tried running generic/470 (aka the MAP_SYNC test) and it
didn't succeed because it sets up dmlogwrites atop dmthinp atop pmem,
and at least one of those dm layers no longer allows fsdax pass-through,
so XFS silently turned mount -o dax into -o dax=never. :(

I'm not sure how to fix that...

--D

> 
> --
> Thanks,
> Ruan.
> 
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> >> ---
> >>   fs/xfs/xfs_super.c | 6 ++++--
> >>   1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index 8495ef076ffc..a3c221841fa6 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -348,8 +348,10 @@ xfs_setup_dax_always(
> >>   		goto disable_dax;
> >>   	}
> >>   
> >> -	if (xfs_has_reflink(mp)) {
> >> -		xfs_alert(mp, "DAX and reflink cannot be used together!");
> >> +	if (xfs_has_reflink(mp) &&
> >> +	    bdev_is_partition(mp->m_ddev_targp->bt_bdev)) {
> >> +		xfs_alert(mp,
> >> +			"DAX and reflink cannot work with multi-partitions!");
> >>   		return -EINVAL;
> >>   	}
> >>   
> >> -- 
> >> 2.36.1
> >>
> >>
> >>
