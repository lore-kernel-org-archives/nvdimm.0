Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7B62F7F00;
	Sat,  3 Oct 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791000277; cv=none; b=TribGM3HFTvUS2G0KWGQAxclUKmNWJtgZRBzRKv6aBGWX7ck3sjcy2a+XREYM6XQhZZ2qAh75XZo+LQ1t2ADWyGeLOzAWh07LVSGM/CsUg55ttHGJh7XnZiUn9W2GrHT7MVW02J++eBUIWJmxhfhf1GY+SfuaOwP4+uQKEJ+1IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791000277; c=relaxed/simple;
	bh=HK2gEMJnEg3iXaF8sI8a26aURfWDgSaQAKEwhmoQCxc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wj1YOgo7Lx1ANfD19WCQvysWz3tbBdQC7R9dFSqx8W/F7zSaBlf1if9gsmbCXd1t00RwW0+GxY2tHUP3k0RtUVFMwKFRLxTC/8Anj+v2Anx4zVCi+qRnbILpEFQpiN6ztcqwUhTyaB7SQlDEOzBjvTu470PI3RJ8nQmHR/pITCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ju1ZKy1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ju1ZKy1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C4D1F000FF;
	Sat,  3 Oct 2026 04:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791000275;
	bh=HK2gEMJnEg3iXaF8sI8a26aURfWDgSaQAKEwhmoQCxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ju1ZKy1mlyuZU7V+KpVMeVA2+IeT+0udcl8NVwonITDJSALDL8UnIXGcJTl6USPbM
	 W7+x8y31nnXnHLeB2f20Wie7zzRCaexyyvQTHBz+wA+zTTaoGRi0vKJEQe08MnVYvc
	 o5Ldj8yo1KZZyEVXQwKnq3N6MdGnzBkO48S8AGaBwsGYlYMi2ohBUy/mc8XGJUzdao
	 voNMm7ILGSWY7uXe+HmQzL92jorQQrHpMGygjntYuOsaCTCoMkJArS+5lTnvQvXM2v
	 bzeBETmH1bY0ckAwp5kwAQsUQp1yqxe6iIcdpZ1f2AjdXggDSVy5979SHze3z6+c1S
	 ALZJpYkJamtDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/11] seq_buf: Add seq_buf_strlen()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kees Cook" <kees@kernel.org>
Cc: nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20261003035921.1918874-5-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 04:04:35 +0000
Message-Id: <20261003040435.96C4D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Several strlcat() call sites being converted to seq_buf need behavior
> seq_buf doesn't currently provide. The return from seq_buf_used() is
> not the length of the string in a seq_buf. Once the buffer is full or
> has overflowed it returns the buffer size, which counts the byte that
> seq_buf_str() replaces with the NUL, so a caller that needs the string
> and its length has to call seq_buf_str() and then walk the string with
> strlen().
>=20
> Move the termination out of seq_buf_str() into a helper that returns
> where it put the NUL, and add seq_buf_strlen(), which terminates the
> buffer in the same way and returns that offset.
>=20
> As discussed in review, don't add WARN_ON() for seq_buf_strlen() and
> drop it from seq_buf_str().
>=20
> Add tests comparing seq_buf_strlen() against strlen() of seq_buf_str()
> for empty, appended, truncated, exactly full, and overflowed buffers,
> checking that seq_buf_strlen() alone terminates a full buffer, and
> checking that a zero-sized seq_buf reports an empty string from both
> accessors without touching the buffer.
>=20
> Tests passed under qemu on ARCH=3Dx86_64 with GCC 16.2.0 and CONFIG_KASAN=
=3Dy,
> and on big-endian ARCH=3Ds390 with GCC s390x-linux-gnu 16.2.0.
>=20
> Assisted-by: LLM
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003035906.too.=
263-kees@kernel.org?part=3D5

