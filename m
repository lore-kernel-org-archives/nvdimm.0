Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193F9317146;
	Thu,  2 Jul 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011079; cv=none; b=aoztfLET7ZB9xbDTxc7Rdgxmm3J1IinhQ/x8XiBgVxMBm+s5DsfhHM1N2Q2bqvDsl/qRmvWJWE3HcXxDszdkG20+FOSr1bnZLlPUeHziU31nj6QdzMQq8E9mOd6ypXFeUgI5612YQf6f6EmktkNktc7krhyxDepsJvMS1p3tqzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011079; c=relaxed/simple;
	bh=biYNUAbSLkMakBI2InMvj+slMvc5J5VSiUpkwej/21U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rM8CmaCCNP/7TloF7PDZGL9YjQeXPeyW2QBOBCLoLVRWMx6yIffy27XauQzN80+3Vj05Fo37lGrflmo8/bfl1JGeqDnsmAl4aFMBzMUAD0Whgz9u9fSo5rvkqXHVG60QddQKz2d0qT/QOO2thQtk2BbNCoinZtz1vWkM4cLWR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ymepa36T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ymepa36T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D15C81F000E9;
	Thu,  2 Jul 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011078;
	bh=ydgqm4JLD9wHorHnF+2XAPjVnBLFS4UbABn2TMKW9lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ymepa36TovSJKNYZV3u+xpDtmvDD0jgD8tu6oITOhStEqSB4dFm2GSNjYvX6a/XhD
	 idd1sj/Z9E/KlApdD9cMjRLqTlqdgS1ZGfahdEB1adsC1jHUM18Idy2FDJdP+91o7q
	 QlYswMBkWSAqfhgV/t0BjA2QDKkEneDGjH+Gl5qKC5w3Z9fiVXFpsrFrRHn8BhtWaG
	 lcACOAbDkojouQsXQtSoi47LOb5OGkLJW+AXDJEZT+ElhlEosUQhZ2/nNXhEJR9+aI
	 PyMC3eJrsnz1BJ5WVFaLKabv6f9zwLwtBLpgZ7fU4xVDkd9t8o3JJ3wtYAC95RX0Zj
	 PrPeMRFBP/AuA==
Date: Thu, 2 Jul 2026 09:51:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>,
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>,
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>,
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>,
	"open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
Message-ID: <20260702165117.GK9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com>
 <20260702140705.GE21339@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702140705.GE21339@lst.de>

On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> In terms of merge logistics, I wonder if we should delay this and
> the previous patch to the next merge window so that we can minimize the
> cross-subsystem merge pain with more file system iomap conversion.
> If none of them actually happen until rc6 or so, orif  the merges aren't
> painful we could still pick them up late in the merge window.

I'd say everything but this patch should go in during the merge window
for 7.3, along with clear instructions to brauner/torvalds to expect
this patch to appear right before 7.3-rc1 gets tagged, to clean up all
the other changes that come in.

--D
