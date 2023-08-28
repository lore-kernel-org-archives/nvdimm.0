Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4C746AB
	for <nvdimm@lists.linux.dev>; Mon, 28 Aug 2023 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fitMFjTe7UlzOJPHkx2hghZeQ5bjBzNc1l5zMQdyLCI=; b=gUZNSERn182ydlMmD/JGiKZEsk
	OgLplGeOv9vuS9OA35h0aZ/IJvVVfJYA16NlznwAcJA1w9FpMTvQS7V139nKFCrrrZQVPptZW1Qnh
	NlrtaWY/AJACSI4Kt7OkQtm136BUQbytcXlI1DESQcEcKTQOF5yaAh/drfTjfw19mNNEA5xwfSgHe
	0BK4iM+Zmjh56/cqY3a2K7nBtryKUbD911r9z6wCXSRIUyA/UBBwxH86i7PeNcYMilqluP9xV6Zfc
	W/F3EDXvuA+TnyWLXwrAAsHLhDWLLd7vBqiildb/I0VtP2zlFjxC3ArtVa0CxBf7pI91HwBNsB6yE
	2vzIhf5A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qadRy-001a4j-36;
	Mon, 28 Aug 2023 14:42:43 +0000
Date: Mon, 28 Aug 2023 15:42:42 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xueshi Hu <xueshi.hu@smartx.com>
Cc: hch@infradead.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, jayalk@intworks.biz, daniel@ffwll.ch,
	deller@gmx.de, bcrl@kvack.org, brauner@kernel.org, jack@suse.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, miklos@szeredi.hu,
	mike.kravetz@oracle.com, muchun.song@linux.dev, djwong@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org, hughd@google.com,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] fs: clean up usage of noop_dirty_folio
Message-ID: <20230828144242.GZ3390869@ZenIV>
References: <20230828075449.262510-1-xueshi.hu@smartx.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828075449.262510-1-xueshi.hu@smartx.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Aug 28, 2023 at 03:54:49PM +0800, Xueshi Hu wrote:
> In folio_mark_dirty(), it can automatically fallback to
> noop_dirty_folio() if a_ops->dirty_folio is not registered.
> 
> As anon_aops, dev_dax_aops and fb_deferred_io_aops becames empty, remove
> them too.

I'd put the last sentence as 'In dev_dax_aops and fb_deferred_io_aops replacing
.dirty_folio with NULL makes them identical to default (empty_aops) and since
we never compare ->a_ops pointer with either of those, we can remove them
completely'.

There could've been places like
#define is_fb_deferred(mapping) (mapping)->a_ops == fb_deferred_io_aops
and those would've been broken by that.  The fact that there's nothing
of that sort in the tree ought to be mentioned in commit message.

Note that we *do* have places where method table comparisons are used
in predicates like that, so it's not a pure theory; sure, missing that
would've probably ended up with broken build, but that can easily be
dependent upon the config (and that, alas, is also not a pure theory -
BTDT).  In this case the change is correct, fortunately...

Other than that part of commit message -

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
