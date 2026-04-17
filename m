Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1423033CF;
	Fri, 17 Apr 2026 08:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776413094; cv=none; b=hVF9DP7rXiijxgXs1/iePRnQ21kMiP4L39t0KHFjU0CSXL6j0+mjZ+NIxt3z/45Hm1CTYLj3gGFwUzVUiN5hTm/GOBL0kBSKlqpcR0tYoYOslybwj/N3gNhcgjvOygakKZBgtdi0V37/BpZSXp/Dsqo6razQ/IctPB+IiCAa7Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776413094; c=relaxed/simple;
	bh=Z1/9pPNfUbG+2/KcKKt8WrOWINsx2g4XRefFSdIht+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUbnlvf4o+h+AcSwTs+pZV+L2SRqQFEIaM9WG//4mWb/mKxZ54i6WT7dXsEc5oCkuRAea9k6S4dviVdMbbBRr+6mwWd8b7YpFsqEGvHbj41MqY2Id4fvyNkqK9UI1DqLdDeGtUS+bKpe4uO/AHEGLC/9Jg9H8R92SFHoNKqI/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T87ww8kT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T87ww8kT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iq953/W1fH4+ePeN3WVL9mT3UeuaUrsvH971+8ptC2o=; b=T87ww8kTWwqx+U9QSTfTTqRRqZ
	RxojXMb7XwOyEEKKGOkXGtQNspCDywrnPZkZvxdVjytiJ2Ot6juHDPLznayKXy6OvXf9CAWS70srF
	nOqZbeb7N35lcHqP3v1ZJgyVerqGiYnYekgL9XP8WpxkSzA5RgtVtVIvCiw1k4UKq2NjnMCnazBz1
	oePh2DcpFxB0JnQ07QvWUHbBbf/ArmV99Ejom7HyOPRfD16PjWULAG81oyrtYedrW4EXxaQM8pfHt
	hn8wiHwZHbkhBpbdmUAP+ZW5LXy7q7DwcJ2lcNqMtvCcrZsXVgNvkrD7dfytayeaFdG5BXf4JJntW
	nwkx7/ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDeBi-00000003eCj-42fO;
	Fri, 17 Apr 2026 08:04:30 +0000
Date: Fri, 17 Apr 2026 01:04:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Joanne Koong <joannelkoong@gmail.com>, John Groves <John@groves.net>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeHpjpNN4TliZOyp@infradead.org>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is the first mail without annoying and pointless full quotes,
so chiming in here.  Sorry if I missed something important in all the
noise.

On Tue, Apr 14, 2026 at 03:19:36PM +0200, Miklos Szeredi wrote:
> On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> 
> > Overall, my intention with bringing this up is just to make sure we're
> > at least aware of this alternative before anything is merged and
> > permanent. If Miklos and you think we should land this series, then
> > I'm on board with that.
> 
> TBH, I'd prefer not to add the famfs specific mapping interface if not
> absolutely necessary.

Yes,  fuse needing support for a specific file systems sounds like a
design mistake.

>This was the main sticking point originally,
> but there seemed to be no better alternative.
> 
> However with the bpf approach this would be gone, which is great.

So what is this bpf magic actually trying to solve?

