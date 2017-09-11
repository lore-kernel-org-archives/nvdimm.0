Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x229.google.com (mail-io0-x229.google.com
 [IPv6:2607:f8b0:4001:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E216B21E87964
 for <linux-nvdimm@lists.01.org>; Sun, 10 Sep 2017 21:07:33 -0700 (PDT)
Received: by mail-io0-x229.google.com with SMTP id v36so5542307ioi.1
 for <linux-nvdimm@lists.01.org>; Sun, 10 Sep 2017 21:10:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170911113900.17E6.E1E9C6FF@jp.fujitsu.com>
References: <150490956040.8621.9918102309170733621.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170911112149.17E3.E1E9C6FF@jp.fujitsu.com>
 <20170911113900.17E6.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 10 Sep 2017 21:10:27 -0700
Message-ID: <CAPcyv4jPKNNYxipHgjTeFPyf6fGhdF2WEr0d5kQEJSYJ23xarA@mail.gmail.com>
Subject: Re: [PATCH ndctl] ndctl: sort by dimm's number when bad dimms are
 shown.
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Sep 10, 2017 at 7:39 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> > +
>> > +   if (!found)
>> > +           goto err_found;
>> > +
>> > +   for (i = 0; i < found; i++) {
>> > +           const char *devname = ndctl_dimm_get_devname(dimms[i]);
>> > +
>> > +           jobj = json_object_new_string(devname);
>> > +           if (!jobj)
>> > +                   break;
>> > +           json_object_array_add(jdimms, jobj);
>> > +   }
>>
>> I have one comment.
>>
>> If output is sorted by device number here,
>> it may be friendly for users.
>> (Especially, # of interleave way becomes huge in future...)
>>
>> Other things are looks good for me.
>
> I made a patch to make sorting.
> I hope it will help....
>
> -------
> To make user friendly, it is desirable that ndctl sorts by dimm's number,
> when output dimms which have badblocks.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
> ---
>  util/json.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/util/json.c b/util/json.c
> index 9b7773e..dac8692 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -366,6 +366,21 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
>         return NULL;
>  }
>
> +static int compare_dimm_number(const void *p1, const void *p2)
> +{
> +       struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
> +       struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
> +       const char *dimm1_name = ndctl_dimm_get_devname(dimm1);
> +       const char *dimm2_name = ndctl_dimm_get_devname(dimm2);
> +       int num1, num2;
> +
> +       sscanf(dimm1_name, "nmem%d", &num1);
> +       sscanf(dimm2_name, "nmem%d", &num2);
> +
> +       return num1 - num2;
> +
> +}
> +
>  static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
>                 unsigned long long addr, unsigned long len)
>  {
> @@ -399,6 +414,8 @@ static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
>         if (!found)
>                 goto err_found;
>
> +       qsort(dimms, found, sizeof(dimm), compare_dimm_number);
> +
>         for (i = 0; i < found; i++) {
>                 const char *devname = ndctl_dimm_get_devname(dimms[i]);

Looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
