Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BA2A2128D6AB
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 20:22:36 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id i4so476349oih.4
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 20:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-6-vishal.l.verma@intel.com>
In-Reply-To: <20190528222440.30392-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 May 2019 20:22:24 -0700
Message-ID: <CAPcyv4hW-Gj5y+btKEsb1wOsKxd64hWY00NRDmeis3ZrkRo_pA@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 05/10] daxctl/list: add numa_node for device
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

On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The kernel provides a 'target_node' attribute for dax devices. When
> converting a dax device to the system-ram mode, the memory is hotplugged
> into this numa node. It would be helpful to print this in device
> listings so that it is easy for applications to detect the numa node to
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
> index babdc8c..b7ce719 100644
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
> +                       json_object_object_add(jdev, "numa_node", jobj);

I think this should be named 'target_node' to not be confused with the
typical 'numa_node' attribute of a device that indicates closest cpu
node. This also collides with the 'numa_node' attribute that is
already emitted at the namespace level.

  {
    "dev":"namespace1.0",
    "mode":"devdax",
    "map":"dev",
    "size":134232408064,
    "uuid":"e6613922-80e9-49f9-ace8-961def867d32",
    "raw_uuid":"b79ce059-e33d-4a90-90ec-06d6786b3644",
    "daxregion":{
      "id":1,
      "size":134232408064,
      "align":2097152,
      "devices":[
        {
          "chardev":"dax1.0",
          "size":134232408064
        }
      ]
    },
    "align":2097152,
    "numa_node":0
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
