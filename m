Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859C42F26
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:27:32 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id r14so12843382qtt.5
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BoyrZhI/SFo2F7HoszDIan4CMWU1RWbm6+Gl19zQGEA=;
        b=Ch8C10PSNgUgzrJSYUwNmUYPnK3KqD5nVzs8U25K8dQe5Nz0RHnqD34dfcVzOfHQn0
         Z7A2NrwTV3T8U5qAOPkdl18fdhCkDtt27sDhMF9az9KwL3bhZc1wWsNakacs8mHp4+2i
         ATHSdkH9LZE8z74Q7FsDuavDIliXPR3QE65Wv381+/ZcyQuEMN7ZFrlis4MW0UWFA66p
         hAq2I0gQh10LCJLc1hBJhl0b+SX/rRCFuGSDgkT7h5GKbOua68a4YV58mo6/qZ9LpsXw
         xHl/NBuQ1Pg3+hWr0zmMYM2z5/HBKY5RxkuejNX/FdePkUnSlgZKK24pt/x4bYmxOQsS
         FISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BoyrZhI/SFo2F7HoszDIan4CMWU1RWbm6+Gl19zQGEA=;
        b=o+/48QL3QceEhzObCTlDqRPAISK/EI3j2BTsHBAcIm32/iX+tTdh4Y6zHXDVq/pW3z
         hOTgNUGvTzk/kthZcjLNpivaRu0cKgqwf6vEbcTJO4BZ29b5eMoHc7PCr+9i3uSmSpei
         dxSiH8FG2XfPEPCtknq6IO4O9Z2JamU+PUxBz1A3gTRkpY/kmU6x7EHGN4LIPKtWkDho
         S4UmYgJPnR6zYGLbSKTadMi5+sMHLuOTPAgpxWpH+yhvfhlJJv7fo2b5A70tCO58VweK
         HKJOFSFSf/2RL9kUiHhLgNeJWIPseCevJt9viBdhfRATRzA+VctGFFknHl8S5J55TlKp
         /avg==
X-Gm-Message-State: AOAM530wpKQDqAG9+53y+hwcB3W7SPKPSU5fqQQbunlwERjgOcSe20cU
	1IFes1JVXxbSPWcEM52MFoTbtQ==
X-Google-Smtp-Source: ABdhPJxE/dHX+9xmPplXl1VvJP7kBTi3tiLgJTGk2+Y/ZJni8J0n6I1+6ACqdKe2xRydNCRf+KVUww==
X-Received: by 2002:ac8:7ca4:: with SMTP id z4mr750427qtv.526.1644262051598;
        Mon, 07 Feb 2022 11:27:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id de15sm5546110qkb.107.2022.02.07.11.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:27:31 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH9fe-000HwP-GM; Mon, 07 Feb 2022 15:27:30 -0400
Date: Mon, 7 Feb 2022 15:27:30 -0400
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
Subject: Re: [PATCH 4/8] mm: move free_devmap_managed_page to memremap.c
Message-ID: <20220207192730.GE49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-5-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:45AM +0100, Christoph Hellwig wrote:
> free_devmap_managed_page has nothing to do with the code in swap.c,
> move it to live with the rest of the code for devmap handling.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/mm.h |  1 -
>  mm/memremap.c      | 21 +++++++++++++++++++++
>  mm/swap.c          | 23 -----------------------
>  3 files changed, 21 insertions(+), 24 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
