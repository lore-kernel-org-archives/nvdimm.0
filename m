Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 19 Aug 2019 09:38:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 00/19] RDMA/FS DAX truncate proposal V1,000,002 ;-)
Message-ID: <20190819123841.GC5058@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190814101714.GA26273@quack2.suse.cz>
 <20190814180848.GB31490@iweiny-DESK2.sc.intel.com>
 <20190815130558.GF14313@quack2.suse.cz>
 <20190816190528.GB371@iweiny-DESK2.sc.intel.com>
 <20190817022603.GW6129@dread.disaster.area>
 <20190819063412.GA20455@quack2.suse.cz>
 <20190819092409.GM7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819092409.GM7777@dread.disaster.area>
Sender: owner-linux-mm@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 19, 2019 at 07:24:09PM +1000, Dave Chinner wrote:

> So that leaves just the normal close() syscall exit case, where the
> application has full control of the order in which resources are
> released. We've already established that we can block in this
> context.  Blocking in an interruptible state will allow fatal signal
> delivery to wake us, and then we fall into the
> fatal_signal_pending() case if we get a SIGKILL while blocking.

The major problem with RDMA is that it doesn't always wait on close() for the
MR holding the page pins to be destoyed. This is done to avoid a
deadlock of the form:

   uverbs_destroy_ufile_hw()
      mutex_lock()
       [..]
        mmput()
         exit_mmap()
          remove_vma()
           fput();
            file_operations->release()
             ib_uverbs_close()
              uverbs_destroy_ufile_hw()
               mutex_lock()   <-- Deadlock

But, as I said to Ira earlier, I wonder if this is now impossible on
modern kernels and we can switch to making the whole thing
synchronous. That would resolve RDMA's main problem with this.

Jason
