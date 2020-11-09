Return-Path: <SRS0=iqJD=EP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43AEC388F9
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 03:13:15 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 222F3206B7
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 03:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CPezAcwD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 222F3206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CE7FC162141F0;
	Sun,  8 Nov 2020 19:13:14 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=63.128.21.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=yi.zhang@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 246D215D96B61
	for <linux-nvdimm@lists.01.org>; Sun,  8 Nov 2020 19:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604891590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xb8k4+yI8fHzzJn7DseqPKs4n9eNjdeWv8c+0AvidmE=;
	b=CPezAcwD7cn8krc4qkAbl9tfP43nISBWzySeLoupBo+DhB4WHRazCHhTRqcZSSB4jx4Lw7
	glvDylmsyPGV0Q6A8SACOzR/U2Rt3tRN2NQVuBJl1ycUXqYfrmMmUtRIwumuysTMice5oa
	+tozbt55f3wKBo3ez882aHbtkqv3yGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-K0ZkzGKLONCTEeCSIzBasg-1; Sun, 08 Nov 2020 22:13:09 -0500
X-MC-Unique: K0ZkzGKLONCTEeCSIzBasg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 654968018A9;
	Mon,  9 Nov 2020 03:13:08 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-67.pek2.redhat.com [10.72.12.67])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 430D2277D6;
	Mon,  9 Nov 2020 03:13:06 +0000 (UTC)
Subject: Re: regression from 5.10.0-rc3: BUG: Bad page state in process
 kworker/41:0 pfn:891066 during fio on devdax
To: Dan Williams <dan.j.williams@intel.com>
References: <1934921834.1085815.1604889035798.JavaMail.zimbra@redhat.com>
 <1687234809.1086398.1604889506963.JavaMail.zimbra@redhat.com>
 <CAPcyv4jto-LCR6EUZj0bka8De9NTwB5OkYLbK83O5hubGfknPQ@mail.gmail.com>
From: Yi Zhang <yi.zhang@redhat.com>
Message-ID: <1bac0f55-367c-d2d5-7847-54b9a47ea525@redhat.com>
Date: Mon, 9 Nov 2020 11:13:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jto-LCR6EUZj0bka8De9NTwB5OkYLbK83O5hubGfknPQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yi.zhang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Message-ID-Hash: S4O33PT3TWUAYHPOUTWU3ILNJV5D2YQE
X-Message-ID-Hash: S4O33PT3TWUAYHPOUTWU3ILNJV5D2YQE
X-MailFrom: yi.zhang@redhat.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/S4O33PT3TWUAYHPOUTWU3ILNJV5D2YQE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit



On 11/9/20 11:00 AM, Dan Williams wrote:
> On Sun, Nov 8, 2020 at 6:38 PM Yi Zhang <yi.zhang@redhat.com> wrote:
>> Hello
>>
>> I found this regression during devdax fio test on 5.10.0-rc3, could anyone help check it, thanks.
> Have you been able to bisect it?
>
Yeah, the bisect is WIP, will update it later. :)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
