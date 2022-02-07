Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DFB29CA
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 14:01:30 +0000 (UTC)
Received: by mail-qk1-f173.google.com with SMTP id j24so10901483qkk.10
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 06:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+VH5Yzc0FArtBDlyVciKdTaJzlAuXtplA0CDhVkYZVw=;
        b=TUJuhAgjjswNVQ7JzTkg9iKkOgM430mBd5iaZFyVB8juiwGMelroxSVc/tEeoVjS03
         SBBJAs6XyaJLOH0zNh1fMB11MocmBy0vZW3lQVqwc7nmLVkUib5NLDfgXeW1egoLcrUl
         0zJ1M9G8GricJAi2JHxOQgJzIsENPf4oXdSlLGMn1ou/GSiwitfE+Re74s2OC3cGYiXS
         WAB6PyKR8iNz2aNJcgzl/Jv2b00SlxQrNVuEW+ZJ8pyVvgvQpU41dl5hiuO86kWk7vjX
         6XluH9RnX42crAJsdacFsF/M+gN0YxPG9aqIQm6tHe1mZG9Uo38/MZ0gAIlPcqFBC8jG
         7hCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+VH5Yzc0FArtBDlyVciKdTaJzlAuXtplA0CDhVkYZVw=;
        b=bofMcDH2C1dP1TLvEUu2MFcIDEJbKVr4WDs2425ga8NN80HA4NvjKF8zWCZnVSlaWu
         oBo350AnDcKnuEuTahzunDZ10zGCjZrkQOWKEbr6IzR8tKoJ2KlnREc5rmpG6NTPhGWw
         RHBtw8gvDtCmjAAubh4nvvx3nN9JmfVBOxG2B9c/JzPxORvaeEtoriOB/jNNXgUcQ027
         2bDSy4vUE+IjyCzmwwb31G0CG6qXxkN+hVbYNSLzYwyMQqFzTBLxTy9cFmJdkzVoGs9c
         BdAe76YH7miD9giZ8e37i5ufD+NWfhiNepcXihd5MRx9KXdeKOeuD2tm/XIHTLsc7yZh
         Ed2g==
X-Gm-Message-State: AOAM5329dlp4o+KoB1UnI0LgONjTiJiElYR6i5dtbj15jcXxbfy8T/+9
	5NWdYsVPARpBacDIBF7hQSDjag==
X-Google-Smtp-Source: ABdhPJxewUAI8RDxJecgMQqK84dnZDRSuWWALhikOi914YekMnNecZIoiX1AIBCzbrtZ6bBwZBwWpw==
X-Received: by 2002:a37:2c02:: with SMTP id s2mr6217893qkh.76.1644242489492;
        Mon, 07 Feb 2022 06:01:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id f4sm5480989qko.72.2022.02.07.06.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 06:01:28 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH4a7-000CyH-Do; Mon, 07 Feb 2022 10:01:27 -0400
Date: Mon, 7 Feb 2022 10:01:27 -0400
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
Subject: Re: [PATCH 3/8] mm: remove pointless includes from <linux/hmm.h>
Message-ID: <20220207140127.GA49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-4-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:44AM +0100, Christoph Hellwig wrote:
> hmm.h pulls in the world for no good reason at all.  Remove the
> includes and push a few ones into the users instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 1 +
>  drivers/gpu/drm/nouveau/nouveau_dmem.c   | 1 +
>  include/linux/hmm.h                      | 9 ++-------
>  lib/test_hmm.c                           | 2 ++
>  4 files changed, 6 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
