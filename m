Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2142D225A35
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 22:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752792797; cv=none; b=nm99Z15JY1/P5Y03jaIrLREQIlqwfp/LwNLtHU9DwEeA5/pPK8qfIjgQocx9n7jCs/vTozpi+0Tt1qzaA8iKYnK6IyaF4GpI1AgQMs5R4MgzRmBklK4KC+F8pHQlY/V0DhPN/mMsUwSXTLX+MVocNXPhNa4o9lNN9u9EdoFEOmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752792797; c=relaxed/simple;
	bh=9e3AIQXj23hWPeNFUN9Iuk2Jsn2bHQgdUUiz5mOhDvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUr/okcECUiFZFPc+Af9s5Clx/2/yuJycVaylfoPoMfzIYIU0uKMwe9gnObT6rbiCPnID9/inhjLVIft9Mt9jusYlmczqQ62R6NFhhF1OU3Al123RnYhQt10h6Z/l1iTYKn86D2iHpq5zC77hzRD3e9GPDwI94MyIZTJwbgAggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M+GXfy38; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M+GXfy38"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752792795; x=1784328795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9e3AIQXj23hWPeNFUN9Iuk2Jsn2bHQgdUUiz5mOhDvc=;
  b=M+GXfy38jPQqwpq17kDh7FdYg1jkHjT3cZr/AxoG40ZjgErSQyvvl4Rg
   BKXVbkQ4VJ3++JLiaPiV/tejXg+HMbRhFlf6QGpjErnhfpiVC2CvGTj1b
   GVjT5RFJW907JqLiRueW6UIhq+IEeaJ8y5rxHZXXABk32Sui/5AwN/Tin
   Ailv8l0HYRYNB/C0EJSdYmEx6H6x6azYK51PbvmMwJ07B2HS+skOxTclV
   oLDevhPw9ytYUjXWshw2dLSW/VE+X97hyJsHUzVPAeqPDsoxsQJX5KBWx
   KEDg7EAysfQjiDPj/mDuj+jG/fyajUE0fbrkR+I9IIBWwXDxcL39uisNR
   w==;
X-CSE-ConnectionGUID: /PH680v3Qye8fh3DInw0Ew==
X-CSE-MsgGUID: 2bav0tIaQze89ZJQF4Irhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="66432322"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="66432322"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 15:53:15 -0700
X-CSE-ConnectionGUID: Z8/ewd2OQRimuhQcw+JZOg==
X-CSE-MsgGUID: oiSGKo66Sn2wzf+6byfzAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157306802"
Received: from fdefranc-mobl3.ger.corp.intel.com (HELO fdefranc-mobl3.localnet) ([10.245.246.211])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 15:53:08 -0700
From: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
To: dan.j.williams@intel.com, dave@stgolabs.net, jonathan.cameron@huawei.com,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, Neeraj Kumar <s.neeraj@samsung.com>
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject:
 Re: [RFC PATCH 05/20] nvdimm/region_label: Add region label updation routine
Date: Fri, 18 Jul 2025 00:53:05 +0200
Message-ID: <2354653.gBsaNRSFpC@fdefranc-mobl3>
In-Reply-To: <1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
References:
 <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124019epcas5p39815cc0f2b175aee40c194625166695c@epcas5p3.samsung.com>
 <1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, June 17, 2025 2:39:29=E2=80=AFPM Central European Summer Time N=
eeraj Kumar wrote:
> Added __pmem_region_label_update region label update routine to update
> region label
>=20
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c          | 142 ++++++++++++++++++++++++++++++++
>  drivers/nvdimm/label.h          |   2 +
>  drivers/nvdimm/namespace_devs.c |  12 +++
>  drivers/nvdimm/nd.h             |  20 +++++
>  include/linux/libnvdimm.h       |   8 ++
>  5 files changed, 184 insertions(+)
>=20
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index d5cfaa99f976..7f33d14ce0ef 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drv=
data *ndd,
>  	nsl_set_checksum(ndd, nd_label, sum);
>  }
> =20
> +static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
> +				   struct cxl_region_label *rg_label)
> +{
> +	u64 sum;
> +
> +	rgl_set_checksum(rg_label, 0);
> +	sum =3D nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
> +	rgl_set_checksum(rg_label, sum);
> +}
> +
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>  		struct nd_lsa_label *nd_label, u32 slot)
>  {
> @@ -1117,6 +1127,138 @@ int nd_pmem_namespace_label_update(struct nd_regi=
on *nd_region,
>  	return 0;
>  }
> =20
> +static int __pmem_region_label_update(struct nd_region *nd_region,
> +		struct nd_mapping *nd_mapping, int pos, unsigned long flags)

Hi Neeraj,

I've noticed that __pmem_region_label_update() shares many similarities=20
with the existing __pmem_label_update().

> +{
> +	struct nd_interleave_set *nd_set =3D nd_region->nd_set;
> +	struct nvdimm_drvdata *ndd =3D to_ndd(nd_mapping);
> +	struct nd_lsa_label *nd_label;
> +	struct cxl_region_label *rg_label;
> +	struct nd_namespace_index *nsindex;
> +	struct nd_label_ent *label_ent;
> +	unsigned long *free;
> +	u32 nslot, slot;
> +	size_t offset;
> +	int rc;
> +	uuid_t tmp;
> +
> +	if (!preamble_next(ndd, &nsindex, &free, &nslot))
> +		return -ENXIO;
> +
> +	/* allocate and write the label to the staging (next) index */
> +	slot =3D nd_label_alloc_slot(ndd);
> +	if (slot =3D=3D UINT_MAX)
> +		return -ENXIO;
> +	dev_dbg(ndd->dev, "allocated: %d\n", slot);
> +
> +	nd_label =3D to_label(ndd, slot);
> +
> +	memset(nd_label, 0, sizeof_namespace_label(ndd));
> +	rg_label =3D &nd_label->rg_label;
> +
> +	/* Set Region Label Format identification UUID */
> +	uuid_parse(CXL_REGION_UUID, &tmp);
> +	export_uuid(nd_label->rg_label.type, &tmp);
> +
> +	/* Set Current Region Label UUID */
> +	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
> +
> +	rg_label->flags =3D __cpu_to_le32(flags);
> +	rg_label->nlabel =3D __cpu_to_le16(nd_region->ndr_mappings);
> +	rg_label->position =3D __cpu_to_le16(pos);
> +	rg_label->dpa =3D __cpu_to_le64(nd_mapping->start);
> +	rg_label->rawsize =3D __cpu_to_le64(nd_mapping->size);
> +	rg_label->hpa =3D __cpu_to_le64(nd_set->res->start);
> +	rg_label->slot =3D __cpu_to_le32(slot);
> +	rg_label->ig =3D __cpu_to_le32(nd_set->interleave_granularity);
> +	rg_label->align =3D __cpu_to_le16(0);
> +
> +	/* Update fletcher64 Checksum */
> +	rgl_calculate_checksum(ndd, rg_label);
> +
> +	/* update label */
> +	offset =3D nd_label_offset(ndd, nd_label);
> +	rc =3D nvdimm_set_config_data(ndd, offset, nd_label,
> +			sizeof_namespace_label(ndd));
> +	if (rc < 0) {
> +		nd_label_free_slot(ndd, slot);
> +		return rc;
> +	}
> +
> +	/* Garbage collect the previous label */
> +	mutex_lock(&nd_mapping->lock);
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +		if (!label_ent->label)
> +			continue;
> +		if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
> +			reap_victim(nd_mapping, label_ent);
> +	}
> +
> +	/* update index */
> +	rc =3D nd_label_write_index(ndd, ndd->ns_next,
> +			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> +
> +	if (rc =3D=3D 0) {
> +		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +			if (!label_ent->label) {
> +				label_ent->label =3D nd_label;
> +				nd_label =3D NULL;
> +				break;
> +			}
> +		dev_WARN_ONCE(&nd_region->dev, nd_label,
> +				"failed to track label: %d\n",
> +				to_slot(ndd, nd_label));
> +		if (nd_label)
> +			rc =3D -ENXIO;
> +	}
> +	mutex_unlock(&nd_mapping->lock);
> +
> +	return rc;
> +}
> +
> +int nd_pmem_region_label_update(struct nd_region *nd_region)

Same here. nd_pmem_region_label_update() is almost identical to the=20
existing nd_pmem_namespace_label_update.=20

Although I'm not familiar with drivers/nvdimm, it seems preferable to=20
reuse and adapt the existing functions to reduce redundancy and simplify=20
future maintenance, unless there are specific reasons for not doing so=20
that I'm unaware of.

Thanks,=20

=46abio

> +{
> +	int i, rc;
> +
> +	for (i =3D 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping =3D &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd =3D to_ndd(nd_mapping);
> +
> +		/* No need to update region label for non cxl format */
> +		if (!ndd->cxl)
> +			continue;
> +
> +		/* Init labels to include region label */
> +		rc =3D init_labels(nd_mapping, 1);
> +
> +		if (rc < 0)
> +			return rc;
> +
> +		rc =3D __pmem_region_label_update(nd_region, nd_mapping, i,
> +					NSLABEL_FLAG_UPDATING);
> +
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/* Clear the UPDATING flag per UEFI 2.7 expectations */
> +	for (i =3D 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping =3D &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd =3D to_ndd(nd_mapping);
> +
> +		/* No need to update region label for non cxl format */
> +		if (!ndd->cxl)
> +			continue;
> +
> +		rc =3D __pmem_region_label_update(nd_region, nd_mapping, i, 0);
> +
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
>  int __init nd_label_init(void)
>  {
>  	WARN_ON(guid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_guid));
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 4883b3a1320f..0f428695017d 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -190,6 +190,7 @@ struct nd_namespace_label {
>  struct nd_lsa_label {
>  	union {
>  		struct nd_namespace_label ns_label;
> +		struct cxl_region_label rg_label;
>  	};
>  };
> =20
> @@ -233,4 +234,5 @@ struct nd_region;
>  struct nd_namespace_pmem;
>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size);
> +int nd_pmem_region_label_update(struct nd_region *nd_region);
>  #endif /* __LABEL_H__ */
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_d=
evs.c
> index 23b9def71012..6cccb4d2fc7b 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, =
const char *buf,
>  	return rc;
>  }
> =20
> +int nd_region_label_update(struct nd_region *nd_region)
> +{
> +	int rc;
> +
> +	nvdimm_bus_lock(&nd_region->dev);
> +	rc =3D nd_pmem_region_label_update(nd_region);
> +	nvdimm_bus_unlock(&nd_region->dev);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(nd_region_label_update);
> +
>  static int nd_namespace_label_update(struct nd_region *nd_region,
>  		struct device *dev)
>  {
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 07d665f18bf6..2fdc92b29e8a 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -322,6 +322,26 @@ static inline void nsl_set_region_uuid(struct nvdimm=
_drvdata *ndd,
>  		export_uuid(ns_label->cxl.region_uuid, uuid);
>  }
> =20
> +static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
> +				  const uuid_t *uuid)
> +{
> +	uuid_t tmp;
> +
> +	import_uuid(&tmp, rg_label->uuid);
> +	return uuid_equal(&tmp, uuid);
> +}
> +
> +static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
> +{
> +	return __le64_to_cpu(rg_label->checksum);
> +}
> +
> +static inline void rgl_set_checksum(struct cxl_region_label *rg_label,
> +				    u64 checksum)
> +{
> +	rg_label->checksum =3D __cpu_to_le64(checksum);
> +}
> +
>  bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
>  			    struct nd_namespace_label *nd_label, guid_t *guid);
>  enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 0a55900842c8..b06bd45373f4 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -115,6 +115,13 @@ struct nd_interleave_set {
>  	u64 altcookie;
> =20
>  	guid_t type_guid;
> +
> +	/* v2.1 region label info */
> +	uuid_t uuid;
> +	int interleave_ways;
> +	int interleave_granularity;
> +	struct resource *res;
> +	int nr_targets;
>  };
> =20
>  struct nd_mapping_desc {
> @@ -302,6 +309,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
>  int nvdimm_has_cache(struct nd_region *nd_region);
>  int nvdimm_in_overwrite(struct nvdimm *nvdimm);
>  bool is_nvdimm_sync(struct nd_region *nd_region);
> +int nd_region_label_update(struct nd_region *nd_region);
> =20
>  static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, vo=
id *buf,
>  		unsigned int buf_len, int *cmd_rc)
> --=20
> 2.34.1
>=20
>=20
>=20
>=20




