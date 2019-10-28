Return-Path: <SRS0=dDVn=YV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E456CA9EBC
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Oct 2019 02:43:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2DCF21783
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Oct 2019 02:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rxSmDbo0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2DCF21783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 01400100EA619;
	Sun, 27 Oct 2019 19:44:18 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::d42; helo=mail-io1-xd42.google.com; envelope-from=oohall@gmail.com; receiver=<UNKNOWN> 
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D2D19100EA613
	for <linux-nvdimm@lists.01.org>; Sun, 27 Oct 2019 19:44:15 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h9so9076706ioh.2
        for <linux-nvdimm@lists.01.org>; Sun, 27 Oct 2019 19:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WajkIfso2UlXgRkDGGI9iOFobax0DuU9gdm0Iijm/A8=;
        b=rxSmDbo0YmfGeXOIN+Q9biZMXG5q+/XkXO3AjnWZKG9k2QoYsiz7/3dMdXaUmdydtA
         6BWrxQMI0AHuw0nXVv4ks4FtDO7UoGpAD31IjfmfGxPe4Gt//TYkVcJYWnDP1v1jNz+o
         c75oqllYLie1bX5jJdtqgLTrpy7qu3HR3TgrMMT1EF/Lmiodbh/48fx9vULV8AFTCVh4
         fcDqWkceNEwGsW++o1WE2+6Q5BW2nt6F1IKAKdnQqPfjoMyeDjSDkldHsSGNfZ72PjAv
         F/EwrYkqQLRi7CzIaRe56lr3UGRIuZFnStLJw69W5mywrUb9uT2V7KbcbKewcbFnfShe
         B4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WajkIfso2UlXgRkDGGI9iOFobax0DuU9gdm0Iijm/A8=;
        b=oB5w3LCtHmUYmOLGvx3D5lJoDk6YL0vtOQA5yrlevS1lbSUFvyzXcijeV8YUnbBWFl
         LV6OUsC+FtZRMezMHnfErcdkItCXYNXRZJWP5YfS8K4QhMMZ8aGIRUUBOoXMaxM52A9N
         txPilbANMNCo3QKv+guxl4aY5yqyC/2j2d4yNg9NkE/KbEdcpSEF4XHiGjercIm2wUl0
         4Z4RkDLiL479EsFpflE9xSSP3xXuH+ah1U/Ols2RG8N3dhtV5Dom94bK4nhVththazoB
         MCkFT8LLaeF+UqQjzGaWIdt1T5OUr58mDkpAFF3nL28jX4vcUVV1Dd/2n+hlgYCPHMyX
         oA6Q==
X-Gm-Message-State: APjAAAVQxGaEeUXBlPZbloh0Lcsl5LcPo+AR+te76brhR4cZUIrDIlxb
	/gZHjPJmSrxfC0mBReLAYE56O0fIbgFuxr1FvJ4=
X-Google-Smtp-Source: APXvYqwOWm0fMe4Z+23NbNt4s3moVCNRfSkGYs68cOaCdJ7rNfZZA3zAvx6xOt8t6pKut1UDb6mLgbG5D1F93mKzz20=
X-Received: by 2002:a5d:8247:: with SMTP id n7mr8103790ioo.195.1572230600541;
 Sun, 27 Oct 2019 19:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191025044721.16617-1-alastair@au1.ibm.com> <20191025044721.16617-10-alastair@au1.ibm.com>
In-Reply-To: <20191025044721.16617-10-alastair@au1.ibm.com>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Mon, 28 Oct 2019 13:43:09 +1100
Message-ID: <CAOSf1CGwuAkeayfk0uowN8gkKXWy8jKzgLX5-Gxxqn3ENNiUdA@mail.gmail.com>
Subject: Re: [PATCH 09/10] powerpc: Enable OpenCAPI Storage Class Memory
 driver on bare metal
To: "Alastair D'Silva" <alastair@au1.ibm.com>
Message-ID-Hash: 2X4TYIZMIL3GPTLG7COF6LDVBNBWU3PW
X-Message-ID-Hash: 2X4TYIZMIL3GPTLG7COF6LDVBNBWU3PW
X-MailFrom: oohall@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: alastair@d-silva.org, Michael Ellerman <mpe@ellerman.id.au>, Frederic Barrat <fbarrat@linux.ibm.com>, Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2X4TYIZMIL3GPTLG7COF6LDVBNBWU3PW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 25, 2019 at 3:51 PM Alastair D'Silva <alastair@au1.ibm.com> wrote:
>
> From: Alastair D'Silva <alastair@d-silva.org>
>
> Enable OpenCAPI Storage Class Memory driver on bare metal
>
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  arch/powerpc/configs/powernv_defconfig | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
> index 6658cceb928c..45c0eff94964 100644
> --- a/arch/powerpc/configs/powernv_defconfig
> +++ b/arch/powerpc/configs/powernv_defconfig
> @@ -352,3 +352,7 @@ CONFIG_KVM_BOOK3S_64=m
>  CONFIG_KVM_BOOK3S_64_HV=m
>  CONFIG_VHOST_NET=m
>  CONFIG_PRINTK_TIME=y
> +CONFIG_OCXL_SCM=m

> +CONFIG_DEV_DAX=y
> +CONFIG_DEV_DAX_PMEM=y

These should probably be modules. Having them as builtins will force
their dependencies (i.e. libnvdimm) to be built into the kernel too.

> +CONFIG_FS_DAX=y
> --
> 2.21.0
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
