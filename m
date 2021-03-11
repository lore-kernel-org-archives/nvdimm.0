Return-Path: <SRS0=VUCp=IJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FED2C433DB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 11 Mar 2021 16:32:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 076DC64F9A
	for <linux-nvdimm@archiver.kernel.org>; Thu, 11 Mar 2021 16:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 076DC64F9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6DCAA100F227C;
	Thu, 11 Mar 2021 08:32:09 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=170.10.133.124; helo=us-smtp-delivery-124.mimecast.com; envelope-from=david@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E68F3100F2276
	for <linux-nvdimm@lists.01.org>; Thu, 11 Mar 2021 08:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615480325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AjxBPEuos0//xANR8jHyBwhDFQYV47gI0GQ1JZxlt9U=;
	b=bo9AhZ6D/k5yi9KYMFn4BD3CyJhXViwig6XS8F+8RGddkET7WrHxQ0DppMhcDKgA5HWiof
	eXI85hIDMvPCuBh8A2KijMbIcgngvjxvNPN64c+L6lLYkm472c2s9FXPs+ymZ8qudw5i4k
	58v9Zv8A5mQTUrKptn74os5XrQeiKHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-RBFRbwVrOwWTOD4pUyAFhQ-1; Thu, 11 Mar 2021 11:32:01 -0500
X-MC-Unique: RBFRbwVrOwWTOD4pUyAFhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90C2694DC8;
	Thu, 11 Mar 2021 16:31:59 +0000 (UTC)
Received: from [10.36.115.26] (ovpn-115-26.ams2.redhat.com [10.36.115.26])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFB9D60C21;
	Thu, 11 Mar 2021 16:31:41 +0000 (UTC)
Subject: Re: [RFC 0/2] virtio-pmem: Asynchronous flush
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
References: <20200420131947.41991-1-pankaj.gupta.linux@gmail.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <7e55abc4-5c91-efb8-1b32-87570dde62cc@redhat.com>
Date: Thu, 11 Mar 2021 17:31:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20200420131947.41991-1-pankaj.gupta.linux@gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Message-ID-Hash: 7NGRN2MGCSAWFDDZUA6Z7ENJ5YKF6JXC
X-Message-ID-Hash: 7NGRN2MGCSAWFDDZUA6Z7ENJ5YKF6JXC
X-MailFrom: david@redhat.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: mst@redhat.com, pankaj.gupta@cloud.ionos.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7NGRN2MGCSAWFDDZUA6Z7ENJ5YKF6JXC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

On 20.04.20 15:19, Pankaj Gupta wrote:
>   Jeff reported preflush order issue with the existing implementation
>   of virtio pmem preflush. Dan suggested[1] to implement asynchronous flush
>   for virtio pmem using work queue as done in md/RAID. This patch series
>   intends to solve the preflush ordering issue and also makes the flush
>   asynchronous from the submitting thread POV.
> 
>   Submitting this patch series for feeback and is in WIP. I have
>   done basic testing and currently doing more testing.
> 
> Pankaj Gupta (2):
>    pmem: make nvdimm_flush asynchronous
>    virtio_pmem: Async virtio-pmem flush
> 
>   drivers/nvdimm/nd_virtio.c   | 66 ++++++++++++++++++++++++++----------
>   drivers/nvdimm/pmem.c        | 15 ++++----
>   drivers/nvdimm/region_devs.c |  3 +-
>   drivers/nvdimm/virtio_pmem.c |  9 +++++
>   drivers/nvdimm/virtio_pmem.h | 12 +++++++
>   5 files changed, 78 insertions(+), 27 deletions(-)
> 
> [1] https://marc.info/?l=linux-kernel&m=157446316409937&w=2
> 

Just wondering, was there any follow up of this or are we still waiting 
for feedback? :)

-- 
Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
