Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF9D2F26
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:35:10 +0000 (UTC)
Received: by mail-qv1-f41.google.com with SMTP id d8so12260357qvv.2
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rboH21WjTo7Zpin6WU8ENnQ0jpp7u5mio4o8y61h1qA=;
        b=VXh06X+F+pn59Qpun2TvClz1m9HjYoHgaKOI4lztMUBuiGjL99BTi+BawyYvV0b0yn
         9cSLWqxROo0MXIKlUdGoc9EE7z86T+5wHR+ArNTi5/pxBOI4IWPMYAGwHGhxndX7GpTZ
         fSLPo9Dt2nuunse7tKeQTFKIcNt0CE4F9KzzI4ti/AgzATLEA1o9kXR4ml55Lqmm3Yhc
         wbAAtoduBxENkPGmrIt8sbv6drZp6l+PHJ57vTSVfC3pA1NN7u0WuhjPEL0YmplkLBQR
         SW4HkKGx0mKB2zSYzcqNdqN99/smutm6o5outMhJEioQPVTN6gdzMAHSMaOhfZa5HAKv
         HEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rboH21WjTo7Zpin6WU8ENnQ0jpp7u5mio4o8y61h1qA=;
        b=hO60nvJzef3hDUeEEQtHxFJcF9xavW4Dyy0Shz1ISPtTNBzE3F8N5hA3QrEgIJjdr/
         Sgep4UbqI8lnMI3YbFjTXesLxd4fNztgSBWUU+tCEkGRZd92aMktZBKPr40VNt9JOn4n
         /+4bW/qcrRc+J01/Ky34urjD75xN+20BbVOZKs56A2DzEEGDFgKRz2q+7z+cJQM/vd8Z
         GYIuWx5TKFwLZWLbWPFvkN59qNKu4NKhGZtS6STT4VspYLKWWeHN1OaQ3TNhP3dYzH8Z
         fRNTB+HSbkN05ocpPCN4Yf0wCcoYT3gEGNeVH+DSjHh0EgxJFEMmm59maMTOhhHp9IWs
         qQbQ==
X-Gm-Message-State: AOAM531F103ToPF8dZm4p4IerAv5TfFnZPk8bkZMoZhVI7k3vcTuTm9U
	RwaNYmDTdtZrDdCij2ii2JmA4w==
X-Google-Smtp-Source: ABdhPJwMTfVdQUHipluh+Ohvh/JxuUZnOnGCSsmXZVjjmoMxCtKJINJPPq28Adoz05obvbxhEw7l+Q==
X-Received: by 2002:ad4:5942:: with SMTP id eo2mr803626qvb.7.1644262509546;
        Mon, 07 Feb 2022 11:35:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bj24sm5684465qkb.115.2022.02.07.11.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:35:09 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH9n2-000I62-Fa; Mon, 07 Feb 2022 15:35:08 -0400
Date: Mon, 7 Feb 2022 15:35:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/8] mm: don't include <linux/memremap.h> in <linux/mm.h>
Message-ID: <20220207193508.GG49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-7-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:47AM +0100, Christoph Hellwig wrote:
> Move the check for the actual pgmap types that need the free at refcount
> one behavior into the out of line helper, and thus avoid the need to
> pull memremap.h into mm.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/arm64/mm/mmu.c                    |  1 +
>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h  |  1 +
>  drivers/gpu/drm/drm_cache.c            |  2 +-
>  drivers/gpu/drm/nouveau/nouveau_dmem.c |  1 +
>  drivers/gpu/drm/nouveau/nouveau_svm.c  |  1 +
>  drivers/infiniband/core/rw.c           |  1 +
>  drivers/nvdimm/pmem.h                  |  1 +
>  drivers/nvme/host/pci.c                |  1 +
>  drivers/nvme/target/io-cmd-bdev.c      |  1 +
>  fs/fuse/virtio_fs.c                    |  1 +
>  include/linux/memremap.h               | 18 ++++++++++++++++++
>  include/linux/mm.h                     | 20 --------------------
>  lib/test_hmm.c                         |  1 +
>  mm/memremap.c                          |  6 +++++-
>  14 files changed, 34 insertions(+), 22 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
