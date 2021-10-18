Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F25F72
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 04:36:43 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1FC5867373; Mon, 18 Oct 2021 06:36:33 +0200 (CEST)
Date: Mon, 18 Oct 2021 06:36:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v10 7/8] xfs: support CoW in fsdax mode
Message-ID: <20211018043633.GA23493@lst.de>
References: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com> <20210928062311.4012070-8-ruansy.fnst@fujitsu.com> <20211014170622.GB24333@magnolia> <CAPcyv4gGxpHBBjB8e23WEQyVfo4R=vT=1syrJXx1tWymCDV51w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gGxpHBBjB8e23WEQyVfo4R=vT=1syrJXx1tWymCDV51w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 14, 2021 at 10:50:00AM -0700, Dan Williams wrote:
> The other blocker was enabling mounting dax filesystems on a
> dax-device rather than a block device. I'm actively refactoring the
> nvdimm subsystem side of that equation, but could use help with the
> conversion of the xfs mount path. Christoph, might you have that in
> your queue?

It's in my queue.  I'm about to send your a series of prep patches
and plan to tackle the actual mounting next merge window.
