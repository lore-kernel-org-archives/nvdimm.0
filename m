Return-Path: <SRS0=EZ84=3F=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55E3C33CB1
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Jan 2020 14:54:13 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F87A207FF
	for <linux-nvdimm@archiver.kernel.org>; Thu, 16 Jan 2020 14:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3l/Wu/A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F87A207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 90D8910096CA3;
	Thu, 16 Jan 2020 06:57:31 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=205.139.110.61; helo=us-smtp-delivery-1.mimecast.com; envelope-from=vgoyal@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 402EF10096C95
	for <linux-nvdimm@lists.01.org>; Thu, 16 Jan 2020 06:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1579186449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GewXvgai6oYcv5uu5jT3XLWaUiemLMNm2W6ZLR1T1ko=;
	b=I3l/Wu/Afu/aPy4XSrz5lIPlSYz23shLRENfrLYvXhGvNkajJDdJJjcbVuZnPVUhF5jxMd
	Yzy8VFtZNZMz4jvQpXPeUk+RD4F9MBmM76kJPs5sR8R1kLxxd4hWOZyxN2xdV66UJNPnvh
	86ei9cTieIs0hi7TDgaV9CaIOPDJaPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-KoBNpf3IMQSxaLPYFvWuOw-1; Thu, 16 Jan 2020 09:54:05 -0500
X-MC-Unique: KoBNpf3IMQSxaLPYFvWuOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5406CA0CC2;
	Thu, 16 Jan 2020 14:54:04 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.18.25.35])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F8455DA60;
	Thu, 16 Jan 2020 14:54:04 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id ABB94220A24; Thu, 16 Jan 2020 09:54:03 -0500 (EST)
Date: Thu, 16 Jan 2020 09:54:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: dan.j.williams@intel.com
Subject: Re: dax: Get rid of fs_dax_get_by_host() helper
Message-ID: <20200116145403.GB25291@redhat.com>
References: <20200106181117.GA16248@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200106181117.GA16248@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Message-ID-Hash: NKVRVVHPOJ5XDUL7WM4TLAATLNGRX4QM
X-Message-ID-Hash: NKVRVVHPOJ5XDUL7WM4TLAATLNGRX4QM
X-MailFrom: vgoyal@redhat.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NKVRVVHPOJ5XDUL7WM4TLAATLNGRX4QM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 06, 2020 at 01:11:17PM -0500, Vivek Goyal wrote:
> Looks like nobody is using fs_dax_get_by_host() except fs_dax_get_by_bdev()
> and it can easily use dax_get_by_host() instead.
> 
> IIUC, fs_dax_get_by_host() was only introduced so that one could compile
> with CONFIG_FS_DAX=n and CONFIG_DAX=m. fs_dax_get_by_bdev() achieves
> the same purpose and hence it looks like fs_dax_get_by_host() is not
> needed anymore.
>  
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Dan,

Ping for this patch. How does it look to you. If you don't have concerns,
can you please take it in your tree.

Thanks
Vivek

> ---
>  drivers/dax/super.c |    2 +-
>  include/linux/dax.h |   10 ----------
>  2 files changed, 1 insertion(+), 11 deletions(-)
> 
> Index: rhvgoyal-linux-fuse/drivers/dax/super.c
> ===================================================================
> --- rhvgoyal-linux-fuse.orig/drivers/dax/super.c	2020-01-03 11:19:57.616186062 -0500
> +++ rhvgoyal-linux-fuse/drivers/dax/super.c	2020-01-03 11:20:08.941186062 -0500
> @@ -61,7 +61,7 @@ struct dax_device *fs_dax_get_by_bdev(st
>  {
>  	if (!blk_queue_dax(bdev->bd_queue))
>  		return NULL;
> -	return fs_dax_get_by_host(bdev->bd_disk->disk_name);
> +	return dax_get_by_host(bdev->bd_disk->disk_name);
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>  #endif
> Index: rhvgoyal-linux-fuse/include/linux/dax.h
> ===================================================================
> --- rhvgoyal-linux-fuse.orig/include/linux/dax.h	2020-01-03 11:20:05.603186062 -0500
> +++ rhvgoyal-linux-fuse/include/linux/dax.h	2020-01-03 11:20:08.942186062 -0500
> @@ -129,11 +129,6 @@ static inline bool generic_fsdax_support
>  			sectors);
>  }
>  
> -static inline struct dax_device *fs_dax_get_by_host(const char *host)
> -{
> -	return dax_get_by_host(host);
> -}
> -
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
>  	put_dax(dax_dev);
> @@ -160,11 +155,6 @@ static inline bool generic_fsdax_support
>  	return false;
>  }
>  
> -static inline struct dax_device *fs_dax_get_by_host(const char *host)
> -{
> -	return NULL;
> -}
> -
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
>  }
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
