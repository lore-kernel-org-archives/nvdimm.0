Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22c.google.com (mail-yb0-x22c.google.com
 [IPv6:2607:f8b0:4002:c09::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC53421CB57B3
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 22:40:17 -0700 (PDT)
Received: by mail-yb0-x22c.google.com with SMTP id e201so2808975ybb.1
 for <linux-nvdimm@lists.01.org>; Wed, 05 Jul 2017 22:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170706131301.4A07.E1E9C6FF@jp.fujitsu.com>
References: <595D2B03.6010408@hpe.com>
 <CAPcyv4hKFLE3FTnPXCvMRhaM_H05x_4d33V0Z6uZy9AJXQRsZw@mail.gmail.com>
 <20170706131301.4A07.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jul 2017 22:41:56 -0700
Message-ID: <CAPcyv4gNnuUugTotxtiHmv49MtVbmRD3V2nrHYf+S-egE9R1dQ@mail.gmail.com>
Subject: Re: [RFC/PATCH] ndctl list should show more hardware information
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
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 5, 2017 at 9:13 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
[..]
>> Yes, that would be great. Last I checked the "json-c" library that
>> ndctl is using did not support this, but I don't think anything
>> prevents json-c from growing this support. I.e. as far as I know it
>> supports hex numbers for input, so I think it is valid json either
>> way.
>
> Sorry, maybe I could not follow here. Please let me confirm.
> In conclusion, json_object_new_int() should be used at here?
>

Yes.

> Since I tried to output hex values for user to compare with dmidecode's output easily,
> I translated to hex strings at here.
> But, I should json_object_new_int() in conclusion, and should expect that json-c
> library will be able to output hex value in future?

I checked, it seems hex output is not valid json. However, I think
what I will do is add a "--hex" option to "ndctl list" that will make
util_display_json_array() manually print the json output object and
convert all integers to hex in the process. While that option will
make the output not machine readable by standards compliant json
parsers it will make it easier for humans to read in some cases.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
