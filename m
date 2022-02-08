Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBD72C9C
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 08:09:40 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id y129so11250286ybe.7
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 00:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DC5h5QPa2MMSD8jMuUZaOZTMv0rKCEv7tr+WwakctiM=;
        b=UKt/5gqtEQEDR+I4jR//5bWv57hPVaW9KmAr8xHRshFW+V9PDSWkFrBE8Hyb8wlSkA
         QQKQ+stzgyEgp5J4DyVY4bvPNBtHP4wSzJ6uJck+8cplu8GPkuIVWQ+Y8zm1xv27s0Zu
         cR2ljgqob8w9EmBGVw0EdJVkId5N+xNPUHeADg5epuSLdcXTrW9Tqo5OcA22EaRu8U3K
         l3cuLzKBbOc9GbQXk+h497gXyT6KtsqpW966ysKE5jotsGOXr7l3B+dKnggATk5GoyUy
         KJOt1xwxzqYiEqEVIBRmXg0oLWnTj4m1q1+iR+FtOucXjtQu9GfhLJMBe3O/kYgazNfR
         tnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DC5h5QPa2MMSD8jMuUZaOZTMv0rKCEv7tr+WwakctiM=;
        b=xbR7sfl0qlk6RkKtYdjN++o5h+Sf66vcHk/Z51vtErKg00ymCwfRmRG425/rE3AVfR
         UEwkuiOhfw1MP7kukIPATjRCIk2TSkpRG1sejx+1whFYfdTwyZYAAc1A6rcQskCrAhYk
         GQf21hY7D7tHGI/pkbiFtAKw+8HcaPJPbXCgyadnrbTc1u5MValVa0LixQxiEPnjmYNw
         mmx/6sskonVvXl/t+WvFgerfwTxQ8XlaqfJYwqiA9by8bc2oyq6v1KxsofiABURYMbd6
         BUXjwV113gHkq9VWY7wX1KwN2MAPJUiE+meDhSYJewqkUzldGuX4E5HPmMKD/A1VNUJM
         FBrw==
X-Gm-Message-State: AOAM530BCIHLCkJ2iSFiwVHGyEPczvE9OWQZ7B/O43wJmR3gj3LEYiQN
	4uOq6l9bc5VCIV3OEiTVBB0p0vq2KdZXJz2mYdZKcw==
X-Google-Smtp-Source: ABdhPJyFSmuR7M4HIJ31YSJoOUpobAKTBK69kzVotLKdLdB2NRipgBTZ2XLKWECEqSNiqnwAnFetqc4Ion8CCMp0OGY=
X-Received: by 2002:a81:ad46:: with SMTP id l6mr3668263ywk.31.1644307779769;
 Tue, 08 Feb 2022 00:09:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220207063249.1833066-1-hch@lst.de> <20220207063249.1833066-5-hch@lst.de>
In-Reply-To: <20220207063249.1833066-5-hch@lst.de>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 8 Feb 2022 16:09:03 +0800
Message-ID: <CAMZfGtUqbU9VpCOA-9bdU6d1CoQ7n8D+26v4j79uLcH1uc5Q2w@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm: move free_devmap_managed_page to memremap.c
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Ben Skeggs <bskeggs@redhat.com>, 
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Alistair Popple <apopple@nvidia.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, LKML <linux-kernel@vger.kernel.org>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	nouveau@lists.freedesktop.org, nvdimm@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 7, 2022 at 2:42 PM Christoph Hellwig <hch@lst.de> wrote:
>
> free_devmap_managed_page has nothing to do with the code in swap.c,
> move it to live with the rest of the code for devmap handling.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
