Return-Path: <SRS0=1/yj=5T=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00ADC2BA17
	for <linux-nvdimm@archiver.kernel.org>; Fri,  3 Apr 2020 01:02:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A065320675
	for <linux-nvdimm@archiver.kernel.org>; Fri,  3 Apr 2020 01:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ynvb5m5/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A065320675
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1AF4F101078F1;
	Thu,  2 Apr 2020 18:03:33 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=207.211.31.120; helo=us-smtp-1.mimecast.com; envelope-from=msnitzer@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com [207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B0A1C101078F1
	for <linux-nvdimm@lists.01.org>; Thu,  2 Apr 2020 18:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1585875759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bO3hj+XmbvjHKiWwQG5/9JyKi4fYtwG5ksjHsl3Ubkw=;
	b=Ynvb5m5/Nvz/3WPhNB17hPEw+163pJLKP7QdUtSDFYNOvDWWR+wex4sXC1qUawv4uTvFDj
	rfU5BFC39s4QLEJfmFtKzBDelYOx9tyNSBqkp7cXgAvTxd99yPRGi9iUYzPARgVLb5DAXn
	E+UJ2dyQUi35LgZabSAxE7jn7ydBxYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-tU0DVqRKPReeeNCAHzbbSQ-1; Thu, 02 Apr 2020 21:02:37 -0400
X-MC-Unique: tU0DVqRKPReeeNCAHzbbSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF3998017CE;
	Fri,  3 Apr 2020 01:02:35 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 124255D9CA;
	Fri,  3 Apr 2020 01:02:33 +0000 (UTC)
Date: Thu, 2 Apr 2020 21:02:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 4/6] dm,dax: Add dax zero_page_range operation
Message-ID: <20200403010231.GA4475@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
 <20200228163456.1587-5-vgoyal@redhat.com>
 <CAPcyv4iWfL+KQjjUXqrTKOL8F4M05Vu=imm5tqsD6MO=XLzoMA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iWfL+KQjjUXqrTKOL8F4M05Vu=imm5tqsD6MO=XLzoMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Message-ID-Hash: J4DQGBX4AY2I4OAJQTDIQ7RVUHLYRC2B
X-Message-ID-Hash: J4DQGBX4AY2I4OAJQTDIQ7RVUHLYRC2B
X-MailFrom: msnitzer@redhat.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, david <david@fromorbit.com>, device-mapper development <dm-devel@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/J4DQGBX4AY2I4OAJQTDIQ7RVUHLYRC2B/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 31 2020 at  3:34pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> [ Add Mike ]
> 
> On Fri, Feb 28, 2020 at 8:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > This patch adds support for dax zero_page_range operation to dm targets.
> 
> Mike,
> 
> Sorry, I should have pinged you earlier, but could you take a look at
> this patch and ack it if it looks ok to go through the nvdimm tree
> with the rest of the series?

Yes, looks fine to me.

Acked-by: Mike Snitzer <snitzer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
