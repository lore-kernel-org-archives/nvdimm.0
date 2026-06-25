Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BA31A9F87;
	Thu, 25 Jun 2026 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412467; cv=none; b=XZ/A1dn07KpNzYI/GMpnGOtGx7IDO9M2ZbWxw7FyIWb7Fdzesur4XYR9bY0Q6pJplJZbLZeB2FytsK/NxY+VycBN6BnNuHbtMAw8tLbxP1Oaiy3ABXeyjDMWVHUOmcRTjroanzbXS6aSJ2l9grJAux00Qp9Y422PQySIB8ybMqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412467; c=relaxed/simple;
	bh=BIxe18bTfLHivSIlZToXa1mXgoMR6efgDuoeBPItP0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SCFTpaLjwh4DtWPVZtT5s1M1pss39qIoaRS5pAIrqsqI+ex90FI6uNGKNaBeLWGVU6/hMVzw93g02id653lbifhs1WduvpGsWxiKjysHg6zucqQswRIpEw+hd2gaAoZJFtQuWMoY1Zn2INNjbqs2DSqf/mLn6vJXSvgjW7ow87g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCBodtBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCBodtBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6217E1F000E9;
	Thu, 25 Jun 2026 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412466;
	bh=3q1Ie/avd6TN8q2vDJhxLX0sG2JnVWKjsJHNwe9Kvqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CCBodtBcw36sN2NWVoKStBwL4dT7NDbYsFt+NXM4eHQlj5cF2gISWP5xr20Gq8rwb
	 zXRNajErfAbbU1EvS9+1PP+ACQQCoBWFWKoMmPuEsdZfnuSYvrV0BTZUJdNwdYyMFR
	 E45FsfSdJ2TH3biyjFoZTFrKbh7XiDl/enK4dg03WKi9qod1579xK/wH8IV9p0JCWx
	 O9hnLYtjQXIPuAVajjFgT4bVN1mSBzo5JbAhVCFjbbngpY3n7POjlXzwjgEQfQ3YiX
	 0d2CzVRa1c1Uo6d4sd8DnYJy6ZK9Xo0epipoQXzMU4FT+ldX/lCQqu+hao8UWW276h
	 YTPLRdeoARm5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 30/31] tools/testing/cxl: Add DC Regions to mock mem
 data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-31-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-31-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:34:26 +0000
Message-Id: <20260625183426.6217E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Medium] Missing bounds validation on `cmd->size_out` causes out-of-bound=
s writes in `mock_get_dc_extent_list`.
- [Medium] `mock_get_dc_extent_list` fails to update `cmd->size_out` to the=
 actual response size.
- [Medium] Unconditionally clearing sent extents in `mock_add_dc_response` =
breaks the host's ability to issue multi-part responses.
- [Medium] Missing bounds validation on `cmd->size_in` causes out-of-bounds=
 reads in mailbox commands.
- [Medium] Missing `devm_kfree()` calls cause unbounded memory accumulation=
 of devres structures when extents are removed.
- [Medium] Validation failures mid-command leave the mock device in a torn =
state due to partial state mutation.
- [Medium] Flawed overlap validation in `new_extent_valid()` allows injecti=
on of overlapping extents.
- [Medium] Concurrent sysfs operations create a race condition resulting in=
 orphaned mock events.
--

commit 8e9b7fc74b6af2c32bcba55480acc53f67c13c08
Author: Ira Weiny <iweiny@kernel.org>

tools/testing/cxl: Add DC Regions to mock mem data

This commit enhances cxl_test by introducing mock memory data for Dynamic
Capacity (DC) regions. It provides simulated sysfs interfaces to inject and
delete extents, alongside emulated mailbox commands to interact with them.

> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index a2bfd52db0762..455f8a50d5818 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
[ ... ]
> @@ -1594,6 +1861,215 @@ static int mock_get_supported_features(struct cxl=
_mockmem_data *mdata,
>  	return 0;
>  }
> =20
> +static int mock_get_dc_config(struct device *dev,
[ ... ]
> +static int mock_get_dc_extent_list(struct device *dev,
> +				   struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mbox_get_extent_out *resp =3D cmd->payload_out;
> +	struct cxl_mockmem_data *mdata =3D dev_get_drvdata(dev);
> +	struct cxl_mbox_get_extent_in *get =3D cmd->payload_in;
> +	u32 total_avail =3D 0, total_ret =3D 0, idx =3D 0;
> +	struct cxl_extent_data *ext;
> +	u32 ext_count, start_idx;
> +	unsigned long i;
> +
> +	ext_count =3D le32_to_cpu(get->extent_cnt);
> +	start_idx =3D le32_to_cpu(get->start_extent_index);
> +
> +	memset(resp, 0, sizeof(*resp));
> +
> +	guard(mutex)(&mdata->ext_lock);

[Severity: Medium]
Does `cmd->size_out` need to be validated against the expected output size
before we `memset` and write into the flexible array? If the caller provides
a buffer smaller than `sizeof(*resp) + total_ret * sizeof(struct cxl_extent=
)`,
could this overflow the output buffer?

> +	/*
> +	 * Total available needs to be calculated and returned regardless of
> +	 * how many can actually be returned.
> +	 */
> +	xa_for_each(&mdata->dc_accepted_exts, i, ext)
> +		total_avail++;
> +
> +	if (start_idx > total_avail)
> +		return -EINVAL;
> +
> +	xa_for_each(&mdata->dc_accepted_exts, i, ext) {
> +		if (total_ret >=3D ext_count)
> +			break;
> +
> +		if (idx++ >=3D start_idx) {
> +			resp->extent[total_ret].start_dpa =3D
> +						cpu_to_le64(ext->dpa_start);
> +			resp->extent[total_ret].length =3D
> +						cpu_to_le64(ext->length);
> +			export_uuid(resp->extent[total_ret].uuid, &ext->uuid);
> +			resp->extent[total_ret].shared_extn_seq =3D
> +						cpu_to_le16(ext->shared_extn_seq);
> +			total_ret++;
> +		}
> +	}
> +
> +	resp->returned_extent_count =3D cpu_to_le32(total_ret);
> +	resp->total_extent_count =3D cpu_to_le32(total_avail);
> +	resp->generation_num =3D cpu_to_le32(mdata->dc_ext_generation);
> +
> +	dev_dbg(dev, "Returning %d extents of %d total\n",
> +		total_ret, total_avail);
> +
> +	return 0;
> +}

[Severity: Medium]
Is it expected that `cmd->size_out` is left unmodified on success here? Oth=
er
mock mailbox commands update this field to reflect the actual response payl=
oad
size (e.g., setting it to `struct_size(resp, extent, total_ret)`).

> +
> +static void dc_clear_sent(struct device *dev)
> +{
> +	struct cxl_mockmem_data *mdata =3D dev_get_drvdata(dev);
> +	struct cxl_extent_data *ext;
> +	unsigned long index;
> +
> +	lockdep_assert_held(&mdata->ext_lock);
> +
> +	/* Any extents not accepted must be cleared */
> +	xa_for_each(&mdata->dc_sent_extents, index, ext) {
> +		dev_dbg(dev, "Host rejected extent %#llx\n", ext->dpa_start);
> +		xa_erase(&mdata->dc_sent_extents, ext->dpa_start);
> +	}
> +}

[Severity: Medium]
Does removing the extent from the XArray via `xa_erase()` leak the underlyi=
ng
`cxl_extent_data` structure? Since it was originally allocated with
`devm_kzalloc()`, it appears this memory will accumulate indefinitely over
repeated insert/erase cycles unless `devm_kfree()` is explicitly called.
This identical pattern exists in `dc_delete_extent()` and
`release_accepted_extent()` as well.

> +
> +static int mock_add_dc_response(struct device *dev,
> +				struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mbox_dc_response *req =3D cmd->payload_in;
> +	u32 list_size =3D le32_to_cpu(req->extent_list_size);
> +	struct cxl_mockmem_data *mdata =3D dev_get_drvdata(dev);
> +	u32 last_offer_seq =3D 0;
> +	bool first =3D true;
> +
> +	guard(mutex)(&mdata->ext_lock);
> +	for (int i =3D 0; i < list_size; i++) {
> +		u64 start =3D le64_to_cpu(req->extent_list[i].dpa_start);
> +		u64 length =3D le64_to_cpu(req->extent_list[i].length);

[Severity: Medium]
Is it safe to iterate up to `list_size` without first validating that
`cmd->size_in` is large enough to contain
`struct_size(req, extent_list, list_size)`? Could a malformed request read
out-of-bounds memory here?

> +		struct cxl_extent_data *ext;
> +		int rc;
> +
> +		/*
> +		 * CXL r4.0 8.2.10.9.9.3: the host must list extents in the
> +		 * order the device offered them (Add Capacity events); reject
> +		 * an out-of-order response as Invalid Input.
> +		 */
> +		ext =3D xa_load(&mdata->dc_sent_extents, start);
> +		if (!ext)
> +			ext =3D xa_load(&mdata->dc_accepted_exts, start);
> +		if (ext) {
> +			if (!first && ext->offer_seq < last_offer_seq) {
> +				dev_err(dev, "Add-DC-Response out of order at extent %#llx\n",
> +					start);
> +				return -EINVAL;
> +			}
> +			last_offer_seq =3D ext->offer_seq;
> +			first =3D false;
> +		}
> +
> +		rc =3D dc_accept_extent(dev, start, length);
> +		if (rc)
> +			return rc;
> +	}

[Severity: Medium]
Could returning an error midway through this loop leave the mock device in a
torn state? If an extent midway through the list fails validation (like the
out-of-order check), previous extents in the iteration have already been
irrevocably transitioned to the accepted state via `dc_accept_extent()`.

> +
> +	dc_clear_sent(dev);
> +	return 0;
> +}

[Severity: Medium]
Will unconditionally calling `dc_clear_sent(dev)` break host responses that=
 are
split into multiple parts? If the host sets `req->flags & CXL_DCD_EVENT_MOR=
E`,
this clears the remaining pending extents before the host can acknowledge t=
hem.

> +
> +static void dc_delete_extent(struct device *dev, unsigned long long star=
t,
> +			     unsigned long long length)
> +{
[ ... ]
> +static int mock_dc_release(struct device *dev,
> +			   struct cxl_mbox_cmd *cmd)
> +{
> +	struct cxl_mbox_dc_response *req =3D cmd->payload_in;
> +	u32 list_size =3D le32_to_cpu(req->extent_list_size);
> +
> +	for (int i =3D 0; i < list_size; i++) {
> +		u64 start =3D le64_to_cpu(req->extent_list[i].dpa_start);
> +		u64 length =3D le64_to_cpu(req->extent_list[i].length);

[Severity: Medium]
Similarly to `mock_add_dc_response()`, does `mock_dc_release()` need to
validate that `cmd->size_in` is large enough to hold `list_size` entries be=
fore
iterating over `req->extent_list[i]`?

> +
> +		dev_dbg(dev, "Extent %#llx released by host\n", start);
> +		release_accepted_extent(dev, start, length);
> +	}
> +
> +	return 0;
> +}
[ ... ]
> @@ -1936,11 +2442,328 @@ static ssize_t sanitize_timeout_store(struct dev=
ice *dev,
> =20
>  static DEVICE_ATTR_RW(sanitize_timeout);
> =20
> +/* Return if the proposed extent would break the test code */
> +static bool new_extent_valid(struct device *dev, size_t new_start,
> +			     size_t new_len)
> +{
> +	struct cxl_mockmem_data *mdata =3D dev_get_drvdata(dev);
> +	struct cxl_extent_data *extent;
> +	size_t new_end, i;
> +
> +	if (!new_len)
> +		return false;
> +
> +	new_end =3D new_start + new_len;
> +
> +	dev_dbg(dev, "New extent %zx-%zx\n", new_start, new_end);
> +
> +	guard(mutex)(&mdata->ext_lock);
> +	dev_dbg(dev, "Checking extents starts...\n");
> +	xa_for_each(&mdata->dc_fm_extents, i, extent) {
> +		if (extent->dpa_start =3D=3D new_start)
> +			return false;
> +	}

[Severity: Medium]
Is it intentional that the overlap validation only checks exact starting
addresses? The iteration calculates `new_end` but doesn't check
`extent->length`, which seems to permit injecting extents that partially ov=
erlap
in physical DPA ranges.

> +
> +	dev_dbg(dev, "Checking sent extents starts...\n");
> +	xa_for_each(&mdata->dc_sent_extents, i, extent) {
> +		if (extent->dpa_start =3D=3D new_start)
> +			return false;
> +	}
> +
> +	dev_dbg(dev, "Checking accepted extents starts...\n");
> +	xa_for_each(&mdata->dc_accepted_exts, i, extent) {
> +		if (extent->dpa_start =3D=3D new_start)
> +			return false;
> +	}
> +
> +	return true;
> +}
[ ... ]
> +static ssize_t __dc_inject_extent_store(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count,
> +					bool shared)
> +{
[ ... ]
> +	if (!new_extent_valid(dev, start, length))
> +		return -EINVAL;
> +
> +	rc =3D devm_add_fm_extent(dev, start, length, uuid_str, shared_extn_seq,
> +				shared);
> +	if (rc) {
> +		dev_err(dev, "Failed to add extent DPA:%#llx LEN:%#llx; %d\n",
> +			start, length, rc);
> +		return rc;
> +	}
> +
> +	mark_extent_sent(dev, start);
> +	rc =3D log_dc_event(mdata, DCD_ADD_CAPACITY, start, length, uuid_str,
> +			  shared_extn_seq, more);
> +	if (rc) {

[Severity: Medium]
Could concurrent sysfs operations result in orphaned events here?
`mark_extent_sent()` aborts silently if the extent was deleted concurrently
(e.g., from a sysfs delete executing at the same time), but
`__dc_inject_extent_store()` will still unconditionally queue a
`DCD_ADD_CAPACITY` event via `log_dc_event()`.

> +		dev_err(dev, "Failed to add event %d\n", rc);
> +		return rc;
> +	}
> +
> +	return count;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D30
