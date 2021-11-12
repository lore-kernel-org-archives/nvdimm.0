Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D2F68
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:40:15 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id i13so6519767qvm.1
        for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 07:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eHFem9bwQXsJyV+6JTiESgkyM4KbH6WnNIZTWfeQdQM=;
        b=YNrl8o8/Vn1AkLLoeyYZG9B20hm49tgpE4O3wgwFJgziK30a3PCI8xmMW/3GH7F4q6
         BCrb+c2z9Qw8YmTih2UF/NtYx6SkbMgpg5McDnMKQVwPvmrIrqWMA0T1P+r76E+hPQU7
         vspp5Z5zqD2ZLqfib+KTnbWtZ2nMsOzbJ4SwLu4cv8m7v9SA8U+cAXRbqUUD+9Xl2Tr5
         OBoBon+vXff3oyhGP2QE2TjyC8BXX7/bObQMaOixmqSVC7ROTUOojKNQp+E940X3GNrK
         90vm6Oa7flbxqDFNtZiHYV4HEx/9Jq8eLboCYNs30tEJ2nBhD0HG9UJ4S25gUib9lmaj
         uKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eHFem9bwQXsJyV+6JTiESgkyM4KbH6WnNIZTWfeQdQM=;
        b=C6OYm3VuaIsIjoMvHm3RqqTkhMYC8wYQBQUN9KRelIlM0CLlZU++t9h+hVlnh1zLZC
         C2qKgzFQhnsgCQUKQRQkwlaL31WrqNSijfPWDwKriWM8yYdwdhZCRsmUUR+fk48x0g4F
         F8mF1W4MXJ7Cfw5VPWur4A19EFtlVFT7zQIfBVh1Y5JdE5Q/CGhuvUhm343jqsjNhjU+
         hcCCvan1qv9x8SLnkfIKEzTzZ83dz4yHvO6vwcoyKN20n1bvAexpd02MZYt/Hkylm7MI
         DTFzvoN8RCr2iCbcF8Ba7I53+4ZG2x6wsv00bKZOLtYTBxGMetptnV0KPZyuNnP0565Z
         NI9A==
X-Gm-Message-State: AOAM531zQx7BrM4uysvvEvh5AucQldQCNCaWJBMQubj6wmzBJ2mUn8pt
	5MEc7JBXkKZN3RLIo5EjJDbKtQ==
X-Google-Smtp-Source: ABdhPJyk+u5C78xlis6nsI4oXFLdxJj5bzxauTbMsNW5fYwp9xLGPXNgO0ahuuvM/969OxjiMZGs4w==
X-Received: by 2002:ad4:5c4f:: with SMTP id a15mr15582209qva.26.1636731614399;
        Fri, 12 Nov 2021 07:40:14 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id t64sm2805724qkd.71.2021.11.12.07.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:40:14 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mlYez-00975w-1c; Fri, 12 Nov 2021 11:40:13 -0400
Date: Fri, 12 Nov 2021 11:40:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 0/8] mm, dax: Introduce compound pages in devmap
Message-ID: <20211112154013.GE876299@ziepe.ca>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112150824.11028-1-joao.m.martins@oracle.com>

On Fri, Nov 12, 2021 at 04:08:16PM +0100, Joao Martins wrote:

> This series converts device-dax to use compound pages, and moves away from the
> 'struct page per basepage on PMD/PUD' that is done today. Doing so, unlocks a
> few noticeable improvements on unpin_user_pages() and makes device-dax+altmap case
> 4x times faster in pinning (numbers below and in last patch).

I like it - aside from performance this series is important to clean
up the ZONE_DEVICE refcounting mess as it means that only fsdax will
be installing tail pages as PMD entries.

Thanks,
Jason
