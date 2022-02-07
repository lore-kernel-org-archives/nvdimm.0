Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382302C9C
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:22:44 +0000 (UTC)
Received: by mail-qt1-f179.google.com with SMTP id l14so542569qtp.7
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yHQiDHxA3qZlcWTxLN1MgZypNnbjTwUZO2QoeiWP/cI=;
        b=WalR+vjdCg+8zPlO5aZ1ywuN+woRsi3gerM9e8um5R75M05o/0A4tTPV0sDoS0iLf7
         MI5Ayh/aUjA3lzGk4knlGcpvrjJkTAzgzCaIVUlu2cLGGSbDhpJ/GrhJhUdc2HnXtmRK
         stuNg7sUYxLt5HQjP/PwyCP9ZRninXNxW8lX4+8vi6VkUSLgg5BY3Jxg39rH3WH2BDNx
         g9rpWqR/RtcR0wf2poNmSVgkhRnSCPEG3oCgynxbJlts+OBBSOpC9atYeDDQCpJbBHmV
         OdyYF8TiYTFFifPNOFO5hE7XJgkPbqKroSw//vj0hDKtL6BLQKT8a9/Jd8uxBZMUHGVb
         3Hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yHQiDHxA3qZlcWTxLN1MgZypNnbjTwUZO2QoeiWP/cI=;
        b=tO8MTD8yBrvlBpYmSZtAPFvbfUbqhZpcCBQxIB0IYm00CtKENynhhjtcYiiOy07gQN
         GVb/FMIIHz/We/R0SHdz8+C/znQx3XCIll1dZggIyg4GDT8k93W0YvG7M4optD9QQ4u2
         KAWH3PREbPZwgwlAfvPlau+dEi3toDw1h482+AyAgHj5DMMu3MaPDrMdSRS8RgmWW326
         fDK2AcypkW7Lk3GhRWqhelFYw+IXpn93aftKOkLtKtY9CNW60P1Z60rYCr1f6bI1lOgS
         Rf01b12bsMbqrqJtMYEq4D23ikTxeSawRo3PevsvBhJnt2KMQkqEbEPya0pFHdj9O4Ie
         LPpA==
X-Gm-Message-State: AOAM531u9VQ4JDEIyFYo4b4xcqoe5PHpAaMFz/Zl5dj3xvKMmFhQX+ck
	buzagfJ2jV5irKO7Y4rBB7XAwg==
X-Google-Smtp-Source: ABdhPJyusc4Y6UBxGsOMvrtpT2MH3zTc6ABg/OaP0sDSZntIjW01XzJV/gLuVV8p/6/141fWu3yUUA==
X-Received: by 2002:a05:622a:1303:: with SMTP id v3mr740294qtk.294.1644261763197;
        Mon, 07 Feb 2022 11:22:43 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id y5sm5930001qkp.37.2022.02.07.11.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:22:42 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH9b0-000HrC-2F; Mon, 07 Feb 2022 15:22:42 -0400
Date: Mon, 7 Feb 2022 15:22:42 -0400
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
Subject: Re: [PATCH 1/8] mm: remove a pointless CONFIG_ZONE_DEVICE check in
 memremap_pages
Message-ID: <20220207192242.GC49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-2-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:42AM +0100, Christoph Hellwig wrote:
> memremap.c is only built when CONFIG_ZONE_DEVICE is set, so remove
> the superflous extra check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/memremap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
