Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DDE2F36
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 20:55:19 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id n190so21047306vsc.11
        for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 12:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GW5QetboOjp/W1DGCPKlZRb9/ODQzueiI/Kp5ewpL8w=;
        b=q1Y43sVBV67a+pTMXgzYdcgrIM1+jDEVyQDrYIY2VqgPCBA4gLIrVelM5WvsaRU6FT
         apqIDYl5nTydWmXdWFsHHzEmnUi9ucbdv/eGaDFY+/ikPxP7rpgjg23TSKdKRNG75RfF
         hOJWv6YDiJCYWInMiKfmSvisKfQHceB412aHHLyIH4laJZDnAhdUA/gwrmMFaTmYP4wI
         JasXHanhpujv7dWFati3LIBFZ6AJQSVfl11oMManr2Pa9YA9E34Bt+wQcOsCwX3M2nO1
         aPfT/BNnaT1wPwl1xWgGhrkDfqq/B+t3Phb8hSkCfWokWCUfGMVgTTrWzsij4Z4mDYa4
         4IoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GW5QetboOjp/W1DGCPKlZRb9/ODQzueiI/Kp5ewpL8w=;
        b=0sk4qscp7v7DNGRjGctAeRz6VuEIsHEzOawvLMwPY0KOsxK++oAN5VXG0msDYHf3GJ
         BcT2Oz5WmGza2M83lOIVIQjPRppTGtKLFspt1TIZbAGj7ORSGB6AqqiU7C3haxxviHNS
         q17UH6eEnmcaiqQqhwHUnmKy9yOeZeRa7Y6D7NTWLvJuDU6xUhzH7ZSAtEwP3bJtYcOS
         6PLuSOWJfVT3VmB9l4kRA6mU9us2b5GwhCECwF0fZ3yt1vEchYA9PGTTDyEobNpOpXUS
         75OCgZGHB7sJ0iczcoa5ToJD5sF9Dx9q7PyNzOIzZtP0Ce8lWwpFyVkDOwDt7BDcq9Yc
         EuMA==
X-Gm-Message-State: AFqh2koDuEdtFgW7fnlh7ayjXttkhzXpnT1rk+EcsbXGeNXOJAgnOW5s
	fQpzhRq0CoKpx3NIMEx4qWIS4kGc7AqXCUptbPqPNQ==
X-Google-Smtp-Source: AMrXdXviSBQt/EVgkIYc2P8tOGvMYorzKUR4KlpF038mvQhGE7AGWByUE0GqDBCYz0ZD4Keh/l4cAHpGGwW9DuqqjQA=
X-Received: by 2002:a67:f650:0:b0:3d3:db6b:e761 with SMTP id
 u16-20020a67f650000000b003d3db6be761mr4768562vso.46.1674680118522; Wed, 25
 Jan 2023 12:55:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <167467815773.463042.7022545814443036382.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167467815773.463042.7022545814443036382.stgit@dwillia2-xfh.jf.intel.com>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 25 Jan 2023 13:54:42 -0700
Message-ID: <CAOUHufashDpjnj=XxaR3jsAxPT6tOuv+Uv9ZuJ_8=vLS_HrDWw@mail.gmail.com>
Subject: Re: [PATCH v2] nvdimm: Support sizeof(struct page) > MAX_STRUCT_PAGE_SIZE
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, stable@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Jeff Moyer <jmoyer@redhat.com>, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 25, 2023 at 1:23 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Commit 6e9f05dc66f9 ("libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE")
>
> ...updated MAX_STRUCT_PAGE_SIZE to account for sizeof(struct page)
> potentially doubling in the case of CONFIG_KMSAN=y. Unfortunately this
> doubles the amount of capacity stolen from user addressable capacity for
> everyone, regardless of whether they are using the debug option. Revert
> that change, mandate that MAX_STRUCT_PAGE_SIZE never exceed 64, but
> allow for debug scenarios to proceed with creating debug sized page maps
> with a compile option to support debug scenarios.
>
> Note that this only applies to cases where the page map is permanent,
> i.e. stored in a reservation of the pmem itself ("--map=dev" in "ndctl
> create-namespace" terms). For the "--map=mem" case, since the allocation
> is ephemeral for the lifespan of the namespace, there are no explicit
> restriction. However, the implicit restriction, of having enough
> available "System RAM" to store the page map for the typically large
> pmem, still applies.
>
> Fixes: 6e9f05dc66f9 ("libnvdimm/pfn_dev: increase MAX_STRUCT_PAGE_SIZE")
> Cc: <stable@vger.kernel.org>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>

Thanks -- that BUILD_BUG_ON() has been a nuisance for some of my debug configs.

Acked-by: Yu Zhao <yuzhao@google.com>
