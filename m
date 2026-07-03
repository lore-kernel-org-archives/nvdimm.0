Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B3E22173D
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043280; cv=pass; b=kOAfLza0l02LFx4zTmmrpm+6V+cufXINB/C9zmmS1MZZxsjmS5af+0LFdy9o2JxOG3Z/+4Igfnvfv9p9Ky7GuMoXxDpia2ZhWGmFk9XzzhFZnJ/fPWZerwSHv+UKmXDkmU6NiJ2wnzgqDsDkkAiOtyKHy4IQ6u6R7YeXCeASsXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043280; c=relaxed/simple;
	bh=JLtvplRuOrV1XCd+vmBKYGpvhguS1Ynr34OsxGcjbOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YXWqO8qiFw6QMxSyurTTecrBJjXe2Un9wucFfEjwFRVtJ28P0kByp6Zob9SHFxPbKNSk3Tv1/k3nmv0Ks8qI0J4wcvW8kJGQV4qA8UYC2ndmrbcC//kYYcjnJdg2Ilpa65wW39EnR+lUc5H6Kkc4ryg3wKvoFT9V5lkQuIgcup0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fu/DB+r0; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fu/DB+r0"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4758bd3731bso37164f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 02 Jul 2026 18:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783043277; cv=none;
        d=google.com; s=arc-20260327;
        b=YBb2cmOjxFGi3xfK0B8N6aTGOil7CxiG/uLt0wZ53udIaJhe07y1RvtOeh4T/fvxlG
         YGxueccVfiHd7obR1gUG91aY5WYuk1CpFCL9I2ryTKSzQ+oiqmuvEuoQCl03y34b35DJ
         1jkl2SXKgTwLquzmriAJsxyk3ItilRWdOFSLfxVniutIO0e60mpwxcEKS/a+Ouyl6V6I
         cFOhLq8pvlHlGDmNFuTuioDw6q+fJOHFrb49SW9q/L2X8e6XF/UjIUa0TEzMpT/4Ar8O
         7+XBWL0g99K/ncUxHduT0n6UVeeIllJWtnFRq07beloRcf7VgDHR/hap+WPzyzrEIimA
         oCOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        fh=TdWKmf1xMHJqY7b3Y95gRqGhafBIw9EWlhDTOkpVU9U=;
        b=lMlT7dkbjapdlFb12v0BbbWOBUI6mUSXAg4F3L2d0zrFi9ee/P+UbRdkFoKx6JV182
         Yrss94ZF/E9xOR1DQvbR+h/4YRes5KxhpsuSPL5NMjg7mrwb4awtahLTm8O9FbiXs8A8
         50yVi4DwQ1KSKB43hKdo0QgdxAyG1HYFYwwe8e5DQ0mErklx+75JW3DoBH3yTXAB+uMX
         1/adlOH/YD/9iZW7uX2cvUZbFoc0LM6ggoy9hZK1ZlecsWzt9vFirOLz2+oRUaNQBH+6
         93PWGAgf+B/GVh8s0/Zaw3EGQe0o5rLq0vejh4NyaMP3WLaVbrP91pBTdbbIoQmyVFmN
         gcOQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783043277; x=1783648077; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=Fu/DB+r0RBfUABT8PEyvslicdeQXmm7zrMcI+2UHThrUm5r7yVzhIp0iEPdIkfQIgA
         SHIl5N/8GRo6FlvUM84ngKL3T1XYx40Lp93VxFODs5D8HJ7AxeuwYhNCm16U5Rv6q93P
         lGQHWvsWbg9RYEO99IO9W3XawTBV8u0GD+WTvM8A5OeaYovTIfPfbjbh891nydcAbr9h
         /rASLySe6E0QgSgZoyzZOjXJXr2GKghzTvxt8Llc3aCFHqKxNSCtreQ7oYAWY7pDcwyY
         0jVuReXqYyIlxJfVFaiyydFKW3AUfBpSItuu1Vsu6V7mZ+U5SKwMAJo+csQodB3QXYAP
         vdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783043277; x=1783648077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOn6vRfEsVTpudhzzAfawUs56a4yn/B/CVb7CXUItZw=;
        b=L4VmdRMENPxM5AOMvxK0heA7dJd2a7hc19OQV5ih7tb7BVWl/LoJaWAXcZ37AOYPn/
         Uo7+KMGtiRwgHg5a7psp5mVWWQPuPwqAJxaKYTZlg/dP27vukm3Kc0Gh7pz9D3tDMAra
         FE8+EHpMg//E4NScQSzlSbenjvZuT+MhIBkz2XlFTzyt3IwqCkdQSGO7HumVpCYjyXTx
         FC+lJHtVhdKeIrl+tL12RJB5NdxraEAI4GTrKnHQxbJDnS8nT/xpCysliAX8T5E5CORx
         xZqMj6mj2QO6MV5rDPWGS53F1SmuYV1WPNWgD9qro7ehm8wnVdir+KPorih0eztW4iAP
         7hvw==
X-Forwarded-Encrypted: i=1; AHgh+Rq79DWMs7Zv2TlNUyIeXH3OGgTU8ya/ZgbQBjxweH0heuMLuEwuiiMBT9D/yamkoG66tuTwjao=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3CeenkRKkAlfdmrI/InlGtA9rt6CqPl5BeYBuRrPPkKUX1mA8
	PCvzjfqtJfLLBzcE/AKwgrLSsoUh+lwZvI8kX8N0HSYbpZjigkqyW+loqMI1+bHOgbyPBMSjEPj
	D6pzkJ5liWt2S61ZD75CGf+GFprGPHjg=
X-Gm-Gg: AfdE7cloJ8LHFPE/TgnMhlgsyndxHpLmJEf1ik8vNfmM8bpfFTwMh4fu9QYtIqy0yH2
	SlepvhyINJzg5zh0PLZ4eQmCrt7cOzsouK8v9zOLnHvSbvjG1iva/HjMiGZWTsf3nFODjhGWGUI
	xBmbT6kcpX+kuUYqLjwuxV3+vaGpUq0BbfSut6wxiLmbyZfjpFMGaFrQ/c4/M0R9TbwqZj28yE1
	jC2Ros+xaCYJIgvaYqcr1v1Z8gb22S04/FP/QJdOMVGgHpxT6RXHCrwqpWXPKhPeNAfCARj6hjr
	VmMP7I0bsBIVZDWQlaUT4arBFMEjj8D4gHMzqHh1gtLwCNrzpeMU
X-Received: by 2002:a05:6000:188a:b0:474:88ef:cdec with SMTP id
 ffacd0b85a97d-479347abc89mr3414307f8f.6.1783043276701; Thu, 02 Jul 2026
 18:47:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-18-joannelkoong@gmail.com> <20260702140705.GE21339@lst.de>
 <20260702165117.GK9392@frogsfrogsfrogs>
In-Reply-To: <20260702165117.GK9392@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:47:43 -0700
X-Gm-Features: AVVi8CdwjVgCnc8OibEiAJiLFqrCHykAhTtcw0AOMmm18cQj3dSCo5Q-SEBvMhY
Message-ID: <CAJnrk1b8j5WHtbHOWNXc4=QBFOxde1f2QxTOeui7Ta8O-xWcTA@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] iomap: pass iomap_next_fn directly instead of
 struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:EROFS FILE SYSTEM" <linux-erofs@lists.ozlabs.org>, 
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>, 
	"open list:F2FS FILE SYSTEM" <linux-f2fs-devel@lists.sourceforge.net>, 
	"open list:FUSE FILESYSTEM [CORE]" <fuse-devel@lists.linux.dev>, 
	"open list:GFS2 FILE SYSTEM" <gfs2@lists.linux.dev>, "open list:NTFS3 FILESYSTEM" <ntfs3@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 9:51=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Thu, Jul 02, 2026 at 04:07:05PM +0200, Christoph Hellwig wrote:
> > Looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > In terms of merge logistics, I wonder if we should delay this and
> > the previous patch to the next merge window so that we can minimize the
> > cross-subsystem merge pain with more file system iomap conversion.
> > If none of them actually happen until rc6 or so, orif  the merges aren'=
t
> > painful we could still pick them up late in the merge window.
>
> I'd say everything but this patch should go in during the merge window
> for 7.3, along with clear instructions to brauner/torvalds to expect
> this patch to appear right before 7.3-rc1 gets tagged, to clean up all
> the other changes that come in.

Just to clarify, did you mean this patch and the previous one? If i'm
interpreting Christoph's concern correctly, I think he's worried about
other filesystems converting to iomap using the ->iomap_begin() /
->iomap_end() functions still? That sounds like a good plan to me, for
v3 I'll submit everything but this patch and the last one and then
submit these patches (and any cleanup ones that become necessary) to
Christian right before 7.3-rc1 gets tagged (which as I understand it,
is when the merge window is about to close).

Thanks,
Joanne
