Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048767E0
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 06:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T3KOxbdAR49UlzR9YGgT8mGXxv3RRYiUh00gOTonZcY=; b=RuY4LJZATK5t4/TmA/aqu2Yt8d
	g3QDZlqufYFda7V6QXZWX76Ywfh+uxaxqh8tRN/UnE3KDxH+kKPiDpzhERG6B53VQJFjbabJaWVnB
	NsAA00Zide4lbhDlNuVKDmCpUPXYDUKhsuj8zHg3O+zZWWrXYBuhlZq8n+uCKM1DVe9Xz5YnFzLed
	BDALg9KSLJetINzCVfQ49eXKWs/+kEIwdPVH9aSg9z2oMpfR3V0fsH1V8CSOGgmYb29JItDo1LL/9
	DX8jcjqrne1VSfMKZHJqO0WiB19P6UpiMbLnZ1EIy5uu2yB5CqjwzVAkQtXH8exTeW3upoT65xsYZ
	modywJqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1o3Afp-00GQ2J-Tw; Mon, 20 Jun 2022 06:14:09 +0000
Date: Sun, 19 Jun 2022 23:14:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Gomatam, Sravani" <sravani.gomatam@intel.com>
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <YrAQMYypulcJWtM+@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
 <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
 <20220619234011.GK227878@dread.disaster.area>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220619234011.GK227878@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 20, 2022 at 09:40:11AM +1000, Dave Chinner wrote:
> That doesn't change the fact we are issuing cache flushes from the
> log checkpoint code - it just changes how we issue them. We removed
> the explicit blkdev_issue_flush_async() call from the cache path and
> went back to the old way of doing things (attaching it directly to
> the first IO of a journal checkpoint) when it became clear the async
> flush was causing performance regressions on storage with really
> slow cache flush semantics by causing too many extra cache flushes
> to be issued.

Yes.  Also actualy nvidmms (unlike virtio-pmem) never supported async
flush anyway and still did the cache flush operations synchronously
anyway.

> To me, this smells of a pmem block device cache flush issue, not a
> filesystem problem...

Yes.  Especially as normal nvdims are designed to not have a volatile
write cache in the storage device sense anyway - Linux just does some
extra magic for REQ_PREFLUSH commands that isn't nessecary and gives
all thus funky userspace solution or snake oil acadmic file systems
extra advantages by skipping that..
