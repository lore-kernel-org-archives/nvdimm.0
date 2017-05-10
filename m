Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6A9421A18AAB
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 15:33:37 -0700 (PDT)
Date: Wed, 10 May 2017 16:32:15 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 1/2] ndctl: add foreach helper for region badblocks in
 libndctl
Message-ID: <20170510223214.GC11414@omniknight.lm.intel.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/10, Dave Jiang wrote:
> The helper function allow iteration through the badblocks file that's part
> of the region sysfs attributes. This will support the region list badblocks
> code that's coming.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> v2: added cleanup of opened badblocks file from Dan's comments.
> v3: fixed inconsistent return code from Andy Rudoff's comments.
> 
>  ndctl/lib/libndctl.c   |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    2 +
>  ndctl/libndctl.h.in    |   10 ++++++
>  3 files changed, 86 insertions(+)
> 
[...]
> +
> +NDCTL_EXPORT struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region)
> +{
> +	int rc;
> +	char *buf = NULL;
> +	size_t rlen = 0;
> +
> +	if (!region->badblocks)
> +		return NULL;
> +
> +	rc = getline(&buf, &rlen, region->badblocks);
> +	if (rc == -1) {
> +		free(buf);
> +		return NULL;
> +	}
> +
> +	rc = sscanf(buf, "%llu %u", &region->bb.offset, &region->bb.len);
> +	free(buf);
> +	if (rc != 2) {
> +		/* end of the road, clean up */

Quick nit - "end of road" doesn't make sense any more as this isn't
reached for EOF

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
