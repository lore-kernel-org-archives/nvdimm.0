Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073FF48D897
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635520; cv=none; b=QdpduxlViVC0XKF77wf/MJ4ij6EPnytG14vD2uCBPjqsd1HN/fSdsLmcT71p2MUP1hwYCNCBiVqWGF38Y8lR41fUrzgd2mMQs1gv8yI9fzYi929rWrkzlkBHAV8rO/UKVZWPr5sr6TQXVefmmpV+FUutEahhJgRZr4T3EH4aqAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635520; c=relaxed/simple;
	bh=0JOnbCEJuigYdbC+1WgMs3mQEXwfJgKKZ6ZSQpKupcA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZpmyIa7q4SEHho5cjAFn44r2398TerWm+WvG6Urzn+bPAhNkqykRAQm2PlShE5Q/VAXFJuJvc4n+XXVbihQGTqhQ6SD2ty/0JACjmKqr+U0Q7jwHCx3mLqOAyzm0Wi1iwKf0dbqBhyHbsbS/tvmrY13q4yEhdchFcGZv+48i80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEyMnbTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEyMnbTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA621F00A3E;
	Thu, 13 Aug 2026 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786635508;
	bh=8HhJB9E/lL1QBhmrYRaN5DuOoxF0/k2qp2NhUOqB/6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dEyMnbTZFwAq93MF+yxVaOaHEPZnN5v0YWnlL6o6GvxeTv+b9uG3U9L51ARfXTQBb
	 VZaCjSBZujHY8COhm3jhCfzt9QKfPp16ZLTH8lqAJWhMH/npPAcM/SoC0jQhZpJ/qS
	 MXcAz8dXOi0kl6It2VMAou4zXtcHeXCyACjFIcyKH/8Znnt8z9tvxBcwQNSrajSBiw
	 AIjqQ2hXJLXE7QQb6FLH3hr2kiPMCLD3WeTOkaQXOlRCdTuQXngkSQJgfnB5im/wNz
	 M5iK8eOGicGZgqFJ9Pkvv4bL8DNu0cb/FZtMB3yioQPosxLYaEXSRr1Ohh1DKmJ5To
	 IalNz+GOpH7sw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/5] ACPI: NFIT: validate control region extent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20260813151843.24305-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
 <20260813151843.24305-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 15:38:28 +0000
Message-Id: <20260813153828.6AA621F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] State corruption and list_head dangling pointers on NFIT table par=
sing error.
- [High] Out-of-bounds read and undefined behavior via bit shift in add_pla=
tform_cap().
--

--- Patch [4]: [PATCH v2 4/5] ACPI: NFIT: validate control region extent ---
commit 0bc177f6743d37dbd5255c0f7a268009d181d358
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

ACPI: NFIT: validate control region extent

This patch modifies sizeof_dcr() to ensure that the advertised subtable size
is large enough to contain all remaining fields, preventing a potential
out-of-bounds read during the memory copy in add_dcr(). It computes the
required size based on the windows count and validates it against the
provided subtable length.

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index bf4ddc56494e3..84c70f1941c57 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -817,12 +817,20 @@ EXPORT_SYMBOL_GPL(nfit_get_smbios_id);
>   */
>  static size_t sizeof_dcr(struct acpi_nfit_control_region *dcr)
>  {
> +	size_t size;
> +
>  	if (dcr->header.length < offsetof(struct acpi_nfit_control_region,
>  				window_size))
>  		return 0;
>  	if (dcr->windows)
> -		return sizeof(*dcr);
> -	return offsetof(struct acpi_nfit_control_region, window_size);
> +		size =3D sizeof(*dcr);
> +	else
> +		size =3D offsetof(struct acpi_nfit_control_region, window_size);
> +
> +	if (size > dcr->header.length)
> +		return 0;

[Severity: High]
This isn't a bug introduced by this patch, but returning 0 here can trigger
a state corruption and memory leak in the caller's error path.

If sizeof_dcr() returns 0, add_dcr() returns false, which causes add_table()
to fail and jump to the error path in acpi_nfit_init():

drivers/acpi/nfit/core.c:acpi_nfit_init() {
    ...
    while (!IS_ERR_OR_NULL(data))
        data =3D add_table(acpi_desc, &prev, data, end);

    if (IS_ERR(data)) {
        dev_dbg(dev, "nfit table parsing error: %ld\n", PTR_ERR(data));
        rc =3D PTR_ERR(data);
        goto out_unlock;
    }
    ...
 out_unlock:
    mutex_unlock(&acpi_desc->init_mutex);
    return rc;
}

When jumping to out_unlock, existing list elements that were temporarily
moved to the stack variable prev are not spliced back to acpi_desc. They
become orphaned, and their list_head pointers are left dangling to invalid
stack memory. Does this need to be cleaned up or spliced back on error?

> +
> +	return size;
>  }
> =20
>  static bool add_dcr(struct acpi_nfit_desc *acpi_desc,

[Severity: High]
This is a pre-existing issue, but is there an out-of-bounds read and undefi=
ned
behavior when parsing the Capabilities table?

In add_table(), a table is only validated to be at least 4 bytes long
(sizeof(struct acpi_nfit_header)). However, add_platform_cap() accesses fie=
lds
beyond the header:

drivers/acpi/nfit/core.c:add_platform_cap() {
    ...
    mask =3D (1 << (pcap->highest_capability + 1)) - 1;
    acpi_desc->platform_cap =3D pcap->capabilities & mask;
    ...
}

If a malformed Capabilities subtable is provided with a length of 4 bytes,
could this result in an out-of-bounds read of pcap->highest_capability and
pcap->capabilities?

Additionally, if pcap->highest_capability is 30 or greater, does the bit sh=
ift
result in signed integer overflow or shift-out-of-bounds undefined behavior?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813150948.1723=
9-1-pengpeng@iscas.ac.cn?part=3D4
