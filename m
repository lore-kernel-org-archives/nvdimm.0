Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31E2F24
	for <nvdimm@lists.linux.dev>; Wed,  9 Feb 2022 12:29:58 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id a19so1604991qvm.4
        for <nvdimm@lists.linux.dev>; Wed, 09 Feb 2022 04:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JpFYQSMAVe6I09BHQOjAX13imKhzUaXlc2+fdsD9V6E=;
        b=Z4Eu786ojGcRgS8Eos4sLr66z2Uqqmgi/bDj6/Y33EEsvVWVKeCNJioyDR9vfy9xaY
         yz3EOxCOZS/4g/fgKsh1/TNwzJVTuJBYxARJaHsw7OoHQBYA7L/O3QtbTl8+Tpf3u32c
         Go3MoLTkH16938QXNFcpZV2qsCQ+/yOIxJO8+ooqAbmuC9zUdvg0Bg4KHC7DQZrRu5Pr
         MEV4AdWysZ66pZX4YRzJgy6PJ/mfwT6AapS6FtqHr95tVUvZ/ng6ysJBJp+d6N+bSxfV
         V5qGUskZ4AiQdRAYVMO4Llk3dzOmsNqH1liuPvseANE5HTBFUWXt5H7TVNAa03BHV8C3
         wh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JpFYQSMAVe6I09BHQOjAX13imKhzUaXlc2+fdsD9V6E=;
        b=47UEDf+zFyhDmAZEjxP0YBE2zmZj101vx3XJPveTb3qdVlGsot0kUp3NbtB3JBWUK6
         zjSVcYoSgydnTyx5H9e8IQny3hnV+z9Zoq6xXLQtCpzBD7qTOiOdJ9VqU55GfxqTkRqa
         0j9BFOY0Pq2NNbBe/KarBoJ93TVJaeuNzXD3eLN5yZKR15yYh/LVETuj2H1bmVNZgfNs
         apmwbbEvBj4CcqD6u7n1kF0cKXmJG284psFNb5XgGOO45o+lSsx5QAwg7Loo5Dfe9v/I
         SfloksbvODSnOHSK/IfyhxK7tqmlWDxBBNPoEqPsJn013iNZQy4BYmAhkBwqHzbCqcah
         XPfg==
X-Gm-Message-State: AOAM532OlnzX+NZCvzWb010hxfPMCJLMxA19SQFVAhmb0KSp7Gy/aTFz
	XycvL5bYPO6tCbEUiWRDrwwmkw==
X-Google-Smtp-Source: ABdhPJwf9mdnK2ldlbFJ89Gp7ICZZlJoeyugDA0YNF0idT1dfs12KR4knXDFD3wj+Sh7mIvt9ShqvQ==
X-Received: by 2002:a05:6214:21ac:: with SMTP id t12mr1263884qvc.123.1644409797997;
        Wed, 09 Feb 2022 04:29:57 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id w13sm8052274qkb.106.2022.02.09.04.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 04:29:57 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nHm6e-001DJi-6l; Wed, 09 Feb 2022 08:29:56 -0400
Date: Wed, 9 Feb 2022 08:29:56 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
	nouveau@lists.freedesktop.org,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 7/8] mm: remove the extra ZONE_DEVICE struct page refcount
Message-ID: <20220209122956.GI49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-8-hch@lst.de>
 <CAPcyv4h_axDTmkZ35KFfCdzMoOp8V3dc6btYGq6gCj1OmLXM=g@mail.gmail.com>
 <20220209062345.GB7739@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209062345.GB7739@lst.de>

On Wed, Feb 09, 2022 at 07:23:45AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 08, 2022 at 07:30:11PM -0800, Dan Williams wrote:
> > Interesting. I had expected that to really fix the refcount problem
> > that fs/dax.c would need to start taking real page references as pages
> > were added to a mapping, just like page cache.
> 
> I think we should do that eventually.  But I think this series that
> just attacks the device private type and extends to the device coherent
> and p2p enhacements is a good first step to stop the proliferation of
> the one off refcount and to allow to deal with the fsdax pages in another
> more focuessed series.

It is nice, but the other series are still impacted by the fsdax mess
- they still stuff pages into ptes without proper refcounts and have
to carry nonsense to dance around this problem.

I certainly would be unhappy if the amd driver, for instance, gained
the fsdax problem as well and started pushing 4k pages into PMDs.

Jason
