Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3B70
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 15:19:01 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EC7E67357; Mon, 19 Jul 2021 17:18:59 +0200 (CEST)
Date: Mon, 19 Jul 2021 17:18:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	darrick.wong@oracle.com, dan.j.williams@intel.com,
	david@fromorbit.com, hch@lst.de, agk@redhat.com, snitzer@redhat.com,
	rgoldwyn@suse.de
Subject: Re: [PATCH v5 9/9] fs/dax: Remove useless functions
Message-ID: <20210719151857.GB22718@lst.de>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com> <20210628000218.387833-10-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628000218.387833-10-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 28, 2021 at 08:02:18AM +0800, Shiyang Ruan wrote:
> Since owner tracking is triggerred by pmem device, these functions are
> useless.  So remove them.

What about ext2 and ext4?
