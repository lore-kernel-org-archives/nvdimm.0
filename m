Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7F62C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 20:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641502495; x=1673038495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qBzWalmZpdaUQkWivhzaH4t23uCN27xqYNbVmdFqzLs=;
  b=UMXN8nCT/xgddVr7At2DmOhs6j9ijXcxqKz0GpKP+zNgHaT9uVRRUcbr
   HVsa+Q7NqKPsu1ZwyGVeTcqld29gmOXgl/A1KI28zFAwZ9vLnUIxuhMoh
   5/2pACXLUMtAMUwOSVC6HTWWQihfw3FRmPU+WQ/WS5FwXCnWeR4Kz/LOD
   WVBEm0ox57Lba2Lo37A7ROLVHFY1mfhB7XhBy5Nzi1M7YgZQv0D6edw6O
   d6S1yxgzDh7dE0OZMUXzmPewPZwbZ2JOANQ6X0yfRu+i+PpuINtLR746r
   Db1AKBHLeHatMMMldjvkLc0B/4PUSEpVMBDB9I/wCmxKcTx0FhiseJ8r/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242528014"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242528014"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:54:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="527121706"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:54:55 -0800
Date: Thu, 6 Jan 2022 12:54:54 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 6/7] ndctl, util: use 'unsigned long long' type in
 OPT_U64 define
Message-ID: <20220106205454.GG178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <4653004cf532c2e14f79a45bddf0ebaac09ef4e6.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4653004cf532c2e14f79a45bddf0ebaac09ef4e6.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:17PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The OPT_U64 define failed in check_vtype() with unknown 'u64' type.
> Replace with 'unsigned long long' to make the OPT_U64 define usable.

I feel like this should be the first patch in the series.

> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  util/parse-options.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/util/parse-options.h b/util/parse-options.h
> index 9318fe7..91b7932 100644
> --- a/util/parse-options.h
> +++ b/util/parse-options.h
> @@ -124,7 +124,7 @@ struct option {
>  #define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
>  #define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h) }
>  #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
> -#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
> +#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned long long *), .help = (h) }

Why can't this be uint64_t?

Ira

>  #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
>  #define OPT_FILENAME(s, l, v, a, h) { .type = OPTION_FILENAME, .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
>  #define OPT_DATE(s, l, v, h) \
> -- 
> 2.31.1
> 
