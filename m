Return-Path: <owner-linux-mm@kvack.org>
Date: Sun, 25 Aug 2019 16:40:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 00/19] RDMA/FS DAX truncate proposal V1,000,002 ;-)
Message-ID: <20190825194049.GB21239@ziepe.ca>
References: <20190819123841.GC5058@ziepe.ca>
 <20190820011210.GP7777@dread.disaster.area>
 <20190820115515.GA29246@ziepe.ca>
 <20190821180200.GA5965@iweiny-DESK2.sc.intel.com>
 <20190821181343.GH8653@ziepe.ca>
 <20190821185703.GB5965@iweiny-DESK2.sc.intel.com>
 <20190821194810.GI8653@ziepe.ca>
 <20190821204421.GE5965@iweiny-DESK2.sc.intel.com>
 <20190823032345.GG1119@dread.disaster.area>
 <20190824044911.GB1092@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824044911.GB1092@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 23, 2019 at 09:49:12PM -0700, Ira Weiny wrote:

> So far, I have not been able to get RDMA to have an issue like Jason suggested
> would happen (or used to happen).  So from that perspective it may be ok to
> hang the close.

No, it is not OK to hang the close. You will deadlock on process
destruction when the 'lease fd' hangs waiting for the 'uverbs fd'
which is later in the single threaded destruction sequence.

This is different from the uverbs deadlock I outlined

Jason
