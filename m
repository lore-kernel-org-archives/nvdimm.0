Return-Path: <SRS0=QkFa=IB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A6EC433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed,  3 Mar 2021 08:20:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6A20164E6C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  3 Mar 2021 08:20:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A20164E6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9531C100EBB67;
	Wed,  3 Mar 2021 00:20:22 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=216.40.44.81; helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com; receiver=<UNKNOWN> 
Received: from smtprelay.hostedemail.com (smtprelay0081.hostedemail.com [216.40.44.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id F3BFB100EBBBB
	for <linux-nvdimm@lists.01.org>; Wed,  3 Mar 2021 00:20:19 -0800 (PST)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
	by smtprelay06.hostedemail.com (Postfix) with ESMTP id 3F59F180CE5FF;
	Wed,  3 Mar 2021 08:20:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: snake87_191524c276c3
X-Filterd-Recvd-Size: 3585
Received: from [192.168.1.159] (unknown [47.151.137.21])
	(Authenticated sender: joe@perches.com)
	by omf04.hostedemail.com (Postfix) with ESMTPA;
	Wed,  3 Mar 2021 08:20:15 +0000 (UTC)
Message-ID: <aed5d2b78c4ac121ca0cf46107334673a3c9a586.camel@perches.com>
Subject: Re: [PATCH v2 08/10] fsdax: Dedup file range to use a compare
 function
From: Joe Perches <joe@perches.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
	linux-fsdevel@vger.kernel.org
Date: Wed, 03 Mar 2021 00:20:14 -0800
In-Reply-To: <20210226002030.653855-9-ruansy.fnst@fujitsu.com>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	 <20210226002030.653855-9-ruansy.fnst@fujitsu.com>
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Message-ID-Hash: HSHGQFAN5D35CYISIZ4GMB6RLMZDAEWI
X-Message-ID-Hash: HSHGQFAN5D35CYISIZ4GMB6RLMZDAEWI
X-MailFrom: joe@perches.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: darrick.wong@oracle.com, willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HSHGQFAN5D35CYISIZ4GMB6RLMZDAEWI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-02-26 at 08:20 +0800, Shiyang Ruan wrote:
> With dax we cannot deal with readpage() etc. So, we create a dax
> comparison funciton which is similar with
> vfs_dedupe_file_range_compare().
> And introduce dax_remap_file_range_prep() for filesystem use.
[]
> diff --git a/fs/dax.c b/fs/dax.c
[]
> @@ -1856,3 +1856,54 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *=
vmf,l
> =A0	return dax_insert_pfn_mkwrite(vmf, pfn, order);
> =A0}
> =A0EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
> +
> +static loff_t dax_range_compare_actor(struct inode *ino1, loff_t pos1,
> +		struct inode *ino2, loff_t pos2, loff_t len, void *data,
> +		struct iomap *smap, struct iomap *dmap)
> +{
> +	void *saddr, *daddr;
> +	bool *same =3D data;
> +	int ret;
> +
> +	while (len) {
> +		if (smap->type =3D=3D IOMAP_HOLE && dmap->type =3D=3D IOMAP_HOLE)
> +			goto next;
> +
> +		if (smap->type =3D=3D IOMAP_HOLE || dmap->type =3D=3D IOMAP_HOLE) {
> +			*same =3D false;
> +			break;
> +		}
> +
> +		ret =3D dax_iomap_direct_access(smap, pos1,
> +			ALIGN(pos1 + len, PAGE_SIZE), &saddr, NULL);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		ret =3D dax_iomap_direct_access(dmap, pos2,
> +			ALIGN(pos2 + len, PAGE_SIZE), &daddr, NULL);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		*same =3D !memcmp(saddr, daddr, len);
> +		if (!*same)
> +			break;
> +next:
> +		len -=3D len;
> +	}
> +
> +	return 0;
> +}

This code looks needlessly complex.

len is never decremented inside the while loop so the while loop
itself looks unnecessary.  Is there some missing decrement of len
or some other reason to use a while loop?

Is dax_iomap_direct_access some ugly macro that modifies a hidden len?

Why not remove the while loop and use straightforward code without
unnecessary indentatation?

{
	void *saddr;
	void *daddr;
	bool *same =3D data;
	int ret;

	if (!len ||
	    (smap->type =3D=3D IOMAP_HOLE && dmap->type =3D=3D IOMAP_HOLE))
		return 0;

	if (smap->type =3D=3D IOMAP_HOLE || dmap->type =3D=3D IOMAP_HOLE) {
		*same =3D false;
		return 0;
	}

	ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
				      &saddr, NULL);
	if (ret < 0)
		return -EIO;

	ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
				      &daddr, NULL);
	if (ret < 0)
		return -EIO;

	*same =3D !memcmp(saddr, daddr, len);

	return 0;
}=09

I didn't look at the rest.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
