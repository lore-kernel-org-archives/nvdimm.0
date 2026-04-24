Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868283AC00;
	Fri, 24 Apr 2026 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037604; cv=none; b=Pe2KGhkZtjXboPExxXYDeyT60wm+Dz+um6GXz3inGecNx59jX8SWgUP23vhbTb1fDbIFmxjNGvi5RWN+/C/t2Q4SrTqu6xJXpKCzYgJZqRgORfadDmnURWX2mUU4EUpNrA15wLiFFRl0NQN+wjkcNlHUQwg03JFrw4iPXD8eIxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037604; c=relaxed/simple;
	bh=cAWFcttdHUtF05cSDhr0+rAgw0R83Ifv4hIjIAXjW3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4HNQeAEuC3pEcRTE9zMABh2OEQ2hAWMczAKTOa8ny0XKSf4O3lysHWoiyjYwfsdKFNCx65jdf9tqTz/eUIPxXL89Il7aCYpCHp5Oei5os+X+SwJyPg6ID67Cw5WON9BcygUjVBKbISrvvzwUd1S/rzrHbpgTFYFfnJZo3+Awf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cwaGamCu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cwaGamCu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ppCzrpMzgabfrm3Cdr1WSRYHoDC3MiyCqfSbp40kjmg=; b=cwaGamCu5vQZdwnzp9Uf/7/n6y
	eMpgULtxbBz7rVWsTTeezIRDqTH0I/OvJ5mV4ddpa+ZKhLs+2+vj/i1d88j404pj9A1MzIrfZq6BQ
	X8f/VK+lx9/9zpEegUwraXLRsBfNHIzaoKzQsMInS/udrbHJyLWuGE1FggG506Ld3rYi6yNBelNLA
	3JeoQWavYDko/3mtj8ogzX7QRszueCZyzK1PDVYkot3iR8Kbz5bVopP+62aRFcxGC/n9deIEM/ycH
	qL89auZFEr4h3I2jMf+TRz/OGw7Fm0aO2nngnT/PSuLRVM5P9uAHz2fGyTkuXp8vinBKuntm7Bewy
	6AoRWvtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGGeV-0000000DFUs-0Aje;
	Fri, 24 Apr 2026 13:33:03 +0000
Date: Fri, 24 Apr 2026 06:33:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Gregory Price <gourry@gourry.net>,
	Joanne Koong <joannelkoong@gmail.com>,
	John Groves <John@groves.net>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
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
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
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
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aetxDlr0e9ILFIcg@infradead.org>
References: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <CAJnrk1ad6t6CJV+xnXwhoNHrHYA3htuaVdDq47FeT60cPBzj7g@mail.gmail.com>
 <aeHXQ2EW2ivlLb_N@gourry-fedora-PF4VCD3F>
 <CAOQ4uxhXTTyySG3tXnqNnP0edbbwUxfeeC7=CypDSyw_Mod48A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhXTTyySG3tXnqNnP0edbbwUxfeeC7=CypDSyw_Mod48A@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 17, 2026 at 11:06:58AM +0200, Amir Goldstein wrote:
> If this logic was to be placed in fs/iomap/ as Christoph suggested,
> I think the rest of the UAPI issues could be sorted out.

For that you don't need it in iomap, it could stay in fuse an be a
generic striping API.  Although IMHO doing it in iomap would be a
lot cleaner and more efficient as well.

> In any case, considering the sheer amount of discussion on this thread
> I have scheduled a cross-track FS+MM+IO for Famfs and DAX iomap.
> 
> I wasn't going to include Storage people at first, but since Christoph
> mentioned that stride/offset iomap could be useful for block iomap,
> I included them as well.

There is no overlap with storage.  Any use of this would have to be
file system level striping, not stackable block driver level striping.
And keeping the rooms smaller is a win on it's own - anyone interested
can join anyway.

