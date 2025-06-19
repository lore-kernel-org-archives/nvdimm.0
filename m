Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31F123D28E;
	Thu, 19 Jun 2025 17:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750355299; cv=none; b=nvdj4tFhfkEOHWTPYRqK1aHbnftqa1dvZY2ZjFLhhZholP1LrCKusOPtwrCCCr4CPBEj+CGMa0RFt4gjIJd0Gf5DPcKWFXT0cawyEeafppqqrvWKgrGm2BnNZqMse+dipObrLC/CRVbD2Qla7oeRBVJI3nO+L5cuImZUq/dIS+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750355299; c=relaxed/simple;
	bh=YvO5fzYLvhWnXwDLeu0osljtoe46Ll4TNlde5gM445I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QpIj2K9mmMYs7vyxemAq4kZSgWiUnDkEfH4Vo6xKrE+cAr0iT/97QzvYkjBEF+jbcS+IB3YjrYmZEn2i5sqEwrKPOdeqKQVWG+/Q+3JCUNHxMnrahd5ZcVCTCMVU/ZfZF6TcAGjOsy/XwXCcmk1jvfripVd15QW1T/agZVpLLEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKZ/Jei6; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKZ/Jei6"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-32b855b468bso9819961fa.3;
        Thu, 19 Jun 2025 10:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750355295; x=1750960095; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YvO5fzYLvhWnXwDLeu0osljtoe46Ll4TNlde5gM445I=;
        b=fKZ/Jei6UwDxt9MzdpYSPDyciIfjpJ311hF/rh8g/lpZt2UmrcgB0XxorcVS651mA8
         e6fM9kzFlxmn1Kqn54BOX2KmN3rgXHFUTiH2nvpcPXw9YX0BKRGv/WckRAX1KkSQ+MNO
         qstg62X0ailrZs9kfkAbXEPFbHS+VqEvqibbet951j6Ahuh78aIiIln5d2z7XiyAHewv
         yznNBUFmhh82memcW8TYbGCLYHyX8ImP7yD+qyzMZv6LPfAmBiu5C/MoUwZ4nFJMk0Mr
         0Noq27ryaKC03R12jkstj2LC1peIl3zTYpaIBS4bE/NrMox/bbWZcGU4Kpr2EAwLCBpN
         bgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750355295; x=1750960095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YvO5fzYLvhWnXwDLeu0osljtoe46Ll4TNlde5gM445I=;
        b=T/+PexpEIJIMgWd74VgllnUNc+YEFDfqh8L42x3WAS7Ar/PhANLIitWMZQQXsK5P9/
         IG8ZgDjbFGrlkPcySq2H9QUx1/XXJOsSeInzaR2T18c3E2kCZG6LX6f2JP42p7TNP/fh
         pajjcxPQ/H+RzYV6IGah7LZzoGtE+kvHcl18U7IXgRYW0yKxSWsCfwJs+DIHyvSA4J1B
         CRmaDtc9jCVxgrZE1eo8lPewiZI7YoCFtxjsf26Ta5POMKsAvzcvslEi2zbqzaJSNc0J
         4l3lL++n9foDnjOFH07n2piJ11Sm4Zqnu727CtQfwNZ8yeyUzJO+gKCwQLrEbYAzmz55
         6JBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhWRhVcBhBIr9wHGmQwiEjxkD+dN49NcC+XnPKrfhZsIJb7bHJ+4IZskOVIUlFdtbvqg6tO2xz@lists.linux.dev, AJvYcCWBz3/zPI3QSKkcqbI9HeVonBY9hbrXzqwdBckaASgo43IWc5+hMOil0dp+q40dfHEPfHdRjw==@lists.linux.dev, AJvYcCWDv2hn1XcoiFos5yvAijvBmwJJq6rO1S7arZyDAYeIy1fKdoC1PhGgXdvAA1ePEED49+M9BBDZZ11z+BQ=@lists.linux.dev, AJvYcCXbWoVtxKvmeUmQu7pI08q57xVXeeKqVj3qz2NnARcfHJbvepEK27nCqRK9PoANytwJelSlMg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMZS7qlE+Vy1pwQHF/FK57iSduMKjU6blnwYcmNEtd31LuonVy
	NvSZ+EqTTI8wm2Fuc2PKF5UpgWxny83+gxr5Dof1rFi4J5zLEOCZ02IL5doFdznBRsT0AOEITIJ
	Hz8GAg0vIWg6kIJLNWIctd/Op8RYZxIc=
X-Gm-Gg: ASbGncs87CiMgFa64dt8zfqgdOP2JLIsroz+gmeuP5ZKgNyOTILRpLdedvcMVmRDT6+
	K2qusuFMWzfapTrp7CrD14lfFa3YcB/XHJGuZiuhWN9bZSML30h/vd3GZE7XBWCY20umWNCC8yc
	jF8aiK/yd0WwgvuOVoH08uEDo1UfqmPVYgi40NksI+GGkFxnzodShCGtxJh3Zg8iAPxbEpiy3Mz
	K3Q4A==
X-Google-Smtp-Source: AGHT+IGL41V3DbmFvBsWr3jGwFHfcX0duW69mbczpCAOINsa85ECUigYdfUlpWqgF++enxibRnhFFvr8Kxdp2WtP+R0=
X-Received: by 2002:a05:651c:2203:b0:32a:8297:54c9 with SMTP id
 38308e7fff4ca-32b4a3088bbmr63065741fa.8.1750355294494; Thu, 19 Jun 2025
 10:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1750099179.git.lorenzo.stoakes@oracle.com> <f528ac4f35b9378931bd800920fee53fc0c5c74d.1750099179.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <f528ac4f35b9378931bd800920fee53fc0c5c74d.1750099179.git.lorenzo.stoakes@oracle.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 20 Jun 2025 02:47:58 +0900
X-Gm-Features: AX0GCFsRgomy43xV-Lv7Stfld1a1yqIyJ3-ysZ2OVO90S8cEE5UAjZMSvGqxZQ8
Message-ID: <CAKFNMom4NJ91Ov7twQ3AGT7PSqt5vN9ROrNHzfV53GHf=bK6oQ@mail.gmail.com>
Subject: Re: [PATCH 10/10] fs: replace mmap hook with .mmap_prepare for simple mappings
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Jens Axboe <axboe@kernel.dk>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	David Sterba <dsterba@suse.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Tigran A . Aivazian" <aivazian.tigran@gmail.com>, Kees Cook <kees@kernel.org>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Tyler Hicks <code@tyhicks.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Dave Kleikamp <shaggy@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Bob Copeland <me@bobcopeland.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Hans de Goede <hdegoede@redhat.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, v9fs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-um@lists.infradead.org, 
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-karma-devel@lists.sourceforge.net, 
	devel@lists.orangefs.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-xfs@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 4:48=E2=80=AFAM Lorenzo Stoakes wrote:
>
> Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
> callback"), the f_op->mmap() hook has been deprecated in favour of
> f_op->mmap_prepare().
>
> This callback is invoked in the mmap() logic far earlier, so error handli=
ng
> can be performed more safely without complicated and bug-prone state
> unwinding required should an error arise.
>
> This hook also avoids passing a pointer to a not-yet-correctly-establishe=
d
> VMA avoiding any issues with referencing this data structure.
>
> It rather provides a pointer to the new struct vm_area_desc descriptor ty=
pe
> which contains all required state and allows easy setting of required
> parameters without any consideration needing to be paid to locking or
> reference counts.
>
> Note that nested filesystems like overlayfs are compatible with an
> .mmap_prepare() callback since commit bb666b7c2707 ("mm: add mmap_prepare=
()
> compatibility layer for nested file systems").
>
> In this patch we apply this change to file systems with relatively simple
> mmap() hook logic - exfat, ceph, f2fs, bcachefs, zonefs, btrfs, ocfs2,
> orangefs, nilfs2, romfs, ramfs and aio.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

For nilfs2,

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
