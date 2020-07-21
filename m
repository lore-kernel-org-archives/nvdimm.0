Return-Path: <SRS0=RGaW=BA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5B0C433E3
	for <linux-nvdimm@archiver.kernel.org>; Tue, 21 Jul 2020 03:23:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 307DE20729
	for <linux-nvdimm@archiver.kernel.org>; Tue, 21 Jul 2020 03:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5h641+M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 307DE20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ED3E612440D5D;
	Mon, 20 Jul 2020 20:23:23 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::143; helo=mail-il1-x143.google.com; envelope-from=pankaj.gupta.linux@gmail.com; receiver=<UNKNOWN> 
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 70B62124059BE
	for <linux-nvdimm@lists.01.org>; Mon, 20 Jul 2020 20:23:21 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id k6so15189204ili.6
        for <linux-nvdimm@lists.01.org>; Mon, 20 Jul 2020 20:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vy/t34kGa+AL0KVS5scjg7XYMyIm/b9u03KSFMBJSXw=;
        b=e5h641+MTFpVytkoYyEBT4W0KfC6V02/Z7w3+CKkJAly6R0JfqLQaCO0C7qq3km8Wb
         WFDVdCc+hEhqY+nS4HFLOvKt9R07H5PBFgzLDAelPS00zA9xMjj/Ih3pNbOYAbJrIhPC
         Gck4m85PrjCgtsTuHQJGL2piphuPT+S7wSsvo8nkiY+ut+DqE2TREJXRiAPn//n8NWEk
         2ZjDXsGBtILiF7AcQoM9O+jhNE6e6dNiHDu9rpIxyw2sm2l/JyKflj0skGlvEuTsINQF
         Jt6rXMIQL3mPqZaXXRWmWnAASVK++i/79at+NWr9oDK1QgLvnlc6R5qYVw+XjfbnJeTh
         wL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vy/t34kGa+AL0KVS5scjg7XYMyIm/b9u03KSFMBJSXw=;
        b=GMZAY4rfRNy2nyf4Em97sZ0aFi5oIIqBBEnjDBEskNvWf4yOkC8tu3x6I7guTygdPb
         IqOsXwLVXvp6su1CiLH5oq+Zbrwcd5cNwgvKc/DY0K2njELTLqm2tSC1NSlEdgKo89gk
         pjz/aWa4HScH7Wq0wVMC/0IeNi0XdjcU0kaI17zvwuNsFgn0fxvUAmBj80U20BSAgX3o
         Asi0wTfMEPi3ZvXPyJRUEwacahe2gznbrPZZuibduKtP3iHPPumCf2ErM/r/b0QQNxUI
         9xupKJkWd+88bnGyr6G55KO7dYs0Y1X1tdffTwDAAKMuc+YeDqkTk5/Da6Rqd2oBz03w
         OuFA==
X-Gm-Message-State: AOAM531UnVUmh6J0CxTgH5c6+BYqhE5WfAzMTMHKlFC4yXE3CNBCjj0K
	OXVXwE0TEjBJFRZn+nruHwHuKbx633vqIvUU/qQ=
X-Google-Smtp-Source: ABdhPJzlqOcqKyey5YvPQM2wcN7pJpIFGRanN3KGGvW5kGMiePQ+aEHo+MR6gDJJj7Vv1ysgkHw3v0zs7bA044vZaeU=
X-Received: by 2002:a05:6e02:80b:: with SMTP id u11mr27228504ilm.178.1595301800016;
 Mon, 20 Jul 2020 20:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200709020629.91671-1-justin.he@arm.com> <20200709020629.91671-4-justin.he@arm.com>
In-Reply-To: <20200709020629.91671-4-justin.he@arm.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Tue, 21 Jul 2020 05:23:08 +0200
Message-ID: <CAM9Jb+i7wMqXWXdnaeXmRQN8w8305A5WRKsnE9PAkxgUs2c++Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] sh/mm: use default dummy memory_add_physaddr_to_nid()
To: Jia He <justin.he@arm.com>
Message-ID-Hash: 3LPEFBBV5HXNAE6MSSCFB6SLANV35TT6
X-Message-ID-Hash: 3LPEFBBV5HXNAE6MSSCFB6SLANV35TT6
X-MailFrom: pankaj.gupta.linux@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Chuhong Yuan <hslester96@gmail.com>, Mike Rapoport <rppt@linux.ibm.com>, Masahiro Yamada <masahiroy@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, linux-nvdimm@lists.01.org, Linux MM <linux-mm@kvack.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Kaly Xin <Kaly.Xi
 n@arm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3LPEFBBV5HXNAE6MSSCFB6SLANV35TT6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> After making default memory_add_physaddr_to_nid in mm/memory_hotplug,
> there is no use to define a similar one in arch specific directory.
>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  arch/sh/mm/init.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> index a70ba0fdd0b3..f75932ba87a6 100644
> --- a/arch/sh/mm/init.c
> +++ b/arch/sh/mm/init.c
> @@ -430,15 +430,6 @@ int arch_add_memory(int nid, u64 start, u64 size,
>         return ret;
>  }
>
> -#ifdef CONFIG_NUMA
> -int memory_add_physaddr_to_nid(u64 addr)
> -{
> -       /* Node 0 for now.. */
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
> -#endif
> -
>  void arch_remove_memory(int nid, u64 start, u64 size,
>                         struct vmem_altmap *altmap)
>  {

Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
