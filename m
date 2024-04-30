Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE821BF3D
	for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 06:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714459598; cv=none; b=kX0VAw1lIKANoZHqDXWPlw6HGXamYIQvQTa8VBZ/mzN9Z7Y6Uw6MUFSDWOYb0BYh0VtMTA36m0HooLuRzlNTFzLSqOWAQeSZU2U597GHFfJUJiqMfaC9qMi7kmfvj9OXkw16nC/M1/bUn4ID02ZmVdEBxpUa+kVYDr7MwE/RHmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714459598; c=relaxed/simple;
	bh=BJHpOQBTYl2CusEmnHRWz9TzqP85OwFTue5pk4Z5ba4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IILD+880TMzR5nNFg49TS8IzkmGcBIJgOP8fz6Wks6av+MTnl0jXYIa6Dy2MNWPJBPLU7IssRKs6Gie4i/hgK7AB4YXHadyH1rU7XgAY6115x1OAoe68Lrk/XnF1krOv14x7d3L+GZuQGXCV2tSvYFnmXGxqw1twDTDtDCKYOIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyhknYTa; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyhknYTa"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecee1f325bso4734387b3a.2
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 23:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714459596; x=1715064396; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8hCjGa0cyR+5KjlfrnK0wTPM9nmlXBCTQii4J3Gjgfc=;
        b=gyhknYTaDH31ZVK/1zknfEfsO42R3BfRjrdCXxaTnzdjDIggAF7FNGYkq+gtDJXk1o
         85VaBJM/KmWE5FqnLVcOZBPL6z8Qg7nQ0FxRau6IqzgL9PSUz/3nLFBf76Gra1JIcinl
         VFNfllwUsD7tjF1TixDGBCpo9kMuVle7QQCO7ENG29rDWYC4oEf92u1s3EgT/EU+FQKV
         4BjwE0WBgvrxidS9zJCNYMB/umT7FHxKHNS6F6aMaB4XfiPwzrjfbXyb67s8PcTKwzDW
         g8SLZiDLLqGm/UB0WhnHYAkxd5mmhks2oppGIzXl9Sja0YYhW3NGp2z3COj0VIAH5N/E
         PcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714459596; x=1715064396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hCjGa0cyR+5KjlfrnK0wTPM9nmlXBCTQii4J3Gjgfc=;
        b=IhHMq89r1YeXWVGP3c4/Dt3jC2fnbstHtijSaUS47/EB0U029EmIh878Y6/sE88i1g
         FlcBQtILRPwuiszqJFiUMKXOVKYHPyfat8rxX3eLbCpwcjKOXrsBHjsVQJAIVkwRvzMT
         CP5RJXeOzNCxvE+DaNi24dIKFMWmiJATis4TatGmk5dJXgv3M5yVBSDY8x7sE0yvH9ad
         MhkjcI0uvbo88vanwhkJmLSgf4nMKCb4dXh1wnTn6xgXk5gOzNJmqCLGuz/yt23ozRpr
         YW8XWFE6PAlyRgZBzrp2lsDRRlZNB7/GeXjLopdR2nOv5CBQn4TYtlGgBLLdbbMl32L6
         cPzg==
X-Forwarded-Encrypted: i=1; AJvYcCXl8bS+UeYAvWTsTbYTZ0yQyhbJpj0QzQGCgNFnmUelqYiNJ+c0k+W1eW4APJHvMz2gtVPVwfF6dApOoWSjP40+v2S9LUZu
X-Gm-Message-State: AOJu0YyCH91FK9JLAQJPBKDe5rCO0Ff/o5HprjhdTo1nljMgU+mUsHZk
	CIn3L49IRcEkVThZFJg2IhECLbuARt5o63mkhkeVbfn9y+uf5lNl
X-Google-Smtp-Source: AGHT+IHZptiykpZhYjFmG4OGGymocqD+APs98M8NEhYGo1chm3Kg5U9XPh+dOTwbEH1pATR3JSfM+A==
X-Received: by 2002:a05:6a20:de96:b0:1aa:7097:49e2 with SMTP id la22-20020a056a20de9600b001aa709749e2mr12942263pzb.50.1714459596260;
        Mon, 29 Apr 2024 23:46:36 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e5c200b001e556734814sm21511890plf.134.2024.04.29.23.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 23:46:35 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 64E1318462BA1; Tue, 30 Apr 2024 13:46:32 +0700 (WIB)
Date: Tue, 30 Apr 2024 13:46:32 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: John Groves <John@groves.net>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Linux CXL <linux-cxl@vger.kernel.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux NVIDMM <nvdimm@lists.linux.dev>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Groves <jgroves@micron.com>, john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com,
	gregory.price@memverge.com, Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Mao Zhu <zhumao001@208suo.com>, Ran Sun <sunran001@208suo.com>,
	Xiang wangx <wangxiang@cdjrlc.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Attreyee M <tintinm2017@gmail.com>
Subject: Re: [RFC PATCH v2 01/12] famfs: Introduce famfs documentation
Message-ID: <ZjCTyOvpBDBuCg5i@archie.me>
References: <cover.1714409084.git.john@groves.net>
 <0270b3e2d4c6511990978479771598ad62cf2ddd.1714409084.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="crT4BUp9nHuKakh4"
Content-Disposition: inline
In-Reply-To: <0270b3e2d4c6511990978479771598ad62cf2ddd.1714409084.git.john@groves.net>


--crT4BUp9nHuKakh4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 12:04:17PM -0500, John Groves wrote:
> * Introduce Documentation/filesystems/famfs.rst into the Documentation
>   tree and filesystems index
> * Add famfs famfs.rst to the filesystems doc index
> * Add famfs' ioctl opcodes to ioctl-number.rst
> * Update MAINTAINERS FILE
>=20

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--crT4BUp9nHuKakh4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZjCTwwAKCRD2uYlJVVFO
o6cyAP9LSH332uDKE+seiJLwDjMnIq+YE0884MKXbf8SHc2gdQEArqUm84vOu682
HXx1CyZQ45bTEfyOQgYNRg/+bNbzpw8=
=+4jA
-----END PGP SIGNATURE-----

--crT4BUp9nHuKakh4--
