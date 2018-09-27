Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 27 Sep 2018 14:25:37 +0200
From: Oscar Salvador <osalvador@techadventures.net>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
Message-ID: <20180927122537.GA20378@techadventures.net>
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20180926075540.GD6278@dhcp22.suse.cz>
 <6f87a5d7-05e2-00f4-8568-bb3521869cea@linux.intel.com>
 <20180927110926.GE6278@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927110926.GE6278@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, pavel.tatashin@microsoft.com, dave.jiang@intel.com, dave.hansen@intel.com, jglisse@redhat.com, rppt@linux.vnet.ibm.com, dan.j.williams@intel.com, logang@deltatee.com, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 27, 2018 at 01:09:26PM +0200, Michal Hocko wrote:
> > So there were a few things I wasn't sure we could pull outside of the
> > hotplug lock. One specific example is the bits related to resizing the pgdat
> > and zone. I wanted to avoid pulling those bits outside of the hotplug lock.
> 
> Why would that be a problem. There are dedicated locks for resizing.

True is that move_pfn_range_to_zone() manages the locks for pgdat/zone resizing,
but it also takes care of calling init_currently_empty_zone() in case the zone is empty.
Could not that be a problem if we take move_pfn_range_to_zone() out of the lock?

-- 
Oscar Salvador
SUSE L3
