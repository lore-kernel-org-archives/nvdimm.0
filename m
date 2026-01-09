Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0206366DCC
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983392; cv=none; b=jPPiGL+q5vRHhxCY695sm/pK14B5bHkIZvckzO5fE2K8kyHcXRnGtTedf0k5kmYt9njgeXsRl1oK9fZiSIq4KmEGo634H2MwbQSovvy6Z+IGWSXY691ssMVae5HlvFpB9IeeFsppG0S0PmbJKdNRaOHgGVwsJlLe77u1BH8kvQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983392; c=relaxed/simple;
	bh=00yYLGXhb42qUhp3Bu+hEI0Ws2wuU/ekKjA7ZDTW8ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YUGrKC5B+9cfFOOPH9XsHzulz34VTKD6nFwulrFpzhK7htM72anNaPJT4hwIPEkyWKz4TGJ1Ja2tsbdbk1YdnVwtABtWPJCZ1JP0mTtJdIQlok7cdlGGXRKX+ewERqk9VmJ+gpZah0nBba9S6gDYB30lXlbOq5d+ibTn4lVbEZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fB1P3j36; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fB1P3j36"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88fca7bce90so46715986d6.3
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 10:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767983390; x=1768588190; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAxsMd9qfhbaF/uFu/ONsXnhJzDpN/ZmkW3TT/4ib5s=;
        b=fB1P3j36Fyr/AYtU9bUS5Tl5bgCFNo2SZelnutYOVj3kU3kmqwK400BEmB934fdpqj
         Vva/je4mHIuzk1+KhOsulBaZl3HAqKWflvQ+lBICPGUMQ7WLDmOX+11dkM5MVhSDgi8s
         ayIEN0JZwG0orq2nRnyYywWbWNAA0jKKENApq+GIOdN1flDNKOIpvwElmRNI8+EEEoxt
         9sznImBUsAWV1L+gEr+Xsw6aNTvf5beR9/uNFXg/cmmwb4ljJFmwXt+d7zFrPCFyheEb
         k+sZ4NgnYZGXb4X668IrTkBqEwWF+NGkzRW7+FyGtNjZGnWAsHFebMv0B4/BuRUPS6c1
         77zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983390; x=1768588190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cAxsMd9qfhbaF/uFu/ONsXnhJzDpN/ZmkW3TT/4ib5s=;
        b=SUW/WsKHseeeJvU3s9beKjIQJBfWLL7th0apecsE24N0u5Rb72nOdR3xK7T3HgtNIm
         lauI1ho3dsF/NG3+iNL9/30c9LMmfcwuBOoaaLfULcHBIduDT9oYPxBZpAZJPJF9cCU4
         cy5H2gQHOPT0axt9vK1ldeh9drIuAIwOZAXKFf8TaN9m1QFD0HdqJlCoOenQAb0jjFc3
         NBY2OjFsxEDNkZhsSUUfxw7j3C1EdViY4JjwlJYup37CIT52Q/dFkkKLu2Ptx6UOUM7Z
         4UZH8AMGLOA+kctEGsRQ8zPXUdLfd2Y2vPyj27SuhAWJfZEZ0p5BrToYJ8E2UuPRt+WH
         s/FA==
X-Forwarded-Encrypted: i=1; AJvYcCVixJ1ZtKUj76zjv9jozCjj7iCwkJv1sj6id4r3/m0su+uy7jxD9/AKxCh9Npff/1rWDKEufLg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHA1Big9uTVoAouhdZcUmQR+/zLBclFzz1VZ0p49+n7EdP9x2h
	oX6oFjY3r1fCwbH2xbBehrPb48wdRhsslCpsiLy9LEZEow8EDJnVBB1Bq5se8A3DS3D9hxgM5FC
	9o8RjrhtJ2LrgRe6rV4yywVcBuknqIp0=
X-Gm-Gg: AY/fxX7xEpo+07Um77iPc13jOuNGOKMxisKM7J99ei3s5jtPjTfO6/6ipQkduhsV1AT
	S2s3VHB4KD/NYTAP8S+WTIQfsdlqkJmd/z/8M3z2/pDxwg7n8txIgJlflMxMuTBSTLpW6iSyejd
	aeC0MSJaTVXpASDmc73H/NOn3RQwqCwU0IXK5GF/WoeE6SGz6NbB0OGtRpNBFV+WpkJiEJ79BMH
	9lbMrQnCkIiv5DJC/gyAZfY/Km1iVmvQIEHk32pwtyMrFHki9CebJjme3AQgUEixbyrqQ==
X-Google-Smtp-Source: AGHT+IHlq/k6aGt3slZY7iNfrk9m2XRGsaHa25Bso2IebEcIgjfLBSdbUtZ1fL6PzKuJnwZWbWVzCQE+c2rsB6YWIcY=
X-Received: by 2002:a05:6214:268f:b0:882:437d:282d with SMTP id
 6a1803df08f44-890841ae54amr151687936d6.30.1767983389887; Fri, 09 Jan 2026
 10:29:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260107153244.64703-1-john@groves.net> <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-13-john@groves.net>
In-Reply-To: <20260107153332.64727-13-john@groves.net>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 9 Jan 2026 10:29:38 -0800
X-Gm-Features: AQt7F2ol_drdQ3iXi69XhhLUyZBWJiqqNDBNu77Lc8heqKjvvqfcHiuhasXh1Zo
Message-ID: <CAJnrk1ZcY3R-iL2jNU3CYsrWBDY4phHM3ujtZybpYH2hZGpxCA@mail.gmail.com>
Subject: Re: [PATCH V3 12/21] famfs_fuse: Basic fuse kernel ABI enablement for famfs
To: John Groves <John@groves.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 7:34=E2=80=AFAM John Groves <John@groves.net> wrote:
>
> * FUSE_DAX_FMAP flag in INIT request/reply
>
> * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
>   famfs-enabled connection
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/fuse_i.h          | 3 +++
>  fs/fuse/inode.c           | 6 ++++++
>  include/uapi/linux/fuse.h | 5 +++++
>  3 files changed, 14 insertions(+)
>
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index c13e1f9a2f12..5e2c93433823 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -240,6 +240,9 @@
>   *  - add FUSE_COPY_FILE_RANGE_64
>   *  - add struct fuse_copy_file_range_out
>   *  - add FUSE_NOTIFY_PRUNE
> + *
> + *  7.46
> + *    - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax=
 maps

very minor nit: the extra spacing before this line (and subsequent
lines in later patches) should be removed

>   */
>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
