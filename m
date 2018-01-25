Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FB7D21E256A0
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jan 2018 22:56:49 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id a24so5872453otd.4
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jan 2018 23:02:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516852902.3724.4.camel@wdc.com>
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
 <1516852902.3724.4.camel@wdc.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Jan 2018 23:02:16 -0800
Message-ID: <CAPcyv4iERedTChineSd-9fYR-xOc6E4L-okj7OnCMmoUkMf0tA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jgg@mellanox.com" <jgg@mellanox.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 24, 2018 at 8:01 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Wed, 2018-01-24 at 19:56 -0800, Dan Williams wrote:
>> The get_user_pages_longterm() api was recently added as a stop-gap
>> measure to prevent applications from growing dependencies on the
>> ability to to pin DAX-mapped filesystem blocks for RDMA indefinitely
>> with no ongoing coordination with the filesystem. This 'longterm'
>> pinning is also problematic for the non-DAX VMA case where the core-mm
>> needs a time bounded way to revoke a pin and manipulate the physical
>> pages. While existing RDMA applications have already grown the
>> assumption that they can pin page-cache pages indefinitely, the fact
>> that we are breaking this assumption for filesystem-dax presents an
>> opportunity to deprecate the 'indefinite pin' mechanisms and move to a
>> general interface that supports pin revocation.
>>
>> While RDMA may grow an explicit Infiniband-verb for this 'memory
>> registration with lease' semantic, it seems that this problem is
>> bigger than just RDMA. At LSF/MM it would be useful to have a
>> discussion between fs, mm, dax, and RDMA folks about addressing this
>> problem at the core level.
>>
>> Particular people that would be useful to have in attendance are
>> Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).
>
> Is on demand paging sufficient as a solution for your use case...

No, in 3 dimensions since there is a need to support non-ODP RDMA
hardware, hypervisors want to coordinate DMA for guests, and non-RDMA
hardware also pins memory indefinitely like V4L2. So it's bigger than
RDMA, but that will likely be the first consumer of this 'longterm
pin' mechanism.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
