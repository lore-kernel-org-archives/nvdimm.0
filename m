Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6189230F7EB;
	Thu, 25 Jun 2026 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411860; cv=none; b=XI3tr3Gt3ycLkT+NzCaadc85ExiYjUYtomfTj4f+28/UDoa+is5oGxb3CLH8NRKqctZoUorhXbnfanX6Id6i6eaTCfim4JsCkFOyBM/KWeXsCfpoZYitq401h/h/j8ub0cHfouFGR9LhkYGl1f/mySij3S2lT7LFkyUJkdalMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411860; c=relaxed/simple;
	bh=ry0sNvlVsC3aiFlZl10rkcmgEzrQiZ/FRb2tWDUolHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=djjjr7v61VL4Bpr1jDCoeLn+a2dxFOz3DheWDz5Y20JYVluFWOunNqoWsebwDRVDGZ80ihx5tcx4ov6UhfstbEnwP+MAPlWXemKz0X8sR4RSKmnzQ98K2OQDApP+7145GalEsxGOzDPAauUPPUJ8zaCLi/iFsMIiay7/+imiEYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDQstgTN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDQstgTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F8E1F00A3A;
	Thu, 25 Jun 2026 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411859;
	bh=pTf2C5d2lFSXSvvib88PwjpdSQHTolWrGh+Vs7bY8GE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UDQstgTNQDItb1vIOCuIRtBywbNK4XMtnEdXxD3Z6K80785Xf+3P/Cwql0xtJQXdO
	 fcLaOgt/mUVoJrqsK1ChCxwi2oBiIEgdTkdPDRoVml1p3WM7PvhkS8nIOtcRR99p7k
	 47dCcMw6kvBcnHWNKJbP8dtr26FvQL0xcjxn7t0KHQnZlQ+lDEHMFxg2D3AANdrSUo
	 8VCIQq4EhA0ijtn97/Qju1A91MRxZGHO8EDTL6kip6jtDPCBIMCvsooKlFO41tHAQT
	 /pqEIPv52ArTV1E6JxUnhxPg+2k0XbrAnhGinO3MZsY1jF/4g7O81Qr1MdLbnOG8Tu
	 47Z6vsrEibNyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 17/31] cxl/mem: Enforce tag-group semantics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-18-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-18-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:24:18 +0000
Message-Id: <20260625182418.E9F8E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Untagged extents spanning different DC partitions and DAX regions =
are incorrectly coalesced and assigned to the same region.
- [High] Fully duplicate extent groups are incorrectly rejected and omitted=
 from the device response.
--

commit c2cf18ae81b1c32953f39b06aeaa9e153f4ac609
Author: Anisa Su <anisa.su887@gmail.com>

cxl/mem: Enforce tag-group semantics

This commit completes tag-group validation. It adds sequence integrity
checks to verify that sharable partitions have dense shared_extn_seq
values, and verifies that tagged allocations do not span DC partitions.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 14ba263044f08..7967b0db2c512 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +static int cxl_check_group_partition(struct cxl_memdev_state *mds,
> +				     const uuid_t *tag,
> +				     const struct list_head *group)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	const struct cxl_dpa_partition *first_part =3D NULL;
> +	u64 first_dpa =3D 0;
> +	struct cxl_extent_list_node *pos;
> +
> +	if (uuid_is_null(tag) || list_empty(group))
> +		return 0;

[Severity: High]
This is a pre-existing issue, but does this explicit bypass for untagged
extents allow them to span different DC partitions?

If a device sends multiple untagged DC add capacity events spanning
different partitions, cxl_add_pending() appears to extract them all into a
single group.

Since this check returns 0 for null UUIDs, cxl_realize_group() processes th=
em
together. Would cxlr_add_extent() then register them all under the DAX regi=
on
of the first extent, effectively merging extents from different partitions =
into
the same region's resource tree?

[ ... ]

>  static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t =
*tag,
> -			     struct list_head *group, bool existing)
> +			     struct list_head *group, bool shareable,
> +			     bool existing)
>  {
>  	struct device *dev =3D mds->cxlds.dev;
>  	struct cxl_extent_list_node *pos, *tmp;
>  	struct cxl_dc_tag_group *tag_group;
>  	int group_cnt =3D 0;
> +	u16 seq_num;
>  	int rc;
> =20
> +	seq_num =3D -1;
>  	list_for_each_entry_safe(pos, tmp, group, list) {
> -		/*
> -		 * Pass the device-stamped 0-based shared_extn_seq through
> -		 * unchanged as the dax-side @seq_num (0..n-1).
> -		 */
> -		u16 seq =3D le16_to_cpu(pos->extent->shared_extn_seq);
> +		if (shareable)
> +			seq_num =3D le16_to_cpu(pos->extent->shared_extn_seq);
> +		else
> +			seq_num++;
> =20
> -		if (cxl_add_extent(mds, pos->extent, seq) < 0) {
> +		if (cxl_add_extent(mds, pos->extent, seq_num) < 0) {

[Severity: High]
This is a pre-existing issue, but what happens if a device resends a tag gr=
oup
where all extents have already been accepted?

If cxl_add_extent() detects a duplicate, it returns 0 without calling
cxlr_add_extent(). If this happens for every extent in the group,
mds->add_ctx.group is never allocated and remains NULL.

Does this cause the subsequent if (!tag_group) check in this function to dr=
op
the group and return -ENXIO instead of returning group_cnt to acknowledge
the extents back to the device?

>  			dev_dbg(dev,
>  				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
>  				tag,
> @@ -1412,15 +1532,22 @@ static int cxl_realize_group(struct cxl_memdev_st=
ate *mds, const uuid_t *tag,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D17
