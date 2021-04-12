Return-Path: <SRS0=o7EX=JJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC27FC433B4
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Apr 2021 07:53:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 22E166102A
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Apr 2021 07:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22E166102A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 80CAF100EBB78;
	Mon, 12 Apr 2021 00:53:35 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.85.166.181; helo=mail-il1-f181.google.com; envelope-from=pankaj.gupta.linux@gmail.com; receiver=<UNKNOWN> 
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 56113100EBBBD
	for <linux-nvdimm@lists.01.org>; Mon, 12 Apr 2021 00:53:32 -0700 (PDT)
Received: by mail-il1-f181.google.com with SMTP id c18so10201225iln.7
        for <linux-nvdimm@lists.01.org>; Mon, 12 Apr 2021 00:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DdceCmZ2FH904nfOs2t/mm+fumePewB2yMQTYqW1pUQ=;
        b=Apq4GwRO8+k0lzIl6z+h+uu8KBzvRtqh328zmOmdX9D8WZDYE43EDj6UJ61SmYmvyY
         DJYhKdL1TrcBWmGShxBBKJ+I7QrwnDJwBAqpkbS1gRDWVpqtdWBpMLqDEoOq6CABvLgR
         nVFTAYG5vfrcdyXQR58db52lun1FYbLhQHMtvbVNGdlXijCx+uCmMysT/fsnpIHRa58p
         cG8r8q/KqmIu4yR/+1pLa16Uw4sYVQ+kY7tKpgV6H1l1IXK43TEON0i7oy9fkvwt9pX9
         AxYtvzX5CROT/ew5dySY6+1CdpLia9Ksrs7pLiP1zHg29+6QVRWO+yxNPOTdzqzjtXb+
         i5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DdceCmZ2FH904nfOs2t/mm+fumePewB2yMQTYqW1pUQ=;
        b=VRY5z5qUPMqDn4LEtU2fhK/Mh7vE4HHDSI3jJPgPpQcRKhoEbxGPKp/0SqP+22slnH
         8MSlPaxel6dd3eJ/C4wQkJHXG3WSbiMzRZrjKS9ZELkqIyqML31eEVZGG9S5Du3qQq74
         9fpXMfskR2dvR4SSJneEY4+KZYqaLrikeKes6YKQdBGq3QTBmqWK9/obyHcaZa2Gl5by
         ZO1OEpYszhWnpqH7srLi6S65YWktny0dxbN4V1PqpmKFH5Au6vZo0IhQDqH0iSq5WmHt
         LnL4jaMoJ6lIfBLxvwGlj/0tdZCvmWMZiTUZWTGZb2QcQMl7alLQFlSlv1TeFszcWGZx
         wwFw==
X-Gm-Message-State: AOAM533lSIw6cU6wGew00j6VsAV7VVDuoJXWDNAIW9YofSjKczxUgMsp
	F6wUyGGea+U3vr4gxxC7mZgMXKLOgzfGRdZ89vPbEqjLezcsoA==
X-Google-Smtp-Source: ABdhPJx7/tHGIFdoZNnflfZ2w5YJbwrMyXJroyLcG0K9F4HeVTdf/EskJQeu4mNbgaLq4xasyQncDOldYVAOl+JcSJs=
X-Received: by 2002:a05:6e02:118b:: with SMTP id y11mr8491030ili.163.1618213951540;
 Mon, 12 Apr 2021 00:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210408104622.943843-1-vaibhav@linux.ibm.com>
In-Reply-To: <20210408104622.943843-1-vaibhav@linux.ibm.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Mon, 12 Apr 2021 09:52:20 +0200
Message-ID: <CAM9Jb+j6oVumXQ+zmYbQSvQ3UzLKT3V8XLq1SotVcwVuUwP09A@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm/region: Update nvdimm_has_flush() to handle
 explicit 'flush' callbacks
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Message-ID-Hash: P7P7MM3S7DMJVQDUFE7RAERRJ64C35NI
X-Message-ID-Hash: P7P7MM3S7DMJVQDUFE7RAERRJ64C35NI
X-MailFrom: pankaj.gupta.linux@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org, Shivaprasad G Bhat <sbhat@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/P7P7MM3S7DMJVQDUFE7RAERRJ64C35NI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Vaibhav,

> In case a platform doesn't provide explicit flush-hints but provides an
> explicit flush callback, then nvdimm_has_flush() still returns '0'
> indicating that writes do not require flushing. This happens on PPC64
> with patch at [1] applied, where 'deep_flush' of a region was denied
> even though an explicit flush function was provided.
>
> Similar problem is also seen with virtio-pmem where the 'deep_flush'
> sysfs attribute is not visible as in absence of any registered nvdimm,
> 'nd_region->ndr_mappings == 0'.

In case of async flush callback, do we still need "deep_flush" ?

Thanks,
Pankaj
>
> Fix this by updating nvdimm_has_flush() adding a condition to
> nvdimm_has_flush() to test if a 'region->flush' callback is
> assigned. Also remove explicit test for 'nd_region->ndr_mapping' since
> regions may need 'flush' without any explicit mappings as in case of
> virtio-pmem.
>
> References:
> [1] "powerpc/papr_scm: Implement support for H_SCM_FLUSH hcall"
> https://lore.kernel.org/linux-nvdimm/161703936121.36.7260632399582101498.stgit@e1fbed493c87
>
> Cc: <stable@vger.kernel.org>
> Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
> Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog:
>
> v3:
> * Removed the test for ND_REGION_SYNC to handle case where a
>   synchronous region still wants to expose a deep-flush function.
>   [ Aneesh ]
> * Updated patch title and description from previous patch
>   https://lore.kernel.org/linux-nvdimm/5e64778d-bf48-9f10-7d3d-5e530e5db590@linux.ibm.com
>
> v2:
> * Added the fixes tag and addressed the patch to stable tree [ Aneesh ]
> * Updated patch description to address the virtio-pmem case.
> * Removed test for 'nd_region->ndr_mappings' from beginning of
>   nvdimm_has_flush() to handle the virtio-pmem case.
> ---
>  drivers/nvdimm/region_devs.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index ef23119db574..c4b17bdd527f 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1234,11 +1234,15 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>  {
>         int i;
>
> -       /* no nvdimm or pmem api == flushing capability unknown */
> -       if (nd_region->ndr_mappings == 0
> -                       || !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
> +       /* no pmem api == flushing capability unknown */
> +       if (!IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
>                 return -ENXIO;
>
> +       /* Test if an explicit flush function is defined */
> +       if (nd_region->flush)
> +               return 1;
> +
> +       /* Test if any flush hints for the region are available */
>         for (i = 0; i < nd_region->ndr_mappings; i++) {
>                 struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>                 struct nvdimm *nvdimm = nd_mapping->nvdimm;
> @@ -1249,8 +1253,8 @@ int nvdimm_has_flush(struct nd_region *nd_region)
>         }
>
>         /*
> -        * The platform defines dimm devices without hints, assume
> -        * platform persistence mechanism like ADR
> +        * The platform defines dimm devices without hints nor explicit flush,
> +        * assume platform persistence mechanism like ADR
>          */
>         return 0;
>  }
> --
> 2.30.2
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
