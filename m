Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D012F2C
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 23:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
	Message-ID:From:References:Cc:To:content-disposition;
	bh=m4ev1WCRNCl+02YqH74txp8M2CR/EORhvQhxQiDZxaA=; b=eqokiLHaXaeyt/5s6v5Dxq44/e
	IAqW59SoSHKudPP22PbYzdepcvKhqjbzyfkSuYw4KpL9xtVArn6pQK2Ldyz7E4YcAH9NSYynVTo0x
	bdiKjmtt+SN4YZG0Ew92tD4rJQNUm7KEjM7PROljaQAtDtxBiTL5EVi6VghTHYbECpve5DE5uUb1N
	duzW6PtphJmZZ+0mX3PJgZhC5/rVEq/3qykeOe3ABa53oImY5pgTVdlOQOq4oG9J4bsLodSeeYQi1
	1+6C1yRgCfpdXKc5xhSACk3BweTjswDgZ4yDXBO7FMi9Z1A4zGwJMemyijSE1P8AHIhJmmSKYeRTc
	ECAC1LFQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <logang@deltatee.com>)
	id 1nHDnM-00EdA1-EY; Mon, 07 Feb 2022 16:51:45 -0700
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
 "Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
 Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Alistair Popple <apopple@nvidia.com>,
 Ralph Campbell <rcampbell@nvidia.com>, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev, linux-mm@kvack.org
References: <20220207063249.1833066-1-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <29a9f365-064a-f5db-0690-57bae007ce62@deltatee.com>
Date: Mon, 7 Feb 2022 16:51:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220207063249.1833066-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: linux-mm@kvack.org, nvdimm@lists.linux.dev, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com, jgg@ziepe.ca, lyude@redhat.com, kherbst@redhat.com, bskeggs@redhat.com, Xinhui.Pan@amd.com, christian.koenig@amd.com, alexander.deucher@amd.com, Felix.Kuehling@amd.com, dan.j.williams@intel.com, akpm@linux-foundation.org, hch@lst.de
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	MYRULES_FREE,NICE_REPLY_A,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
Subject: Re: start sorting out the ZONE_DEVICE refcount mess
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2022-02-06 11:32 p.m., Christoph Hellwig wrote:
> Hi all,
> 
> this series removes the offset by one refcount for ZONE_DEVICE pages
> that are freed back to the driver owning them, which is just device
> private ones for now, but also the planned device coherent pages
> and the ehanced p2p ones pending.
> 
> It does not address the fsdax pages yet, which will be attacked in a
> follow on series.
> 
> Diffstat:
>  arch/arm64/mm/mmu.c                      |    1 
>  arch/powerpc/kvm/book3s_hv_uvmem.c       |    1 
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    2 
>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |    1 
>  drivers/gpu/drm/drm_cache.c              |    2 
>  drivers/gpu/drm/nouveau/nouveau_dmem.c   |    3 -
>  drivers/gpu/drm/nouveau/nouveau_svm.c    |    1 
>  drivers/infiniband/core/rw.c             |    1 
>  drivers/nvdimm/pmem.h                    |    1 
>  drivers/nvme/host/pci.c                  |    1 
>  drivers/nvme/target/io-cmd-bdev.c        |    1 
>  fs/Kconfig                               |    2 
>  fs/fuse/virtio_fs.c                      |    1 
>  include/linux/hmm.h                      |    9 ----
>  include/linux/memremap.h                 |   22 +++++++++-
>  include/linux/mm.h                       |   59 ++++-------------------------
>  lib/test_hmm.c                           |    4 +
>  mm/Kconfig                               |    4 -
>  mm/internal.h                            |    2 
>  mm/memcontrol.c                          |   11 +----
>  mm/memremap.c                            |   63 ++++++++++++++++---------------
>  mm/migrate.c                             |    6 --
>  mm/swap.c                                |   49 ++----------------------
>  23 files changed, 90 insertions(+), 157 deletions(-)

Looks good to me. I was wondering about the location of some of this
code, so it's nice to see it cleaned up. Except for the one minor issue
I noted on patch 6, it all looks good to me. I've reviewed all the
patches and tested the series under my p2pdma series.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
