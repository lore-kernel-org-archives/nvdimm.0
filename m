Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22f.google.com (mail-yb0-x22f.google.com
 [IPv6:2607:f8b0:4002:c09::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47A7E21B02B9C
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:21:38 -0700 (PDT)
Received: by mail-yb0-x22f.google.com with SMTP id v197so6958901ybv.3
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:23:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a412d42be4d552c5da7ef90e035ef7610778fecc.1498754314.git.jerry.hoemann@hpe.com>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
 <a412d42be4d552c5da7ef90e035ef7610778fecc.1498754314.git.jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 14:23:10 -0700
Message-ID: <CAPcyv4h2=x6MgFcOZj_p-2WanOBw1vZO7C8hWbX10_y+t_ywxw@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] libnvdimm: Add bus level dsm mask.
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 9:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Add a bus level dsm_mask to nvdimm_bus_descriptor to allow the passthru
> calling mechanism to specify a different mask from the cmd_mask.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  include/linux/libnvdimm.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 6c80701..f8b8f43 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -54,6 +54,7 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
>
>  struct nvdimm_bus_descriptor {
>         const struct attribute_group **attr_groups;
> +       unsigned long bus_dsm_mask;
>         unsigned long cmd_mask;
>         struct module *module;
>         char *provider_name;
> --
> 1.8.5.6
>

This patch can be squashed with the next one, it's ok to touch
drivers/acpi and drivers/nvdimm in the same patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
