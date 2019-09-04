From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [RFC PATCH v2 02/19] fs/locks: Add Exclusive flag to user Layout
 lease
Date: Wed, 4 Sep 2019 16:12:35 -0700
Message-ID: <69a7c037-6b4b-dbe3-2b42-77f85043b9eb@nvidia.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-3-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190809225833.6657-3-ira.weiny@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: ira.weiny@intel.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-nvdimm@lists.01.org

On 8/9/19 3:58 PM, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Add an exclusive lease flag which indicates that the layout mechanism
> can not be broken.

After studying the rest of these discussions extensively, I think in all
cases FL_EXCLUSIVE is better named "unbreakable", rather than exclusive.

If you read your sentence above, it basically reinforces that idea: "add an
exclusive flag to mean it is unbreakable" is a bit of a disconnect. It 
would be better to say,

Add an "unbreakable" lease flag which indicates that the layout lease
cannot be broken.

Furthermore, while this may or may not be a way forward on the "we cannot
have more than one process take a layout lease on a file/range", it at
least stops making it impossible. In other words, no one is going to
write a patch that allows sharing an exclusive layout lease--but someone
might well update some of these patches here to make it possible to
have multiple processes take unbreakable leases on the same file/range.

I haven't worked through everything there yet, but again:

* FL_UNBREAKABLE is the name you're looking for here, and

* I think we want to allow multiple processes to take FL_UNBREAKABLE
leases on the same file/range, so that we can make RDMA setups
reasonable. By "reasonable" I mean, "no need to have a lead process
that owns all the leases".



thanks,
-- 
John Hubbard
NVIDIA
