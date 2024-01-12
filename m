Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24210FE;
	Fri, 12 Jan 2024 02:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9kjrJNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E13C433C7;
	Fri, 12 Jan 2024 02:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705026071;
	bh=vzFsyrcpEKyKi/ZCFmMLv89tZPcFv5KRoRhuUunRASo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o9kjrJNVjySVcq//l8zcsYCy/We/gWt06pCCqQ1F05AgF3+pJ9szXMi/SPheIJkXR
	 mikdThOdtqsduSSb6SAufKn3FTaVyYYq+aNy8yE3RURhXwKg9FZ1r9Aymm1M0skPbk
	 n/5LC628c5bbRBeTGW9bdouALGnSVwguBqhv028a0JrDQPdlgdwFLbKpg9JuzLNzp6
	 ldR2YzvvyEPJ2NYQGE3mzRy5cSxl8QJoOhxKSBVb4MA9+cX/D32iNQV14q7vuFbPaR
	 ZtK6eRvNR0T8pmxZjVOxFt1vHEZFP91TekqBnRwt6UI/35xKcSzUgD0b88Xv1bqmHb
	 n2qRqxUa/AZQw==
Date: Thu, 11 Jan 2024 18:21:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, chandan.babu@oracle.com,
	dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20240112022110.GP722975@frogsfrogsfrogs>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <ZaAeaRJnfERwwaP7@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaAeaRJnfERwwaP7@redhat.com>

On Thu, Jan 11, 2024 at 10:59:21AM -0600, Bill O'Donnell wrote:
> On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
> > FSDAX and reflink can work together now, let's drop this warning.
> > 
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> 
> Are there any updates on this?
 
Remind us to slip this in for 6.8-rc7 if nobody complains about the new
dax functionality. :)

--D

> Thanks-
> Bill
> 
> 
> > ---
> >  fs/xfs/xfs_super.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 1f77014c6e1a..faee773fa026 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -371,7 +371,6 @@ xfs_setup_dax_always(
> >  		return -EINVAL;
> >  	}
> >  
> > -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> >  	return 0;
> >  
> >  disable_dax:
> > -- 
> > 2.42.0
> > 
> 
> 
