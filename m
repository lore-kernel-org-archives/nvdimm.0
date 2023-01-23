Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A277C;
	Mon, 23 Jan 2023 19:47:26 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id jm10so12470321plb.13;
        Mon, 23 Jan 2023 11:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBsOuBeZmizkCpiObnueSyLNHUyq18ijoTACbxi/qCw=;
        b=YNSKaun5tSykYRXFo8DuSx8MGNu7dJOI7hW/N6d/u/8zvescwCrTxm0iWr6DC+Pf2A
         U8E1ZmuR8HCoAVCkDWRDIAq6oauFmx+Ab7TZlCNSJ2B+GEmCYuX4Y2TK+ZvRz48b8sl0
         h1hN56ewEBb9XbQ6HU8N5agK9QRrVw3RSl/vmObYAUlnkzpef2AZYeHhpFeln4mRaXha
         HL+d5xKOAnDqC71KCBtq33dumT9WD3TjvuzaJeDcIuk1AiZ9ig60vboGMNXDDLiUGEQ9
         V4Zkzvpw1+AK4sO0VFVOAhZKIct9PwHOYeAutftdogK/7W1MHtU4t9sMdmutPBD7+XsL
         4TGg==
X-Gm-Message-State: AFqh2kp5Ub46u0/pqABx1BycOj/c2/J9+/Jv8CzPku23ktxaLS6c3qRK
	ucWYFVTbPc3wK7ovjW7h+3s=
X-Google-Smtp-Source: AMrXdXvfK5mbs8dNd8I/pgphfjpkG9tj7Pxsz/hA5VFQ+HwYWwvNOoHEYzZM9wNmI4uRnGef/Yze9g==
X-Received: by 2002:a17:90a:b002:b0:229:932:a0f3 with SMTP id x2-20020a17090ab00200b002290932a0f3mr27137965pjq.27.1674503246346;
        Mon, 23 Jan 2023 11:47:26 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:dbe2:4986:5f46:bb00? ([2620:15c:211:201:dbe2:4986:5f46:bb00])
        by smtp.gmail.com with ESMTPSA id gd23-20020a17090b0fd700b00212e5fe09d7sm39962pjb.10.2023.01.23.11.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:47:25 -0800 (PST)
Message-ID: <771236a2-b746-368d-f15f-23585f760ebd@acm.org>
Date: Mon, 23 Jan 2023 11:47:23 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Joao Martins <joao.m.martins@oracle.com>,
 John Hubbard <jhubbard@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 nvdimm@lists.linux.dev, Shakeel Butt <shakeelb@google.com>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <Y84OyQSKHelPOkW3@casper.infradead.org> <Y86PRiNCUIKbfUZz@nvidia.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y86PRiNCUIKbfUZz@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 05:44, Jason Gunthorpe wrote:
> I've gone from quite a different starting point - I've been working
> DMA API upwards, so what does the dma_map_XX look like, what APIs do
> we need to support the dma_map_ops implementations to iterate/etc, how
> do we form and return the dma mapped list, how does P2P, with all the
> checks, actually work, etc. These help inform what we want from the
> "phyr" as an API.

I'm interested in this topic. I'm wondering whether eliminating 
scatterlists could help to make the block layer faster.

Thanks,

Bart.

