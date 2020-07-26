Return-Path: <SRS0=A3Mq=BF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10ADFC433E5
	for <linux-nvdimm@archiver.kernel.org>; Sun, 26 Jul 2020 17:44:54 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D71F4206D8
	for <linux-nvdimm@archiver.kernel.org>; Sun, 26 Jul 2020 17:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=dabbelt-com.20150623.gappssmtp.com header.i=@dabbelt-com.20150623.gappssmtp.com header.b="QWRKokJ1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D71F4206D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5B1DA119315CB;
	Sun, 26 Jul 2020 10:44:53 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::542; helo=mail-pg1-x542.google.com; envelope-from=palmer@dabbelt.com; receiver=<UNKNOWN> 
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C9FC01192E953
	for <linux-nvdimm@lists.01.org>; Sun, 26 Jul 2020 10:44:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so8103431pge.12
        for <linux-nvdimm@lists.01.org>; Sun, 26 Jul 2020 10:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=rz8PmAevX+AVytGTYCByWyvIy1/4eNHrEUMkdI13ieQ=;
        b=QWRKokJ1jbQuW0PkRJtwvVGJquSmHlRYaYTPngCykthHbtqC79WUZMe9dn94R+JHQ3
         MD6r4dbJ5S5EaTgzrs+PGRazPszQO6zgfKXIJWnhSpchzyta3doIZ1/mZ5P+pYMOJDQz
         H3b5dNV2gTNEO8N8SPevaOxawfoYNgAXdLyr0+yPXY3YUsKjNCb7/MEFYzngumWotZa2
         SRpKioyQgEhCAChtQDAJaDviE+f1X6taWqAtuQ0sMa5r2GQyorbXhCUrIaxkZai+xhQ/
         gE9k0/WeZ7f9KgmR16E5JMvK0QwTmEkUJjdbe7w5yBQg5IhZ/XLHXP1aTWzYshwZtbN7
         T23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=rz8PmAevX+AVytGTYCByWyvIy1/4eNHrEUMkdI13ieQ=;
        b=PznnmoRyp5clKtPY/VWXBvx+PmC9/mVbRvj+CsQyJNOyP+G2v1tpuGhZdZJJM1/kAc
         2j/wsZ1C5mTOxRlo92bNGWOv6xbyZPPUgcf+XB1+jj3y285i/wsJyxSZfGPIVOETif/S
         WfDxNtZVw82z/MhOjEysvi/bojWjnmkLly1s7Eacoi4gKYG9VzVb14oy945tA92jufas
         N8xR80AkBQPiqLYXISqBvuq8QBHgVOoEYcWxmS5yyIqT8GQmUKB5sZEjM59GnLl72v+9
         yTfRH2BKcl/soSPgZF8ZVyof4TZ/dHpns1AiDUsyhQfvMZZL2p5NAwzUGaIVsAGJG5RL
         wvqA==
X-Gm-Message-State: AOAM533Z5DZ2EGPjqV9H9loZVXVmhwYhA2HxA7ihvceSSq59erswRwjT
	fLqZ4rKVbBu0fsI0wv+ZNSE11g==
X-Google-Smtp-Source: ABdhPJwMFBKRD5d4MvMpsgEw1KumsNACvODlt+6//ct5AFSF4islz3zAwhx/bKFoMeysRB9OE9FIlA==
X-Received: by 2002:a62:8081:: with SMTP id j123mr30331pfd.80.1595785489483;
        Sun, 26 Jul 2020 10:44:49 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id u2sm12465061pfl.21.2020.07.26.10.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 10:44:48 -0700 (PDT)
Date: Sun, 26 Jul 2020 10:44:48 -0700 (PDT)
X-Google-Original-Date: Sun, 26 Jul 2020 10:44:45 PDT (-0700)
Subject: Re: [PATCH 4/6] arch, mm: wire up secretmemfd system call were relevant
In-Reply-To: <20200720092435.17469-5-rppt@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: rppt@kernel.org
Message-ID: <mhng-ffb01b1d-16c2-4998-8434-99f1cae575bd@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Message-ID-Hash: PIBEL2NXBJ32GNUUUECZP4O6M3IWS2KZ
X-Message-ID-Hash: PIBEL2NXBJ32GNUUUECZP4O6M3IWS2KZ
X-MailFrom: palmer@dabbelt.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, luto@kernel.org, Arnd Bergmann <arnd@arndb.de>, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com, dave.hansen@linux.intel.com, elena.reshetova@intel.com, hpa@zytor.com, idan.yaniv@ibm.com, mingo@redhat.com, jejb@linux.ibm.com, kirill@shutemov.name, willy@infradead.org, rppt@linux.ibm.com, rppt@kernel.org, Paul Walmsley <paul.walmsley@sifive.com>, peterz@infradead.org, tglx@linutronix.de, tycho@tycho.ws, will@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-riscv@lists.infradead.org, x86@kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PIBEL2NXBJ32GNUUUECZP4O6M3IWS2KZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

On Mon, 20 Jul 2020 02:24:33 PDT (-0700), rppt@kernel.org wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
>
> Wire up secretmemfd system call on architectures that define
> ARCH_HAS_SET_DIRECT_MAP, namely arm64, risc-v and x86.
>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/arm64/include/asm/unistd32.h      | 2 ++
>  arch/arm64/include/uapi/asm/unistd.h   | 1 +
>  arch/riscv/include/asm/unistd.h        | 1 +
>  arch/x86/entry/syscalls/syscall_32.tbl | 1 +
>  arch/x86/entry/syscalls/syscall_64.tbl | 1 +
>  include/linux/syscalls.h               | 1 +
>  include/uapi/asm-generic/unistd.h      | 7 ++++++-
>  7 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/unistd.h b/arch/riscv/include/asm/unistd.h
> index 977ee6181dab..9e47d9aed5eb 100644
> --- a/arch/riscv/include/asm/unistd.h
> +++ b/arch/riscv/include/asm/unistd.h
> @@ -9,6 +9,7 @@
>   */
>
>  #define __ARCH_WANT_SYS_CLONE
> +#define __ARCH_WANT_SECRETMEMFD
>
>  #include <uapi/asm/unistd.h>

Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
