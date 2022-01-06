Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A08168
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 17:08:26 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id gp5so3001058pjb.0
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 09:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/HMCfYkQLqC/tzBB9VloCoBpRqs3lmfc/m+Izvs0OL8=;
        b=KCwpucCyPQJiFa60oquZO8qm5fKFk8sv3AE4jQKvr3hCG+vNlMPWq9JhQtgJocbWI0
         qXLUMEOQpvm6Ynuvuj5CVvwKX+ks/+ZGFJnErtI0EsabbSc6OB9lu9PKv9hwyTEfGB34
         laMzBWoNjmmLxWn2aRb3bMczpc9JSlWjBkGnlWwDMNF5HP249AQjUdfhXuRGmWN7ZEF8
         MaXy/biZ03zE5IprnrV37U3SRRjvHZ78MG5IDR1nVfp46iu2aYw7ck5cDcMWbpB0pDmt
         X2D2gWM/fa6uutcPzbh4UitSb2DJBDa2jZM9JkZ9nHy71SHJmVCshl6hCCxKY8T4UlAi
         WyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/HMCfYkQLqC/tzBB9VloCoBpRqs3lmfc/m+Izvs0OL8=;
        b=m6csFiNwxC2M3IoqT+iawgRJ6wSrg3UVvVuYoD+56QgSDbnEoR8TDda7NW90IqxfiB
         vo5uj2Hk1vKt997oxQU2rXOHd3WHfUz9Tb28l1U3iX1uHLG8MmoVbbh3+muQI+2zX9pb
         xAklai6DzVgFOQVBybaSHmvpTGuQFJbiiPM73YUsfGwqLDqV8xqelOfTjZkhYe+RWWdu
         2VLdMxnuy/4A4uwUy2Vqp5NUuoN3fvsFOVlCjd+GZUZeCVeiIhNGaXnBoY7xZkk1OPmF
         wSodaD6bEuE7AUHOXrjuwvvR0Kh/B4ZY23I7kz5Lo0ucHntOnb9UtmlLZXnb9cg0ZrXy
         mN0A==
X-Gm-Message-State: AOAM533rsvQvmv/jyf4x1pK/W78/05W2upv9129G9JznEzh910CFhJuM
	cE427T8XP4vZIN0PmjM2tAKMgkmm8x+gBpw0tY01ZQtya/c=
X-Google-Smtp-Source: ABdhPJxRuhjPQph8Jke/XeZj+5AyUQZwTLVYIlNT/LfJB61I3vN7hdATlVKk1fZbrOx2aGDOiUfP6fetmXnH/nUdjqQ=
X-Received: by 2002:a17:90a:7101:: with SMTP id h1mr11019892pjk.93.1641488905956;
 Thu, 06 Jan 2022 09:08:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220106050940.743232-1-vishal.l.verma@intel.com> <20220106050940.743232-2-vishal.l.verma@intel.com>
In-Reply-To: <20220106050940.743232-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jan 2022 09:08:14 -0800
Message-ID: <CAPcyv4hX6rZrcB5FjSbzaUh6HZ9bodwA8gqvsW1+c4-D7jfhfA@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/3] scripts: fix contrib/do_abidiff for updated fedpkg
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 5, 2022 at 9:09 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> A recent fedpkg update wants --name instead of --module-name.

Ugh, how annoying.

>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  contrib/do_abidiff | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/contrib/do_abidiff b/contrib/do_abidiff
> index 0bd7a16..e8c3a65 100755
> --- a/contrib/do_abidiff
> +++ b/contrib/do_abidiff
> @@ -29,7 +29,7 @@ build_rpm()
>         version="$(./git-version)"
>         release="f$(basename $(readlink -f /etc/mock/default.cfg) | cut -d- -f2)"
>         git archive  --format=tar --prefix="ndctl-${version}/" HEAD | gzip > ndctl-${version}.tar.gz
> -       fedpkg --release $release --module-name ndctl mockbuild
> +       fedpkg --release $release --name=ndctl mockbuild

Would it be worthwhile to document the version of the fedpkg that this
script targets?

Otherwise, looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>         [ "$?" -eq 0 ] || err "error building $ref"
>         mkdir -p release/rel_${ref}/
>         cp results_ndctl/*/*/*.x86_64.rpm release/rel_${ref}/
> --
> 2.33.1
>
