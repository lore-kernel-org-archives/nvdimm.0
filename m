Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95E0A2195406F
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 10:27:31 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id y11so72199708oie.0
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 10:27:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170421071219.18744-3-oohall@gmail.com>
References: <20170421071219.18744-1-oohall@gmail.com>
 <20170421071219.18744-3-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Apr 2017 10:27:30 -0700
Message-ID: <CAPcyv4jPzOQhkJxtxWdx5ZMX+YL9DZ75XxwVR0=itckYeTgM4w@mail.gmail.com>
Subject: Re: [PATCH 3/3] ndctl: print alignment of dax namespaces
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 21, 2017 at 12:12 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> Print the alignment for dax namespaces creation. It's good to be explicit about
> it since about the selected region alignment dictates the type of faults
> we allow on the namespace.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  util/json.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/util/json.c b/util/json.c
> index d6a8d4c899ed..720d22559df0 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -299,6 +299,11 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>                 if (!jobj)
>                         goto err;
>                 json_object_object_add(jndns, "uuid", jobj);
> +               jobj = json_object_new_int64(ndctl_dax_get_align(dax));
> +               if (!jobj)
> +                       goto err;
> +               json_object_object_add(jndns, "align", jobj);
> +

Yes, we need this, but lets hide this attribute when the 'align' is
zero. That helps with ndctl running on older kernels that do not have
an align attribute available.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
