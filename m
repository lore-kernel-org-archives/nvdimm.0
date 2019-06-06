Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 5 Jun 2019 23:18:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 03/10] mm/gup: Pass flags down to __gup_device_huge*
 calls
Message-ID: <20190606061819.GA20520@infradead.org>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606014544.8339-4-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606014544.8339-4-ira.weiny@intel.com>
Sender: owner-linux-mm@kvack.org
To: ira.weiny@intel.com
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 05, 2019 at 06:45:36PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> In order to support checking for a layout lease on a FS DAX inode these
> calls need to know if FOLL_LONGTERM was specified.
> 
> Prepare for this with this patch.

The GUP fast argument passing is a mess.  That is why I've come up
with this as part of the (not ready) get_user_pages_fast_bvec
implementation:

http://git.infradead.org/users/hch/misc.git/commitdiff/c3d019802dbde5a4cc4160e7ec8ccba479b19f97
