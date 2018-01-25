Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B25F21E25682
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jan 2018 19:56:17 -0800 (PST)
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
Date: Thu, 25 Jan 2018 04:01:43 +0000
Message-ID: <1516852902.3724.4.camel@wdc.com>
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
In-Reply-To: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
Content-Language: en-US
Content-ID: <421B4EAE84F4C14BB9A74F1146530B6F@namprd04.prod.outlook.com>
MIME-Version: 1.0
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jgg@mellanox.com" <jgg@mellanox.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-01-24 at 19:56 -0800, Dan Williams wrote:
> The get_user_pages_longterm() api was recently added as a stop-gap
> measure to prevent applications from growing dependencies on the
> ability to to pin DAX-mapped filesystem blocks for RDMA indefinitely
> with no ongoing coordination with the filesystem. This 'longterm'
> pinning is also problematic for the non-DAX VMA case where the core-mm
> needs a time bounded way to revoke a pin and manipulate the physical
> pages. While existing RDMA applications have already grown the
> assumption that they can pin page-cache pages indefinitely, the fact
> that we are breaking this assumption for filesystem-dax presents an
> opportunity to deprecate the 'indefinite pin' mechanisms and move to a
> general interface that supports pin revocation.
> 
> While RDMA may grow an explicit Infiniband-verb for this 'memory
> registration with lease' semantic, it seems that this problem is
> bigger than just RDMA. At LSF/MM it would be useful to have a
> discussion between fs, mm, dax, and RDMA folks about addressing this
> problem at the core level.
> 
> Particular people that would be useful to have in attendance are
> Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).

Is on demand paging sufficient as a solution for your use case or do
you perhaps need something different? See also
https://www.openfabrics.org/images/eventpresos/workshops2013/2013_Workshop_Tues_0930_liss_odp.pdf

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
