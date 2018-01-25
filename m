Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4930021E256BB
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jan 2018 19:50:35 -0800 (PST)
Received: by mail-oi0-x234.google.com with SMTP id 8so32959oix.13
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jan 2018 19:56:04 -0800 (PST)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Jan 2018 19:56:02 -0800
Message-ID: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
Subject: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
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
To: lsf-pc@lists.linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-rdma <linux-rdma@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, jgg@mellanox.com
List-ID: <linux-nvdimm@lists.01.org>

The get_user_pages_longterm() api was recently added as a stop-gap
measure to prevent applications from growing dependencies on the
ability to to pin DAX-mapped filesystem blocks for RDMA indefinitely
with no ongoing coordination with the filesystem. This 'longterm'
pinning is also problematic for the non-DAX VMA case where the core-mm
needs a time bounded way to revoke a pin and manipulate the physical
pages. While existing RDMA applications have already grown the
assumption that they can pin page-cache pages indefinitely, the fact
that we are breaking this assumption for filesystem-dax presents an
opportunity to deprecate the 'indefinite pin' mechanisms and move to a
general interface that supports pin revocation.

While RDMA may grow an explicit Infiniband-verb for this 'memory
registration with lease' semantic, it seems that this problem is
bigger than just RDMA. At LSF/MM it would be useful to have a
discussion between fs, mm, dax, and RDMA folks about addressing this
problem at the core level.

Particular people that would be useful to have in attendance are
Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
