Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1028021A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 15:39:09 -0700 (PDT)
Date: Tue, 10 Jul 2018 16:39:07 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCHv3] ndctl: Add 'list' verbose options
Message-ID: <20180710223907.GB25279@linux.intel.com>
References: <20180706170211.3014-1-keith.busch@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180706170211.3014-1-keith.busch@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Keith Busch <keith.busch@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 06, 2018 at 11:02:11AM -0600, Keith Busch wrote:
> The informational and miscellaneous flag options are becoming more
> numerous, and can be difficult to remember what can be listed. This
> patch adds a 'verbose' option that increases the detail listed by
> automatically enabling options and less essential information.
> 
> The verbose option can be repeated multiple times to increase the
> detail. There are currently three levels of verbose with output detail
> documented in the ndctl list manpage.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
<>
> @@ -112,7 +115,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
>  	numa = ndctl_region_get_numa_node(region);
>  	if (numa >= 0) {
>  		jobj = json_object_new_int(numa);
> -		if (jobj)
> +		if (jobj && flags & UTIL_JSON_VERBOSE)
>  			json_object_object_add(jregion, "numa_node", jobj);
>  	}

This same change needs to be repeated in the other place where we print the
numa_node, in util_namespace_to_json().

The rest looks good.  You can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
