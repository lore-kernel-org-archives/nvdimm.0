Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 13 Aug 2019 15:00:22 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 16/19] RDMA/uverbs: Add back pointer to system
 file object
Message-ID: <20190813180022.GF29508@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-17-ira.weiny@intel.com>
 <20190812130039.GD24457@ziepe.ca>
 <20190812172826.GA19746@iweiny-DESK2.sc.intel.com>
 <20190812175615.GI24457@ziepe.ca>
 <20190812211537.GE20634@iweiny-DESK2.sc.intel.com>
 <20190813114842.GB29508@ziepe.ca>
 <20190813174142.GB11882@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813174142.GB11882@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 13, 2019 at 10:41:42AM -0700, Ira Weiny wrote:

> And I was pretty sure uverbs_destroy_ufile_hw() would take care of (or ensure
> that some other thread is) destroying all the MR's we have associated with this
> FD.

fd's can't be revoked, so destroy_ufile_hw() can't touch them. It
deletes any underlying HW resources, but the FD persists.
 
> > This is why having a back pointer like this is so ugly, it creates a
> > reference counting cycle
> 
> Yep...  I worked through this...  and it was giving me fits...
> 
> Anyway, the struct file is the only object in the core which was reasonable to
> store this information in since that is what is passed around to other
> processes...

It could be passed down in the uattr_bundle, once you are in file operations
handle the file is guarenteed to exist, and we've now arranged things
so the uattr_bundle flows into the umem, as umems can only be
established under a system call.

Jason
