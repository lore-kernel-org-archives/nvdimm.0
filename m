Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8B03C1979;
	Thu,  2 Jul 2026 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001232; cv=none; b=iEZBDlphSnIn7vM37mGPH9WjNZZ8GfLgPx0yLuX+NY72TF1879yesAav4SbUnkc+o1YsuPvylqz/ym/om2AqJHLOptG00kZWfaDEZNEUi6NMpOWBPi6YHY0WHpi565HzzDtdXiHWS4qda5QtESIB9jomS1c9J/ylAhiy6ClMnfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001232; c=relaxed/simple;
	bh=F/tM2eAzg331w2LaSdd/nlcr+scQCGc/VlLA8+T5PuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onj6mkRlzXgVLjbEpqMWetmmIrRPzx5uQtQbgTWNbV3ujb0VKcSyB46gY1u4CAFfeDIyljn+fYz+fXRPD7QjuuU1DqWYDV2NSE8UEbC17Q/cAQzQdemm9iTjlAC/TJg3SrEB9LwQtdGYfIE/bGe4nxxkJT2ZAjDZ8hScrZIHkLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 90D9968BEB; Thu,  2 Jul 2026 16:07:05 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:07:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org,
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
Message-ID: <20260702140705.GE21339@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-18-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-18-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

In terms of merge logistics, I wonder if we should delay this and
the previous patch to the next merge window so that we can minimize the
cross-subsystem merge pain with more file system iomap conversion.
If none of them actually happen until rc6 or so, orif  the merges aren't
painful we could still pick them up late in the merge window.

