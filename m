Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B11FA6
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 22:07:21 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id 2so16522117pjw.2
        for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 15:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uGTALhbZONK07EnTqNzLb5OFo7sOJ1WnH/JS/fksxZ4=;
        b=qW44w090em7gPbYvbMftkAX4Kvke2EP4xsZopvyQYxJet+uD2q9FrkvME10M9tUtmO
         X0ArALnU4GOM4RpFLYtr4bx0MpBZA554kHWbufBfTUNaqHhLHDjr51XHQdOPMxkQgCXg
         NV0mdNXOuzxeZUNmauE//Xw4ily3/UjO/MvX7UN7+CVRdmJUV6HF15N4VgrrGumDREwQ
         mQr7NBQxJVjAKI7QuaN+TbxUCnrDwve7/GDCashxgzsy+utUcS00v8RMdQzi18ZQO+sj
         C3gytJIJs+P+LCAmm5F7B8ZgvVAvSUSOeGPK1NcM/2jE17EGM2aXjbAO22u5NH5fWlQJ
         NrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uGTALhbZONK07EnTqNzLb5OFo7sOJ1WnH/JS/fksxZ4=;
        b=SgBWGlNgIF8FPFfSZ/ApfEIG/vFmvbShJsk8RgyDnwcsPTipaD2F1XoyiOc/YRrRZ2
         Bm9x/4Hy642KKjW0tUvbVA2b+D83gTw/QxVb3zTXjkHbRJUGcc1OZlTgGu0817yjCysU
         4tAITG/4nqVGGplimAdVlWQC/dmzCa10SntTqOSmyFisrFbFf8PsQ/pTBjgtgY3PElSe
         uawuv7MH9cEo4NAlhsKrqHpGeKHWPIrzlOrrFH+i4RWF1Nzi11KdQ55KvmilW/C4MLFE
         0W+jX6+tKL0a86nOgq/7NlAzC6zMl9xK5YM+YQXEsZPl/eonIKP7gC48obvC0YVmTA3m
         oYog==
X-Gm-Message-State: AOAM533KEr5HmOgmsgK6ikLBEX9aYU4CH+WPOOvtBB0V1sGCqKWZLNki
	xC/s483dZWOSZAg55pjVFlWKRbBQ1g6kzsDgFsVxPw==
X-Google-Smtp-Source: ABdhPJynx2l3cB2Gnxdh26yL6kd+AAVfXhzzqC3Ft2s9qeSNSOaR3yfL83lS+0+wlt4mWc4yp2miJE+sHJq1HcNQSls=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr11070951plg.147.1649714840717; Mon, 11
 Apr 2022 15:07:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-2-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-2-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 15:07:10 -0700
Message-ID: <CAPcyv4gr7YzrmqNhA-S8h-nRhpr8OHhUkn16c8jiL1U3ypp1wQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] x86/mm: fix comment
To: Jane Chu <jane.chu@oracle.com>
Cc: david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> There is no _set_memory_prot internal helper, while coming across
> the code, might as well fix the comment.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/mm/pat/set_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index abf5ed76e4b7..38af155aaba9 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>  }
>
>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed
>   * a pgprot_t value from upper layers and a reservation has already been taken.
>   * If you want to set the pgprot to a specific page protocol, use the
>   * set_memory_xx() functions.
> --
> 2.18.4
>
