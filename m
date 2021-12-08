Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FE2CA6
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 21:48:32 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so4176427otg.4
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 13:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pr04vC42Xgru+ljjY2RIXTIfLjbNYKZ9r1zFIGxcXoY=;
        b=k/wNAZ/AuybVkjvZk0AVbEel9i/byaYc0RHKeJ2Onbw5Ljfcu6Xnyj+9LI990TvN17
         gXDf3i6QbS3XX7dPGW+YLDZbyI3mtMNb6MFuI6VkXJ2O5oQe1Uo9Lyl0tVWguuywJCFa
         mHqOkMKQ7PqxaxmziyGmPdBP2mwA1hnS8p5uWaBGotrHYNv/cjDPcj+3Mak8UWIy7h20
         QRoBVpj+nzyt0Aw0Gbh3QeSkhPXMsa+KU1FHYIgJauwm8Rp5LV1wfW7uL+xJ1Uc7JCNu
         JH5dQF7u7GU18e7C5LWtAiUmjGqBiEBBNuc1jv2kxcgrVTM4eUd3S52SC7tCDUm8G3Ny
         089w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pr04vC42Xgru+ljjY2RIXTIfLjbNYKZ9r1zFIGxcXoY=;
        b=LjCV+Ss9yyvEx8ly4knm+YAEXC1gMqVtRbrQLjkNrPLRha4Hlcu822B7VBMxQsTP8t
         NAxqaeaEcsBfE51vgFcSSUpii5ptnjD8Lu7yV9DMddDqajYIYWXIML6hMQNe5HHYAVkg
         IqFyRjwpPESDSLKsGUfXxmA4nZkqwRWZAE89m6BFrzRbIp/8SnhLthqEyg/TdpFSsZ8M
         rYG1Dhk080v+09JjvSemy6xzFnWqlW2T5c733DTOG/SRXnk+RRpe2xroNjcohPq87yMf
         1cdUH0YA1ceYRZYwcqUsWHmB810NWDCLM1tQnU+KD/5XwsF/Tqmshe6H5yz8IN7Io8mS
         zTlA==
X-Gm-Message-State: AOAM532KNg0SEHl1G1AMILMBlOuOrTD8r1TWFfZqraPvWnYMWFjX9u2+
	viYUxbBwxbhQ+i8Y3zK1AE39C9l8y8/sKmObArdM9A==
X-Google-Smtp-Source: ABdhPJytBuTjeCKfp6rkBQCmelcmlaBO2OidL/00Nfjy7FVsSkc8RPlf2x7l4LB3x9S5XMeU0lGhMFLO6K5igGgZaaY=
X-Received: by 2002:a9d:7dca:: with SMTP id k10mr1870023otn.274.1639000111567;
 Wed, 08 Dec 2021 13:48:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-7-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 13:47:57 -0800
Message-ID: <CAPcyv4guhW3=JAyZ1o4cwRWCZzrUyzdqGqtc4ZtCFwwStoxhzA@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 06/12] ndctl: Update ndctl.spec.in for 'ndctl.conf'
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The new config system introduces and installs a sample config file
> called ndctl.conf. Update the RPM spec to include this in the %files
> section for ndctl.

Modulo new ndctl.conf.d directory name:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl.spec.in | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 0563b2d..07c36ec 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -118,6 +118,7 @@ make check
>  %{_sysconfdir}/modprobe.d/nvdimm-security.conf
>
>  %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
> +%config(noreplace) %{_sysconfdir}/ndctl/ndctl.conf
>
>  %files -n daxctl
>  %defattr(-,root,root)
> --
> 2.33.1
>
