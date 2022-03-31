Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175F17B
	for <nvdimm@lists.linux.dev>; Thu, 31 Mar 2022 22:55:17 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4KTz4R3pVzz4xNm;
	Fri,  1 Apr 2022 09:48:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1648766939;
	bh=aCINHo9aji2F1GB8wO1FkUovXMk3qb0+GTDDR4ex5/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dlUEQiCcWq10xVDmBrRso2Emc/0wrNv0ndsF/2+QGo4Y5jyiyKuInvQ/BEi+zCd+i
	 b+Z5mps0KRuEVkHmh3cekVX8fuFXleSSrDMdw3WXzHcQ7HPnRHFsBr1pfROJFwm3a7
	 80dBeBdlPyFuihhzJoi6cV6e5bhziV1UFSMNhcEw72MJNcxYg5yIZgs7HYy31YNWaE
	 3vSSFHL6wEAGhGckOrYe+vLIA4rDbZKwV7M17cDAV4HVmNXZ0pzPpoKEhUGciP4ju5
	 1DDyeh8/jmIX1SY6KHUFpz2xhMZM8656+TSSgkxBdApiQDlYAoJt79yAoopB0qNJDa
	 +NhAj87+PZkvQ==
Date: Fri, 1 Apr 2022 09:48:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>, Muchun Song
 <songmuchun@bytedance.com>, <dan.j.williams@intel.com>,
 <willy@infradead.org>, <jack@suse.cz>, <viro@zeniv.linux.org.uk>,
 <apopple@nvidia.com>, <shy828301@gmail.com>, <rcampbell@nvidia.com>,
 <hughd@google.com>, <xiyuyang19@fudan.edu.cn>,
 <kirill.shutemov@linux.intel.com>, <zwisler@kernel.org>,
 <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
 <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <duanxiongchun@bytedance.com>, <smuchun@gmail.com>
Subject: Re: [PATCH v5 0/6] Fix some bugs related to ramp and dax
Message-ID: <20220401094854.56615a65@canb.auug.org.au>
In-Reply-To: <20220331153604.da723f3546fa8adabd7a74ae@linux-foundation.org>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
	<YkXPA69iLBDHFtjn@qian>
	<20220331153604.da723f3546fa8adabd7a74ae@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nIhTqK6YrZqOjv9JOjZ_kms";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/nIhTqK6YrZqOjv9JOjZ_kms
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 31 Mar 2022 15:36:04 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Thanks.  I'll drop
>=20
> mm-rmap-fix-cache-flush-on-thp-pages.patch
> dax-fix-cache-flush-on-pmd-mapped-pages.patch
> mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
> mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch
> mm-pvmw-add-support-for-walking-devmap-pages.patch
> dax-fix-missing-writeprotect-the-pte-entry.patch
> dax-fix-missing-writeprotect-the-pte-entry-v6.patch
> mm-simplify-follow_invalidate_pte.patch

I have removed those and the 4 patches that I had to revert yesterday.

--=20
Cheers,
Stephen Rothwell

--Sig_/nIhTqK6YrZqOjv9JOjZ_kms
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJGL9YACgkQAVBC80lX
0GyePgf+LiEn85D2IxTfAf8/DAtAZbCjQ30Nl29rv31sOL0T1vsVkFibp8yQrNvI
TlEBWUiti1ls7bc3c+v5yLAfxYKSyvSp9i9oSBYW9c8fZ1ihm8F6R8+hLZgu3foU
gUw3PaIFi6KI0dMGvAadN5rYuhvvMqUwlZHo02nYOt2bGjr3DQWGrZm0qa6jiQNC
a1Mu5zqoOA3fVY7VakijGvZ7YM/qYik+TrbpYKhlzoRlKaPW/Ddijsn+lqm24W1T
tz3lV9AoXTUZ8TOsUOqfNtEbs0s8ivmhAmdLiJ08+REpONzNQr4QO9W6Xw6ZKnaR
12qE+W2r83Rbjj2BTSoNXL5pJEeOKg==
=vrD8
-----END PGP SIGNATURE-----

--Sig_/nIhTqK6YrZqOjv9JOjZ_kms--
