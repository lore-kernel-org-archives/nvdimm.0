From: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] common/rc: add _require_scratch_dax
Date: Thu, 19 Jan 2017 12:17:00 +0800
Message-ID: <20170119041700.GR1859@eguan.usersys.redhat.com>
References: <1484708826-23529-1-git-send-email-xzhou@redhat.com>
 <1484708826-23529-2-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484708826-23529-2-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Jan 18, 2017 at 11:07:03AM +0800, Xiong Zhou wrote:
> To make sure we can test DAX feature on SCRATCH_DEV.
> 
> Signed-off-by: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  common/rc | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 892c46e..ea7956b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2632,6 +2632,16 @@ _require_scratch_shutdown()
>  	_scratch_unmount
>  }
>  
> +# Does dax mount option work on this dev/fs?
> +_require_scratch_dax()
> +{
> +	_scratch_unmount

Use _require_scratch instead of _scratch_unmount here. _require_scratch
ensures we have SCRATCH_DEV defined and unmounts it if it's mounted.

Thanks,
Eryu

> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount -o dax || \
> +		_notrun "$SCRATCH_DEV $FSTYP does not support -o dax"
> +	_scratch_unmount
> +}
> +
>  # Does norecovery support by this fs?
>  _require_norecovery()
>  {
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
