Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62FB7F
	for <nvdimm@lists.linux.dev>; Tue, 18 Oct 2022 05:26:11 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id BEE2D68C4E; Tue, 18 Oct 2022 07:26:06 +0200 (CEST)
Date: Tue, 18 Oct 2022 07:26:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
	david@fromorbit.com, nvdimm@lists.linux.dev,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 07/25] fsdax: Hold dax lock over mapping insertion
Message-ID: <20221018052606.GA18887@lst.de>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com> <166579185727.2236710.8711235794537270051.stgit@dwillia2-xfh.jf.intel.com> <Y02tnrZXxm+NzWVK@nvidia.com> <634db85363e2c_4da329489@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <634db85363e2c_4da329489@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 17, 2022 at 01:17:23PM -0700, Dan Williams wrote:
> Historically, no. The block-device is allowed to disappear while inodes
> are still live.

Btw, while I agree with what you wrote below this sentence is at least
a bit confusing.  Struct block_device/gendisk/request_queue will always
be valid as long as a file system is mounted and inodes are live due
to refcounting.  It's just as you correctly pointed out del_gendisk
might have aready been called and they are dead.
