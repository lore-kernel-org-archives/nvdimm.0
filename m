Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E88C2239364B
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 16:51:46 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id 24so9050142oij.3
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 16:57:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180201004938.19823-1-vishal.l.verma@intel.com>
References: <20180201004938.19823-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 31 Jan 2018 16:57:21 -0800
Message-ID: <CAPcyv4g7iHrrpDNShfRY-NT-C+487SomsY9iwTWkQ8-VJOATfw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: remove a double put in injection status json
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 31, 2018 at 4:49 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> newer json-c catches a double put of the json object in printing the
> injection status. We only need to put the containing jobj.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/inject-error.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
> index 374ae0b..9b9d821 100644
> --- a/ndctl/inject-error.c
> +++ b/ndctl/inject-error.c
> @@ -263,8 +263,6 @@ static int injection_status(struct ndctl_namespace *ndns)
>                 printf("%s\n", json_object_to_json_string_ext(jobj,
>                         JSON_C_TO_STRING_PRETTY));
>         }
> -
> -       json_object_put(jbbs);
>         json_object_put(jobj);

Yeah, once you link an object to a container you only need to put that
parent object. Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
