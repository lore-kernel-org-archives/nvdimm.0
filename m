Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF8B36C
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 07:32:14 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2e64a6b20eeso208589257b3.3
        for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 00:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjTDi9n/uLRqxVKGGOaPNySXftZQ6axRJXtPfIo5LUI=;
        b=oy0ldmBjJZfRyL+iZuZ5FQ/Inj2N4hflGyxVltzKvGdTjhOYfkFX8SjWEA2uOlOnz3
         AKOfxviF2B7L+/oZuIvzhkjT00ZrJliFLYhLF5UqAOo0/bMIjxjKCLujhnabL6gKCGgO
         6MdTSmLe+CDGS2g1FopXywQUJWfY5c6avaXqJbsJKiYkTBJ/0avOJLEK3cVY8YflI3R9
         9ZHjM2AsS6qJf+rw0uC4YVZdhi463GG9MmJXC5ZHSj13srAq2ZRVFVYkCDQ6zhypRruU
         I5qQRa/lQIUTWj8p7n28JUDfMbQT8CfQr4x1Gd54i7/6CAtDTanLGOYFGb9GZwXKSAon
         h4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjTDi9n/uLRqxVKGGOaPNySXftZQ6axRJXtPfIo5LUI=;
        b=Bdf3waIswgAO6p96/eU+d1nStmMiGZvqBlvNQvepVEOQ9V6siG8AUHuIheG/oDTmA8
         MsXX0Zmk4MfAWjQRciZ1XsGy1Hry5kiym0ZS5Us8Sc9D9CRqPOHZnA31Qhk8qUDgm6nb
         ETFgbbuRP1u+Q9AHM1/E+E6ZvV7MMs4DtIplXJgyPqQVZVOr7TaeUWsGS7lGvIICarj7
         VbwZ5Q9RCXOgAlvyh3VQy0yUyyacgKI1VvgTf9FlxpdhALT+EgMghAYw+KC5dz2xRdWO
         phwRfOVnDu0ySetrYg3zQ3l6mjlLK6QvJ8rL913KlOoMY0W0L/4SI3EpwGWQ8Pu+Warv
         wqSA==
X-Gm-Message-State: AOAM532ZUrJ6dbcmNmNvPwyiV6qw7WcPa5wHUATd/QW0lqBA9vFiYuLn
	VlhfcmwrKMhVXIQcXNVUYpi9vne09X2NUaYcPc2B1Q==
X-Google-Smtp-Source: ABdhPJz47F/zt8DASramM8wZ7Ct2jmaZz8jkBg/c3k72v2zUuDdQNpuEmcP5Le6BlzGgL/Da/aZVgVfRA9PmmuG+3Qc=
X-Received: by 2002:a81:897:0:b0:2e5:f3b2:f6de with SMTP id
 145-20020a810897000000b002e5f3b2f6demr35325738ywi.141.1648625533474; Wed, 30
 Mar 2022 00:32:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220329134853.68403-1-songmuchun@bytedance.com>
 <20220329134853.68403-4-songmuchun@bytedance.com> <YkPu7XjYzkQLVMw/@infradead.org>
In-Reply-To: <YkPu7XjYzkQLVMw/@infradead.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Wed, 30 Mar 2022 15:31:37 +0800
Message-ID: <CAMZfGtWOn0a1cGd6shognp0w1HUqHoEy2eHSWHvVxh6sb4=utQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Xiongchun duan <duanxiongchun@bytedance.com>, 
	Muchun Song <smuchun@gmail.com>, Shiyang Ruan <ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 30, 2022 at 1:47 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Mar 29, 2022 at 09:48:50PM +0800, Muchun Song wrote:
> > + * * Return the start of user virtual address at the specific offset within
>
> Double "*" here.

Thanks for pointing out this.

>
> Also Shiyang has been wanting a quite similar vma_pgoff_address for use
> in dax.c.  Maybe we'll need to look into moving this to linux/mm.h.
>

I saw Shiyang is ready to rebase onto this patch.  So should I
move it to linux/mm.h or let Shiyang does?

Thanks.
