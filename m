Return-Path: <SRS0=71B7=6N=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A77FC83000
	for <linux-nvdimm@archiver.kernel.org>; Wed, 29 Apr 2020 14:01:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 317A82083B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 29 Apr 2020 14:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="mzVn/jDG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 317A82083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=yadro.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D54351007B64F;
	Wed, 29 Apr 2020 06:59:54 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=89.207.88.252; helo=mta-01.yadro.com; envelope-from=r.bolshakov@yadro.com; receiver=<UNKNOWN> 
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 52C481007B64D
	for <linux-nvdimm@lists.01.org>; Wed, 29 Apr 2020 06:59:52 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id C93B6412CC;
	Wed, 29 Apr 2020 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
	content-type:content-type:content-transfer-encoding:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received:received; s=mta-01; t=
	1588168851; x=1589983252; bh=PFQ+bnPNNJYx7rujMY9zrWYg2tjFphBQGIb
	XMJn43Q8=; b=mzVn/jDG2iH8Ng5dI4ec/VbIkJPjIRDAbCj/7gUcRhDabcdOLvl
	sdYsGlbLUHe2lqo0hSvgAqrZ0b/gQwaro2FX7nzxiCe0T4Xuhlwj4CXaV30irYwG
	X3SSYZtOjbL/Ogl2pNAL02ywEpHc4o4Nk8OuamdYlyYY8++Fzn3XOs2E=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
	by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LvlLtNU3-tSf; Wed, 29 Apr 2020 17:00:51 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS id D14BC4C848;
	Wed, 29 Apr 2020 17:00:50 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 17:00:51 +0300
From: Roman Bolshakov <r.bolshakov@yadro.com>
To: <martin.petersen@oracle.com>
Subject: Re: [Ksummit-discuss] [PATCH v2 0/3] Maintainer Entry Profiles
Date: Wed, 29 Apr 2020 16:55:27 +0300
Message-ID: <20200429135524.52802-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <yq1tv9fdfar.fsf@oracle.com>
References: <yq1tv9fdfar.fsf@oracle.com>
MIME-Version: 1.0
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Message-ID-Hash: CJW5FAFGTNNRTTIKP4JBSBKWA2IWTUMS
X-Message-ID-Hash: CJW5FAFGTNNRTTIKP4JBSBKWA2IWTUMS
X-MailFrom: r.bolshakov@yadro.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: bvanassche@acm.org, dvyukov@google.com, gregkh@linuxfoundation.org, ksummit-discuss@lists.linuxfoundation.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, mchehab@kernel.org, me@tobin.cc, stfrench@microsoft.com, Roman Bolshakov <r.bolshakov@yadro.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CJW5FAFGTNNRTTIKP4JBSBKWA2IWTUMS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/11/19 5:40 PM, Martin K. Petersen wrote:
> After the Plumbers session last year I wrote this for SCSI based on a
> prior version by Christoph. It's gone a bit stale but I'll update it to
> match your template.
> 

Hi Martin,

The Maintainer profile is very helpful. Are you planning to send another
version and address Bart's comments?

Thanks,
Roman
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
