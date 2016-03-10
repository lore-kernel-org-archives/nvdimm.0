Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: NeilBrown <neilb@suse.com>
Date: Fri, 11 Mar 2016 10:54:06 +1100
Subject: Re: [PATCH 12/12] dax: New fault locking
In-Reply-To: <1457637535-21633-13-git-send-email-jack@suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz> <1457637535-21633-13-git-send-email-jack@suse.cz>
Message-ID: <87h9gdj3dt.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain

On Fri, Mar 11 2016, Jan Kara wrote:

> Currently DAX page fault locking is racy.
>
> CPU0 (write fault)		CPU1 (read fault)
>
> __dax_fault()			__dax_fault()
>   get_block(inode, block, &bh, 0) -> not mapped
> 				  get_block(inode, block, &bh, 0)
> 				    -> not mapped
>   if (!buffer_mapped(&bh))
>     if (vmf->flags & FAULT_FLAG_WRITE)
>       get_block(inode, block, &bh, 1) -> allocates blocks
>   if (page) -> no
> 				  if (!buffer_mapped(&bh))
> 				    if (vmf->flags & FAULT_FLAG_WRITE) {
> 				    } else {
> 				      dax_load_hole();
> 				    }
>   dax_insert_mapping()
>
> And we are in a situation where we fail in dax_radix_entry() with -EIO.
>
> Another problem with the current DAX page fault locking is that there is
> no race-free way to clear dirty tag in the radix tree. We can always
> end up with clean radix tree and dirty data in CPU cache.
>
> We fix the first problem by introducing locking of exceptional radix
> tree entries in DAX mappings acting very similarly to page lock and thus
> synchronizing properly faults against the same mapping index. The same
> lock can later be used to avoid races when clearing radix tree dirty
> tag.

Hi,
 I think the exception locking bits look good - I cannot comment on the
 rest.
 I looks like it was a good idea to bring the locking into dax.c instead
 of trying to make it generic.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4gkeAAoJEDnsnt1WYoG5wSAP/3FtUQghPezAGs/b7vhlZn9h
TiWGipgf257u8Ojd9s81p0skzDO3grNKK8Rl25O91w7PzybzMfRIKa8jAQZ74cti
cmXESS+4GOpO6JW40q3Cor7QljJr0SgQYvbXzSrIflxZ0GDxwSZm81AUd6zb9hMU
jy7mvxuyF35dQ3b2Sg9ySvXUYVEOAligkpThA7614vE+bJIGSw1NUBtl0IAUIIMm
KiuY+tgzo4l7m6bjKva3KD35ZC8B0m+y6GdroAlwasUQ+iP3w3ugrQf/UWVWHDxU
OasyyFgnZz1L3lL7ucYtam6kRayIfs1A00YDZH9cn6JFEshxvPdAg+gmJDytIkEJ
vTd1s4Ojjbi9+rzSee/i3n0b6nnBjjVUxxb4ryoQxwn/qUR11WiwJEKoVGSQ54v3
PLVDE1y9sE6fNx+cUvM4G1cND+3osS7UcwDlKLFZh2a3TWJlFPirH51nuqvpL27P
atxJalORVoQvMEz9+DmZAw8NgoeOh/we697LZ8sNquZbSH+6YwRrnjg3D3lNRgc0
gi1lUAiDGRjbr3apLelVO+Bt7UE1BILVc0aOo8ax4ZP60MT34WahTvfAwofoXnk/
tAbDpGtnPT1Cz+cR4AIxwJr8o/faWzT47fyovWRLd0B4eloCDI4mpTm0LbhP2StS
G/uRqPyfP5sHVtpA6TKR
=23vL
-----END PGP SIGNATURE-----
--=-=-=--
