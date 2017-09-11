Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x230.google.com (mail-io0-x230.google.com
 [IPv6:2607:f8b0:4001:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6909621E87964
 for <linux-nvdimm@lists.01.org>; Sun, 10 Sep 2017 21:06:22 -0700 (PDT)
Received: by mail-io0-x230.google.com with SMTP id g32so881495ioj.2
 for <linux-nvdimm@lists.01.org>; Sun, 10 Sep 2017 21:09:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170911102055.17E0.E1E9C6FF@jp.fujitsu.com>
References: <150490955511.8621.11056333479696382004.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170911102055.17E0.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 10 Sep 2017 21:09:15 -0700
Message-ID: <CAPcyv4hAJgVW-zDSOt=vK8zXrOo3VT4-aeDMzLPsxUbV46Sifg@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: reduce indentation in
 util_region_badblocks_to_json / dev_badblocks_to_json
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

On Sun, Sep 10, 2017 at 6:20 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> Use a 'continue' to out-dent the badblock parsing code block.
>>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  util/json.c |  108 +++++++++++++++++++++++++++++++----------------------------
>>  1 file changed, 57 insertions(+), 51 deletions(-)
>>
>> diff --git a/util/json.c b/util/json.c
>> index 639f0ff043ca..1d1727c1c062 100644
>> --- a/util/json.c
>> +++ b/util/json.c
>> @@ -389,43 +389,46 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>>       }
>>
>>       ndctl_region_badblock_foreach(region, bb) {
>> -             if (flags & UTIL_JSON_MEDIA_ERRORS) {
>> -                     struct ndctl_dimm *dimm = NULL;
>> -                     unsigned long long spa;
>> +             struct ndctl_dimm *dimm;
>> +             unsigned long long addr;
>> +             const char *devname;
>>
>> -                     /* get start address of region */
>> -                     spa = ndctl_region_get_resource(region);
>> -                     if (spa == ULONG_MAX)
>> -                             goto err_array;
>> +             bbs += bb->len;
>>
>> -                     /* get address of bad block */
>> -                     spa += bb->offset << 9;
>> -                     dimm = badblock_to_dimm(region, spa);
>> +             if (!(flags & UTIL_JSON_MEDIA_ERRORS))
>> +                     continue;
>
>
>
> I suppose that there seems to be no need to output when UTIL_JSON_MEDIA_ERRORS
> is off at this function. So, it may be able to be checked at first
> rather than using continue.
>

We still need to calculate the total number of badblocks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
