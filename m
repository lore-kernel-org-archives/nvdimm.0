Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 8 May 2015 10:20:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2 00/10] evacuate struct page from the block layer,
 introduce __pfn_t
Message-ID: <20150508092044.GH889@ZenIV.linux.org.uk>
References: <CAPcyv4i5957h0PW5JL0rv4iurL=c7ppEFj3cDrrrMc4MQmJQGQ@mail.gmail.com>
 <20150507173641.GA21781@gmail.com>
 <CAPcyv4hHwW4U8x1_VLGj2Q4a3HxWgK4F4n9qXg8009_n7sxkmg@mail.gmail.com>
 <554BA748.9030804@linux.intel.com>
 <20150507191107.GB22952@gmail.com>
 <20150507193635.GC5966@gmail.com>
 <20150507194832.GB23511@gmail.com>
 <20150507195313.GA23597@gmail.com>
 <20150507201815.GD5966@gmail.com>
 <20150508053759.GA25786@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150508053759.GA25786@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Jerome Glisse <j.glisse@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <clm@fb.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Rik van Riel <riel@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Tejun Heo <tj@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, paulmck@linux.vnet.ibm.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 08, 2015 at 07:37:59AM +0200, Ingo Molnar wrote:

>     same as iov_iter_get_pages(), except that pages array is allocated
>     (kmalloc if possible, vmalloc if that fails) and left for caller to
>     free.  Lustre and NFS ->direct_IO() switched to it.
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> So if code does iov_iter_get_pages_alloc() on a user address that has 
> a real struct page behind it - and some other code does a regular 
> get_user_pages() on it, we'll have two sets of struct page 
> descriptors, the 'real' one, and a fake allocated one, right?

Huh?  iov_iter_get_pages() is given an array of pointers to struct page,
which it fills with what it finds.  iov_iter_get_pages_alloc() *allocates*
such an array, fills that with what it finds and gives the allocated array
to caller.

We are not allocating any struct page instances in either of those.
