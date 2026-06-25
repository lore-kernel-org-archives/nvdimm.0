Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971B02D94B5;
	Thu, 25 Jun 2026 18:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412313; cv=none; b=sR9JDjyJAcKX6rg3QVYEm84HzkIywwRbkR69sctEvqZSXTpq8nGobucaBqHnvbdR4QKVjXYEcLnST9QxJLPxyc8WWVHJ2rBLmgJkvdm7xSeeb1dBuvPlZJn+cdmw/TpdPATgLr2wFT5dwTAFml4GTZfgsJtHk6DOIIu8mA7rjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412313; c=relaxed/simple;
	bh=xJiz+tegieTGRoI8xRaV2sVK7mIwWMAUpvX6CLNW6kQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=APGG0qbl11PmNgg/65T31JXTh+9NNG8cbV4cybO6pQfdNofEzWCs63C9MDM1r8a2F0tpbL+CqX74TbtRQpaPgJyhVk91RAM8buh7AtYnGnUD93y6T6Y6ItFbH7r1s52luUq6p/pf/eAzgScx3NfV+XMrw9lEbGn+fgEc7CbtSM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lB/mRUub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lB/mRUub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACC61F000E9;
	Thu, 25 Jun 2026 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412312;
	bh=TrCfSdZdzI8ZP4+B3aqHmbJMYyYjvsZNRKv/CZd0VSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lB/mRUubFR1tjTCeiKikza5EdY4c2shJF8SS8mkGhjE5iSpS4ooxffWE2iWH7kYYR
	 x+LU7b9pks6nrxNEbKbQ3EfFvNVwtzXr3rAj5Xh9LzvFQuUvx+BYcSlZ7rdbmPRsaI
	 9KM9XLbYenFDNftFP0U2O+KohK8DLGX/RySSnag22E9XcGFtDt1Ob0kW42TdN5bUm8
	 kT1Jb52BSiq3M/o3LR4VuljqCZ+KyPeFhZisPVr53Tv3F81vb3hord2UIejv8V/FIl
	 QcqoPck+TlXTEgztCNEGjeuTCwydfO4q7sXP3h5l28s8UQODkpRbdkTm30mp8iPCAf
	 tB4KHxJsNA5sA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 29/31] tools/testing/cxl: Make event logs dynamic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-30-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-30-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:31:51 +0000
Message-Id: <20260625183151.CACC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete validation of `nr_recs` in `mock_clear_event` allows =
an out-of-bounds array access and arbitrary memory free.
--

commit fb02931b1ff4b8cef05ff7386cba792c02a0c46e
Author: Ira Weiny <iweiny@kernel.org>

tools/testing/cxl: Make event logs dynamic

This commit modifies the mock event logs in the cxl test tool to be
dynamically allocated instead of using static arrays. This is intended to
support dynamically generating events when extents are created or destroyed.

> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 271c7ad8cc32c..a2bfd52db0762 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c

[ ... ]

> @@ -325,23 +354,20 @@ static int mock_clear_event(struct device *dev, str=
uct cxl_mbox_cmd *cmd)
>  	if (!log)
>  		return 0; /* No mock data in this log */
> =20
> -	/*
> -	 * This check is technically not invalid per the specification AFAICS.
> -	 * (The host could 'guess' handles and clear them in order).
> -	 * However, this is not good behavior for the host so test it.
> -	 */
> -	if (log->clear_idx + pl->nr_recs > log->cur_idx) {
> -		dev_err(dev,
> -			"Attempting to clear more events than returned!\n");
> -		return -EINVAL;
> -	}
> +	guard(write_lock)(&log->lock);
> =20
>  	/* Check handle order prior to clearing events */
> -	for (nr =3D 0, handle =3D event_get_clear_handle(log);
> -	     nr < pl->nr_recs;
> -	     nr++, handle++) {
> +	handle =3D log->current_handle;
> +	for (nr =3D 0; nr < pl->nr_recs && handle !=3D log->last_handle;
> +	     nr++, handle =3D event_inc_handle(handle)) {
> +
> +		dev_dbg(dev, "Checking clear of %d handle %u plhandle %u\n",
> +			log_type, handle,
> +			le16_to_cpu(pl->handles[nr]));
> +
>  		if (handle !=3D le16_to_cpu(pl->handles[nr])) {
> -			dev_err(dev, "Clearing events out of order\n");
> +			dev_err(dev, "Clearing events out of order %u %u\n",
> +				handle, le16_to_cpu(pl->handles[nr]));
>  			return -EINVAL;
>  		}
>  	}
> @@ -350,25 +376,12 @@ static int mock_clear_event(struct device *dev, str=
uct cxl_mbox_cmd *cmd)
>  		log->nr_overflow =3D 0;
> =20
>  	/* Clear events */
> -	log->clear_idx +=3D pl->nr_recs;
> -	return 0;
> -}
> +	for (nr =3D 0; nr < pl->nr_recs; nr++)
> +		mes_del_event(dev, log, le16_to_cpu(pl->handles[nr]));

[Severity: Medium]
Can this result in an out-of-bounds access and arbitrary memory free?

If a user issues a clear command where pl->nr_recs is greater than the
number of valid events, the validation loop above terminates early when
handle =3D=3D log->last_handle. It does not return an error for the extra
records.

The deletion loop here then unconditionally iterates pl->nr_recs times,
passing the remaining, unvalidated user-provided handles to mes_del_event().

Inside mes_del_event():

static void mes_del_event(struct device *dev, struct mock_event_log *log,
                          u16 handle)
{
        ...
        record =3D log->events[handle];
        ...
        devm_kfree(dev, record);
}

Since the user-provided handles are not validated against the log->events
array size bounds when the validation loop terminates early, does this allow
an out-of-bounds read on the array followed by freeing whatever value is re=
ad?

> +	dev_dbg(dev, "Delete log %d cur %d last %d\n",
> +		log_type, log->current_handle, log->last_handle);
> =20
> -static void cxl_mock_event_trigger(struct device *dev)
> -{

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D29
