Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09224A138B;
	Thu,  9 Jul 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783619961; cv=none; b=BjBCxx5wVpTKp5xulSlvwToL0CTcC6XBRnJjieYXL5bLCx8PkGUJihw72Tld6r6BJj16l12MiT7JjZo6vCVNGp+0IXoVevYYbSF2nxtWbVbYNcAzeSPDpJbv1idEMX9MjOKq8XK7Oolyym9+xN5C7FD9TBf+eQVDOgXqBWAKHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783619961; c=relaxed/simple;
	bh=IeL1oxUC9sGqcnSkpWpKrEd+SnQglbBpUQgEgR4fVhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sbr0KOdLt+yPAxOoPC2RJnstks126fG3o0EMqw70bHj0EnU8IdEOBNPtgJee1dsBKr3cE+cS5N6q1xJ4WWdnjS5/Qk0JrU2xvoB0z95n9B8Y0O1Zxj2Tdb908Pw/7HZfSUn5d7CXehsNVnbrYcfwLyq9VbJrimUJiTVXa+nj8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JnRdgkaU; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnRdgkaU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783619959; x=1815155959;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IeL1oxUC9sGqcnSkpWpKrEd+SnQglbBpUQgEgR4fVhc=;
  b=JnRdgkaUvM4RMFPZgvWP8AeM+ILhBt9xvV2kickeqYstZLD7JUW4s/2Z
   Zc/xAmxB0975A/AzHVyaTjEhKwWf++hr0NanZ1EqTno2Pn9YRuVp8D9eX
   P4kC2eaIYsLKTE48yPMR7iNahCkvTr5eY5G7q3+zpwEBBOWm7p+LYLT57
   ChsvGkPHszwFgQ8C5E9oqvH0wS/OuU9sXgBfohcwGTsEocLDW2Ac1Ln5L
   fNxH2/lBwGc146B4oAH9EPXEiqL+gjku95K/BVxkq+DQWfGZUIiu5St+U
   592teC2iRkCdOtUOoknGd5XTvVLhYqQ7GqJStzrrfm7C5AmtQ2UkyD1b8
   A==;
X-CSE-ConnectionGUID: MQdw9gYaQeGGYIZpYvdjOA==
X-CSE-MsgGUID: qB5pgQZPQsqtqb0zdvvP0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88139727"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88139727"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:59:06 -0700
X-CSE-ConnectionGUID: NTSX3/2GQH6HiLFnWbczgA==
X-CSE-MsgGUID: ot/6hvFVQieZNeL412g8ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252920873"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:59:05 -0700
Message-ID: <f8005e88-51d9-4cc4-8a7e-596347de5d84@intel.com>
Date: Thu, 9 Jul 2026 10:59:04 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
> and export both so a driver can render and parse the memory online type
> through its own sysfs interface.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/base/memory.c          | 9 +++++++++
>  include/linux/memory_hotplug.h | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index b318344426fa..3a2f69d3af7b 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char *str)
>  	}
>  	return -EINVAL;
>  }
> +EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
> +
> +const char *mhp_online_type_to_str(int online_type)
> +{
> +	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
> +		return NULL;
> +	return online_type_to_str[online_type];
> +}
> +EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
>  
>  #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
>  
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7c9d66729c60..5d4b628c4a1f 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
>  extern u64 max_mem_size;
>  
>  extern int mhp_online_type_from_str(const char *str);
> +const char *mhp_online_type_to_str(int online_type);
>  
>  /* If movable_node boot option specified */
>  extern bool movable_node_enabled;

