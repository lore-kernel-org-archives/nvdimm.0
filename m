Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0615E7C
	for <nvdimm@lists.linux.dev>; Mon,  7 Mar 2022 19:45:12 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so180656pjb.3
        for <nvdimm@lists.linux.dev>; Mon, 07 Mar 2022 11:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+WHw8wA+vLWo7oWVtkmkJtckazm4Tpbyl0j5hRmc72I=;
        b=gpei+/4EfKjAsEiFmyCoss0es55XdNV/tLnLM4Ifn//Ypim9wrM+g4DLOrpfAi2jxw
         f2Eem1sye+ZMOwglmQow3S7YjlZkfCb++20GNxd4mnl61q2/P+Cz8RVOylmpLWbBLF/1
         mfv3btzpQkiGD0kRRHoqXqSAO00OIqF5VvxStUDSCgz3c3roWX3LM41yu2SdS6hsggqg
         cl/VK4BN7lrKN19QDpEQs1ds8+D32Gb8c8b8z4T1BJ4RoRRXQ7+z1ucnEzqDyJepnsk1
         ppj63nykJRY92HrJNIiT9Nenflksu7g0DWa8UgrkPiAZL2Tv2GN8yHtgSaZsHP4sYrPT
         quaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+WHw8wA+vLWo7oWVtkmkJtckazm4Tpbyl0j5hRmc72I=;
        b=47LR7eTNJy/ETyApI+PFkbFEv6sJN0FFhRflTIaanXRcxK4DzA4coWtBP2ZW22Mwny
         pZKZcqPTSxzEwhYtYdyw+AvLbR+e+9pM0wNw/ocDg7M6UvxyaATiBzwvxqzLJY/sQod1
         ite98Uj2vbk0WTy2/tmE74NMzuC1TSvfRfG2Su2ayuuKVZhXJI5gCn+eO9GBW9EXrYXR
         Ol/G7+BV8IZ2HNI++dzajjHcPNzYEF4LLJD3jRUwUAF3BSFWTGo/xmJMBH+p2ymJ4Viu
         L8a7WcC0++GxoxjI9DGAFlMQhunQCjWlZ8wjxNhNKFQCt0sp+Wwfm1y53QYRiWSWb/oZ
         azWw==
X-Gm-Message-State: AOAM532RJ7YQqxdK9ju1C4ceBbzRkIEOSnHDjOaPECTPKCNLkLixQfPs
	xSbTDBTqiwfehr1dXpvpW9F/f+nPMsSHja+VOmG/hJtcRa8=
X-Google-Smtp-Source: ABdhPJxnRsAAcSNpEXBNXt/NhFr/cu8MX1539Vqy3+b4g7eIeWBOXSBQcRkrZZv4FSk04k0MJnpewFJEV0Cf4i5UIkA=
X-Received: by 2002:a17:902:d506:b0:151:ced2:3cf with SMTP id
 b6-20020a170902d50600b00151ced203cfmr13917431plg.147.1646682312109; Mon, 07
 Mar 2022 11:45:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304200643.1626110-1-vishal.l.verma@intel.com>
In-Reply-To: <20220304200643.1626110-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Mar 2022 11:45:04 -0800
Message-ID: <CAPcyv4hLnbEfg=1kQ5WZ6-4OpG5s+Amrc7nJCa+amgYWJKX0yA@mail.gmail.com>
Subject: Re: [ndctl PATCH] scripts/docsurgeon: Fix document header for section
 1 man pages
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 12:07 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Document header generation for section 1 man pages (cxl-foo commands) was
> missing the section number in parenthesis, i.e. it would generate:
>
>   cxl-foo
>   =======
>
> instead of:
>
>   cxl-foo(1)
>   ==========
>
> resulting in asciidoc(tor) warnings.
>

What was the warning? Is a "Fixes:" tag appropriate?

> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  scripts/docsurgeon | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/docsurgeon b/scripts/docsurgeon
> index ca0ad78..1421ef7 100755
> --- a/scripts/docsurgeon
> +++ b/scripts/docsurgeon
> @@ -244,7 +244,7 @@ gen_cli()
>
>         # Start template generation
>         printf "%s\n" "$copyright_cli" > "$tmp"
> -       gen_header "$name" >> "$tmp"
> +       gen_header "$name($_arg_section)" >> "$tmp"
>         gen_section_name "$name" >> "$tmp"
>         gen_section_synopsis_1 "$name" >> "$tmp"
>         gen_section "DESCRIPTION" >> "$tmp"
>
> base-commit: 55f36387ee8a88c489863103347ae275b1bc9191
> prerequisite-patch-id: 24c7dc0c646c21238e4741a9432739788c908de7
> prerequisite-patch-id: 2f5ab7c9c5b30aa585956e8a43dd2ec4d92d6afb
> prerequisite-patch-id: 6ffa6ce0ea258fec17fa6066e4ee437ffd26307c
> prerequisite-patch-id: 98f586353f89820d0b0e294c165dbbd7306cdd40
> prerequisite-patch-id: 83f078f0afe936dc6f0e172f59da14412981a030
> --
> 2.34.1
>
>
