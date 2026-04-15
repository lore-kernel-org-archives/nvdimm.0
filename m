Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D53DE445
	for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776267180; cv=none; b=CQgTc0szD5BaskeRJiX7l4xqqved8QpmUAAxl+yGYYVQClHEHk08HG7MMj2TSS/UnpL62hxMGZLF0WAifoaNyoWvhgxEal5nW/BIVXEr6/uz+H/OJmevwq6PzFujfkVp3n3wdu657ULKF1oAToxjUgBcrcRKRcgfcL9kIgiM320=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776267180; c=relaxed/simple;
	bh=S9dcy47a6bd3TjyPD9yCkf196y5TA2ypeoVg+NZ5el8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ouxba76RxFX9/yBpLCkiDxlxAtpoUM3ZwZR0fC5NVg3wRmANuW/VzS0asZ12kZ9jP2W6fufWAG/OU63H0wTiUle+vNWx41AHNiOpRn0WHl6zk09jsYmuEX2RG+YzDpNxgpBdQH5aUyanfg6EeFT5ksa9K4iW/yk1/Kb5IjgIOMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qKZYyjiK; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qKZYyjiK"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-650789b22e3so7989875d50.1
        for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 08:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776267172; x=1776871972; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e5e7YwNWCtbTE/x5+I5oKOHLYRavpYy019TGcszzWak=;
        b=qKZYyjiKtLvBdtt1CGFP2gJKMe4YC/KhkBd2btFLKAbOJZguFwvpV/kOosggZaHi2/
         wdCkmvgj8DFtSg9d0fEtHhfQyKpBG32+M3vSjESqYHeTD166r4wp6ufd/1DW3CAiZ0WV
         Yl7QpuXX5ZTFGffY6lU3ThxROI1zlhUl2Q21WA+FYi0f+ic9MOef78zlaePlpNE/Auog
         tkmdhp/C/gTJSFAfw/9pxalRSXQrHoVX3yyCz4RSBZZGeHptlYwZ2j20k83jVceRIRFt
         WK11KRXJmDi9TFLhXAegX57quO/G4je0bhBFGYvOBBHZ80OsZFmXbAsFWH0IYdBFMmAJ
         dxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776267172; x=1776871972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5e7YwNWCtbTE/x5+I5oKOHLYRavpYy019TGcszzWak=;
        b=RyUqv/1L+fHuuYUESq7P9H8Pkc+guQJBCEjgYORn0m3HQnfCpdaiItkQGevCL4MWmH
         VcM862nbsyiVLwobPWm7M0vFygmLSZ4ZIlYOmndj5eXUc+51fwP7FUoTiCmGVl/FreIR
         Nv38ztiqgtkjiGfhLu8ytjGLQlN3TD9Mu3/PyV4A17xlj2j2/XMT3L00xIiWNGIhGZGu
         mKPsqAYd+SxhprjO2Jzq2HWXmCfS2Cm05RBxOG0DtivK1haSIwTJ5e3fxWldORmcR7Sg
         WMazcGNQShhgQqq7sFMfVe1UKX3SFRLXzRSEJE10eiPWrYjCbOOZFLWMWXsbscB3KoyZ
         DBEQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Tc9MRCBICIvODyqEqzkDM+sFBaNLxmtEYRMQAUJMIErroF/d2wwaYFW8hhwUAA87Jxmax97M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWaWB1mmQSZ2BG3u0plTHTc0PbtL8rGSyUEHoyTmWQceU618+t
	VojDdXz6LH5yvXMMw8wCqDsqc5xLRah4KxiOSPh65ISXfaSmSuHJqzQajO7v1YPCOFk=
X-Gm-Gg: AeBDiethGY7u17hNocYvknZ9TmlFEN5ov0DHYvSaVJA65iDEc72PFU/G1i5CFGjwYQU
	lhCVlq4+fhU1ZLoEkw014jDF9lD8FRISiCis81hvLOTlGUHizA4A30KSxq7xHXzUZog9+5ceGz0
	0uyoSZ0j0g/WY+gCvUe4LVlRL8KV9BeDoPdWpL501M1aBsURM3azAppzZHClWGine78S7sn0RSC
	LDOAAIxzziH2QZzu3o4BhfCLv2jJLu+2FP4/IA5tgdmDzKxAbx+gUewwVDhS/dHMh+nXe3Rnfb2
	mF22l7ukD817L8DNBUTmSmxDB0ZXFDS61s3D7U/ikD0+Okd8uvyN4vYRtQg+M+JPh21g8sxajIX
	cEcwRXrz4w4xaJU5N+8ppNopRBQtIgtxcnhC4BCvq4i1k9IBDVjeqXaXE5i0EYufDjlpRPOV/M/
	0uhB6eTVJngweUTCBdBus5ahMCG3+v84I3+cMHUzxgVkUCshA2
X-Received: by 2002:a05:690e:4188:b0:651:c024:5726 with SMTP id 956f58d0204a3-651c0245898mr12329101d50.33.1776267171618;
        Wed, 15 Apr 2026 08:32:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2607:fb90:ea03:4042:f7e3:e9e9:9e22:5a8e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ae6cb9ea1csm16952326d6.28.2026.04.15.08.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 08:32:50 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:32:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Groves <John@groves.net>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>,
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
Message-ID: <ad-vnqRrUGs9n0N8@gourry-fedora-PF4VCD3F>
References: <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F>
 <CAJfpegsUVv0ziMSQiq9pKeXf6G-+LROPTW077hHMSmAirVCLQw@mail.gmail.com>
 <ad-qSB4oL5D3S-ht@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad-qSB4oL5D3S-ht@casper.infradead.org>

On Wed, Apr 15, 2026 at 04:10:00PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 15, 2026 at 04:04:50PM +0200, Miklos Szeredi wrote:
> > On Wed, 15 Apr 2026 at 15:35, Gregory Price <gourry@gourry.net> wrote:
> > 
> > > This was my first reaction when I realized the BPF program would be
> > > controlling iomap return value in the fault path.  Big ol' (!)  popped
> > > up over my head.
> > 
> > I'm wondering which part of this triggers the big (!).
> > 
> > BPF program being run in the fault path?
> > 
> > Or that the return value from the BPF function is used as iomap?
> > 
> > Or something else?
> 
> If a BPF program controls what memory address a fault now allows access
> to, who validates that this is a memory address within the purview of
> the BPF program, and not, say, the address of the kernel page tables?
> 
> (I have done no looking to determine if this is already considered)

From an initial look at the existing bpf ops structures, I do not see
any other struct with a similar (obvious) pattern - so it's not clear to
me such a concern has been exposed elsewhere or directly addressed.

There is a verifier step for the BPF program that in theory would
validate the range matches the DAX ranges, but i think that only
validates the types are right and only on load - I think the BPF
program itself would be the address validater, which is a strong no.

BPF folks please correct me if i'm off base here.

My initial take is that it's a real concern a "bug" in a BPF program
could let userland map arbitrary memory into userland page tables, and
such an extension would not be a quick fix to the FAMFS problem.

~Gregory
