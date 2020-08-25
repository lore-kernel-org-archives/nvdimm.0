Return-Path: <SRS0=BlKz=CD=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BA0C433E1
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 00:09:07 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A65D4207D3
	for <linux-nvdimm@archiver.kernel.org>; Tue, 25 Aug 2020 00:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A65D4207D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 58132137DB2B1;
	Mon, 24 Aug 2020 17:09:07 -0700 (PDT)
Received-SPF: Pass (helo) identity=helo; client-ip=211.29.132.97; helo=mail110.syd.optusnet.com.au; envelope-from=david@fromorbit.com; receiver=<UNKNOWN> 
Received: from mail110.syd.optusnet.com.au (mail110.syd.optusnet.com.au [211.29.132.97])
	by ml01.01.org (Postfix) with ESMTP id E657A1307C9E0
	for <linux-nvdimm@lists.01.org>; Mon, 24 Aug 2020 17:09:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
	by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 5E3E5108D79;
	Tue, 25 Aug 2020 10:09:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1kAMWM-0005k3-RG; Tue, 25 Aug 2020 10:09:02 +1000
Date: Tue, 25 Aug 2020 10:09:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH 6/9] iomap: Convert read_count to byte count
Message-ID: <20200825000902.GG12131@dread.disaster.area>
References: <20200824145511.10500-1-willy@infradead.org>
 <20200824145511.10500-7-willy@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200824145511.10500-7-willy@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
	a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
	a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
	a=n1aMJpBO7yNg7y_OdF8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Message-ID-Hash: DQSKNY7LK7FD3CBZZ62MJQ6OW7ETHPQY
X-Message-ID-Hash: DQSKNY7LK7FD3CBZZ62MJQ6OW7ETHPQY
X-MailFrom: david@fromorbit.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DQSKNY7LK7FD3CBZZ62MJQ6OW7ETHPQY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 24, 2020 at 03:55:07PM +0100, Matthew Wilcox (Oracle) wrote:
> Instead of counting bio segments, count the number of bytes submitted.
> This insulates us from the block layer's definition of what a 'same page'
> is, which is not necessarily clear once THPs are involved.

I'd like to see a comment on the definition of struct iomap_page to
indicate that read_count (and write count) reflect the byte count of
IO currently in flight on the page, not an IO count, because THP
makes tracking this via bio state hard. Otherwise it is not at all
obvious why it is done and why it is intentional...

Otherwise the code looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
