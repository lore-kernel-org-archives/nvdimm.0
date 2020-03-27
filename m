Return-Path: <SRS0=ElX1=5M=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057FBC2D0E5
	for <linux-nvdimm@archiver.kernel.org>; Fri, 27 Mar 2020 22:06:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 86DAA2071B
	for <linux-nvdimm@archiver.kernel.org>; Fri, 27 Mar 2020 22:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86DAA2071B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 59FCC10FC359C;
	Fri, 27 Mar 2020 15:07:07 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=115.124.30.56; helo=out30-56.freemail.mail.aliyun.com; envelope-from=bo.liu@linux.alibaba.com; receiver=<UNKNOWN> 
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 02A5A10FC341D
	for <linux-nvdimm@lists.01.org>; Fri, 27 Mar 2020 15:07:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=bo.liu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TtnyMjr_1585346766;
Received: from rsjd01523.et2sqa(mailfrom:bo.liu@linux.alibaba.com fp:SMTPD_---0TtnyMjr_1585346766)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 Mar 2020 06:06:11 +0800
Date: Sat, 28 Mar 2020 06:06:06 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 20/20] fuse,virtiofs: Add logic to free up a memory range
Message-ID: <20200327220606.GA119028@rsjd01523.et2sqa>
References: <20200304165845.3081-1-vgoyal@redhat.com>
 <20200304165845.3081-21-vgoyal@redhat.com>
 <20200326000904.GA34937@rsjd01523.et2sqa>
 <20200327140114.GB32717@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200327140114.GB32717@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-ID-Hash: EXKNEKDM4HDWVA42JM425A56VWLOBXXP
X-Message-ID-Hash: EXKNEKDM4HDWVA42JM425A56VWLOBXXP
X-MailFrom: bo.liu@linux.alibaba.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com, mst@redhat.com
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: bo.liu@linux.alibaba.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EXKNEKDM4HDWVA42JM425A56VWLOBXXP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 27, 2020 at 10:01:14AM -0400, Vivek Goyal wrote:
> On Thu, Mar 26, 2020 at 08:09:05AM +0800, Liu Bo wrote:
> 
> [..]
> > > +/*
> > > + * Find first mapping in the tree and free it and return it. Do not add
> > > + * it back to free pool. If fault == true, this function should be called
> > > + * with fi->i_mmap_sem held.
> > > + */
> > > +static struct fuse_dax_mapping *inode_reclaim_one_dmap(struct fuse_conn *fc,
> > > +							 struct inode *inode,
> > > +							 bool fault)
> > > +{
> > > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > > +	struct fuse_dax_mapping *dmap;
> > > +	int ret;
> > > +
> > > +	if (!fault)
> > > +		down_write(&fi->i_mmap_sem);
> > > +
> > > +	/*
> > > +	 * Make sure there are no references to inode pages using
> > > +	 * get_user_pages()
> > > +	 */
> > > +	ret = fuse_break_dax_layouts(inode, 0, 0);
> > 
> > Hi Vivek,
> > 
> > This patch is enabling inline reclaim for fault path, but fault path
> > has already holds a locked exceptional entry which I believe the above
> > fuse_break_dax_layouts() needs to wait for, can you please elaborate
> > on how this can be avoided?
> > 
> 
> Hi Liubo,
> 
> Can you please point to the exact lock you are referring to. I will
> check it out. Once we got rid of needing to take inode lock in
> reclaim path, that opended the door to do inline reclaim in fault
> path as well. But I was not aware of this exceptional entry lock.

Hi Vivek,

dax_iomap_{pte,pmd}_fault has called grab_mapping_entry to get a
locked entry, when this fault gets into inline reclaim, would
fuse_break_dax_layouts wait for the locked exceptional entry which is
locked in dax_iomap_{pte,pmd}_fault?

thanks,
liubo
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
