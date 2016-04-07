Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x230.google.com (mail-ob0-x230.google.com
 [IPv6:2607:f8b0:4003:c01::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 316831A1F2D
 for <linux-nvdimm@lists.01.org>; Thu,  7 Apr 2016 06:16:12 -0700 (PDT)
Received: by mail-ob0-x230.google.com with SMTP id j9so52318280obd.3
 for <linux-nvdimm@lists.01.org>; Thu, 07 Apr 2016 06:16:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1502009.VVHIfC1a8J@c203>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
 <20160407010720.30641.60021.stgit@dwillia2-desk3.jf.intel.com>
 <1502009.VVHIfC1a8J@c203>
Date: Thu, 7 Apr 2016 06:16:11 -0700
Message-ID: <CAPcyv4j9OVmbfShcwvqndhUA1wdZK+soDut6rT3xfPXv7-Q1Vw@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/5] ndctl, list: add a '--health' option
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 7, 2016 at 1:41 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Mittwoch, 6. April 2016 18:07:20 CEST Dan Williams wrote:
>> Dump dimm smart data in the dimm listing when '--health' is specified.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>
> [...]
>
>> @@ -200,6 +201,7 @@ int cmd_list(int argc, const char **argv)
>>                               "filter by region-type"),
>>               OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
>>               OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
>> +             OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
>>               OPT_BOOLEAN('R', "regions", &list.regions,
>>                               "include region info"),
>>               OPT_BOOLEAN('N', "namespaces", &list.namespaces,
>> @@ -299,6 +301,15 @@ int cmd_list(int argc, const char **argv)
>>                               continue;
>>                       }
>>
>> +                     if (list.health) {
>> +                             struct json_object *jhealth;
>> +
>> +                             jhealth = util_dimm_health_to_json(dimm);
>> +                             if (jhealth)
>> +                                     json_object_object_add(jdimm, "health",
>> +                                                     jhealth);
>
> Maybe some sort of error message for the else path? Either here or in
> util_dimm_health_to_json()?

Yeah, I wasn't sure how to differentiate "dimm does not support smart"
vs "dimm smart data retrieval failed" in this routine.  However,
you're right a debug message at a minimum is needed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
