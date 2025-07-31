Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CA01ACED9;
	Thu, 31 Jul 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753974484; cv=none; b=mBxVdsEpspS7rp1lHptg5c/JXk259NgnHaXWSJaaXjfVnmliXvsDqGjKNcCKWuEUcg61qxoHVYf6fo8Ko320NcLiqaU9Sdxo3fbNW704+AksHwJhqQcEVA0WNK4m4hbOLKyrpqd7Ct0aOFz9BOnYyW20Ydyr3kC86yRCokEg5l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753974484; c=relaxed/simple;
	bh=pa9VwKcB+q4yAi7+Bv6abIVQ9PXsM7T2n398NDcEzhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4V69nLumlKIQJ7TNHKF7nfWs7XU36I6MHzpskC/tnmrkbwIukewGJ0YmAPaNcizDcx/Qf8ZqW7CdrHFGmb+XdEDWRnjwG9BFIjriogSP/bycXaFvBVFd5DM+g4ZhkywLmNWeH75sCeNpVAfK6I0/mx6cVWqtHTt0rCgjCgIEXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+zBw3wB; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+zBw3wB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753974482; x=1785510482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pa9VwKcB+q4yAi7+Bv6abIVQ9PXsM7T2n398NDcEzhw=;
  b=J+zBw3wBJ8/D3sdDDsSDVCZHB9ionY4uh/zoeHOUH4mS8ASgpNjmqesx
   ASqtJBjDmcjWTsEGQ3mOHMJGTybusvXYA+dPATNspM80LXT4vDmE033qm
   Vm48uJN0UnLtYwQkD+bzYAhvY3ppLImZzb8bJgi8VZqEWA3CFXwrLQyJs
   3ceTDagnknsCqJKi1Uk4b4gCUqOqMw1x+G06+Cj3Hn1BB5GXtzdlArgt0
   7jO1QExRwkftt2+X7V9TeJBfTKmHq8f8SVRpIR44d9N9vnfMf5eAEe5zr
   iTWTqo4zFgLEFz8XQfPVfPJXUFFl3r9Rj6ZlBsdKn9jIb08D+wCSZgSSB
   A==;
X-CSE-ConnectionGUID: 1eiRAbvGS+2XVfceKCoNNQ==
X-CSE-MsgGUID: MQzCTPAERWu1orbtA6YJRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56233353"
X-IronPort-AV: E=Sophos;i="6.17,353,1747724400"; 
   d="scan'208";a="56233353"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 08:08:01 -0700
X-CSE-ConnectionGUID: M6otbXP0RIWZisz8EVv6Tg==
X-CSE-MsgGUID: ycrG9/pUR/WhaLOaEtc/Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,353,1747724400"; 
   d="scan'208";a="163642643"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 31 Jul 2025 08:07:59 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhUsv-0003rU-0Z;
	Thu, 31 Jul 2025 15:07:57 +0000
Date: Thu, 31 Jul 2025 23:07:56 +0800
From: kernel test robot <lkp@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	gost.dev@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, a.manzanares@samsung.com,
	vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <202507312211.ovRqDhYY-lkp@intel.com>
References: <20250730121209.303202-6-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-6-s.neeraj@samsung.com>

Hi Neeraj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f11a5f89910a7ae970fbce4fdc02d86a8ba8570f]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Kumar/nvdimm-label-Introduce-NDD_CXL_LABEL-flag-to-set-cxl-label-format/20250730-202209
base:   f11a5f89910a7ae970fbce4fdc02d86a8ba8570f
patch link:    https://lore.kernel.org/r/20250730121209.303202-6-s.neeraj%40samsung.com
patch subject: [PATCH V2 05/20] nvdimm/region_label: Add region label updation routine
config: x86_64-randconfig-121-20250731 (https://download.01.org/0day-ci/archive/20250731/202507312211.ovRqDhYY-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507312211.ovRqDhYY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507312211.ovRqDhYY-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/nvdimm/label.c:1184:25: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] align @@     got restricted __le16 [usertype] @@
   drivers/nvdimm/label.c:1184:25: sparse:     expected restricted __le32 [usertype] align
   drivers/nvdimm/label.c:1184:25: sparse:     got restricted __le16 [usertype]
   drivers/nvdimm/label.c: note: in included file (through drivers/nvdimm/nd-core.h):
   drivers/nvdimm/nd.h:314:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] align @@     got restricted __le16 [usertype] @@
   drivers/nvdimm/nd.h:314:37: sparse:     expected restricted __le32 [usertype] align
   drivers/nvdimm/nd.h:314:37: sparse:     got restricted __le16 [usertype]

vim +1184 drivers/nvdimm/label.c

  1139	
  1140	static int __pmem_region_label_update(struct nd_region *nd_region,
  1141			struct nd_mapping *nd_mapping, int pos, unsigned long flags)
  1142	{
  1143		struct nd_interleave_set *nd_set = nd_region->nd_set;
  1144		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
  1145		struct nd_lsa_label *nd_label;
  1146		struct cxl_region_label *rg_label;
  1147		struct nd_namespace_index *nsindex;
  1148		struct nd_label_ent *label_ent;
  1149		unsigned long *free;
  1150		u32 nslot, slot;
  1151		size_t offset;
  1152		int rc;
  1153		uuid_t tmp;
  1154	
  1155		if (!preamble_next(ndd, &nsindex, &free, &nslot))
  1156			return -ENXIO;
  1157	
  1158		/* allocate and write the label to the staging (next) index */
  1159		slot = nd_label_alloc_slot(ndd);
  1160		if (slot == UINT_MAX)
  1161			return -ENXIO;
  1162		dev_dbg(ndd->dev, "allocated: %d\n", slot);
  1163	
  1164		nd_label = to_label(ndd, slot);
  1165	
  1166		memset(nd_label, 0, sizeof_namespace_label(ndd));
  1167		rg_label = &nd_label->rg_label;
  1168	
  1169		/* Set Region Label Format identification UUID */
  1170		uuid_parse(CXL_REGION_UUID, &tmp);
  1171		export_uuid(nd_label->rg_label.type, &tmp);
  1172	
  1173		/* Set Current Region Label UUID */
  1174		export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
  1175	
  1176		rg_label->flags = __cpu_to_le32(flags);
  1177		rg_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
  1178		rg_label->position = __cpu_to_le16(pos);
  1179		rg_label->dpa = __cpu_to_le64(nd_mapping->start);
  1180		rg_label->rawsize = __cpu_to_le64(nd_mapping->size);
  1181		rg_label->hpa = __cpu_to_le64(nd_set->res->start);
  1182		rg_label->slot = __cpu_to_le32(slot);
  1183		rg_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
> 1184		rg_label->align = __cpu_to_le16(0);
  1185	
  1186		/* Update fletcher64 Checksum */
  1187		rgl_calculate_checksum(ndd, rg_label);
  1188	
  1189		/* update label */
  1190		offset = nd_label_offset(ndd, nd_label);
  1191		rc = nvdimm_set_config_data(ndd, offset, nd_label,
  1192				sizeof_namespace_label(ndd));
  1193		if (rc < 0) {
  1194			nd_label_free_slot(ndd, slot);
  1195			return rc;
  1196		}
  1197	
  1198		/* Garbage collect the previous label */
  1199		guard(mutex)(&nd_mapping->lock);
  1200		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
  1201			if (!label_ent->label)
  1202				continue;
  1203			if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
  1204				reap_victim(nd_mapping, label_ent);
  1205		}
  1206	
  1207		/* update index */
  1208		rc = nd_label_write_index(ndd, ndd->ns_next,
  1209				nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
  1210		if (rc)
  1211			return rc;
  1212	
  1213		list_for_each_entry(label_ent, &nd_mapping->labels, list)
  1214			if (!label_ent->label) {
  1215				label_ent->label = nd_label;
  1216				nd_label = NULL;
  1217				break;
  1218			}
  1219		dev_WARN_ONCE(&nd_region->dev, nd_label,
  1220				"failed to track label: %d\n",
  1221				to_slot(ndd, nd_label));
  1222		if (nd_label)
  1223			rc = -ENXIO;
  1224	
  1225		return rc;
  1226	}
  1227	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
