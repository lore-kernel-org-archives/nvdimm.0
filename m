Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDB22C98
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 16:45:32 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="218448371"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="218448371"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:45:28 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="667593015"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:45:25 -0700
Date: Wed, 3 Nov 2021 09:45:25 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, aneesh.kumar@linux.ibm.com,
	vaibhav@linux.ibm.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com
Subject: Re: [REPOST PATCH v2 1/2] libndctl, intel: Indicate supported
 smart-inject types
Message-ID: <20211103164524.GV3538886@iweiny-DESK2.sc.intel.com>
References: <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
 <163491461724.1641479.6370717053054036222.stgit@lep8c.aus.stglabs.ibm.com>
 <20211028044539.GC3538886@iweiny-DESK2.sc.intel.com>
 <78cf83c5-6df3-a02b-f081-d6f028c3ef23@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78cf83c5-6df3-a02b-f081-d6f028c3ef23@linux.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Wed, Nov 03, 2021 at 02:33:37PM +0530, Shivaprasad G Bhat wrote:
>    Thanks for the comments Ira. Replies inline..
> 
>    On 10/28/21 10:15, Ira Weiny wrote:
> 
>  On Fri, Oct 22, 2021 at 09:57:07AM -0500, Shivaprasad G Bhat wrote:
> 
>  From: Vaibhav Jain [1]<vaibhav@linux.ibm.com>
> 
> 
>  [snip]
> 
>  < snip>
> 
>          ndctl_cmd_unref(si_cmd);
>          return rc;
>  @@ -415,8 +423,10 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
>          struct json_object *jhealth;
>          struct json_object *jdimms;
>          struct json_object *jdimm;
>  +   unsigned int supported_types;
>          int rc;
> 
>  +   /* Get supported smart injection types */
> 
>  NIT: this comment is probably unnecessary.
> 
>    The code changes definition of the return value hence wanted to
> 
>    clarify that, it indicates a set of flags instead of a boolean.
> 
>    From that pov, the comment helps avoiding the confusion.
> 
>    Please let me know If you think the otherway.

But that change is documented in the change log.  When reading the code after
the change the function is pretty self documenting.

And if you want to document the call, that should be done with the definition
in the *.c file.  Not at the call sites.

Ira

> 
>          rc = ndctl_dimm_smart_inject_supported(dimm);
>          switch (rc) {
>          case -ENOTTY:
>  @@ -431,6 +441,15 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
>                  error("%s: smart injection not supported by either platform firmware or the kernel.",
>                          ndctl_dimm_get_devname(dimm));
>                  return rc;
>  +   default:
>  +           if (rc < 0) {
>  +                   error("%s: Unknown error %d while checking for smart injection support",
>  +                         ndctl_dimm_get_devname(dimm), rc);
>  +                   return rc;
>  +           }
>  +           /* Assigning to an unsigned type since rc < 0 */
> 
>  Comment wrong?
> 
>    Will get rid of it.
> 
>  +           supported_types = rc;
>  +           break;
>          }
> 
>          if (sctx.op_mask & (1 << OP_SET)) {
> 
>  [snip]
> 
>  Other than the comment it looks fine.
> 
>  Reviewed-by: Ira Weiny [2]<ira.weiny@intel.com>
> 
> 
>    Thanks!
> 
>    -Shivaprasad
> 
> References
> 
>    Visible links
>    1. mailto:vaibhav@linux.ibm.com
>    2. mailto:ira.weiny@intel.com
