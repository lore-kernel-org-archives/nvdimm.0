Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A23DCDA1
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777041339; cv=pass; b=WT1wS8Mn2Psrv29Ej9+qTzFKsrJZ6hN9X49AJGbWx8CqwgHS8tRcrbvWz8ut6+VgDScHngLpWEQ8I96N7x+92XkXnRoLG1Da9KPKLscZIN5UyFCohY7Wl2qSe9+t0tLg2T3+DVEwvTTyVAi5SwQYMGpni6wvanazZAnHR/hFN0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777041339; c=relaxed/simple;
	bh=p9jt1gHiba+dFBOeRmZKFoj/PrXR4D3UohMC2L6rPSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TzQoI9fZASr9IZNuLYXlL60HJj8D4oKnSHwQxXImn1dwNGwvjABpAYPy5+I6DGE+QWpr28T4oNXLQzG2Uofuokr1i2uP6Cjyfokj9iIi86iQBoL0Mffjxol3anzrrvNJ78DMvq27ivYQ5UNQshAIrF0unztONCbGtq/3WaS7/IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VD4uCk3L; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VD4uCk3L"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ba8472c1613so1011376266b.0
        for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 07:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777041336; cv=none;
        d=google.com; s=arc-20240605;
        b=cbTtAfkD987J4nsZS/IL74gcO3zJFwP5VNJUA3BYQRz45H1h2B/Y8pfgASi8/i7Hdr
         P/Bi8GhQE5zR2MWOHH1PQ7vhS4681nR35/gzT/qRGdbOvbveF5iRBFaCTpvBFDGpdMNk
         oSApgkyZBC0u0Sc3OaOEx4laT6wu4hIP0cbK5g1nmwwuGTFp9uC6UE9suOEBjNVZHFI5
         zjXQpNkYqRuaWqYxhUg+FXvzq3srr2hccM7g7aGeCW1ErmBRVvtcXYuOl9zLJpPnxnPz
         7LfXJQUDC/935KxD0dAhJaLOvl2EXtsjFMdSNoEcHNvD73OEx0VZwJCJdnzGAhGtn7jg
         D25g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wytk7xcJQB1xNQvFPDmiI04wJ1luZnUZ5xfDJ7i2YWg=;
        fh=VXnhjV6/odix74X8dwt6JnCFW2oATDmZX3fHbNludPk=;
        b=axP/ops6QD2hO7zy/ze52K9IMWZAUd14GxfwljPQOy37EhrbSw/cfRXNRO8pUczgoF
         Um2AzJSlgey0HbXtEM65CaOXICpnMc/PjSArNYT0fnavIwgE5Am0C61gta7ObLBOTB/z
         zzkOvmJvfEKIAuY74ySz7ksLCce25g/ebfFqH9YpGnYDOdwaXeQUodRkDYFWrl4/PGzy
         HLXWx/OYwx9kPcNFjiN3mb7AXuKsrzh7dEhGBnV9QC3QdMcvx8UQyVIpXdo0zIu+Oev5
         pKgFGmBY6lQtWD3o2jrvPHrpY8o3o06Bu4biE8EMmZRsdNUyT6qMI24TJz/+jJNjSIyK
         KQLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777041336; x=1777646136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wytk7xcJQB1xNQvFPDmiI04wJ1luZnUZ5xfDJ7i2YWg=;
        b=VD4uCk3L3xbhe1mtezlD095eZ1pqafChtBAZQyJ8b3vmsX7m5Ngb68xVw0vdQ6aoxb
         d+kOSkD44Ki1LbMnuTtY81THEperU4qEM2dOCBf5c5cwyLhIMO3nrpUcS9L/zQaSc2BS
         HPK4D1doP2vVUIZ7WUkGQoNBMN/DQ5r2Dvl2Huz5J61ChXfjylwDmeh1clgO7MYxIk9k
         +37zht47jaGdq9D5iEgj+Vs7Lbdt3DmkhViPDoYSBZbZhDQWYTodmE4yF/BZ8uhdbyHg
         yuMXEEB/f8VARXNdRUxt2fRCD6lqNaoMDxelpIMV0fIOfo52BI6tWehGWWFfYTTwvatF
         zepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777041336; x=1777646136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wytk7xcJQB1xNQvFPDmiI04wJ1luZnUZ5xfDJ7i2YWg=;
        b=dPr6K940QHA3gzyI7zcbsA/3Wf/Sz+Jywa8yS3VJlbjOsk64o1rcMoxBIMb//Eol9p
         HEU3WUUeOKaeuW0Y1YHOri26x8FJMcDOi0uXF7V4Rgfq/iOHcNWNljccJEBfXDudwvNM
         KHH+F970qG9Pgp8zR8/DF6qjpDAipCuTDNSb6qiZyTKje8ERfen8Lxb3YKWNXu9t2AsQ
         5x+MiEs27Cl75w0n95RfR7g6Xy/tMX5Mz6PhTsP7/AkQrziy1t3aowW3VEeokeJ09M+3
         10rwLn/ENKWCSv8sQZ+m0gJ8K+iUOQ/LsGeQiEZpEqCrRWzNik1smkBy8XKaOfTWfoB6
         7BBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+9Z1MdPfx+iRswE6++jQKzPL5FTmRUrJmJ5oFcfLH0GlQqLP0ukj4zVSCEcY1dFh8RpmDAaXM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyc8qaVRA37EHK7OrPHTiV8+4vBRbFmlPT1uWEWIQu7IiBSxqVT
	IduXGS18+ejAEB3ej+6MxCL9B1oz9+C08CA0Mp00AYMC5+cdXNLHvk5lGbWfrJfj/1X7v73bEx1
	iPW3hPPq3G7miaM9Lruqsk9KBmreJ+ig=
X-Gm-Gg: AeBDiesasepkk7o/0d8ujws/VJN+M42ChNgftKV/rjG5Pu3D07yeOqeFa5axKCxaKVF
	XlQbcaB98r/nZXiSyECCTq2wgb85qv1bbxn4aNsqgaBRqGP9ASW+FNnR2bj0LL8mY+QNuMtuNQp
	topc+MZQnNf5YOHeAixSN2e6P/VS81Rxc85X/6sDUsDKrs9mWqsVVuRubhKcsQiAYCz/rQACvQT
	XGBbcrJT+2SWMDHz+/Rn9E2GtGZI4kq7nmNQOlEGJyXklE0oyVMQnA7RiqbvxrtoV28sdwcZiDu
	+SJCMKPY8Fz2ZO+TlpJRnlmUAil/23lnbeuy/JiVxe4myrS77SRz
X-Received: by 2002:a17:907:d93:b0:bae:58eb:674c with SMTP id
 a640c23a62f3a-bae58eb6a09mr81309766b.24.1777041335826; Fri, 24 Apr 2026
 07:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net> <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F> <CAJnrk1ad6t6CJV+xnXwhoNHrHYA3htuaVdDq47FeT60cPBzj7g@mail.gmail.com>
 <aeHXQ2EW2ivlLb_N@gourry-fedora-PF4VCD3F> <CAOQ4uxhXTTyySG3tXnqNnP0edbbwUxfeeC7=CypDSyw_Mod48A@mail.gmail.com>
 <aetxDlr0e9ILFIcg@infradead.org>
In-Reply-To: <aetxDlr0e9ILFIcg@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 24 Apr 2026 16:35:23 +0200
X-Gm-Features: AQROBzDRfaDvwqj3ChfxGHta3IykNz6mtcAvKLit3KlwoyD0SfB9SEJdl9WFDYQ
Message-ID: <CAOQ4uxi2sb4rCR9_xTD3FFEwiPXxDG-sYzvAWqcjMQi1+Om+gQ@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Christoph Hellwig <hch@infradead.org>
Cc: Gregory Price <gourry@gourry.net>, Joanne Koong <joannelkoong@gmail.com>, 
	John Groves <John@groves.net>, "Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 3:33=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Apr 17, 2026 at 11:06:58AM +0200, Amir Goldstein wrote:
> > If this logic was to be placed in fs/iomap/ as Christoph suggested,
> > I think the rest of the UAPI issues could be sorted out.
>
> For that you don't need it in iomap, it could stay in fuse an be a
> generic striping API.  Although IMHO doing it in iomap would be a
> lot cleaner and more efficient as well.
>
> > In any case, considering the sheer amount of discussion on this thread
> > I have scheduled a cross-track FS+MM+IO for Famfs and DAX iomap.
> >
> > I wasn't going to include Storage people at first, but since Christoph
> > mentioned that stride/offset iomap could be useful for block iomap,
> > I included them as well.
>
> There is no overlap with storage.  Any use of this would have to be
> file system level striping, not stackable block driver level striping.
> And keeping the rooms smaller is a win on it's own - anyone interested
> can join anyway.
>

OK. Changed to FS+MM.

Thanks,
Amir.
