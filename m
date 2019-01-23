Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E511120985998
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 11:32:19 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 1/6] libndctl: Use the supported_alignment attribute
Date: Wed, 23 Jan 2019 19:32:18 +0000
Message-ID: <eb998c851c5c4d4805bf1f527c805877fc8448fc.camel@intel.com>
References: <20190116094909.23112-1-oohall@gmail.com>
In-Reply-To: <20190116094909.23112-1-oohall@gmail.com>
Content-Language: en-US
Content-ID: <638CBE9DB43B3F4F8FDCEBBAD6DAC425@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "oohall@gmail.com" <oohall@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-01-16 at 20:49 +1100, Oliver O'Halloran wrote:
> Newer kernels provide the "supported_alignments" sysfs attribute that
> indicates what alignments can be used with a PFN or DAX namespace. This
> patch adds the plumbing inside of libndctl to allow users to query this
> information through using:
> 	ndctl_{dax|pfn}_get_supported_alignment(), and
> 	ndctl_{dax|pfn}_get_num_alignments()
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> v3: Changed the return type of the *_get_supported_alignment() functions
>     to unsigned long to match the existing *_get_alignment() functions.
> ---
>  ndctl/lib/libndctl.c   | 40 ++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |  7 +++++++
>  ndctl/libndctl.h       |  6 ++++++
>  3 files changed, 53 insertions(+)

Hi Oliver,

Thanks for resubmitting this series. I had a few comments below:

> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 0c3a35e5bcc9..53369b5c9886 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -31,6 +31,7 @@
>  #include <ccan/build_assert/build_assert.h>
>  
>  #include <ndctl.h>
> +#include <util/size.h>
>  #include <util/sysfs.h>
>  #include <ndctl/libndctl.h>
>  #include <ndctl/namespace.h>
> @@ -237,6 +238,7 @@ struct ndctl_pfn {
>  	int buf_len;
>  	uuid_t uuid;
>  	int id, generation;
> +	struct ndctl_lbasize alignments;
>  };
>  
>  struct ndctl_dax {
> @@ -4781,6 +4783,18 @@ static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
>  	else
>  		pfn->size = strtoull(buf, NULL, 0);
>  
> +	/*
> +	 * If the kernel doesn't provide the supported_alignments sysfs
> +	 * attribute then it's safe to assume that we are running on x86
> +	 * which will always support 2MB and 4KB alignments.
> +	 */
> +	sprintf(path, "%s/supported_alignments", pfn_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		sprintf(buf, "%d %d", SZ_4K, SZ_2M);
> +
> +	if (parse_lbasize_supported(ctx, pfn_base, buf, &pfn->alignments) < 0)
> +		goto err_read;
> +
>  	free(path);
>  	return pfn;
>  
> @@ -5015,6 +5029,22 @@ NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
>  	return 0;
>  }
>  
> +NDCTL_EXPORT int ndctl_pfn_get_num_alignments(struct ndctl_pfn *pfn)
> +{
> +	return pfn->alignments.num;
> +}
> +
> +NDCTL_EXPORT unsigned long ndctl_pfn_get_supported_alignment(struct ndctl_pfn *pfn, int i)

This and a few other spots exceed 80 char lines, could you fix that up
all over?

> +{
> +	if (pfn->alignments.num == 0)
> +		return 0;
> +
> +	if (i < 0 || i > pfn->alignments.num)
> +		return -1;

A bare '-1' return is unusual for exported functions. The convention in
libndctl is to return -ERRNO. In this case, -EINVAL seems the right
error to return?

> +	else
> +		return pfn->alignments.supported[i];
> +}
> +
>  NDCTL_EXPORT int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn,
>  		struct ndctl_namespace *ndns)
>  {
> @@ -5237,6 +5267,16 @@ NDCTL_EXPORT unsigned long ndctl_dax_get_align(struct ndctl_dax *dax)
>  	return ndctl_pfn_get_align(&dax->pfn);
>  }
>  
> +NDCTL_EXPORT int ndctl_dax_get_num_alignments(struct ndctl_dax *dax)
> +{
> +	return ndctl_pfn_get_num_alignments(&dax->pfn);
> +}
> +
> +NDCTL_EXPORT unsigned long ndctl_dax_get_supported_alignment(struct ndctl_dax *dax, int i)

Another > 80 char line.

> +{
> +	return ndctl_pfn_get_supported_alignment(&dax->pfn, i);
> +}
> +
>  NDCTL_EXPORT int ndctl_dax_has_align(struct ndctl_dax *dax)
>  {
>  	return ndctl_pfn_has_align(&dax->pfn);
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 6c4c8b4dfb8e..0103c1b71a1d 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -385,3 +385,10 @@ global:
>  	ndctl_namespace_get_next_badblock;
>  	ndctl_dimm_get_dirty_shutdown;
>  } LIBNDCTL_17;
> +
> +LIBNDCTL_19 {
> +	ndctl_pfn_get_supported_alignment;
> +	ndctl_pfn_get_num_alignments;
> +	ndctl_dax_get_supported_alignment;
> +	ndctl_dax_get_num_alignments;
> +} LIBNDCTL_18;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 62cef9e82da3..0f1f66256c1d 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -681,6 +681,12 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
>  struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
>  int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
>  
> +int ndctl_pfn_get_num_alignments(struct ndctl_pfn *pfn);
> +unsigned long ndctl_pfn_get_supported_alignment(struct ndctl_pfn *pfn, int i);
> +
> +int ndctl_dax_get_num_alignments(struct ndctl_dax *dax);
> +unsigned long ndctl_dax_get_supported_alignment(struct ndctl_dax *dax, int i);

For the libndctl.h definitions, instead of appending these at the
bottom, can you group the ndctl_pfn_ additions with the remaining
ndctl_pfn_ ones in the file? And same for ndctl_dax_*

> +
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
