Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7CAE021CC5353
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 06:29:34 -0700 (PDT)
Subject: Re: [RFC/PATCH] ndctl list should show more hardware information
References: <595D2B03.6010408@hpe.com>
 <CAPcyv4hKFLE3FTnPXCvMRhaM_H05x_4d33V0Z6uZy9AJXQRsZw@mail.gmail.com>
 <20170706131301.4A07.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4gNnuUugTotxtiHmv49MtVbmRD3V2nrHYf+S-egE9R1dQ@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <dfdbac16-ebe6-5c5d-9558-b4295c453bc2@hpe.com>
Date: Thu, 6 Jul 2017 09:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gNnuUugTotxtiHmv49MtVbmRD3V2nrHYf+S-egE9R1dQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 7/6/2017 1:41 AM, Dan Williams wrote:
> On Wed, Jul 5, 2017 at 9:13 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> [..]
>>> Yes, that would be great. Last I checked the "json-c" library that
>>> ndctl is using did not support this, but I don't think anything
>>> prevents json-c from growing this support. I.e. as far as I know it
>>> supports hex numbers for input, so I think it is valid json either
>>> way.
>>
>> Sorry, maybe I could not follow here. Please let me confirm.
>> In conclusion, json_object_new_int() should be used at here?
>>
>
> Yes.
>
>> Since I tried to output hex values for user to compare with dmidecode's output easily,
>> I translated to hex strings at here.
>> But, I should json_object_new_int() in conclusion, and should expect that json-c
>> library will be able to output hex value in future?
>
> I checked, it seems hex output is not valid json. However, I think
> what I will do is add a "--hex" option to "ndctl list" that will make
> util_display_json_array() manually print the json output object and
> convert all integers to hex in the process. While that option will
> make the output not machine readable by standards compliant json
> parsers it will make it easier for humans to read in some cases.

Will that convert all integers to hex if that option is used?  Some values
are more useful as decimal and some are more useful as hex.  In this case
where the value is never really useful as decimal, I thought the original
code did pretty well.  I'd prefer that to yet another option.

-- ljk


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
