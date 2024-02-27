Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E186184D
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 00:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708995505; cv=none; b=WskkuXbXCuUx8LPS9/4NiQH+DbexZijjor4NPKTyJTMzpK5O4TNrVzz6oTr7vf0FHeHP13wDJSlQEXlfc3OjiTzu1j+R3lTul2+1U2JhOsgMcIeRthZE2rCDvvgbSEgPMLYtg1PyVcAWhydlsfGxoENhDwBgNQid9gJ366XiedM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708995505; c=relaxed/simple;
	bh=qaRGbZw3nMP//+JFjvNcVW+EqA2CwVdYh7gZL5mLkLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ODuiojWSorSYvzZctFMT1bCaqWbzZyuRIqqwMU+GzeNQli+n89jie6WKKuGZe7KCQ2kMGPaysv9I+BYDOHsqQWjm2eP/KP63Cg2zJG3HMvPV0RNiu3y8ZU+Fbvwt8cWdONWsiGIcKOVxPpRjSnp2+JMlS++kqtfh7aOHsSSdd0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGKHVXGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGKHVXGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00271C43601
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708995505;
	bh=qaRGbZw3nMP//+JFjvNcVW+EqA2CwVdYh7gZL5mLkLg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kGKHVXGl/zXzQArIGOQ7r9QPmyZbfpKxLFeEtYFo3tgRArS98f4pPvvIIHM2yavTw
	 46mLQnXKWbC0AGgdmakZ4xDyt3mqI0occa5H+0TqpK/kDG5JFlDFZziwkBOaMbsm4I
	 g2O65NmqYKSBI4nYCm+jOBPuMBkl/W+x63TDUltzLw3mPb1pcWaHyI/Q7mHWEqwscu
	 Mwi+0dLi0+y77wX6Z2JN2UjicfQgwKFxZNfaBboSuhaA2i3qeTiUcfpuyoA8Eb78WR
	 IemhHMaH40FYjNls8yw1N8Hh+8lc6UH+CRPSthDxG8HR26HRWA1rYxuIm4ci9H+e+b
	 9/K6QcvCaXjyg==
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-412a14299a4so17301285e9.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 16:58:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU3wrs6WnXHv3zXvhKe+pZnTgNj2MsqkdW46EnADRS5h+a41TXBlRY/eeB0uiWebnN0EeTqEWroZYOpN+nJi4vTF1tjHrUf
X-Gm-Message-State: AOJu0YxwVGjCBINOuNMaPFFLpvevcWegT+ILD4AkFO817ApkeyQQ/Phw
	n8oOh9+dMTpCI2uYYG5FkK6lgDo8W+36OUGE4By4oymwa9h7uUICTHpYEIdp/w+0Th4hUjg87xX
	3N8//npfbgMaBj7hKB+YxhlTqTFk=
X-Google-Smtp-Source: AGHT+IFqjJgJkjMPawllVB8Z7vRbF30E2T+0rElmebjASihu2o/pZv4K7aKT/m1kXdVooPiQbMb0WJiPbiiC5Pfh6/A=
X-Received: by 2002:a05:600c:a07:b0:412:955e:90e0 with SMTP id
 z7-20020a05600c0a0700b00412955e90e0mr5714587wmp.34.1708995503389; Mon, 26 Feb
 2024 16:58:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1708709155.git.john@groves.net> <ZdkzJM6sze-p3EWP@bombadil.infradead.org>
 <cc2pabb3szzpm5jxxeku276csqu5vwqgzitkwevfluagx7akiv@h45faer5zpru>
 <Zdy0CGL6e0ri8LiC@bombadil.infradead.org> <w5cqtmdgqtjvbnrg5okdgmxe45vjg5evaxh6gg3gs6kwfqmn5p@wgakpqcumrbt>
In-Reply-To: <w5cqtmdgqtjvbnrg5okdgmxe45vjg5evaxh6gg3gs6kwfqmn5p@wgakpqcumrbt>
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Mon, 26 Feb 2024 16:58:09 -0800
X-Gmail-Original-Message-ID: <CAB=NE6UvHSvTJJCq-YuBEZNo8F5Kg25aK+2im=V7DgEsTJ8wPg@mail.gmail.com>
Message-ID: <CAB=NE6UvHSvTJJCq-YuBEZNo8F5Kg25aK+2im=V7DgEsTJ8wPg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
To: John Groves <John@groves.net>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, 
	gregory.price@memverge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 1:16=E2=80=AFPM John Groves <John@groves.net> wrote=
:
>
> On 24/02/26 07:53AM, Luis Chamberlain wrote:
> > On Mon, Feb 26, 2024 at 07:27:18AM -0600, John Groves wrote:
> > > Run status group 0 (all jobs):
> > >   WRITE: bw=3D29.6GiB/s (31.8GB/s), 29.6GiB/s-29.6GiB/s (31.8GB/s-31.=
8GB/s), io=3D44.7GiB (48.0GB), run=3D1511-1511msec
> >
> > > This is run on an xfs file system on a SATA ssd.
> >
> > To compare more closer apples to apples, wouldn't it make more sense
> > to try this with XFS on pmem (with fio -direct=3D1)?
> >
> >   Luis
>
> Makes sense. Here is the same command line I used with xfs before, but
> now it's on /dev/pmem0 (the same 128G, but converted from devdax to pmem
> because xfs requires that.
>
> fio -name=3Dten-256m-per-thread --nrfiles=3D10 -bs=3D2M --group_reporting=
=3D1 --alloc-size=3D1048576 --filesize=3D256MiB --readwrite=3Dwrite --fallo=
cate=3Dnone --numjobs=3D48 --create_on_open=3D0 --ioengine=3Dio_uring --dir=
ect=3D1 --directory=3D/mnt/xfs

Could you try with mkfs.xfs -d agcount=3D1024

 Luis
