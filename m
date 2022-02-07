Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B942F26
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 19:36:19 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id k9so12213622qvv.9
        for <nvdimm@lists.linux.dev>; Mon, 07 Feb 2022 11:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AZb+VjqCK8DT8gUN4DVyYxz5ldTv3hxfq1kOHV3So/k=;
        b=KntHAMqOekGnRUkUpQJ4RmJ6jMnHjUV7NyerhvsEdoAGvARGmb4G3Wj/k8wnWrJ4v5
         8kPwNbh9XAYp6cLgi4gIv627uiqcRa+LFZjBeDErIxOg8LxHgVSzpBBgB4/02CnckDoW
         j/vS99YpkyicivGZvG7tPxKD1tg9I4Ra2r60sYYIh7hopzEEGFHdBxN13YaxsF1pjtQ4
         t2UWWLHBR9zIycMbU/55yGUwhwjflg+CGCZLsD+asK60z79VcLiGPwy6B0EGe8DupEXr
         Ad4Gbvw45NbEij0sfEUWdE7DXdHVlwqV31kqZB6dVE9msUcvQULHgg4p2QKDUMuJskEz
         lXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AZb+VjqCK8DT8gUN4DVyYxz5ldTv3hxfq1kOHV3So/k=;
        b=titHhts3xpSVQLRgUiESJTb6oH4e7roq2xcYHGCZLrnZLhRO8aHQSdcSoIhH810Wc7
         4FSSrNvfwXWFYRvFv9l+ovCClXaxxYkVwpUesBPdUJcAzrnitAl4ZrelzGwMMB7Y/vJg
         hG9HKR35hY41VGg9s9kWh2ca88UsqkcT0ThUvLDSg09CxI1mls9Lo5wmDAoIWfb9TAlo
         ZWVEbYnlxcd5+v5QnlDjyfDcdOdsCNZFgiBsLb4920WT1VqUEr+34mq8+JXs0uJYo9OE
         Y0ZF9btcdO8NoAMFqPsrVn/J2HVEww/hXMFVW2kb/2MNhD7MHSgmPI4LYayXAlbwkYgC
         9kAw==
X-Gm-Message-State: AOAM532HGVVV5XsxkNT0zMII0Z/Udabj8OMgFcbTPLHL5W1hcF+LzHLU
	SIPzApj8p0ELi7DXyR+R+gX3PXj6+r7HxA==
X-Google-Smtp-Source: ABdhPJx0Ja9WLXhMDJ89Idc/sHv1PbTV/zifEfvcLL+6K0fCDuGFFRfG8vhitXIXvhCy0TtD+Fimvw==
X-Received: by 2002:a05:6214:2aad:: with SMTP id js13mr896600qvb.32.1644262578716;
        Mon, 07 Feb 2022 11:36:18 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id h1sm5945976qkn.71.2022.02.07.11.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:36:18 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1nH9o9-000I7B-La; Mon, 07 Feb 2022 15:36:17 -0400
Date: Mon, 7 Feb 2022 15:36:17 -0400
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
Subject: Re: [PATCH 8/8] fsdax: depend on ZONE_DEVICE || FS_DAX_LIMITED
Message-ID: <20220207193617.GH49147@ziepe.ca>
References: <20220207063249.1833066-1-hch@lst.de>
 <20220207063249.1833066-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207063249.1833066-9-hch@lst.de>

On Mon, Feb 07, 2022 at 07:32:49AM +0100, Christoph Hellwig wrote:
> Add a depends on ZONE_DEVICE support or the s390-specific limited DAX
> support, as one of the two is required at runtime for fsdax code to
> actually work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Makes sense, but leaves me wonder why a kconfig randomizer didn't hit
this.. Or maybe it means some of the function stubs on !ZONE_DEVICE
are unnecessary now..

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
