Return-Path: <SRS0=BlKz=CD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10D3C433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 22:05:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8966820706
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 22:05:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8966820706
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 63E4111154CB3;
	Tue, 25 Aug 2020 15:05:29 -0700 (PDT)
Received-SPF: Pass (helo) identity=helo; client-ip=211.29.132.80; helo=mail109.syd.optusnet.com.au; envelope-from=david@fromorbit.com; receiver=<UNKNOWN> 
Received: from mail109.syd.optusnet.com.au (mail109.syd.optusnet.com.au [211.29.132.80])
	by ml01.01.org (Postfix) with ESMTP id 2B43511154CB0
	for <linux-nvdimm@lists.01.org>; Tue, 25 Aug 2020 15:05:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
	by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 13A45D7D47D;
	Wed, 26 Aug 2020 08:05:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1kAh4E-0000RK-Vc; Wed, 26 Aug 2020 08:05:22 +1000
Date: Wed, 26 Aug 2020 08:05:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 9/9] iomap: Change calling convention for zeroing
Message-ID: <20200825220522.GO12131@dread.disaster.area>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-10-willy@infradead.org>
 <20200825002735.GI12131@dread.disaster.area>
 <20200825032603.GL17456@casper.infradead.org>
 <E47B2C68-43F2-496F-AA91-A83EB3D91F28@dilger.ca>
 <20200825042711.GL12131@dread.disaster.area>
 <20200825124024.GN17456@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200825124024.GN17456@casper.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
	a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
	a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
	a=2U9gKF9mzcrskAPIHE4A:9 a=CjuIK1q_8ugA:10 a=n3xvM8a_0i4A:10
	a=biEYGPWJfzWAr4FL6Ov7:22
Message-ID-Hash: PAYXNBCXC5AS4QVAHGGORHWZBNLA4L5R
X-Message-ID-Hash: PAYXNBCXC5AS4QVAHGGORHWZBNLA4L5R
X-MailFrom: david@fromorbit.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Andreas Dilger <adilger@dilger.ca>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PAYXNBCXC5AS4QVAHGGORHWZBNLA4L5R/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 25, 2020 at 01:40:24PM +0100, Matthew Wilcox wrote:
> Any objection to leaving this patch as-is with a u64 length?

No objection here - I just wanted to make sure that signed/unsigned
overflow was not going to be an issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
