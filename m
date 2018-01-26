Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D30F42222C22B
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jan 2018 12:55:03 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id t78so1185152oih.4
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jan 2018 13:00:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180126205449.28693-1-ross.zwisler@linux.intel.com>
References: <20180125232638.6585-2-ross.zwisler@linux.intel.com>
 <20180126205449.28693-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 13:00:32 -0800
Message-ID: <CAPcyv4j32EVw94JMsou0GgX=t-OWrNwQ=_qvpmUaVs2hy6D6aQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 2/2] ndctl: add sector_size to 'ndctl list' output
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 26, 2018 at 12:54 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> It used to be that the only PMEM namespaces with a variable sector size
> were ones with a BTT, but that has changed.  sector_size still doesn't make
> sense for device DAX since we don't have a block I/O path.
>
> If we don't have a specified sector size, as happens with namespaces of
> devtype nd_namespace_io and older v1.1 namespace labels, we will display
> the default sector size of 512.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  util/json.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/util/json.c b/util/json.c
> index 95beaa2..647bf03 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -718,11 +718,6 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>                         goto err;
>                 json_object_object_add(jndns, "uuid", jobj);
>
> -               jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
> -               if (!jobj)
> -                       goto err;
> -               json_object_object_add(jndns, "sector_size", jobj);
> -
>                 bdev = ndctl_btt_get_block_device(btt);
>         } else if (pfn) {
>                 ndctl_pfn_get_uuid(pfn, uuid);
> @@ -774,6 +769,24 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>         } else
>                 bdev = ndctl_namespace_get_block_device(ndns);
>
> +       jobj = NULL;
> +       if (btt) {
> +               jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
> +               if (!jobj)
> +                       goto err;
> +       } else if (!dax) {
> +               unsigned int sector_size = ndctl_namespace_get_sector_size(ndns);
> +

I'd put a comment here that says on kernel's that do not export a
sector_size attribute, or if userspace fails to select a dynamic
sector_size, the kernel default size is 512.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
