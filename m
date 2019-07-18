Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89CAC212B9A98
 for <linux-nvdimm@lists.01.org>; Thu, 18 Jul 2019 16:43:50 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id s184so22911544oie.9
 for <linux-nvdimm@lists.01.org>; Thu, 18 Jul 2019 16:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190717225400.9494-1-vishal.l.verma@intel.com>
 <20190717225400.9494-6-vishal.l.verma@intel.com>
In-Reply-To: <20190717225400.9494-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Jul 2019 16:41:11 -0700
Message-ID: <CAPcyv4jeVMQP8QAtiQt81n1+jS7J49L8Ki_GDtT6rXFmaxMogQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v6 05/13] daxctl/list: add target_node for device
 listings
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 17, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The kernel provides a 'target_node' attribute for dax devices. When
> converting a dax device to the system-ram mode, the memory is hotplugged
> into this numa node. It would be helpful to print this in device
> listings so that it is easy for applications to detect the node to
> which the new memory belongs.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  util/json.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/util/json.c b/util/json.c
> index babdc8c..f521337 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -271,6 +271,7 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
>  {
>         const char *devname = daxctl_dev_get_devname(dev);
>         struct json_object *jdev, *jobj;
> +       int node;
>
>         jdev = json_object_new_object();
>         if (!devname || !jdev)
> @@ -284,6 +285,13 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
>         if (jobj)
>                 json_object_object_add(jdev, "size", jobj);
>
> +       node = daxctl_dev_get_target_node(dev);
> +       if (node >= 0) {
> +               jobj = json_object_new_int(node);
> +               if (jobj)
> +                       json_object_object_add(jdev, "target_node", jobj);
> +       }
> +

We moved 'numa_node' to the UTIL_JSON_VERBOSE set on "ndctl list"
should do the same for target node?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
