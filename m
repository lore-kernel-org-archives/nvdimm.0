Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 30 Nov 2017 10:53:23 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 1/4] mm: introduce get_user_pages_longterm
Message-ID: <20171130095323.ovrq2nenb6ztiapy@dhcp22.suse.cz>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151197873499.26211.11687422577653326365.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151197873499.26211.11687422577653326365.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, hch@lst.de, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 29-11-17 10:05:35, Dan Williams wrote:
> Until there is a solution to the dma-to-dax vs truncate problem it is
> not safe to allow long standing memory registrations against
> filesytem-dax vmas. Device-dax vmas do not have this problem and are
> explicitly allowed.
> 
> This is temporary until a "memory registration with layout-lease"
> mechanism can be implemented for the affected sub-systems (RDMA and
> V4L2).

One thing is not clear to me. Who is allowed to pin pages for ever?
Is it possible to pin LRU pages that way as well? If yes then there
absolutely has to be a limit for that. Sorry I could have studied the
code much more but from a quick glance it seems to me that this is not
limited to dax (or non-LRU in general) pages.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
