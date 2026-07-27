Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEB4367B86;
	Mon, 27 Jul 2026 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154640; cv=none; b=BSt/qIprIB06oYn7i5vN7Kw7BrTlcqUCy/4N8iq9V3iBuMZ6nWa4UAhaJWFNSTNofbq/gKdaZLiGHiGJjbFEqXGcbu9eX/2TFPrePFB8HAqmvKI1zVEOt2ILKK6jJjwOKX0bXV209alMWliDPwqIAw8/0jJ3UgiNdJ+STqoojH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154640; c=relaxed/simple;
	bh=NeaLOb1aABVmCMj6cFU7v+9eC2Mm33tRjUoRnFrhZLQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=goUgBzlpl8+3T94ayRxjgcWLfMJ8n6MeEajBtryhSoXglmuDdWk342Zl4wHtV2JGDWvF+dNhODvovappcivVScfNt/MdoHoH4S+JIPbsLG61eimYSD3vyle81tSwHWRDG/ntRx62xaSG6KSnXjbBBteppp23AO410Be/c1YeY3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eA/mJvYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eA/mJvYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15201F000E9;
	Mon, 27 Jul 2026 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154638;
	bh=NeaLOb1aABVmCMj6cFU7v+9eC2Mm33tRjUoRnFrhZLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eA/mJvYYWYyQToOwMxBuZtDOznAZ4sSa7fAd0rt6SJ2ZsLACDtgFN4aoEIz9M1mBu
	 Wk2dyBDMVv8FpcGwbi9b8eAXMXFPyhgZjIvnrp/1DMla//cQclanSyOMzLzjYGLxS3
	 K2vqBszGwFwgeTqmH8bTCnN6lbxu8JhhmsUccwQk4AqqO/L1PnZP2VhCD6pJIii6aC
	 /HEGewYLrnyEi+Ei+wRaCvB3TSrDTRzKR0oD9lWINESBvZ9OCzFd4X6Seg/Qwh4ACm
	 okOn9eXXKQpbVoqDBtCOQ2SrB5scXH0SZMfXUX3uTW+U3w53ZZ04IZt84EqUdYrrpX
	 vIXL4/LNV1MuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] ACPI: use a named initializer for
 acpi_device_id::id
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGF3ZWwgWmFsZXdza2kgKFRoZSBDYXBhYmxlIEh1Yik=?= <pzalewski@thegoodpenguin.co.uk>
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260727-acpi-refactor-v1-9-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-9-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 12:17:18 +0000
Message-Id: <20260727121718.B15201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

> Use a named initializer for the acpi_device_id::id field for
> readability and drop setting the list terminator fields
> explicitly as well to be consistent with the rest of the kernel
> code.
>=20
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727-acpi-refac=
tor-v1-0-ff900aa326ee@thegoodpenguin.co.uk?part=3D9

