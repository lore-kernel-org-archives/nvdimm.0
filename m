Return-Path: <SRS0=UChI=AT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D41C433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed,  8 Jul 2020 10:18:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE8192084C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  8 Jul 2020 10:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fossix-org.20150623.gappssmtp.com header.i=@fossix-org.20150623.gappssmtp.com header.b="HO/KpHv/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE8192084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fossix.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ACB05110E5FDC;
	Wed,  8 Jul 2020 03:18:16 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::644; helo=mail-pl1-x644.google.com; envelope-from=santosh@fossix.org; receiver=<UNKNOWN> 
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C8D7C110BA974
	for <linux-nvdimm@lists.01.org>; Wed,  8 Jul 2020 03:18:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so17096881plm.10
        for <linux-nvdimm@lists.01.org>; Wed, 08 Jul 2020 03:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Nu8tMtS1CHOKv8Npsd1m3FEiYGh7b41rILIM3J0Mdk4=;
        b=HO/KpHv/Nn8ouKpmUwHdztzP4s/lq60LCvz93pKcwy5knT+gcgo4pb7Yamrg2xKbag
         HQVdoU9bHDAK5XHWvolnuJL0IYRZ3loCWrvpfvI6KXiPe42OJ99kws2zzBltPpUm9P2p
         1eGKzF7ljnOw96aclOjCblMhML83dAwjsunNti6FhtJdNbcC6Ee5BKAaoAp9TcvkmBZO
         FxYWe4vIuuj/CsF1keO3zuMmOvunD1CmcdjYcKvvQTH+fT8e5gTbScAH8VqqSwlzRyKk
         CAG70y7mB4+x1YnHPSfYOb0lFip7iSmkVjWd6oQ7q2oxZ28ay26pni57duu5Y35M4kQl
         YOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Nu8tMtS1CHOKv8Npsd1m3FEiYGh7b41rILIM3J0Mdk4=;
        b=J8vnRkhWS/eKL26CwONOkQ/76PwnAuRgh3vYdhk/hfEq4KS1q1CqTczgRF7/+VFMWN
         QD8ygRFqBmp3GhFNS+iwITZXuf3v5fcBA/Y2heim8MmPQUCEEpNml78XSen7rnJfHiOO
         O5LrhFuIte9pB5RA6h/dDU8CaKjcD9W6NlQ3iDJtXKgOTL9kSsFD8t1eCiJhCTFXRrOv
         fp9W9MjUtZUHx8ENm55Fg72tI9Ufw+HlqrQ0Q6+4Ti7wZ5wE4qY97dYTA8MWJ1Ovn5oS
         BiURm04r1TEi3tpXlOail2Q8xY1RHJvi1Mtdljz/qFD4TQj/9CPYUXs3zm9SIXLj4HGc
         Y9xw==
X-Gm-Message-State: AOAM531t93HSlQPKsUwEKQ6xDqj1QvWDMejpRpauAREiw957NUhmzvpJ
	0mGUgG5GrNUB2SxxRo3ZRC1Mhw==
X-Google-Smtp-Source: ABdhPJyuBab+f0kOA9xJ+EH0O6BmGeBMoUhHDkVDa6b+rNsK1I8jKljCpYm8CUsJnh3zAi5C4SR+og==
X-Received: by 2002:a17:90a:6acb:: with SMTP id b11mr8729198pjm.71.1594203493290;
        Wed, 08 Jul 2020 03:18:13 -0700 (PDT)
Received: from localhost ([203.223.190.240])
        by smtp.gmail.com with ESMTPSA id br9sm4651498pjb.56.2020.07.08.03.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 03:18:12 -0700 (PDT)
From: Santosh Sivaraj <santosh@fossix.org>
To: Harish <harish@linux.ibm.com>, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, vishal.l.verma@intel.com
Subject: Re: [ndctl PATCH] Documentation: write-infoblock namespace as mutually exclusive
In-Reply-To: <20200708072319.10896-1-harish@linux.ibm.com>
References: <20200708072319.10896-1-harish@linux.ibm.com>
Date: Wed, 08 Jul 2020 15:48:06 +0530
Message-ID: <877dves42p.fsf@santosiv.in.ibm.com>
MIME-Version: 1.0
Message-ID-Hash: VECFAPQ2ADUI3MEJO7L5SPQY7KXICFTG
X-Message-ID-Hash: VECFAPQ2ADUI3MEJO7L5SPQY7KXICFTG
X-MailFrom: santosh@fossix.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Harish <harish@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VECFAPQ2ADUI3MEJO7L5SPQY7KXICFTG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hi,

Harish <harish@linux.ibm.com> writes:

> The write-infoblock command allows user to write to only one of
> namespace, stdout or to a file. Document that explicitly and also
> change the usage string to indicate mutual exclusion.
>
> Signed-off-by: Harish <harish@linux.ibm.com>
> ---
>  Documentation/ndctl/ndctl-write-infoblock.txt | 14 ++++++++------
>  ndctl/namespace.c                             |  4 +++-
>  2 files changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/ndctl/ndctl-write-infoblock.txt b/Documentation/ndctl/ndctl-write-infoblock.txt
> index 8197559..c29327d 100644
> --- a/Documentation/ndctl/ndctl-write-infoblock.txt
> +++ b/Documentation/ndctl/ndctl-write-infoblock.txt
> @@ -61,19 +61,21 @@ read 1 infoblock
>  
>  OPTIONS
>  -------
> -<namespace(s)>::
> -	One or more 'namespaceX.Y' device names. The keyword 'all' can be specified to
> -	operate on every namespace in the system, optionally filtered by bus id (see
> -        --bus= option), or region id (see --region= option).
> +<namespace>::
> +	Write the infoblock to 'namespaceX.Y' device name. The keyword 'all' can be
> +	specified to operate on every namespace in the system, optionally filtered
> +	by bus id (see --bus= option), or region id (see --region= option).
> +	(mutually exclusive with --stdout and --output)
>  
>  -c::
>  --stdout::
> -	Write the infoblock to stdout
> +	Write the infoblock to stdout (mutually
> +	exclusive with <namespace> and --output)
>  
>  -o::
>  --output=::
>  	Write the infoblock to the given file (mutually
> -	exclusive with --stdout).
> +	exclusive with <namespace> and --stdout).
>  
>  -m::
>  --mode=::
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 0550580..cf6c4ea 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -2346,7 +2346,9 @@ int cmd_read_infoblock(int argc, const char **argv, struct ndctl_ctx *ctx)
>  
>  int cmd_write_infoblock(int argc, const char **argv, struct ndctl_ctx *ctx)
>  {
> -	char *xable_usage = "ndctl write-infoblock <namespace> [<options>]";
> +	char *xable_usage = "ndctl write-infoblock [<namespace> | -o <file> "
> +			"| --stdout] [<options>]";
> +

This is now consistent with the man-page.

Since size (-s) mandatory with --stdout, should that be included in the usage
too?

  Usage: ndctl write-infoblock [<namespace> | -o <file> | -s SIZE --stdout] [<options>]

Reviewed-by: Santosh S <santosh@fossix.org>

Thanks,
Santosh
>  	const char *namespace = parse_namespace_options(argc, argv,
>  			ACTION_WRITE_INFOBLOCK, write_infoblock_options,
>  			xable_usage);
> -- 
> 2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
