Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 6 Jun 2019 16:46:52 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190606194652.GI17373@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <c559c2ce-50dc-d143-5741-fe3d21d0305c@nvidia.com>
 <20190606171158.GB11374@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606171158.GB11374@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 06, 2019 at 10:11:58AM -0700, Ira Weiny wrote:

> 2) This is a bit more subtle and something I almost delayed sending these out
>    for.  Currently the implementation of a lease break actually removes the
>    lease from the file.  I did not want this to happen and I was thinking of
>    delaying this patch set to implement something which keeps the lease around
>    but I figured I should get something out for comments.  Jan has proposed
>    something along these lines and I agree with him so I'm going to ask you to
>    read my response to him about the details.
>
> 
>    Anyway so the key here is that currently an app needs the SIGIO to retake
>    the lease if they want to map the file again or in parts based on usage.
>    For example, they may only want to map some of the file for when they are
>    using it and then map another part later.  Without the SIGIO they would lose
>    their lease or would have to just take the lease for each GUP pin (which
>    adds overhead).  Like I said I did not like this but I left it to get
>    something which works out.

So to be clear.. 

Even though the lease is broken the GUP remains, the pages remain
pined, and truncate/etc continues to fail? 

I like Jan's take on this actually.. see other email.

Jason
