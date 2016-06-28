From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] dm: update table type check for dax
Date: Tue, 28 Jun 2016 16:07:15 -0400
Message-ID: <20160628200714.GC8300@redhat.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
 <1467142636-21094-2-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467142636-21094-2-git-send-email-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 28 2016 at  3:37pm -0400,
Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> Allow table type DM_TYPE_BIO_BASED to extend with
> DM_TYPE_DAX_BIO_BASED since DM_TYPE_DAX_BIO_BASED
> supports bio-based requests.
> 
> Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/md/dm-ioctl.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index b59e3459..0f32791 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1267,6 +1267,15 @@ static int populate_table(struct dm_table *table,
>  	return dm_table_complete(table);
>  }
>  
> +static bool is_valid_type(unsigned cur, unsigned new)
> +{
> +	if (cur == new ||
> +	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
> +		return true;
> +
> +	return false;
> +}
> +
>  static int table_load(struct dm_ioctl *param, size_t param_size)
>  {
>  	int r;
> @@ -1309,7 +1318,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
>  			DMWARN("unable to set up device queue for new table.");
>  			goto err_unlock_md_type;
>  		}
> -	} else if (dm_get_md_type(md) != dm_table_get_type(t)) {
> +	} else if (!is_valid_type(dm_get_md_type(md), dm_table_get_type(t))) {
>  		DMWARN("can't change device type after initial table load.");
>  		r = -EINVAL;
>  		goto err_unlock_md_type;
> 

You said in the 0th header: "Patch 1 solves an error when lvremove is
made to a snapshot device."

I'm not seeing why this patch 1 fixes anything specific to snapshot
device removal (but I can see why patch 2 makes snapshot creation
"work").  I'll apply your 2nd patch and see if I can see what you mean.

I actually see this error, without either of your 2 proposed patches
applied, when I try to create a snapshot of a DAX capable LV:

# lvcreate -s -n snap -L 100M pmem/lv
  device-mapper: reload ioctl on (253:7) failed: Invalid argument
  Failed to lock logical volume pmem/lv.
  Aborting. Manual intervention required.
Jun 28 15:57:28 rhel-storage-02 kernel: device-mapper: ioctl: can't change device type after initial table load.
