Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058B6319858
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776781819; cv=none; b=UiTdT6n1JK7P88tbGztl7UU9uBKff4E4VTpHqGEL3WFh4NQIsj5ulxfIsTNnPkoXuco/vSC2BUNYjvCSKzxmeGNqWzHSgB/qOGxRXkQsHgN5motUWVGOdyMaVLePcI1PDfgxPcDOYwchMuebPo2cw3c36rSifdIMZyVPFF6uHMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776781819; c=relaxed/simple;
	bh=OOpDos/Z9VaSP4OAHAzHjn2FVBZGB3TMPAJ8x0XR0vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unAu8grm4aQU3yrVBpFPdUIJRTMFBvue87/TbACYCJRWZgVCLoVqeCRcv/fofylLH5a3eRTBtJc6yIfSKjkh4oeb1qTa9ohSsfv4kdbmujZbkGuhyQJCBQdXgyxo3jR+ZZCz40MYYb19pUNxg7+odweaBVxUce7/qLy0eFa820c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Z6ExfpUJ; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Z6ExfpUJ"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8ee9ec26edaso68897785a.2
        for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 07:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776781817; x=1777386617; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J5FC0V63oKQuJOmL33I9jXWd+zejUzRlce9wtAa95Fk=;
        b=Z6ExfpUJRcHGXb1fdigMGbZucWQqCvWKuDGgmSuy6uF4vL2pXcSjqZQB4vxwqdsyp9
         8DDSicwbhFbJS3sN646/Du5U3QIha1KVHoeth8z7uRc4F4MIh1QW6jaC3DkvO8HzRtU7
         4f8EfjxR/GfkneoIk2TrOx7josNNurn/DeJO1h5Ifa9Pcbix0b3woTxkvtbGfxeX5eXM
         tyPUzk7iSfJOcnAcAHb5VhcISAZgZ1dsl5nBwu2zY65+7eMQp6ghfv0xJrQzzMqQIq1D
         w6RoOmSw1x3cSKxVoYaNezu85oMXZugn0drWzYaeO1yv24TkDGZSWK/T2i2cGDnaJS7n
         miug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776781817; x=1777386617;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J5FC0V63oKQuJOmL33I9jXWd+zejUzRlce9wtAa95Fk=;
        b=c6DNgWb41cN5BOEBwVNaVZaIralVORn9tc0BRWs4pPA9PETE+L+PSX9xXKukedv/vQ
         erLxgAPzBjtrfWoARUJS7145aQGyiBkSN1+wUxMZy0vAVTYBBiwDDsIbDLG01c6r0pFY
         q6D9L64VUddNsTe9G5YeU59bnlxIw/vNcONhjptKFQDvMPzTCviAKLRvtdJz6qqC+EgK
         Nlw8v4fK+2lT79NZ7tg26t/aWCQTzEFwnzuO+cfI/lG7vi5I75NAfLwPCE21iScCFKXe
         iiXYEQJzh8Xmo6syBsbqEOfl3N3VpdjOEw8jy42WbKuVgkpnT4syHxdf2Mhq9J2NDM/d
         2FrA==
X-Forwarded-Encrypted: i=1; AFNElJ+LJJPmZrgVl49HYULZA/Ss1reqfjwbp6fK26waN/OVlqaFofN0kfZKK566C1WjEldLzzqEtHA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxw00mSpOEO+2FyGldZcBIdF81z44M11pKiml2n6K5jIEFUqauF
	6olVEnAXNU6KJ5muX8/b8v/OoSQ8bAAYT22bagrExZnvg6ciWmq77RRIA06E9B7V0nE=
X-Gm-Gg: AeBDiesXzwfjsDO336gEPDrIe5qKVBYdM7xZy5vEjZe61aZMcqpv1pE2WcG1KNH3p4j
	MHbgBkX42oNGYViG0jvRJyuLOTyR0LjDP5wW+HdyFqH8ippiSuthHc7XbUFQZ7dHIUGpKLY8jr8
	/Xw2hW5lP/qFLTJVoNKobunv062R3V9B0hXkq44+d1G5c73xL8RKZDMrzBXkd5savWw/Groeo9R
	R7LEkwzHhZIrsYXGk++m6a3Xmi6w550XPcAafAle0mvrvQyhjLcwh0RBdip3YtRfk7PgwHuc2GE
	xCIAL0HqI8EtKUq6PzG0+EKmgHFQRVbjsOOtGZp1FVZDUx9HREX1kBmTJWWoq/TVWuLFIJJmf+G
	PprVSoshf9dg3LM6RXNEBhj6AsmdCTHsK5CxVYmoDvptv3YRKVle6sp1T1vsFQ+bneClHBsWKX1
	OS0uBL9P0c3jD1GM6wuphh6B1zKnUSvVq4mxAVOpSUo7p4V4c=
X-Received: by 2002:a05:620a:17a3:b0:8ee:e011:a77a with SMTP id af79cd13be357-8eee011add0mr229077285a.13.1776781814650;
        Tue, 21 Apr 2026 07:30:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2607:fb90:a81f:533:271b:a845:9f29:eff0])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb19632130sm612607285a.41.2026.04.21.07.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 07:30:14 -0700 (PDT)
Date: Tue, 21 Apr 2026 10:30:08 -0400
From: Gregory Price <gourry@gourry.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: John Groves <John@groves.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeeJ8Lgg2z0X-NC_@gourry-fedora-PF4VCD3F>
References: <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <aeUU8hMwPij2WvfF@groves.net>
 <aeVy2MzucnrLlOQx@gourry-fedora-PF4VCD3F>
 <CAJnrk1ZpPS9rOoBqOBRsqTu0Zgk=aoYzpYZ0mAVDCoeewtLhcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZpPS9rOoBqOBRsqTu0Zgk=aoYzpYZ0mAVDCoeewtLhcg@mail.gmail.com>

On Mon, Apr 20, 2026 at 08:12:17PM -0700, Joanne Koong wrote:
> On Sun, Apr 19, 2026 at 5:27 PM Gregory Price <gourry@gourry.net> wrote:
> >
> >   struct fuse_dax_fmap_ops {
> >       char name[FUSE_DAX_FMAP_OPS_NAME_LEN];   // 16 bytes
> >       int (*dax_fmap_parse)(struct fuse_dax_fmap_parse_ctx *ctx);
> 
> Just a note for later, if the bpf approach gets pursued further:
> instead of making this a dax specific ops, I think this needs to be
> integrated interface-wise with Darrick's fuse-iomap work since he does
> the same thing. I think dax_fmap_parse() could be renamed to something
> like iomap_setup(), where userspace can use this to do any sort of
> generic setup, whether that's mapping related or dax related or not.
> In my mind, the dax vs non dax distinction is handled by the fuse
> iomap plumbing that chooses which iomap entry points to call,  but
> beyond that,  the callbacks and struct ops themselves should be
> generic enough to be shared between the two.
> 

I think this is reasonable.  I'm not a FUSE wizard either, but I would
presume the iomap_setup() process would just essentially be John's
existing GET_FMAP / GET_DAXDEV code bundled.

GET_DAXDEV happens lazily to save him the round-trips to userland if the
DAXDEVs have already been seen previously.  I think your proposal does
in fact save him further round trips, and it would probably solve the
performance impact he saw from porting to FUSE.

> > And otherwise, imap_begin() works exactly as Joanne proposed, but with
> > in-kernel cached data instead of the bpfmap.
> >
> >   const struct dax_simple_meta *meta = (const struct dax_simple_meta *)
> >                    bpf_fuse_dax_resolve_get_meta(ctx, 0, sizeof(*meta));
> 
> another note for later, if the benchmarks prove promising and after
> the LSF discussions we decide to go with this approach: imo we
> could/should repurpose this into a generic
> bpf_fuse_iomap_get_inode_meta() that returns a bounded pointer into
> whatever opaque blob was cached on the inode during iomap_setup(),
> where it'd be a generic kfunc serving both the dax and non-dax case
> for any kind of mapping layout
> 

Note that Christian Brauner just said he preferred not having dedicated
bpf storage in struct inode [1].

sans BPF, is there value in such a metadata blob existing?

If there was a generic format, then I suppose the blob storage would not
be BPF specific, it would just overload it (simple union).

[1] https://lore.kernel.org/linux-fsdevel/20260421-arsch-gelernt-e0b5bcd8a7ff@brauner/T/#m8fea90f5ed4a1b23bdc2563d978948b263b2030b

~Gregory
