Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B53722035BB2E
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 15:22:11 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id l138so9747241oib.7
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 15:26:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171121150501.d4d811a66444cb5c9cb85bf2@linux-foundation.org>
References: <151068938905.7446.12333914805308312313.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151068939435.7446.13560129395419350737.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171121150501.d4d811a66444cb5c9cb85bf2@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 15:26:26 -0800
Message-ID: <CAPcyv4jRqkwdVZrRnMcvAq1OJ0+DpHFQ6yhXhgN-ts1HMF1Nfw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: introduce get_user_pages_longterm
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 21, 2017 at 3:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 14 Nov 2017 11:56:34 -0800 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Until there is a solution to the dma-to-dax vs truncate problem it is
> > not safe to allow long standing memory registrations against
> > filesytem-dax vmas. Device-dax vmas do not have this problem and are
> > explicitly allowed.
> >
> > This is temporary until a "memory registration with layout-lease"
> > mechanism can be implemented for the affected sub-systems (RDMA and
> > V4L2).
>
> Sounds like that will be unpleasant.  Do we really need it to be that
> complex?  Can we get away with simply failing the get_user_pages()
> request?  Or are there significant usecases for RDMA and V4L to play
> with DAX memory?

V4L plus DAX is indeed dubious, but RDMA to persistent memory is
something the RDMA community is interested in supporting [1].

[1]: http://www.snia.org/sites/default/files/SDC15_presentations/persistant_mem/ChetDouglas_RDMA_with_PM.pdf
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
