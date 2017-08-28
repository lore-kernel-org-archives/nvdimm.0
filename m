Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE8E421DF809A
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 13:47:54 -0700 (PDT)
Date: Mon, 28 Aug 2017 14:50:33 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] libnvdimm: clean up command definitions
Message-ID: <20170828205033.GA6859@anatevka.americas.hpqcorp.net>
References: <150393513271.10003.253995897844648312.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150393513271.10003.253995897844648312.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


On Mon, Aug 28, 2017 at 08:45:32AM -0700, Dan Williams wrote:
> Remove the command payloads that do not have an associated libnvdimm
> ioctl. I.e. remove the payloads that would only ever be carried in the
> ND_CMD_CALL envelope. This prevents userspace from growing unnecessary
> dependencies on this kernel header when userspace already has everything
> it needs to craft and send these commands.

Userspace needs to include linux/ndctl.h to make the call as
that is where nd_cmd_pkg is defined.

So you want to have some structures defined in ndctl.h and other
defined in the to be created libndctl-nfit.h?  Plus a third header
file for the HPE non-root calls?

Will libndctl-nfit.h be generally available and installed?
Will it be clean so that other applications can use it to get these
definitions?  Or will it be loaded w/ a bunch of stuff only useful
to your ndctl command?


> 
> Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
> Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/uapi/linux/ndctl.h |   37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
> index 6d3c54264d8e..3f03567631cb 100644
> --- a/include/uapi/linux/ndctl.h
> +++ b/include/uapi/linux/ndctl.h
> @@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
>  	__u64 cleared;
>  } __packed;
>  
> -struct nd_cmd_trans_spa {
> -	__u64 spa;
> -	__u32 status;
> -	__u8  flags;
> -	__u8  _reserved[3];
> -	__u64 trans_length;
> -	__u32 num_nvdimms;
> -	struct nd_nvdimm_device {
> -		__u32 nfit_device_handle;
> -		__u32 _reserved;
> -		__u64 dpa;
> -	} __packed devices[0];
> -
> -} __packed;
> -
> -struct nd_cmd_ars_err_inj {
> -	__u64 err_inj_spa_range_base;
> -	__u64 err_inj_spa_range_length;
> -	__u8  err_inj_options;
> -	__u32 status;
> -} __packed;
> -
> -struct nd_cmd_ars_err_inj_clr {
> -	__u64 err_inj_clr_spa_range_base;
> -	__u64 err_inj_clr_spa_range_length;
> -	__u32 status;
> -} __packed;
> -
> -struct nd_cmd_ars_err_inj_stat {
> -	__u32 status;
> -	__u32 inj_err_rec_count;
> -	struct nd_error_stat_query_record {
> -		__u64 err_inj_stat_spa_range_base;
> -		__u64 err_inj_stat_spa_range_length;
> -	} __packed record[0];
> -} __packed;
> -
>  enum {
>  	ND_CMD_IMPLEMENTED = 0,
>  

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
