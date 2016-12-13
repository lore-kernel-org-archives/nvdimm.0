From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
Date: Tue, 13 Dec 2016 15:42:31 -0500
Message-ID: <20161213204231.k2kdsdxqgtqjqzo4@thunk.org>
References: <20161212164708.23244-1-jack@suse.cz>
 <20161213115209.GG15362@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161213115209.GG15362@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-mm@kvack.org, linux-ext4@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Dec 13, 2016 at 12:52:09PM +0100, Jan Kara wrote:
> OK, with the final ack from Johannes and since this is mostly DAX stuff,
> can we take this through NVDIMM tree and push to Linus either late in the
> merge window or for -rc2? These patches require my DAX patches sitting in mm
> tree so they can be included in any git tree only once those patches land
> in Linus' tree (which may happen only once Dave and Ted push out their
> stuff - this is the most convoluted merge window I'd ever to deal with ;-)...
> Dan?

I've sent out the pull request for ext4.... which includes the
dax-4.0-iomap-pmd and fscrypt branch.  Yes, convoluted.  :-)

		      	      	       	    - Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
