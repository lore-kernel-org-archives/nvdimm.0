Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF246148850;
	Fri, 17 Apr 2026 08:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776413633; cv=none; b=L9wieWnDhAIziASz5uFaS4SsdpWs5htDTCNvRVjd84CoKuo3qMdCTEtSQZhPo5u8aQ4gTSFrCPde0oaRiIsnlRVrcmo5vckZzNimytSElYQb/tIcRHpcIVLv6RJvSsFaQsfS4KlXsxtB3rxHMDynPccf3fWfR8mLuSYap1DiNaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776413633; c=relaxed/simple;
	bh=AB7kM5+zl3g8v3ZilOIEtTC6f3PJQWJBnG4VUhc+iZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgOCuvSL5BwA67HCtHykKaxblnqVFCc1/r2toPDdEWghRdmamzOI7Ffl0kO29vlJvxrQfayNLcitMSfdsNB3ZaX48yVYvMTpTCRnbY1FIgYoemQiw6WYQAlBw5eK/XHygjehnmEJJWzHvJ94zeGmfM4h+8JJ9S+kWcMrMAKxNvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WiUBalMv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WiUBalMv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FzPtR8XBpYAtdtjQmCJHfr8Ak8KPMG6rRy1FtmV/4Ek=; b=WiUBalMv2ap5OVbiLawUg65FpJ
	pNR7afCUfM1Y5H54gD+mxP8FYdeUTwkkA0bT3lpL+c2tHtDjv+GO30fdIjntRTwTbAd8Ac7v6SlHG
	lqWz8sQrCTNB4Ep8rwbbWG4pbA7aV+GFKeiZJB77GSFPS8eReDRblh7k8h7G6m2tu+qF6HCe9R9IA
	GfbsHW+OdCKYCTzghN0ZunI2/qjjk5OhnzOg4tETYlXD81TCs8hZLXOGYe9ljt3UkAVvJU0CbNX6o
	x5sep4jdX3jQXeY7TS15OBgmnyfO4hgqG348n4PVarvlmqSUYt+ZuPwizux3jrEhwKNss9LcOpUbe
	vgKRI+UQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDeKW-00000003erK-0sn1;
	Fri, 17 Apr 2026 08:13:36 +0000
Date: Fri, 17 Apr 2026 01:13:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <djbw@kernel.org>, Gregory Price <gourry@gourry.net>,
	Joanne Koong <joannelkoong@gmail.com>,
	John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan J Williams <dan.j.williams@intel.com>,
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
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeHrsIGagdmZJ1Fw@infradead.org>
References: <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
 <20260416224331.GD114184@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416224331.GD114184@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 16, 2026 at 03:43:31PM -0700, Darrick J. Wong wrote:
> ...the memory interleaving is a rather interesting quality of famfs.
> There's no good way to express a formulaic meta-mapping in traditional
> iomap parlance, and famfs needs that to interleave across memory
> controllers/dimm boxen/whatever.  Throwing individual iomaps at the
> kernel is a very inefficient way to do that.  So I don't think there's a
> good reason to get rid of GET_FMAP at this time...

Why no?  We can triviall make an iomap point to multiple backing
devices and throw in a stride/offset.  That would make btrfs
striping (and non-degraded parity RAID reads) a lot more efficient.

> ...however the strongest case (IMO) would be if (having merged famfs) we
> then merge fuse-iomap after famfs.  Then we extend the existing
> fuse-iomap-bpf prototype to allow per-mount and per-inode iomap bpf ops.
> That enables us to analyze thoroughly the performance characteristics of:

Don't go there.  I think that you two are comining up with two
interfaces for roughly the same thing is a pretty clear indicator
that this needs to be fully hashed out as a single interface first,
and any kind of preliminary merging is just going to create problems.

