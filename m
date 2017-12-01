Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DE2B221660E0
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 02:07:54 -0800 (PST)
Date: Fri, 1 Dec 2017 11:12:18 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 1/4] mm: introduce get_user_pages_longterm
Message-ID: <20171201101218.mxjyv4fc4cjwhf2o@dhcp22.suse.cz>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151197873499.26211.11687422577653326365.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171130095323.ovrq2nenb6ztiapy@dhcp22.suse.cz>
 <CAPcyv4giMvMfP=yZr=EDRAdTWyCwWydb4JVhT6YSWP8W0PHgGQ@mail.gmail.com>
 <20171130174201.stbpuye4gu5rxwkm@dhcp22.suse.cz>
 <CAPcyv4h5GUueqB-QhbWbn39SBPDE-rOte6UcmAHSWQdVyrF2Rw@mail.gmail.com>
 <20171130181741.2y5nyflyhqxg6y5p@dhcp22.suse.cz>
 <CAPcyv4hwsGQCUcTdpT7UVJyPN0RJz+CAqGNvTSK9Ka1nsypQjA@mail.gmail.com>
 <20171130190117.GF7754@ziepe.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171130190117.GF7754@ziepe.ca>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 30-11-17 12:01:17, Jason Gunthorpe wrote:
> On Thu, Nov 30, 2017 at 10:32:42AM -0800, Dan Williams wrote:
> > > Who and how many LRU pages can pin that way and how do you prevent nasty
> > > users to DoS systems this way?
> > 
> > I assume this is something the RDMA community has had to contend with?
> > I'm not an RDMA person, I'm just here to fix dax.
> 
> The RDMA implementation respects the mlock rlimit

OK, so then I am kind of lost in why do we need a special g-u-p variant.
The documentation doesn't say and quite contrary it assumes that the
caller knows what he is doing. This cannot be the right approach.

In other words, what does V4L2 does in the same context? Does it account
the pinned memory or it allows user to pin arbitrary amount of memory.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
