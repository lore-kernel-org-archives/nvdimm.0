Return-Path: <SRS0=d9u0=CZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_05,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6BEC433E2
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Sep 2020 12:11:01 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A55F722211
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Sep 2020 12:11:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A55F722211
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 122D6143FE18A;
	Wed, 16 Sep 2020 05:11:00 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=115.124.30.54; helo=out30-54.freemail.mail.aliyun.com; envelope-from=richard.weiyang@linux.alibaba.com; receiver=<UNKNOWN> 
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1DAF414321AAE
	for <linux-nvdimm@lists.01.org>; Wed, 16 Sep 2020 05:10:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=richard.weiyang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0U97rCs8_1600258251;
Received: from localhost(mailfrom:richard.weiyang@linux.alibaba.com fp:SMTPD_---0U97rCs8_1600258251)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Sep 2020 20:10:51 +0800
Date: Wed, 16 Sep 2020 20:10:51 +0800
From: Wei Yang <richard.weiyang@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] kernel/resource: make iomem_resource implicit in
 release_mem_region_adjustable()
Message-ID: <20200916121051.GA46809@L-31X9LVDL-1304.local>
References: <20200911103459.10306-1-david@redhat.com>
 <20200916073041.10355-1-david@redhat.com>
 <20200916100223.GA46154@L-31X9LVDL-1304.local>
 <d11eba75-71c0-4153-944b-56e22044e0eb@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d11eba75-71c0-4153-944b-56e22044e0eb@redhat.com>
Message-ID-Hash: 3J5CIMJMZPSE2YKRO422WEB2A7WHX4BW
X-Message-ID-Hash: 3J5CIMJMZPSE2YKRO422WEB2A7WHX4BW
X-MailFrom: richard.weiyang@linux.alibaba.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Wei Yang <richard.weiyang@linux.alibaba.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ardb@kernel.org>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Baoquan He <bhe@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: Wei Yang <richard.weiyang@linux.alibaba.com>
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3J5CIMJMZPSE2YKRO422WEB2A7WHX4BW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 16, 2020 at 12:03:20PM +0200, David Hildenbrand wrote:
>On 16.09.20 12:02, Wei Yang wrote:
>> On Wed, Sep 16, 2020 at 09:30:41AM +0200, David Hildenbrand wrote:
>>> "mem" in the name already indicates the root, similar to
>>> release_mem_region() and devm_request_mem_region(). Make it implicit.
>>> The only single caller always passes iomem_resource, other parents are
>>> not applicable.
>>>
>> 
>> Looks good to me.
>> 
>> Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
>>
>
>Thanks for the review!
>

Would you send another version? I didn't take a look into the following
patches, since the 4th is missed.

>-- 
>Thanks,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
