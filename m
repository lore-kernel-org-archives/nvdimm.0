Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A762211E9588
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 14:49:56 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 3/5] ndctl/dimm: Add offset and size options to
 {read, write, zero}-labels
Date: Fri, 22 Mar 2019 21:49:53 +0000
Message-ID: <32fe21cd06ec2e1a3add9235511e6ac536efcda9.camel@intel.com>
References: <155183603979.191625.11689546261255336448.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155183605525.191625.7383205178321396418.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155183605525.191625.7383205178321396418.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <3D2044CCB761044CA75D400E9FDA7172@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-03-05 at 17:34 -0800, Dan Williams wrote:
> Allow for more precision in label utilities, i.e. stop operating over
> the entire label area.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/ndctl/labels-options.txt |    9 ++++++
>  ndctl/dimm.c                           |   45 ++++++++++++++++++++++++--------
>  ndctl/lib/dimm.c                       |   36 +++++++++++++++++++++-----
>  ndctl/lib/libndctl.sym                 |    2 +
>  ndctl/lib/private.h                    |    3 --
>  ndctl/libndctl.h                       |    4 +++
>  util/util.h                            |    4 +++
>  7 files changed, 83 insertions(+), 20 deletions(-)
> 

[..]

> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index 5a17f0b63b80..1304017d5e3b 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -241,9 +241,6 @@ struct ndctl_namespace {
>   *
>   * A command may only specify one of @source, or @iter.total_buf, not both.
>   */
> -enum {
> -	READ, WRITE,
> -};

This fails to build as libndctl.c now needs to include util/util.h..
Stale version perhaps? (Patch 4 in the series also fails to apply
cleanly)

>  struct ndctl_cmd {
>  	struct ndctl_dimm *dimm;
>  	struct ndctl_bus *bus;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 8aa4b8bbe6c2..c9d0dc120d3b 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -307,8 +307,12 @@ struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_size(struct ndctl_dimm *dimm);
>  struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_read(struct ndctl_cmd *cfg_size);
>  struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_write(struct ndctl_cmd *cfg_read);
>  int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm);
> +int ndctl_dimm_zero_label_extent(struct ndctl_dimm *dimm,
> +		unsigned int len, unsigned int offset);
>  struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm);
>  struct ndctl_cmd *ndctl_dimm_read_label_index(struct ndctl_dimm *dimm);
> +struct ndctl_cmd *ndctl_dimm_read_label_extent(struct ndctl_dimm *dimm,
> +		unsigned int len, unsigned int offset);
>  int ndctl_dimm_validate_labels(struct ndctl_dimm *dimm);
>  enum ndctl_namespace_version {
>  	NDCTL_NS_VERSION_1_1,
> diff --git a/util/util.h b/util/util.h
> index 001707e8b159..54c6ef18b6d7 100644
> --- a/util/util.h
> +++ b/util/util.h
> @@ -73,6 +73,10 @@
>  #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>  
> +enum {
> +	READ, WRITE,
> +};
> +
>  static inline const char *skip_prefix(const char *str, const char *prefix)
>  {
>          size_t len = strlen(prefix);
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
