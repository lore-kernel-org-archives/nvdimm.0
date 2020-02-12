Return-Path: <SRS0=sp4a=4A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B261FC2BA83
	for <linux-nvdimm@archiver.kernel.org>; Wed, 12 Feb 2020 14:04:14 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C29F20724
	for <linux-nvdimm@archiver.kernel.org>; Wed, 12 Feb 2020 14:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YrEdYfb4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C29F20724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1EBDA10FC336E;
	Wed, 12 Feb 2020 06:07:31 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=207.211.31.120; helo=us-smtp-1.mimecast.com; envelope-from=jmoyer@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com [207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EC76A10FC3367
	for <linux-nvdimm@lists.01.org>; Wed, 12 Feb 2020 06:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1581516250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkUlI+BB2B8+j0YKiZsn18wND8fkjaz9cJpL8khZI/I=;
	b=YrEdYfb4jvk3CdgILE8AjAXqMQH94HAhR2LIdzRoYrcbYT+GsrIg00dSCxv4gXl0MnU6I0
	FcBxO1ygSZSvXwsAjXWtFF2H3G5BvVLJ2GDLNO780ChPIuUpMSqEaiQilTsFCh4wgZG6qK
	C0qDh6Dis3zM8FGkEmIL7XM+RIUxWEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-EGWgC3boOC-rlWPu_6rROQ-1; Wed, 12 Feb 2020 09:04:06 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23CC7A09A1;
	Wed, 12 Feb 2020 14:04:05 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99CEA9006B;
	Wed, 12 Feb 2020 14:04:04 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] tools/testing/nvdimm: Fix compilation failure without CONFIG_DEV_DAX_PMEM_COMPAT
References: <20200123154720.12097-1-jack@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 12 Feb 2020 09:04:03 -0500
In-Reply-To: <20200123154720.12097-1-jack@suse.cz> (Jan Kara's message of
	"Thu, 23 Jan 2020 16:47:20 +0100")
Message-ID: <x498sl73nsc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: EGWgC3boOC-rlWPu_6rROQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Message-ID-Hash: HHVR45RD2W75VMC3L227U77MNY5NK6CT
X-Message-ID-Hash: HHVR45RD2W75VMC3L227U77MNY5NK6CT
X-MailFrom: jmoyer@redhat.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HHVR45RD2W75VMC3L227U77MNY5NK6CT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Jan Kara <jack@suse.cz> writes:

> When a kernel is configured without CONFIG_DEV_DAX_PMEM_COMPAT, the
> compilation of tools/testing/nvdimm fails with:
>
>   Building modules, stage 2.
>   MODPOST 11 modules
> ERROR: "dax_pmem_compat_test" [tools/testing/nvdimm/test/nfit_test.ko] undefined!
>
> Fix the problem by calling dax_pmem_compat_test() only if the kernel has
> the required functionality.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

What's the motivation?  Is this just to fix randconfig builds?  The
reason I ask is that the test suite will expect to be able to find the
dax_pmem_compat module, so it doesn't make sense to me to disable those
tests only in the kernel as you'll hit a problem when running the tests
anyway.

But, I understand if you want to prevent build bots from hitting
compilation failures due to this.

-Jeff

> ---
>  tools/testing/nvdimm/test/nfit.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index bf6422a6af7f..a8ee5c4d41eb 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -3164,7 +3164,9 @@ static __init int nfit_test_init(void)
>  	mcsafe_test();
>  	dax_pmem_test();
>  	dax_pmem_core_test();
> +#ifdef CONFIG_DEV_DAX_PMEM_COMPAT
>  	dax_pmem_compat_test();
> +#endif
>  
>  	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
