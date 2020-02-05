Return-Path: <SRS0=cats=3Z=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5772C35247
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Feb 2020 20:03:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A61D32072B
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Feb 2020 20:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QJk5mJrO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A61D32072B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C552D10FC33F8;
	Wed,  5 Feb 2020 12:06:27 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=205.139.110.61; helo=us-smtp-delivery-1.mimecast.com; envelope-from=vgoyal@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1F35D10FC33F6
	for <linux-nvdimm@lists.01.org>; Wed,  5 Feb 2020 12:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1580932986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BpPZ5tPOzIi782xwIySoug6Mj3mFol2Rq1NxMABC0gc=;
	b=QJk5mJrOQJ2d1FS5BM3y+jZlk5C2ul2ztS5CQDghP+AqeBOYuDd/nomKfozbK1guJ0cuJI
	bl8UFeBn9ZCaL1fUf6xRnrhJtkgyZ08ppm3QUlrK0bFe+3V1XdWp8RDKyrlWbjF5AAbHlM
	O/LS+VSkV23kXsnPsaFSlBRWPkN8gro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-Ia_x1XtbN7K5wWSb8iM-oQ-1; Wed, 05 Feb 2020 15:03:03 -0500
X-MC-Unique: Ia_x1XtbN7K5wWSb8iM-oQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8100E1857341;
	Wed,  5 Feb 2020 20:03:02 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.18.25.35])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E022810013A1;
	Wed,  5 Feb 2020 20:02:59 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id 73FD42202E9; Wed,  5 Feb 2020 15:02:59 -0500 (EST)
Date: Wed, 5 Feb 2020 15:02:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] dax, pmem: Add a dax operation zero_page_range
Message-ID: <20200205200259.GE14544@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-2-vgoyal@redhat.com>
 <20200205183050.GA26711@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200205183050.GA26711@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Message-ID-Hash: 4SSTACD77FZ4NDHESLCDNIJCCVFTQUV5
X-Message-ID-Hash: 4SSTACD77FZ4NDHESLCDNIJCCVFTQUV5
X-MailFrom: vgoyal@redhat.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4SSTACD77FZ4NDHESLCDNIJCCVFTQUV5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 05, 2020 at 10:30:50AM -0800, Christoph Hellwig wrote:
> > +	/*
> > +	 * There are no users as of now. Once users are there, fix dm code
> > +	 * to be able to split a long range across targets.
> > +	 */
> 
> This comment confused me.  I think this wants to say something like:
> 
> 	/*
> 	 * There are now callers that want to zero across a page boundary as of
> 	 * now.  Once there are users this check can be removed after the
> 	 * device mapper code has been updated to split ranges across targets.
> 	 */

Yes, that's what I wanted to say but I missed one line. Thanks. Will fix
it.

> 
> > +static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > +				    unsigned int offset, size_t len)
> > +{
> > +	int rc = 0;
> > +	phys_addr_t phys_pos = pgoff * PAGE_SIZE + offset;
> 
> Any reason not to pass a phys_addr_t in the calling convention for the
> method and maybe also for dax_zero_page_range itself?

I don't have any reason not to pass phys_addr_t. If that sounds better,
will make changes.

> 
> > +	sector_start = ALIGN(phys_pos, 512)/512;
> > +	sector_end = ALIGN_DOWN(phys_pos + bytes, 512)/512;
> 
> Missing whitespaces.  Also this could use DIV_ROUND_UP and
> DIV_ROUND_DOWN.

Will do.


> 
> > +	if (sector_end > sector_start)
> > +		nr_sectors = sector_end - sector_start;
> > +
> > +	if (nr_sectors &&
> > +	    unlikely(is_bad_pmem(&pmem->bb, sector_start,
> > +				 nr_sectors * 512)))
> > +		bad_pmem = true;
> 
> How could nr_sectors be zero?

If somebody specified a range across two sectors but none of the sector is
completely written. Then nr_sectors will be zero. In fact this check
shoudl probably be nr_sectors > 0 as writes with-in a sector will lead
to nr_sector being -1.

Am I missing something.

> 
> > +	write_pmem(pmem_addr, page, 0, bytes);
> > +	if (unlikely(bad_pmem)) {
> > +		/*
> > +		 * Pass block aligned offset and length. That seems
> > +		 * to work as of now. Other finer grained alignment
> > +		 * cases can be addressed later if need be.
> > +		 */
> > +		rc = pmem_clear_poison(pmem, ALIGN(pmem_off, 512),
> > +				       nr_sectors * 512);
> > +		write_pmem(pmem_addr, page, 0, bytes);
> > +	}
> 
> This code largerly duplicates the write side of pmem_do_bvec.  I
> think it might make sense to split pmem_do_bvec into a read and a write
> side as a prep patch, and then reuse the write side here.

Ok, I will look into it. How about just add a helper function for write
side and use that function both here and in pmem_do_bvec().

> 
> > +int generic_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > +				 unsigned int offset, size_t len);
> 
> This should probably go into a separare are of the header and have
> comment about being a section for generic helpers for drivers.

ok, will do.

Thanks
Vivek
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
