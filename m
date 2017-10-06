Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 022A021FC746D
 for <linux-nvdimm@lists.01.org>; Fri,  6 Oct 2017 15:49:11 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id q4so14309196oic.7
 for <linux-nvdimm@lists.01.org>; Fri, 06 Oct 2017 15:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507329939.29211.434.camel@infradead.org>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1507329939.29211.434.camel@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Oct 2017 15:52:34 -0700
Message-ID: <CAPcyv4jLj2WOgPA+B5eYME0uZyuoy3gp35w+4rCa_EZxm-QSKA@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
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
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 6, 2017 at 3:45 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2017-10-06 at 15:35 -0700, Dan Williams wrote:
>> Add a helper to determine if the dma mappings set up for a given device
>> are backed by an iommu. In particular, this lets code paths know that a
>> dma_unmap operation will revoke access to memory if the device can not
>> otherwise be quiesced. The need for this knowledge is driven by a need
>> to make RDMA transfers to DAX mappings safe. If the DAX file's block map
>> changes we need to be to reliably stop accesses to blocks that have been
>> freed or re-assigned to a new file.
>
> "a dma_unmap operation revoke access to memory"... but it's OK that the
> next *map* will give the same DMA address to someone else, right?

I'm assuming the next map will be to other physical addresses and a
different requester device since the memory is still registered
exclusively.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
