Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x243.google.com (mail-io0-x243.google.com
 [IPv6:2607:f8b0:4001:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7A8E21F3C181
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 08:57:57 -0700 (PDT)
Received: by mail-io0-x243.google.com with SMTP id h70so1446331ioi.4
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 09:01:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011115410.GF30803@8bytes.org>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150764701194.16882.9682569707416653741.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171011115410.GF30803@8bytes.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 09:01:25 -0700
Message-ID: <CAA9_cmdN4N8nDdyhgn61A2_vwuTP3LJTgDCEHMQLoaFZg=DtHw@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] IB/core: use MAP_DIRECT to fix / enable RDMA to
 DAX mappings
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
To: Joerg Roedel <joro@8bytes.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Doug Ledford <dledford@redhat.com>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, iommu@lists.linux-foundation.org, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-xfs@vger.kernel.org, linux-mm <linux-mm@kvack.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 4:54 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Tue, Oct 10, 2017 at 07:50:12AM -0700, Dan Williams wrote:
>> +static void ib_umem_lease_break(void *__umem)
>> +{
>> +     struct ib_umem *umem = umem;
>> +     struct ib_device *idev = umem->context->device;
>> +     struct device *dev = idev->dma_device;
>> +     struct scatterlist *sgl = umem->sg_head.sgl;
>> +
>> +     iommu_unmap(umem->iommu, sg_dma_address(sgl) & PAGE_MASK,
>> +                     iommu_sg_num_pages(dev, sgl, umem->npages));
>> +}
>
> This looks like an invitation to break your code by random iommu-driver
> changes. There is no guarantee that an iommu-backed dma-api
> implemenation will map exactly iommu_sg_num_pages() pages for a given
> sg-list. In other words, you are mixing the use of the IOMMU-API and the
> DMA-API in an incompatible way that only works because you know the
> internals of the iommu-drivers.
>
> I've seen in another patch that your changes strictly require an IOMMU,
> so you what you should do instead is to switch from the DMA-API to the
> IOMMU-API and do the address-space management yourself.
>

Ok, I'll switch over completely to the iommu api for this. It will
also address Robin's concern.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
