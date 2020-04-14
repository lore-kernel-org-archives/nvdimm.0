Return-Path: <SRS0=8wp3=56=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B50AC2BA19
	for <linux-nvdimm@archiver.kernel.org>; Tue, 14 Apr 2020 12:54:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC0112076D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 14 Apr 2020 12:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cO3SG34p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC0112076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A294010FC546A;
	Tue, 14 Apr 2020 05:55:05 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=205.139.110.61; helo=us-smtp-delivery-1.mimecast.com; envelope-from=vgoyal@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 75A6F10112D5A
	for <linux-nvdimm@lists.01.org>; Tue, 14 Apr 2020 05:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1586868866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ccpe52mTDyC9nOe0e/xM0kPaLBd9rNdSI9IJFo2/EN8=;
	b=cO3SG34p7kR/B6TTHM9QdstnXHEJbGD9gTWQ9DWtDHtS+yWuk21KZqTnVTHkAKd1XnrDqw
	Njbp+CSjHBY+AMUDYwWyd3gXZ+dEoxSnQxWqsRrfOzwBwrJn6qYvOb+nUTpBXpB2W0Reds
	pvRgNoP5cmlL5wJ+G3AAUFNOXIoOkhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-YVT18TVnP6iwR2Qxc-UDZw-1; Tue, 14 Apr 2020 08:54:22 -0400
X-MC-Unique: YVT18TVnP6iwR2Qxc-UDZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF89D8017FF;
	Tue, 14 Apr 2020 12:54:20 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-133.rdu2.redhat.com [10.10.115.133])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B509A10027B3;
	Tue, 14 Apr 2020 12:54:11 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id 24C16220935; Tue, 14 Apr 2020 08:54:11 -0400 (EDT)
Date: Tue, 14 Apr 2020 08:54:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Liu Bo <bo.liu@linux.alibaba.com>
Subject: Re: [PATCH 13/20] fuse, dax: Implement dax read/write operations
Message-ID: <20200414125411.GA210453@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
 <20200304165845.3081-14-vgoyal@redhat.com>
 <20200404002521.GA125697@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200404002521.GA125697@rsjd01523.et2sqa>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Message-ID-Hash: GYG5EBB43HAGEHHLDWKUR7BKDLBQAE6P
X-Message-ID-Hash: GYG5EBB43HAGEHHLDWKUR7BKDLBQAE6P
X-MailFrom: vgoyal@redhat.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com, mst@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, Peng Tao <tao.peng@linux.alibaba.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/GYG5EBB43HAGEHHLDWKUR7BKDLBQAE6P/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 04, 2020 at 08:25:21AM +0800, Liu Bo wrote:

[..]
> > +static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
> > +					 loff_t length, unsigned flags,
> > +					 struct iomap *iomap)
> > +{
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > +	struct fuse_dax_mapping *dmap;
> > +	int ret;
> > +
> > +	/*
> > +	 * Take exclusive lock so that only one caller can try to setup
> > +	 * mapping and others wait.
> > +	 */
> > +	down_write(&fi->i_dmap_sem);
> > +	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos, pos);
> > +
> > +	/* We are holding either inode lock or i_mmap_sem, and that should
> > +	 * ensure that dmap can't reclaimed or truncated and it should still
> > +	 * be there in tree despite the fact we dropped and re-acquired the
> > +	 * lock.
> > +	 */
> > +	ret = -EIO;
> > +	if (WARN_ON(!dmap))
> > +		goto out_err;
> > +
> > +	/* Maybe another thread already upgraded mapping while we were not
> > +	 * holding lock.
> > +	 */
> > +	if (dmap->writable)
> 
> oops, looks like it's still returning -EIO here, %ret should be zero.
> 

Good catch. Will fix it.

Vivek
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
