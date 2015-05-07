Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 8 May 2015 00:55:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2 01/10] arch: introduce __pfn_t for persistent memory
 i/o
Message-ID: <20150508005536.312c3eff@canb.auug.org.au>
In-Reply-To: <20150506200459.40425.80269.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150506200459.40425.80269.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ZBX3C/SxMRbyJ71XlnK8K=D"; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@lists.01.org, mingo@kernel.org, linux-fsdevel@vger.kernel.org, mgorman@suse.de, "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

--Sig_/ZBX3C/SxMRbyJ71XlnK8K=D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 06 May 2015 16:04:59 -0400 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> diff --git a/include/asm-generic/pfn.h b/include/asm-generic/pfn.h
> new file mode 100644
> index 000000000000..91171e0285d9
> --- /dev/null
> +++ b/include/asm-generic/pfn.h
> @@ -0,0 +1,51 @@
> +#ifndef __ASM_PFN_H
> +#define __ASM_PFN_H
> +
> +#ifndef __pfn_to_phys
> +#define __pfn_to_phys(pfn)      ((dma_addr_t)(pfn) << PAGE_SHIFT)

Why dma_addr_t and not phys_addr_t?  i.e. it could use a comment if it
is correct.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ZBX3C/SxMRbyJ71XlnK8K=D
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVS3zuAAoJEMDTa8Ir7ZwV0DUQAIPz+kNeGUhG6kkcIL7EWU+3
9y2jBYlyORUutJ9qnBykXRW+KRbdapGU43hwiFRiq4ElJRu+bF23D+euK98o0oXb
wAEAN9mCs1OuuqlDMd86l/zw2C6/4jBjaJxL7ktY8qlh63/sL87UiwyJvYXRTOdr
c8SUkaHQAQF1hz5Ks8BV9Hz+Lz82CpWF0Ce5G+GfDMm4Er4qp/WaTgj4X6v+xQ1e
pIEc3D39Vh9rysUkkncut7QXUH9AR9RgYLeQTFmNPeHjdij4GACVUCTAQWC7NPgI
bLTACX+eE+qUINyfg/1Fxm4d6uoXgca2m0IZ3boNEpgS+yiYiBphu/nxacJqUIZb
HoNnUpo4ioI7mjH8Wf+ftLT/JA4eXHv/8OxUktKW5tDHU8SbsJUjwdSoXOERNdsM
jm5/2a+ShZvhCvtf7BZCjq6s9YVmlTGoUjMF/kfb2Bfn+cxaJhz6+cHxfB7HnbPA
N64NtumQzTWkEJkks2Mka7oTGeNrHz1Xk31VI2y0N2kR0vjKjCRKKfviQcuOpMkU
d2AOZfCdEhkxWfOHjjRxTGW98oimirT4vjZgY9R+OdnNFDPUpd9SnEkQ4ua4kQDM
JcwZ3B8NBN+fEwgArbXZ7YQ1RL9K2lGiTCyVVWkK4+xMtuLMIkB2VhQHx259oLa/
rRXMOJNNQ4d6LDhHjC/O
=6syQ
-----END PGP SIGNATURE-----

--Sig_/ZBX3C/SxMRbyJ71XlnK8K=D--
