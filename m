Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com
 [IPv6:2607:f8b0:4864:20::32e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E14462112FACC
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 18:52:17 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id j9-v6so3988772otl.2
 for <linux-nvdimm@lists.01.org>; Tue, 02 Oct 2018 18:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20181002033140.21295-1-vishal.l.verma@intel.com>
 <20181002033140.21295-4-vishal.l.verma@intel.com>
In-Reply-To: <20181002033140.21295-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Oct 2018 18:52:06 -0700
Message-ID: <CAPcyv4jymeoY0ZVgF5OH06+ZEesnzjVJPxN=zffcBFRt+OT3yA@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/5] util/json: consolidate check for the
 UTIL_JSON_MEDIA_ERRORS flag
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
To: Vishal L Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 1, 2018 at 8:38 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> We don't need to check for the above flag for each badblock we're
> iterating over. Remove the check in the respective loops, and return
> early if it is not set.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  util/json.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/util/json.c b/util/json.c
> index 30b56c3..4dd5fc3 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -457,7 +457,8 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>                 jbbs = json_object_new_array();
>                 if (!jbbs)
>                         return NULL;
> -       }
> +       } else
> +               return NULL;
>
>         ndctl_region_badblock_foreach(region, bb) {
>                 struct json_object *jdimms;
> @@ -465,9 +466,6 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>
>                 bbs += bb->len;
>
> -               if (!(flags & UTIL_JSON_MEDIA_ERRORS))
> -                       continue;
> -

The reason for this awkwardness is to account for the total badblocks
count even when the individual badblocks are not emitted. See that
"bbs += bb->len" that will now be skipped. Perhaps at least a comment
is needed because that trickery is not obvious.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
