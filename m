Return-Path: <SRS0=x1B7=2Q=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328CAC2D0DA
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Dec 2019 17:49:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DFD1A20828
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Dec 2019 17:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="s7191fmu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFD1A20828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 78A1C1011367A;
	Thu, 26 Dec 2019 09:52:29 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::342; helo=mail-ot1-x342.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6B11B10113304
	for <linux-nvdimm@lists.01.org>; Thu, 26 Dec 2019 09:52:26 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 19so20754624otz.3
        for <linux-nvdimm@lists.01.org>; Thu, 26 Dec 2019 09:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jODvApVPoLS2fokNHtaqYPuM9BD3Dfb58+fIaxBPOzA=;
        b=s7191fmuubvVFXN1uLbfPei5f4hISNJCwFDtd/Lzbev7OfKXvuDxLtvB1HnR8XvChC
         Eia5wp0Y6xDiliDDzxrzzpnvNSVKvUZ0bS4K8dwL6rAuRCiOjWR1XcEnaqaHHAi/85si
         lxRUSaO+MzA6BM4b7U6lyRzeEZTzcrou1SVcHiZ6sYb3+wcQhmlwfTH7zXpKn3ILkG1k
         KMgpCg1drOiF3uT+cWQp51LH98W1r33eVYR/C5OwscARboU74Qv33CBq0kYB1utPbHso
         B7AguakbxUY6gAhHYlEUZrZrkojKVLra6EjBxo3k+0eYEnK+ZMNCJF4FevOM0grvqe7p
         uyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jODvApVPoLS2fokNHtaqYPuM9BD3Dfb58+fIaxBPOzA=;
        b=XleLMnhPh/eyYzjyld5RBvAaijWBCueIe6QD7hzLqhjDGEV8xZ5uZKlzdaxCZWgHLL
         C91ObB5j8q0GEHgNSKSggx/5U/UyfW0ngdVZBZAgbXDxOeFhTN3q8dqOuultKEbi5Nqp
         SxTcJwyzLi5LnTnYAx6GSXT2EgC12pwz4CMxpwcB16hXITGkC1qRhLGjvhWqwHdG5/F5
         QkSEIePmUahZENZNm2gefQnNqiiTxT20el4wDKyuzqMidC2E+kMVm51DNZirmmtveBeQ
         qKHS0DJhCfctmd9fif7FauAkhHLMoBYZCa861CWC20d26odxSOsOwn7rJJnefpE/ShJx
         E0sA==
X-Gm-Message-State: APjAAAWQbUYXnUuMY6+5Bc9fQkk3iRu77REFslAdC0aADijYUpt0BoFA
	52aWqx3Ga0DLCyWd/40WlWRSnlDKN6JT556xv5zb7A==
X-Google-Smtp-Source: APXvYqwXvmwHcfjrFs5hR+NHzXAuDOdo6Z5QHm6zaTisJunSK68qHspp7QYSq0GVd4EPkucpNvqnmQqtnDza7WsohPE=
X-Received: by 2002:a9d:68cc:: with SMTP id i12mr15701921oto.207.1577382544809;
 Thu, 26 Dec 2019 09:49:04 -0800 (PST)
MIME-Version: 1.0
References: <2369E669066F8E42A79A3DF0E43B9E643AC9EB31@pgsmsx114.gar.corp.intel.com>
 <CAPcyv4jTS+JcmH=Oe3Js0dw+Ovu+P6yBKHDZp8xxUT6Rbhpaqw@mail.gmail.com>
 <SN6PR11MB3264D981A619065F1A4EFFB992280@SN6PR11MB3264.namprd11.prod.outlook.com>
 <CAPcyv4iP1NK=2funtr6yp9VhedntKvzkvBsXDkLLXt6FBZYO=A@mail.gmail.com>
 <SN6PR11MB3264C140FEB5C66679095AFF922B0@SN6PR11MB3264.namprd11.prod.outlook.com>
 <SN6PR11MB3264617D4EA3C3C4706C7C6D922B0@SN6PR11MB3264.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB3264617D4EA3C3C4706C7C6D922B0@SN6PR11MB3264.namprd11.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Dec 2019 09:48:54 -0800
Message-ID: <CAPcyv4iFZUzhTG+6L=RExcJOCeLak7aEbX_A=pGga4Bw+467dw@mail.gmail.com>
Subject: Re: [PATCH] daxctl: Change region input type from INTEGER to STRING.
To: "Li, Redhairer" <redhairer.li@intel.com>
Message-ID-Hash: YFXHM5WJM6ELBAH6P3WX6YW2JVT7DVJD
X-Message-ID-Hash: YFXHM5WJM6ELBAH6P3WX6YW2JVT7DVJD
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YFXHM5WJM6ELBAH6P3WX6YW2JVT7DVJD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 25, 2019 at 6:22 PM Li, Redhairer <redhairer.li@intel.com> wrote:
>
>
>
> Build error is solved by following change.
>
> diff --git a/test/Makefile.am b/test/Makefile.am
> index 829146d..d764190 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -98,10 +98,10 @@ ack_shutdown_count_set_SOURCES =\
>  ack_shutdown_count_set_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
>
>  blk_ns_SOURCES = blk_namespaces.c $(testcore)
> -blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
> +blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS) $(UUID_LIBS)
>
>  pmem_ns_SOURCES = pmem_namespaces.c $(testcore)
> -pmem_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
> +pmem_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS) $(UUID_LIBS)
>
>  dpa_alloc_SOURCES = dpa-alloc.c $(testcore)
>  dpa_alloc_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
> @@ -143,6 +143,7 @@ device_dax_LDADD = \
>                 $(LIBNDCTL_LIB) \
>                 $(KMOD_LIBS) \
>                 $(JSON_LIBS) \
> +               $(UUID_LIBS) \
>                 ../libutil.a

Ah, sorry about that.

Hmm, are you running this on top of Ubuntu?

We have had a long standing problem whereby Fedora autoincludes some
library dependencies and Ubuntu does not.

    011fc692270b ndctl, test: add UUID_LIBS for list_smart_dimm

Please send this as a formal fix patch.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
