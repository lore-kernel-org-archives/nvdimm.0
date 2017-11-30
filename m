Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90FB821A04E2F
 for <linux-nvdimm@lists.01.org>; Thu, 30 Nov 2017 09:59:02 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id 184so5419309oii.2
 for <linux-nvdimm@lists.01.org>; Thu, 30 Nov 2017 10:03:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171130174201.stbpuye4gu5rxwkm@dhcp22.suse.cz>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151197873499.26211.11687422577653326365.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171130095323.ovrq2nenb6ztiapy@dhcp22.suse.cz>
 <CAPcyv4giMvMfP=yZr=EDRAdTWyCwWydb4JVhT6YSWP8W0PHgGQ@mail.gmail.com>
 <20171130174201.stbpuye4gu5rxwkm@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Nov 2017 10:03:26 -0800
Message-ID: <CAPcyv4h5GUueqB-QhbWbn39SBPDE-rOte6UcmAHSWQdVyrF2Rw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm: introduce get_user_pages_longterm
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
To: Michal Hocko <mhocko@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 30, 2017 at 9:42 AM, Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 30-11-17 08:39:51, Dan Williams wrote:
> > On Thu, Nov 30, 2017 at 1:53 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > > On Wed 29-11-17 10:05:35, Dan Williams wrote:
> > >> Until there is a solution to the dma-to-dax vs truncate problem it is
> > >> not safe to allow long standing memory registrations against
> > >> filesytem-dax vmas. Device-dax vmas do not have this problem and are
> > >> explicitly allowed.
> > >>
> > >> This is temporary until a "memory registration with layout-lease"
> > >> mechanism can be implemented for the affected sub-systems (RDMA and
> > >> V4L2).
> > >
> > > One thing is not clear to me. Who is allowed to pin pages for ever?
> > > Is it possible to pin LRU pages that way as well? If yes then there
> > > absolutely has to be a limit for that. Sorry I could have studied the
> > > code much more but from a quick glance it seems to me that this is not
> > > limited to dax (or non-LRU in general) pages.
> >
> > I would turn this question around. "who can not tolerate a page being
> > pinned forever?".
>
> Any struct page on the movable zone or anything that is living on the
> LRU list because such a memory is unreclaimable.
>
> > In the case of filesytem-dax a page is
> > one-in-the-same object as a filesystem-block, and a filesystem expects
> > that its operations will not be blocked indefinitely. LRU pages can
> > continue to be pinned indefinitely because operations can continue
> > around the pinned page, i.e. every agent, save for the dma agent,
> > drops their reference to the page and its tolerable that the final
> > put_page() never arrives.
>
> I do not understand. Are you saying that a user triggered IO can pin LRU
> pages indefinitely. This would be _really_ wrong. It would be basically
> an mlock without any limit. So I must be misreading you here

You're not misreading. See ib_umem_get() for example, it pins pages in
response to the userspace library call ibv_reg_mr() (memory
registration), and will not release those pages unless/until a call to
ibv_dereg_mr() is made. The current plan to fix this is to create
something like a ibv_reg_mr_lease() call that registers the memory
with an F_SETLEASE semantic so that the kernel can notify userspace
that a memory registration is being forcibly revoked by the kernel. A
previous attempt at something like this was the proposed MAP_DIRECT
mmap flag [1].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012815.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
