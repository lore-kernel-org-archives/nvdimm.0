Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAF62C9C
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:34:59 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id j12so12862719qtr.2
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9c7vpxYS+6RnfIRFWhHgAcQnmpWWsCXDoIZ8HfcxKVk=;
        b=eyrwc8BMMdOVC7JxxbPkKv0E+7XYg1mWVnxya1gkeBbn+6FIIKA4h5dIP4xxQ6Lyue
         PP3XS1TlpffXxqvfwJvChxVJKrRaJ4INlob/J3j8V4nhPl1/nALzUS4bebpDgN+o/Aus
         QQg2zEZcdkmCLgeogf4eYK3AO+nmond0PimC6gBZEbdgCdCPZ88/G1CIEJ9vhbSZK4os
         tk4KtyYHQy6WXksXzSrn8f5eOqxd/45+LU03LL1E7V5s7Z/zSb/UfyVa4YpBFVPoHCin
         OF1OweCzorEMyWiZQI+JHPsC+t/W26GR57RXRrAWC89poKcjeNO3WJ+VmGSwbNpLPdn4
         ljZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9c7vpxYS+6RnfIRFWhHgAcQnmpWWsCXDoIZ8HfcxKVk=;
        b=BIOkCCq5iraD94mr6AEWP1k5O239GJQ9gVu1PMsU162Hwj2u7CflhLDgoUeVB08Nto
         NH8L5ibxnvaAhcfFqL9jxBuJD4X899vBY/qoiqjLw1x1nXaNs5e+cLBN2KbXfnFOlVPu
         yOrZh56ThDhx6pqY/DfvEB14AnkYx0dpe5h7KRwFIm00eOXar/yv9hc4kMmIOw+LS7Y6
         pPoOOGafzk0UQlvit+xUnLNdkwWpPSGdVAImN4T1cOCr8OQl4inHdE7ojx+q6IVb85pj
         E9au0LiPevffL2pfBA9xdL6imgBUiWpTYON1nGyS/aFLWKuhpN6ARKMzTP4ulULsH6QL
         ZXWA==
X-Gm-Message-State: AOAM532GuovTTCk0ibxt2sCIJU0XWckDP+z9WTutObrl8gyQwdolTNXT
	tnyDHKLDVddMu3CXFrpYzTuNTg==
X-Google-Smtp-Source: ABdhPJyvD659xk5KRCKkhy7N4LjGPrkEHjwUHp/EZt//+nT6eRHPcHoug24DbpSsFF9r7utyh5WJCw==
X-Received: by 2002:ac8:7507:: with SMTP id u7mr761226qtq.518.1644262498222;
        Mon, 07 Feb 2022 11:34:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id o18sm6033304qkp.26.2022.02.07.11.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:34:57 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH9mq-000I5O-UX; Mon, 07 Feb 2022 15:34:56 -0400
Date: Mon, 7 Feb 2022 15:34:56 -0400
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
Subject: Re: [PATCH 5/8] mm: simplify freeing of devmap managed pages
Message-ID: <20220207193456.GF49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-6-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:46AM +0100, Christoph Hellwig wrote:
> Make put_devmap_managed_page return if it took charge of the page
> or not and remove the separate page_is_devmap_managed helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/mm.h | 34 ++++++++++------------------------
>  mm/memremap.c      | 20 +++++++++-----------
>  mm/swap.c          | 10 +---------
>  3 files changed, 20 insertions(+), 44 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
