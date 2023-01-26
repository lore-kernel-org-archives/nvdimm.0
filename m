Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAAE15A1;
	Thu, 26 Jan 2023 01:45:44 +0000 (UTC)
Message-ID: <56ce760f-188c-3a1d-0512-9122247ea100@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674697536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4KOttIHpVKCbLr1jUjmRYQ6CJOVPDQyGMQ4zA8kCVw=;
	b=prmflUUZo/lJoWZPYQY87qo96iE00QkhoR3A/ixwEGMb9JQ6SKYt9nzyVxcTjLGf/yfVjN
	TbMjehqyfU6FV4JtcWz1tTOthCDG5h9phv4zjocA9eGILYXgFBFlBlNn+Orqc28NlWVdNR
	YE/ym7jgTyojydoL5rMqJd/l0E9dLmA=
Date: Thu, 26 Jan 2023 09:45:21 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
To: Jason Gunthorpe <jgg@nvidia.com>, lsf-pc@lists.linuxfoundation.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, linux-rdma@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
 Joao Martins <joao.m.martins@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 nvdimm@lists.linux.dev
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <Y8v+qVZ8OmodOCQ9@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2023/1/21 23:03, Jason Gunthorpe 写道:
> I would like to have a session at LSF to talk about Matthew's
> physr discussion starter:
> 
>   https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> 
> I have become interested in this with some immediacy because of
> IOMMUFD and this other discussion with Christoph:
> 
>   https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/

I read through the above patches. I am interested in the dma-buf.

Zhu Yanjun

>      
> Which results in, more or less, we have no way to do P2P DMA
> operations without struct page - and from the RDMA side solving this
> well at the DMA API means advancing at least some part of the physr
> idea.
> 
> So - my objective is to enable to DMA API to "DMA map" something that
> is not a scatterlist, may or may not contain struct pages, but can
> still contain P2P DMA data. From there I would move RDMA MR's to use
> this new API, modify DMABUF to export it, complete the above VFIO
> series, and finally, use all of this to add back P2P support to VFIO
> when working with IOMMUFD by allowing IOMMUFD to obtain a safe
> reference to the VFIO memory using DMABUF. From there we'd want to see
> pin_user_pages optimized, and that also will need some discussion how
> best to structure it.
> 
> I also have several ideas on how something like physr can optimize the
> iommu driver ops when working with dma-iommu.c and IOMMUFD.
> 
> I've been working on an implementation and hope to have something
> draft to show on the lists in a few weeks. It is pretty clear there
> are several interesting decisions to make that I think will benefit
> from a live discussion.
> 
> Providing a kernel-wide alternative to scatterlist is something that
> has general interest across all the driver subsystems. I've started to
> view the general problem rather like xarray where the main focus is to
> create the appropriate abstraction and then go about transforming
> users to take advatange of the cleaner abstraction. scatterlist
> suffers here because it has an incredibly leaky API, a huge number of
> (often sketchy driver) users, and has historically been very difficult
> to improve.
> 
> The session would quickly go over the current state of whatever the
> mailing list discussion evolves into and an open discussion around the
> different ideas.
> 
> Thanks,
> Jason
> 

