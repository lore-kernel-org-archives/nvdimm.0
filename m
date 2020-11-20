Return-Path: <SRS0=wSbi=E2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0EAC56201
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Nov 2020 16:32:05 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA8C12242B
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Nov 2020 16:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idcWn3rF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA8C12242B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 00CDB100ED484;
	Fri, 20 Nov 2020 08:32:04 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=63.128.21.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=jmoyer@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 2AAB9100EF27D
	for <linux-nvdimm@lists.01.org>; Fri, 20 Nov 2020 08:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605889917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aRqJqgKZnzrFeN4r7J3TRFQH2S+VjzEDzxpgpntqdyc=;
	b=idcWn3rFfZ1L1BzOM4ZySaMVucogibr5RFH26uteUIVejj24jT0koAulHmM0E5ZxYjJdPZ
	FMCYwA479uPHj+zp43D5nfqTVvLJghWWaF7ISLShUPTyACDImInOggsCKdDlUy1yn9RDCH
	SvAsNHoxV6NCbh3yUkGWTwve0RzpfOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-8FIUf5amNRO85NzX2gUTNw-1; Fri, 20 Nov 2020 11:31:55 -0500
X-MC-Unique: 8FIUf5amNRO85NzX2gUTNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AD89805F0E;
	Fri, 20 Nov 2020 16:31:54 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AE9819726;
	Fri, 20 Nov 2020 16:31:53 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [ndctl PATCH 2/8] lib/libndctl: fix memory leakage problem in add_bus
References: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
	<8caac123-9d45-c848-d45a-3cb8be5a2708@huawei.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 20 Nov 2020 11:31:58 -0500
In-Reply-To: <8caac123-9d45-c848-d45a-3cb8be5a2708@huawei.com> (Zhiqiang Liu's
	message of "Fri, 6 Nov 2020 17:25:03 +0800")
Message-ID: <x49zh3cm1kx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jmoyer@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Message-ID-Hash: 2AQ3UAGLNYMQJ5WHKQM4YO2X2M46HY3S
X-Message-ID-Hash: 2AQ3UAGLNYMQJ5WHKQM4YO2X2M46HY3S
X-MailFrom: jmoyer@redhat.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linfeilong <linfeilong@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2AQ3UAGLNYMQJ5WHKQM4YO2X2M46HY3S/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Zhiqiang Liu <liuzhiqiang26@huawei.com> writes:

> In add_bus(), bus->bus_path is set by calling parent_dev_path(),
> which will finally adopt realpath(, NULL) to allocate new path.
> However, bus->bus_path will not be freed in err_read tag, then,
> memory leakage occurs.
>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  ndctl/lib/libndctl.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ad521d3..3926382 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -975,6 +975,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  	free(bus->wait_probe_path);
>  	free(bus->scrub_path);
>  	free(bus->provider);
> +	free(bus->bus_path);
>  	free(bus->bus_buf);
>  	free(bus);
>   err_bus:

Acked-by: Jeff Moyer <jmoyer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
