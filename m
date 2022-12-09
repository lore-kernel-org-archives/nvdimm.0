Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED4763C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606931; x=1702142931;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jd1wk4u6381cqu63aSq1YSeA4pG0WZ9zj9r2dVZNb20=;
  b=BngqCTS5cAVJytyPeIbJDuwccHPw6LBNauBVca2LyUNepAswdD0O8qUz
   Kk/c4vSo7jfhi9JcE7IybF2y4r64IivIf+qlzUNWeH4xRe91FZcP9jYX7
   9KvCd9BMGda2wtOw0R04xZGw52+qQjHKOPX38bg80y7JtlbHNkIYLgtmA
   xSCPNnJrK/FI8lXvGQUb0Qn7l/2gAfr5YKVdQtbz/JJBPSWCoAQa2DFLT
   D0i7hyAYadjEFQDyh9fq1xb9cIDTeHvqOCC/m5ZtvOiAG9BHB5X591zDD
   m6fnotyK1HrvjzFcmtoreTbn3oteHB4tHFt84qIcusXWGW2kbzqn+jupM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="344545873"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="344545873"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:28:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="736279883"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="736279883"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:28:50 -0800
Date: Fri, 9 Dec 2022 09:28:48 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 10/18] cxl/list: Record cxl objects in json
 objects
Message-ID: <Y5NwUKehrlX6mh3Y@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053493696.582963.9963151335296712050.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053493696.582963.9963151335296712050.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:28:57PM -0800, Dan Williams wrote:
> In preparation for reusing 'cxl list' object selection in other utilities,
> like 'cxl create-region', record the associated cxl object in the json
> object. For example, enable 'cxl create-region -d decoderX.Y' to lookup the
> memdevs that result from 'cxl list -M -d decoderX.Y'.
> 
> This sets up future design decisions for code that wants to walk the
> topology. It can either open-code its own object walk, or get the json-c
> representation of a query and use that. Unless the use case knows exactly
> the object it wants it is likely more powerful to specify a
> cxl_filter_walk() query and then walk the topology result.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/json.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 292e8428ccee..844bc089a4b7 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -365,6 +365,8 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		if (jobj)
>  			json_object_object_add(jdev, "partition_info", jobj);
>  	}
> +
> +	json_object_set_userdata(jdev, memdev, NULL);
>  	return jdev;
>  }
>  
> @@ -423,6 +425,7 @@ void util_cxl_dports_append_json(struct json_object *jport,
>  			json_object_object_add(jdport, "id", jobj);
>  
>  		json_object_array_add(jdports, jdport);
> +		json_object_set_userdata(jdport, dport, NULL);
>  	}
>  
>  	json_object_object_add(jport, "dports", jdports);
> @@ -446,6 +449,7 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
>  	if (jobj)
>  		json_object_object_add(jbus, "provider", jobj);
>  
> +	json_object_set_userdata(jbus, bus, NULL);
>  	return jbus;
>  }
>  
> @@ -570,6 +574,7 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  					       jobj);
>  	}
>  
> +	json_object_set_userdata(jdecoder, decoder, NULL);
>  	return jdecoder;
>  }
>  
> @@ -628,6 +633,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
>  			json_object_object_add(jmapping, "decoder", jobj);
>  
>  		json_object_array_add(jmappings, jmapping);
> +		json_object_set_userdata(jmapping, mapping, NULL);
>  	}
>  
>  	json_object_object_add(jregion, "mappings", jmappings);
> @@ -693,6 +699,7 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>  
>  	util_cxl_mappings_append_json(jregion, region, flags);
>  
> +	json_object_set_userdata(jregion, region, NULL);
>  	return jregion;
>  }
>  
> @@ -765,6 +772,7 @@ void util_cxl_targets_append_json(struct json_object *jdecoder,
>  			json_object_object_add(jtarget, "id", jobj);
>  
>  		json_object_array_add(jtargets, jtarget);
> +		json_object_set_userdata(jtarget, target, NULL);
>  	}
>  
>  	json_object_object_add(jdecoder, "targets", jtargets);
> @@ -807,6 +815,7 @@ static struct json_object *__util_cxl_port_to_json(struct cxl_port *port,
>  			json_object_object_add(jport, "state", jobj);
>  	}
>  
> +	json_object_set_userdata(jport, port, NULL);
>  	return jport;
>  }
>  
> 
