Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x242.google.com (mail-qk0-x242.google.com
 [IPv6:2607:f8b0:400d:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A623721E2DA67
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 22:20:43 -0700 (PDT)
Received: by mail-qk0-x242.google.com with SMTP id d21so1099825qke.3
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 22:23:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g-bk2ppR2HM85=rmCHB1TaZ4FL2oLMNgKsv56HWDE6Gg@mail.gmail.com>
References: <150251474784.11236.9077158081550562491.stgit@dwillia2-desk3.amr.corp.intel.com>
 <201708151333.nLya1R9C%fengguang.wu@intel.com>
 <CAOSf1CGa3BBmDZ5KjsK0fsT8e7uN10oTSqKNyognAe+8hSDKVQ@mail.gmail.com>
 <CAPcyv4g-bk2ppR2HM85=rmCHB1TaZ4FL2oLMNgKsv56HWDE6Gg@mail.gmail.com>
From: Oliver <oohall@gmail.com>
Date: Wed, 16 Aug 2017 15:23:08 +1000
Message-ID: <CAOSf1CEBYYNTPffkzCbBZvTPXBw=GQjd4hMC4HGeN=48S_Vqcw@mail.gmail.com>
Subject: Re: [PATCH 2/3] libnvdimm, pfn, dax: show supported dax/pfn region
 alignments in sysfs
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, kbuild test robot <lkp@intel.com>, kbuild-all@01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 16, 2017 at 1:47 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Aug 14, 2017 at 11:46 PM, Oliver <oohall@gmail.com> wrote:
>> On Tue, Aug 15, 2017 at 4:02 PM, kbuild test robot <lkp@intel.com> wrote:
> [..]
>>>    114  static const unsigned long *nd_pfn_supported_alignments(void)
>>>    115  {
>>>    116          /*
>>>    117           * This needs to be a local variable because the *_SIZE macros
>>>    118           * aren't always constants.
>>>    119           */
>>
>> I probably should have been clearer, "local" here really means
>> "non-static". Otherwise the array could have been made a global.
>>
>
> Whoops, my fault. How about this:
>
> @@ -127,8 +127,11 @@ static const unsigned long
> *nd_pfn_supported_alignments(void)
>  #endif
>                 0,
>         };
> +       static unsigned long data[ARRAY_SIZE(supported_alignments)];
>
> -       return supported_alignments;
> +       memcpy(data, supported_alignments, sizeof(data));
> +
> +       return data;
>  }

That should do the trick, but you'll need to fix up the source array
declaration too.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
