Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE8072
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 00:20:39 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id o8so2286290plg.11
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 17:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=++GKWz1ssqCoeJx6bnGwv/X0kc5Z2dWJaQSf7sR2xSw=;
        b=U0PaRa++GGYaBFwYDH/lfFiilXCr2yuSCQujvVP22gL1atGIlTC378Mi40GfDOVB6A
         LGJQH3s5KlIRQ7jvjPI7PRMBUiieTdQD8EYG6o6W2/O8U70BMLXDq35Kwa1IwBLb3eom
         EOH0+hBF8DUoD0vjyPGEBg4f5VkUqNjqnUR5DPN7lHlEuj7S/OJejm38Ozv0gPPydnJt
         3V1iRBhx3r8j1M1OTc1CWwejo+jBFjEltwpdNN/0xia1WQwphKJ6zjxe6RMYwdaUPRTY
         P7ywcBETHArMhiTAjqTuk79xznUmb5Hx5aIFoY/zOl2nJ4TIx9npkb6bAAG6BO9aDRpO
         wqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++GKWz1ssqCoeJx6bnGwv/X0kc5Z2dWJaQSf7sR2xSw=;
        b=n3X8og+DpMn08P82iWPmhW9vZ4+2VCPx42vCYJnQxTdayS30jf+L1YqOUqDyYGAVm6
         eqaWKUISObLVBUrY92MnmNH/c2RM9ETWvsNxqxDbHBhN/3BXN8wYX1RthBNf6Z6FbJwv
         ne0oU/pCpVQ8qThmZj0H//2fG0tB8Je6iPWst2zlAPRUiIgaZhUE0Ttu/6NyoYBl3NpN
         Lssxh/WQf5NvI9qCtCoXJuQuDe4rKCv+xxYPDjFdmZHTl8savk29PUEBpf634r9HDqUs
         CV9qzkaQ+EO1BzbDIINd92sdFQyZIVGuPO18jJKZQHOTIXfqRLbfVbUfBT9Kldn+FGXQ
         OK7A==
X-Gm-Message-State: AOAM532bDajpFJb7g/CTiiQCWOMomQ/Ip3dwMZLv6fe980gLP8fMhob3
	ron9FsBvjDjBFj1yjhm4JLr+D3ZGFVXQQWJ9fTzvSQ==
X-Google-Smtp-Source: ABdhPJyrCy3+Y6IJAkn3gtPXWHmXninLfXfs7SN98GDpyx+hpvDd5ePEFLW9PH44iDbQsDONtPRb8Mn3CdBYf6L02Lc=
X-Received: by 2002:a17:902:6bc7:b029:129:20c4:1c33 with SMTP id
 m7-20020a1709026bc7b029012920c41c33mr679072plt.52.1626308439094; Wed, 14 Jul
 2021 17:20:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-4-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-4-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jul 2021 17:20:28 -0700
Message-ID: <CAPcyv4jgsAy0RFnxvegJSBypYnHS_JrMUmbLvgwvSDUXurHnnA@mail.gmail.com>
Subject: Re: [PATCH v3 03/14] mm/page_alloc: refactor memmap_init_zone_device()
 page init
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Move struct page init to an helper function __init_zone_device_page().
>
> This is in preparation for sharing the storage for / deduplicating
> compound page metadata.
>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
