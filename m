Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D75A1844
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 01:34:20 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id z4so737860pgh.12
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 17:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vvTayVguxhrumT3w+R+Kjfmd3diECndIkorPQyxblp0=;
        b=NFjoQ+hOdtNnkcduj0LnOAfr0t13qJU0g+H3qDYhxHXNY2kSOBhjJ57id3nggkZ63z
         bd+0no5Sz1hfOpOM7FqU7/lcj3mw/zA9iIJGXn1/3gABVkhTJwDuVFXiLCiF+AoiAuvP
         xzHa0AMAlBDyRB3g8rVKOe7JL6peWAms2JmtnTljT+4i1CykaarkkcY2Phufrs+l4f98
         tIBmQaYCJwnUN4p1EvcyxZr3Y2TIDezPhrxlygMSyqcqJutwde5Wmrbzs8FUsbjeBtAE
         KAXJkvUlQ4SnUi7Ml0QZWal8mO29LLZbB5qS5ZaYGR1b1d2ZM10qVKD8leaATzhRe6MQ
         OvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vvTayVguxhrumT3w+R+Kjfmd3diECndIkorPQyxblp0=;
        b=E/qoNOqRt6q3QZyoWpnGjFMDRuOFrxm1FjZlxkWEMB1Wa3Q0/HyOTOc0vOu6HgHsOF
         M3JmpSrGwxqVDlns2ht5pLR4WsLGp2NsIOC0C5tvcsypWc2ZY6AhclYi3LNphcNGcnbF
         2Ijo/VW4MjMNRU4mqPMx1jmYW79aKZ09CqqL3mMq7nd/4E2P9QuozXJ4l/iGiSK0ULZO
         3KHzSAYZRnSJHpLXLz39iuXWSdGZPJ4g6bxoq+H3mmKAuKVZXofDRjWyivtW6MDZrylz
         o5fjEUhlKRCBahrW65uclhHqlfqesTqKiA99Qye3d+MTusl0MprqhH6TX4N7v2MpER8i
         U9jQ==
X-Gm-Message-State: AOAM530v3uj1eQeBsHeM15lpmd609HdcDhRD+zbPP/h4iUvTekZELLq7
	dN9zyZ72E6zdgc+J7AmQtXHaWMbTShaNu6Bve63sxQ==
X-Google-Smtp-Source: ABdhPJzAqkHS4nuPDQC4F8eXmkoN7S6evLhsGsn+9OiK2Onw6wqEebsZdEzEmmlrTDiHX9fR4bL6Yj1AYLHUkW1bqes=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr370669pgb.74.1644975259581; Tue, 15 Feb
 2022 17:34:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-6-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-6-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 17:34:12 -0800
Message-ID: <CAPcyv4jWuWWWBAEesMorK+LL6GVyqf-=VSChdw6P8txtckC=aw@mail.gmail.com>
Subject: Re: [PATCH v10 5/9] fsdax: Introduce dax_load_page()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> The current dax_lock_page() locks dax entry by obtaining mapping and
> index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
> to lock a specific dax entry

I do not see a call to dax_lock_entry() in this function, what keeps
this lookup valid after xas_unlock_irq()?
