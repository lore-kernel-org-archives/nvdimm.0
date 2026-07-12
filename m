Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADDECA52;
	Sun, 12 Jul 2026 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871780; cv=none; b=jKF+SJTb4odrxh0fRLETNyjdDWofqMidoxDbJj1JJYUFBVhvrNydOc+ZJOX921kAS4fS+j0sE6/xU3m44m4UAcQKB9lG0C6zVILP4RVZPMqnnwuqxF0Zop0WHMmN8lJZHg4jlKa/3099tKzl1gVB1bTEtDfn5p7j/v1I293nLzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871780; c=relaxed/simple;
	bh=ppgpUhFVaPuBc8uCCo5ywn3REQbNffMCyZ9EwY5Akro=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p3CD7D5BTA4Uvi9/vIowMhxL/RD6mRoodIsQztAscVYsceU5pu9zbE6C0cdZ5EWEsyimXa1TC1NgkMQoTq0ZNENsSHRP6nPmRRFLhITSiEbroQnc7Pzc+dJJiOcrNZd/D4JTNHC+eZgSwL8nSWnSS6eOd+oIq30TIbShnjKVJJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gb3OmSKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gb3OmSKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835AD1F000E9;
	Sun, 12 Jul 2026 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783871778;
	bh=mBdK+WNbFd+c77xcZ54RcT/lRXVWPTVrW8YKkpD7bMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gb3OmSKbWXm65TnF35SQG8lm7X+3t7T/QyX0R9m4fThPSS5yIwZyorFM3/TjBPisn
	 eILpM3TDoXwx26j6tsDwWOscUfuehbj4BmEKwb9kbURzJ5mxBQW6gxohxd2Ikx5ib5
	 o4oDpOGZHI5+qYbldLHeHRFLLfQwW+jos1wdJY1+HwBxU3Bp6NmapZhwnXI6eWMnDs
	 bkEjdmDit5F06R9JZVMA3V/J3AvFKLWPoWE1A9+rfZVQMXrLz/DT4KfPg1c0L8Yjc8
	 x1EQOTtZSbtn9d/APeY+htGeaevGMm9phP7cBxbtHRD2GvVjg9agkpLJWbT+87c8ag
	 ARyvh0t0UPTZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/10] mm/memory_hotplug: export
 mhp_get_default_online_type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260712154505.3564379-5-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
 <20260712154505.3564379-5-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:56:18 +0000
Message-Id: <20260712155618.835AD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] add_memory_resource() caches mhp_get_default_online_type() at th=
e start but re-reads it for the final condition check, potentially ignoring=
 concurrent sysfs policy changes.
--

--- Patch [4]: [PATCH v7 04/10] mm/memory_hotplug: export mhp_get_default_o=
nline_type ---
commit d037ee754b46e2d238e974dbf3f6ebb2ab7882bc
Author: Gregory Price <gourry@gourry.net>

mm/memory_hotplug: export mhp_get_default_online_type

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.
This commit exports mhp_get_default_online_type to allow these drivers
to build when hotplug is disabled and still use the DAX use case.

[ ... ]

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6833208cc17cb..4942570540956 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
> =20
>  	return mhp_default_online_type;
>  }
> +EXPORT_SYMBOL_GPL(mhp_get_default_online_type);

[Severity: Medium]
In add_memory_resource(), mhp_get_default_online_type() is cached at the
start of the function, but then re-read for the final condition check:

mm/memory_hotplug.c:add_memory_resource() {
	enum mmop online_type =3D mhp_get_default_online_type();
...
	/* online pages if requested */
	if (mhp_get_default_online_type() !=3D MMOP_OFFLINE)
		walk_memory_blocks(start, size, &online_type,
				   online_memory_block);
}

If a system administrator modifies the auto-online sysfs policy concurrently
while a memory hot-add operation is in progress, could this re-read cause
the operation to silently ignore the user's explicit online policy
(e.g., online_movable), onlining the memory into the default zone instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712154505.3564=
379-1-gourry@gourry.net?part=3D4
