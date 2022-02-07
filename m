Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975E22F26
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:26:49 +0000 (UTC)
Received: by mail-qk1-f171.google.com with SMTP id o12so11839723qke.5
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bGzAS0zKkWkFPCiUJqrRhTBAlrJP3SGf1MGlPyahzN4=;
        b=b7ELmtzNyf/nrudljsQzl4Q1Js/C7bJel76vjls1xYAgKYUp0D32NW/dwCQI91vZZP
         cXbYYhEP/g8elhxNJkVvAoFewT4/BqI63tG4dQgRBW68M7alExU2eUsV3nwL+RRGhNfV
         j9OssUbyMS/ts/M6+OwPFFARzPDqKR87URSREqouyR+yUBPPCOc+h8b8yGuU3ej+D/xM
         yigD/3UGPd7ytRh96Y0Q0EKXaGboDozlOgbEE8YSvDdrFF+CXBdAOzxWkzfsUC5OZ96L
         FougQ7rtCxrXPxFtxmHqPYYsSOKmfZn62Sni/waJLdqf1/0D0HpcPN3YMwknPx6e2shw
         Hl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bGzAS0zKkWkFPCiUJqrRhTBAlrJP3SGf1MGlPyahzN4=;
        b=fq85Z4VA0QOb6HKAuUs7Dk1JD0LTSy2ROGOSTu5KbzXB+EPHqT9w1Q40tpJ9JdHZNH
         LvKC68GH8QpRGf40rFUubGRB9ISS1P1KjEn4/Ek8aoBLMMsAPDCNXipUrre8y3tL8VtA
         WwLMMWkLIkEMKvqSL1YZ1zNO0XG8R+gL0KSxcS8B+9/TbeLjFA1KFjFClmKOylo8x+5j
         CJTr1Bb2M0XvzNjmJzeR/faNAgigBE/KUb1rHKGN0r11dhpHnCtn5qClhZL2NqGSo1Wo
         qjaDP6Hrg5IS22Cwn+cmvj0grGvIzmHb5dVJuqKDsjkSXn7dFNhMAeTepPy2+/QQ7Y+F
         Gp4w==
X-Gm-Message-State: AOAM530Gni/WY7CJ7MqUU6SdeX2zZGGW1j+7nMuQsxsnH9xUQGkakayI
	AATKSl9Iib45juyfP+VMEdUiGg==
X-Google-Smtp-Source: ABdhPJyr6K2wB/TmouPqeHofF9/cBL8QhnN30S2Z0xEYqLSWtmQW56XluhEWaS6dhmSL4EVhM8SlGg==
X-Received: by 2002:a05:620a:1204:: with SMTP id u4mr761415qkj.707.1644262008607;
        Mon, 07 Feb 2022 11:26:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id w8sm5913769qti.21.2022.02.07.11.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:26:47 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH9ex-000HvP-5E; Mon, 07 Feb 2022 15:26:47 -0400
Date: Mon, 7 Feb 2022 15:26:47 -0400
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
Subject: Re: [PATCH 2/8] mm: remove the __KERNEL__ guard from <linux/mm.h>
Message-ID: <20220207192647.GD49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-3-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:43AM +0100, Christoph Hellwig wrote:
> __KERNEL__ ifdefs don't make sense outside of include/uapi/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/mm.h | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
