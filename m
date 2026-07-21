Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE99363081
	for <nvdimm@lists.linux.dev>; Tue, 21 Jul 2026 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655667; cv=none; b=Bk8Bi1fMxy/8Wu3NFRpEoi9kVNjJ/dFHYvXFS6QDJFKZ5SOhSwsyiMjByeUOc4AHhOLCd0089W+WYbj5grDhXcTOf2AdY1Pw/Id9274DbDzIi958d8aSSAY5kdNbv222MV7N6YGSUGpKM/7p+jcC8M2faVTLwQY1v1WwbXyyxCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655667; c=relaxed/simple;
	bh=ODtyo4DXX+IsVQEtyuytt8MBgamDODOWx7t1OEFcZXU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qqUNV4d6FB9pZvXQ+J4MjbZPhhYADFSryMUSSwbuhICSZr4jsmIlleM79SCnatwqEVnfDOatLByPRpVq0hYRxjKtzu7BngtDyYqC3ydxncLPQK77NdjyTAZo8rt4hBufA59Xst0Xi7EibmrYI2QxmrqXgkqCiVnBFqkoHV2njVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISjnY6Nz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISjnY6Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B837D1F00A3A;
	Tue, 21 Jul 2026 17:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784655665;
	bh=YOPtZ1PZxJbE10N++cdC5oQ2MdFjxmpHMODBFYNr0JM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ISjnY6NzGfNkdkwoucXOW/GgysRTkMzxqgzOZTOUKU1CvSp85RWknHfbP94c38ZYW
	 2THr5RaE1RzHRcd/CMBgfUodf5P/AAHIoj3ZKH1FmrFRHYZ2JvbttioEsxBIpBrgS9
	 CIrXoZkI7xWLkOPIlcvMoscu/JbeItmUdvjHlxqDFTgFcvoxU0MoXoGupfsnr4hyJ/
	 hRCZe8eHgEeJaQ358Yg4+scYKyR1ZnmxqPbAIkJL5zT8aZ1lDzZ9nqKDwrnGVTa8de
	 Ro+2cFr8kYfIxsxm9Gah3i/M35+x2+b62nE4YDEh1cgW1znciW1znV9JrvXkiwKyb6
	 jWIpFcRE0GPCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260721172132.3718892-1-rdunlap@infradead.org>
References: <20260721172132.3718892-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 17:41:05 +0000
Message-Id: <20260721174105.B837D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Writing to poisoned memory without clearing it first can trigg=
er a Machine Check Exception (MCE) leading to a kernel panic.
--

--- Patch [1]: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings ---
commit e89a1ebc4ad5020678df8e74422e59aff926ae52
Author: Randy Dunlap <rdunlap@infradead.org>

libnvdimm: nd.h: clean up kernel-doc warnings

This commit resolves kernel-doc warnings in include/linux/nd.h by adding
missing struct member, function parameter, and function return descriptions.

> diff --git a/include/linux/nd.h b/include/linux/nd.h
> index fa099e295f780..62988000e7a7e 100644
> --- a/include/linux/nd.h
> +++ b/include/linux/nd.h

[ ... ]

> @@ -174,11 +177,14 @@ static inline int nvdimm_read_bytes(struct nd_names=
pace_common *ndns,
>   * @offset: namespace-relative starting offset
>   * @buf: buffer to drain
>   * @size: transfer length
> + * @flags: process (0) or atomic (1) context
>   *
>   * NVDIMM Namepaces disks do not implement sectors internally.  Dependin=
g on
>   * the @ndns, the contents of @buf may be in cpu cache, platform buffers,
>   * or on backing memory media upon return from this routine.  Flushing
>   * to media is handled internal to the @ndns driver, if at all.
> + *
> + * Returns: %0 on success or a negative error code on failure
>   */
>  static inline int nvdimm_write_bytes(struct nd_namespace_common *ndns,
>  		resource_size_t offset, void *buf, size_t size,

[Severity: Critical]
This is a pre-existing issue, but while reviewing this documentation update
for nvdimm_write_bytes(), I noticed a potential problem in its underlying=20
implementation in drivers/nvdimm/claim.c:nsio_rw_bytes().

When a write is performed on a poisoned PMEM block and clearing the poison
fails (for instance, when unaligned or in atomic context), the code sets=20
the error code but appears to fall through to execute the write anyway:

drivers/nvdimm/claim.c:nsio_rw_bytes() {
    ...
                if (cleared < size)
                    rc =3D -EIO;
                // ...
            } else
                rc =3D -EIO;
    }

    memcpy_flushcache(nsio->addr + offset, buf, size);
    ...
}

Can a read-for-ownership of a poisoned cacheline during this fallback write
trigger a synchronous Machine Check Exception and panic the kernel?

Would it be safer to return early or skip the memcpy_flushcache call when=20
rc is set to -EIO?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721172132.3718=
892-1-rdunlap@infradead.org?part=3D1
