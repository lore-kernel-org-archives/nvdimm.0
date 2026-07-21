Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B347125C;
	Tue, 21 Jul 2026 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658172; cv=none; b=N8KBJ7rM0vW/k7UUVlJ3gitiBPoou0YlnsYy6ZkN+JhTY0F3gwnnqBF5qM/Ck1DMvXoy8NIRxTX4qaGfcZ8xpZyzsQq6D+Ylh/UHTpZQgo6BIqAb1WKDLmZ1kUKx5NnmwJLtzyq7mL+5jDZ2t1GqYS4jE8/F06Rw8WQF0zg3N/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658172; c=relaxed/simple;
	bh=eiiqFtDP4NjLFCTYVe8IvKFh3B2Cnoiy3NAQIZUw8iQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fFilVaX0So6oGoIRapXi/57Iu/GAl10d0f+hJ4fVg7v1M8YXAFEmDQtKqKbYjJM1qlQYfHvq23qeBgjRNnA1YcMTMVu4OR1VTcv8O5rgLFVE8+EfXUMnWoSlgIQpKh7Qqgv7FNvHqkYkgMdalUW/yOYmlGnAGYvZ7SelDmoVIsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbG/YujY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbG/YujY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF5B1F000E9;
	Tue, 21 Jul 2026 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658171;
	bh=MdJ+f83C+MLx2LvfM5IxZZaW8kjryJbrHaV6kOWN28c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BbG/YujYkZ9cWzit4HawvXhL2WhPTqKvki6PecSgcLKk4CtxhDIEweKndauybA7B6
	 DNDN9i+POJ+g3l09o9FfVXqt41imIkv1NoWKisDfqRr2y8AtjzdLWItoY9PFOwuiE3
	 Rlx71S3/ANaHdTo8aauekk29CqjDYJrtbieXeya1fr92xKhO5Yxlwcy2vY9MlAyYFY
	 ubowbn7mCpw7mHbToCj+SIv6fsFwSVjJU6R2+GSvcNfEEhJUYvOdcfa+/NvL05SZQq
	 xh74NMrEoR0wFzPbHUn2OxXQgbS1W1gQ8nGFkisWUQ8DdA8dukVPpdW9Self6ewelI
	 3KqMfPP+PlC+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/36] mm/compaction: disallow compaction on private
 nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, tj@kernel.org, damon@lists.linux.dev, hannes@cmpxchg.org, kvm@vger.kernel.org, mkoutny@suse.com
In-Reply-To: <20260720193431.3841992-12-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-12-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:22:49 +0000
Message-Id: <20260721182250.CCF5B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The kcompactd background compaction daemon is not prevented from c=
ompacting private nodes.
--

--- Patch [11]: [PATCH v5 11/36] mm/compaction: disallow compaction on priv=
ate nodes ---
commit 8f0db5de5c5b2025b3451b6bb90c3cd06411f91d
Author: Gregory Price <gourry@gourry.net>

mm/compaction: disallow compaction on private nodes
   =20
This commit skips compaction on private nodes because they do not yet suppo=
rt
page migration. It adds checks to direct compaction and sysfs paths to abort
compaction early for private nodes.

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 9f81055a358ed..8c1351cce7bcc 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c

[ ... ]

> @@ -3017,6 +3026,9 @@ static ssize_t compact_store(struct device *dev,
>  {
>  	int nid =3D dev->id;
> =20
> +	if (node_is_private(nid))
> +		return -EINVAL;
> +
>  	if (nid >=3D 0 && nid < nr_node_ids && node_online(nid)) {
>  		/* Flush pending updates to the LRU lists */
>  		lru_add_drain_all();

[Severity: High]
The commit message states we should disallow compaction on private nodes
because migration is not yet supported. Does this patch miss the background
compaction daemon paths?

Under memory pressure, kswapd calls wakeup_kcompactd(), which currently
bypasses private node checks:

mm/compaction.c:wakeup_kcompactd() {
    ...
    if (!kcompactd_node_suitable(pgdat))
        return;

    wake_up_interruptible(&pgdat->kcompactd_wait);
}

This wakes up the daemon which will then unconditionally execute
compact_zone() for the node without verifying if the node is private:

mm/compaction.c:kcompactd_do_work() {
    ...
    for (zoneid =3D 0; zoneid <=3D cc.highest_zoneidx; zoneid++) {
        ...
        status =3D compact_zone(&cc, NULL);
    ...
}

Could this result in the background daemon uselessly waking up and
attempting unsupported page migration on private nodes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D11
