Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BFE31F98E;
	Thu, 25 Jun 2026 18:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412174; cv=none; b=WfGOWsP7UY02qoQ3g5Tw6x0AZ8LKOuYQtl+cJaJ+KPg0otJejxnjRCdEl68awwJkyiGoM/PfszrM6cVrM2zUb7ypFD8/qoLyW1oD5i3iuW4ixnErm+rD4/L3ww3cmcC5XIjjnamRipCrh7tIXmnQpeUVLKVAJcd8lk+xqfrK9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412174; c=relaxed/simple;
	bh=JvkF40AIIcuoWa+UiK9EW/a9KcmP/IGjnbsnzLQIFsQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dYZm8ISMRSCqJZRoCuL/BAmcunLO99F/N7tobeMsTCr0vfC9I/SOzlTarVXgN803ZXbOuf8ASqzW74MJ9B4hyo6C3L/IJG6vhVdorn/OL2/CZUIScgPrBVgTH94CTpvhGMJxayxssIeJfUw/rrYcOBm/iE/Rge9lZHWmB19zdvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBZGSl5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBZGSl5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C431F000E9;
	Thu, 25 Jun 2026 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412173;
	bh=WwA+s0fwHHBfJLWTS732y1Tg5XxHb68mv3+xU8MRjp8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XBZGSl5cQIPM/foAFkdUVUPg93LP9yvmTAYA3sriDUCu8+IeTZ5COx2c/bl7UJMpD
	 PsbFAipoV+7A/o9WH2a1L3mNSoowpGgf/P7EeuH6P1bB1fNkgHSPrvQdEtaGMXPIfC
	 e2lMIl0fa51tsy8DOYTolSHDhT+xwyUslj4Mys2TF2f5mBECtwgsgqvfn5IYVdmhLP
	 b2PVIWdAXMvKDPv7Z1MGsvuYAHpC9c4AIzDKLiyhbZKP+EyqCF25q4MxokdEgwkwtI
	 psZ4FpaKooya3xUbnq/gG6oqU3VA/HqWZmBvFoBtixNFHLNtq9eWGSDut9y9wIkxua
	 9FBn+LGQ0Mkvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 28/31] cxl/mem: Trace Dynamic capacity Event Record
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-29-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-29-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:29:32 +0000
Message-Id: <20260625182933.08C431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `cxl_dynamic_capacity` tracepoint omits `validity_flags` and=
 other critical diagnostic fields, leaving userspace unable to validate par=
sed values.
--

commit 7da6c652fcb2ca33cefdf89b66affc0318921f70
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Trace Dynamic capacity Event Record

This commit adds tracepoints for CXL Dynamic Capacity Event Records defined
in the CXL specification. It enables user space debugging of DC capacity
changes by exposing the events through the trace log.

> diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
> index a972e4ef19368..e5b88887d11b5 100644
> --- a/drivers/cxl/core/trace.h
> +++ b/drivers/cxl/core/trace.h

[ ... ]

> +TRACE_EVENT(cxl_dynamic_capacity,
> +
> +	TP_PROTO(const struct cxl_memdev *cxlmd, enum cxl_event_log_type log,
> +		 struct cxl_event_dcd *rec),
> +
> +	TP_ARGS(cxlmd, log, rec),
> +
> +	TP_STRUCT__entry(
> +		CXL_EVT_TP_entry
> +
> +		/* Dynamic capacity Event */
> +		__field(u8, event_type)
> +		__field(u16, hostid)
> +		__field(u8, updated_region_index)
> +		__field(u64, dpa_start)
> +		__field(u64, length)
> +		__array(u8, uuid, UUID_SIZE)
> +		__field(u16, sh_extent_seq)
> +	),

[Severity: Medium]
Are we missing some diagnostic fields from struct cxl_event_dcd in
this tracepoint definition?=20

It appears that validity_flags, flags (which contains the More bit),
num_avail_extents, and num_avail_tags are omitted here. Without
validity_flags, user space might be unable to determine if hostid and
updated_region_index contain valid data or hardware garbage. Additionally,
dropping the flags field could prevent user space from properly piecing
together multi-record capacity changes using the More bit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D28
