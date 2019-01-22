Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 22 Jan 2019 08:46:47 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH] libnvdimm: Clarify nd_pfn_init() flow
Message-ID: <20190122004647.GA6575@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190122002615.GB5855@richard>
 <CAPcyv4jXS-doCdyTrcV3DL63N-q4m1H2=Msgm1z88HnF8bcEig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jXS-doCdyTrcV3DL63N-q4m1H2=Msgm1z88HnF8bcEig@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 04:29:08PM -0800, Dan Williams wrote:
>On Mon, Jan 21, 2019 at 4:26 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>[..]
>> >@@ -706,6 +711,22 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>> >               sig = DAX_SIG;
>> >       else
>> >               sig = PFN_SIG;
>> >+
>> >+      /*
>> >+       * Check for an existing 'pfn' superblock before writing a new
>> >+       * one. The intended flow is that on the first probe of an
>> >+       * nd_{pfn,dax} device the superblock is calculated and written
>> >+       * to the namespace. In this case nd_pfn_validate() returns
>> >+       * -ENODEV because no valid superblock exists currently.
>>
>> As you replied in following mail:
>>
>> 3/ If present, nd_pfn_validate() returns 0 and nd_dax_probe()
>> registers the dax0.1 device (this is a libnvdimm 'personality device).
>>
>> So at this point, nd_pfn_validate() return 0 or -ENODEV?
>
>In this case 0, because the configuration was successfully validated.
>
>-ENODEV, is only returned for the initial case where we want the
>kernel to write the configuration.
>
>All other error codes are an actual failure and the probe procedure stops.

To be honest, this maybe crystal clear for you. But I still feel a little
confused. Especially on differentiating those cases. How many cases we have? 

And what's your first probe mean? This the nd_btt/pfn/dax_probe()? or the
linux driver probe?

-- 
Wei Yang
Help you, Help me
