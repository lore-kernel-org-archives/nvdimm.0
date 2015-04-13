Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 19:22:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413172225.GC14243@lst.de>
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com> <552BB4CA.6060808@plexistor.com> <20150413123535.GA2666@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150413123535.GA2666@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 13, 2015 at 02:35:35PM +0200, Ingo Molnar wrote:
> How does splice work with DAX files?

By falling back to default_file_splice_read/default_file_splice_write
which doesn't use the iter ops, but instead requires a copy in the
splice code.  But given that the actual underlying reads and writes
bypass the pagecache it's not any less effiecient than the normal
pagecache based splice.

> AFAICS vmsplice() won't work, as 
> it uses get_user_pages(), which needs struct page backing.

Exactly.

> Also, how 
> will f_op->sendpage() work? That too needs page backing.

default_file_splice_read allocates it's own kernel pages, which are
then passed to ->sendpage.
