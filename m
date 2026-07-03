Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D953E1CEAC2;
	Fri,  3 Jul 2026 02:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783044108; cv=none; b=Y3pB91pDMba1dq9/LH2vvbduEWbjqa3MnQQWoR+xYBvUJ5vciwF2b0aCc9NbuuOsT3vSAFM20RV+v5iYlM5fYyQSkew0ZVY6z78gYsW6t0hArC6XdWz8tYjI980FSEcJ6aj1Z8M2eQXLI9u+mHgzUlWvJIFe8sf4c84FkiKPYOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783044108; c=relaxed/simple;
	bh=GAM+m6cWDuuutfc0N8W+w2qobBwH4/jAJw4LN4feaPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBMK6lqVEJUkp9s3QRpDbj5E/jMMgqbH+RjFDXZjocw85+YOtssYt9NVdYmR+hTt92dxtzsLBRxyBkSoI4r32j1kfRI5EgPmopJ6vT0AmiGvu5Pgw6+TlFwM8eO92675hlogxVPvo/ZqAh1Uzefnz1DT+Rw1X2pVLeb/ebYlhio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZ+G2Lxb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZ+G2Lxb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 74CBF1F000E9;
	Fri,  3 Jul 2026 02:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783044107;
	bh=oMB68yM9vnc03sy1HjctW2y/WonQpK4WbJis7WinceA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UZ+G2LxbC6hyyPY45gChM82kirEdP2W1cjQ9cB8OMLYUlkgPJvcmz/MIwlujeZotn
	 4R/Zvspof7xaAk0X3wOEeMxwWctRoLV4NTsc8rCCvYPFhVb70Q3E9WueaPYWgiO166
	 2xfbkdD8pCO8AIcoqCOfLU0RCSAZUSynWck7z/YdMGgn6CidZh7U3ECdLyiqSYmIa8
	 M5P1TAt9IbsmnguwJe2hbJNiSXqqC63NyKcHW0pu+qG7lIvuTSoTWo9hiMZTxGrVTP
	 BJg1wFffSxulJHs9pt/+Ff8RV8ItkGlqOI2T/5xJPdCI7Mb+FwKTLrcrnQUpxeWmfr
	 1in1VDEBLw3PA==
Date: Thu, 2 Jul 2026 19:01:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
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
Message-ID: <20260703020147.GT9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com>
 <20260702140705.GE21339@lst.de>
 <20260702165117.GK9392@frogsfrogsfrogs>
 <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>

On Thu, Jul 02, 2026 at 06:47:43PM -0700, Joanne Koong wrote:
> On Thu, Jul 2, 2026 at 9:51 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > > Looks good:
> > >
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > >
> > > In terms of merge logistics, I wonder if we should delay this and
> > > the previous patch to the next merge window so that we can minimize the
> > > cross-subsystem merge pain with more file system iomap conversion.
> > > If none of them actually happen until rc6 or so, orif  the merges aren't
> > > painful we could still pick them up late in the merge window.
> >
> > I'd say everything but this patch should go in during the merge window
> > for 7.3, along with clear instructions to brauner/torvalds to expect
> > this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> > the other changes that come in.
> 
> Just to clarify, did you mean this patch and the previous one? If i'm

Er, yes, patches 16-18 in this series.

> interpreting Christoph's concern correctly, I think he's worried about
> other filesystems converting to iomap using the ->iomap_begin() /
> ->iomap_end() functions still? That sounds like a good plan to me, for
> v3 I'll submit everything but this patch and the last one and then
> submit these patches (and any cleanup ones that become necessary) to
> Christian right before 7.3-rc1 gets tagged (which as I understand it,
> is when the merge window is about to close).

Yes.  And be sure to ask both of them beforehand so there aren't any
youknowwho-style surprises/outrages.

--D

> Thanks,
> Joanne
> 
