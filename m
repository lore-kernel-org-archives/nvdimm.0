Return-Path: <SRS0=QSYE=II=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85D3C433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Mar 2021 23:30:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 402D264DDA
	for <linux-nvdimm@archiver.kernel.org>; Wed, 10 Mar 2021 23:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 402D264DDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1A525100F224E;
	Wed, 10 Mar 2021 15:30:19 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::52f; helo=mail-ed1-x52f.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5C06E100EB82C
	for <linux-nvdimm@lists.01.org>; Wed, 10 Mar 2021 15:30:16 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id w9so273663edt.13
        for <linux-nvdimm@lists.01.org>; Wed, 10 Mar 2021 15:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vuj/D7o1+/AE9t3wM/vQsuPf0MOJqhA/d5cfPutvQfU=;
        b=o2uQ9nbLBO9R5FOm8KE2FiXDRix0GjxEoucgtHfPLR/wQNZblGYKZeUbZaB3a3gVls
         j5myReVOVSv8e+2as+yWYoc126H5rXjnDz1S/XKEZZqyjP5CjOuJtJdCXwtvh1gGajGB
         AttnNRUhzEiJr3aYXULMyxlHaZvK4tQR2BqqciENC5bZuYnHlM/sDf07rKUZp/9ev5Cl
         YaTNrQmG9WizlGQCUI2TAeuVaoqvCRRHdWDslVQgyQLqCWkKN4ZG/iNSyYEhHzvH3WFj
         K4JoRLLeA8DgfDKV+deTn3ktf5nSBZdM2H3ftPJJGmo54eTR0tvDEMLQuNJeSgoQMGGN
         ngGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vuj/D7o1+/AE9t3wM/vQsuPf0MOJqhA/d5cfPutvQfU=;
        b=CgjZ5rl7kOamZg/dbkR//4ugZF7i5uWg1wihRu7yOEiEcRBz2YgFea2XyNYRkoxn3u
         hFsPIQ+ew1oMqFnIkS0vjydyEq5kpfzKhkySef2z6Ms7g6zMUMZdeVta3oXV0A1ZT/DT
         aRuoeCzRsxhtK0MDB2GrEdjbv2dfluuL6Uu4h9oxRYn1fZbnujkT67FyfsgW1Nys33ss
         JacYS3HCjmqRtF7Z8/Ug562tDpZ4SFnE7tXrEF4r9GKdhuE6TyRWgVAMxtlngEMSU6Dz
         t5gxoEZ3y6gfqwqX4p0sMMj8l0QFjn+YyQvz+5bcpMnlhPegaIgvDZrdRf9CMz7YPNrw
         vUPQ==
X-Gm-Message-State: AOAM532j8nGRdXM76+S8fXc6Z8RmOtJv7IIj6Ijxieqw0q+toUIrQWJG
	ycTjFMnWfewRxLx7OxaiQFozIETlWJGRXQN46TG2pA==
X-Google-Smtp-Source: ABdhPJyAUtjsQZeO+IyfOJ0D71CMa4kn2W9c7sy/JaW+YXPD6tUcwvd9d32TJu/3+N1X9rS+ufsB+LKVJeI/Uw+LbQg=
X-Received: by 2002:aa7:c3cd:: with SMTP id l13mr5720329edr.52.1615419014504;
 Wed, 10 Mar 2021 15:30:14 -0800 (PST)
MIME-Version: 1.0
References: <161534060720.528671.2341213328968989192.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210310065425.GA1794@lst.de>
In-Reply-To: <20210310065425.GA1794@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Mar 2021 15:30:02 -0800
Message-ID: <CAPcyv4i4SUEd_zg7HyuqpE3_KUQU=4Pci40CKX7aM6NNsy9wew@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm: Notify disk drivers to revalidate region read-only
To: Christoph Hellwig <hch@lst.de>
Message-ID-Hash: KMS35UHJIRZ7F3KNAEFWEH76UOHG2BTS
X-Message-ID-Hash: KMS35UHJIRZ7F3KNAEFWEH76UOHG2BTS
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, kernel test robot <lkp@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KMS35UHJIRZ7F3KNAEFWEH76UOHG2BTS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 9, 2021 at 10:54 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Looks good to me:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Question on the pre-existing code: given that nvdimm_check_and_set_ro is
> the only caller of set_disk_ro for nvdimm devices, we'll also get
> the message when initially setting up any read-only disk.  Is that
> intentional?

Yeah, that's intentional. There's no other notification that userspace
would be looking for by default besides the kernel log, and the block
device name is more meaningful than the region name, or the nvdimm
device status for that matter.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
