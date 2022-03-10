Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4937A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 01:02:17 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id bx5so3825633pjb.3
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 17:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IhfcqA5j4A8+cMHFR/NtiJjgNVB+qOjhOgFLJgToPWQ=;
        b=NdlCgpyR4b6VJWwPwqOC1MX6c6jvcptN0j9px6P5gSJixNo6VOfOmyZRxxRxE+VcE+
         3nEGij+QWTIieZfJjhT4HEQ3r8HlS19ooIBYayhvUymBhIQ9hyFgxtJgI8pCRkAg+1pQ
         wZsyJA2tqg/k12oz9Zx1hzeXs53PX/Kj85fAbo2oA10eW2hvyuDPgEUBhgXI6pkk7Y4r
         4/vjzDmA4LTjsDjSdL3djqJkFB/CcFZI7eYmB7zcVbZW/JYEKjHk2esCGc2dbDEPdE6T
         FFVi6RCbUv4X+dMgyidWvaHx1H1e/ThhA9xh9EmPmn8MxL3p8c6rsvYdZ7ZqiLAGwoMG
         82mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhfcqA5j4A8+cMHFR/NtiJjgNVB+qOjhOgFLJgToPWQ=;
        b=q0gHw4InHsEeUb45L3ryU1Yvqbsrnccey66/wKN438DSjomTuhqMgknlZGv/dWCQqu
         2pIPW4xcxkwdhRyhS5EACbUJ2lD4OU5uV1HqNRA0Mzn7FxVKQpJo/E7fTerx8b/A6OQX
         u0L7aIZJWl2+lNElsShEQNzwX/Vuv2Iliu37CIIl/Wp4vLy2NRjq99bATuzeqPsLiD1P
         ce9mWvhBKgR57UJX4GUFjgc3Ld5t8ZziBV/h+9T0eMjzFWs3DzW2VwnDslA1BnIcqu28
         jVtNK1+R71aQwWIYMmyXT6dXFinTfEhLMmNyEnjK6blwZunzIuBkbT0n773dRbyPCPq/
         ON+A==
X-Gm-Message-State: AOAM532xjGOl7ZYjiEpIUVQ/aitmVXslvgDaVq5bbUOkivbwq4Qa+cb9
	66Moq/GAh4PVD4kQo0Rs/6LKITFL803Grkh+uhx9dA==
X-Google-Smtp-Source: ABdhPJwgZUATGKxceYX9Kl5KUvMdd8JlCChq4tHFBS02sVXYJrllv/gFImd7TLQzyeaZBA7iP0auoWsyQWoxXaoDMk0=
X-Received: by 2002:a17:902:d506:b0:151:ced2:3cf with SMTP id
 b6-20020a170902d50600b00151ced203cfmr2284734plg.147.1646874136625; Wed, 09
 Mar 2022 17:02:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com> <20220302082718.32268-7-songmuchun@bytedance.com>
In-Reply-To: <20220302082718.32268-7-songmuchun@bytedance.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 17:02:05 -0800
Message-ID: <CAPcyv4gnzDMWgzw9xW6PLRvDgw18RL35NtWsKYRV391SRWSuQg@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] mm: remove range parameter from follow_invalidate_pte()
To: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, xiyuyang19@fudan.edu.cn, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	duanxiongchun@bytedance.com, Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 2, 2022 at 12:30 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The only user (DAX) of range parameter of follow_invalidate_pte()
> is gone, it safe to remove the range paramter and make it static
> to simlify the code.
>

Looks good, I suspect this savings is still valid if the "just use
page_mkclean_one" directly feedback is workable.

Otherwise you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
