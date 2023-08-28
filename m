Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCDF6125
	for <nvdimm@lists.linux.dev>; Mon, 28 Aug 2023 12:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ve4BHXYYDtHmo8gKLNw/Y51LgqpTIonHiBSys2mOFvE=; b=YPhPLM4VvUMqhydvfSNnt3IVIo
	NF6Vq7yPJcJOISvvC4reeQp3n1ILZOteFy3C8qgXMu4BN5F+3Ea5qT5OQQzKjL5vvxaF+OeuArG4/
	9gcwlmXRv0MRBTaMxcRLKff80PQlGThqLFVyU3UU8e1RtbDQ0Rh7Iy1P7qQiz28L2FawNSPOuin+n
	WmjOTHU6a13xRi2ppuVNSsD4Yv/Px1AQcCDqjtRQlyxj38R2gS711V7U+aQIqdfVf7OjwRA4MrYiY
	QQG/IITuIyF6/xLNZ0cI7vhTTlAe7bcUD/i/7EFI5RN69Qp51h1s9P2mRnYh44ewIkXIDkMgD1kBV
	bYvHDEww==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qabBw-000BZW-FS; Mon, 28 Aug 2023 12:18:00 +0000
Date: Mon, 28 Aug 2023 13:18:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Xueshi Hu <xueshi.hu@smartx.com>
Cc: hch@infradead.org, dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, jayalk@intworks.biz, daniel@ffwll.ch,
	deller@gmx.de, bcrl@kvack.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, miklos@szeredi.hu,
	mike.kravetz@oracle.com, muchun.song@linux.dev, djwong@kernel.org,
	akpm@linux-foundation.org, hughd@google.com, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] fs: clean up usage of noop_dirty_folio
Message-ID: <ZOyQePmvT6LaJst+@casper.infradead.org>
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

On Mon, Aug 28, 2023 at 03:54:49PM +0800, Xueshi Hu wrote:
> In folio_mark_dirty(), it can automatically fallback to
> noop_dirty_folio() if a_ops->dirty_folio is not registered.
> 
> As anon_aops, dev_dax_aops and fb_deferred_io_aops becames empty, remove
> them too.
> 
> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
