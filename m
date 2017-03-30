Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A183721DFA7B0
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 08:20:54 -0700 (PDT)
Subject: Re: [PATCH v2] libndctl: add support for the MSFT family of DSM
 functions
References: <20170326201753.1522-1-lijunpan2000@gmail.com>
 <CAPcyv4g623k8L11ong4yccSmFFPmtKyieFSdKS0n3KGqGkYRYw@mail.gmail.com>
 <30a1d53a6012419a8ed812f01f33d1c1@AUSX13MPS325.AMER.DELL.COM>
 <DF4PR84MB016996D9258AF7CE65F58455AB350@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <3b15ec3e-2dd8-40a6-0c43-5e6ec0e31b54@hpe.com>
Date: Thu, 30 Mar 2017 11:20:46 -0400
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB016996D9258AF7CE65F58455AB350@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Lijun.Pan@dell.com" <Lijun.Pan@dell.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "lijunpan2000@gmail.com" <lijunpan2000@gmail.com>
Cc: "Stuart.Hayes@dell.com" <Stuart.Hayes@dell.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 3/29/2017 6:26 PM, Elliott, Robert (Persistent Memory) wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
>> Of Lijun.Pan@dell.com
>> Sent: Wednesday, March 29, 2017 4:41 PM
>> To: dan.j.williams@intel.com; lijunpan2000@gmail.com
>> Subject: RE: [PATCH v2] libndctl: add support for the MSFT family of DSM
>> functions
>
>>> -----Original Message-----
>>> From: Dan Williams [mailto:dan.j.williams@intel.com]
>
>>>> From: Lijun Pan <Lijun.Pan@dell.com>
>>>>
>>>> This patch retrieves the health data from NVDIMM-N via
>>>> the MSFT _DSM function[1], following JESD245A[2] standards.
>>>> Now 'ndctl list --dimms --health --idle' could work
>>>> on MSFT type NVDIMM-N, but limited to health_state,
>>>> temperature_celsius, and life_used_percentage.
>>>
> ...
>> Output is something like,
>>
>>   "health":{
>>     "health_state":"ok",
>>     "temperature_celsius":193.750000,
>>     "life_used_percentage":1
>>   }
>>
>> If the BIOS returns a value say 45.75, how can it be represented in (__u16)
>> instead of using a 'double' type? I think the ((__u16) temp & 0x0FFC) already
>> represents a temperature in 1/16 Celsius granularity. No need to multiple it
>> by
>> 16 again.
>>
>> Below I quote the section 7.8 of JESD245.pdf
>> Bit 3 has a resolution of  1/2 Celsius,
>> Bit 2 has a resolution of 1/4 Celsius,
>> Bit 1 has 1/8 Celsius, but is reserved, so I assume it be zero,
>> Bit 0 has 1/16 Celsius, but is reserved, so I assume it be zero.
>>
>> ((__u16) temp & 0x0FFC) will only get the bit11 - bit 0. This presents the
>> 1/16 Celsius resolution, kind of left shifted 4 bits.
>> So we don't need to do
>> 'return CMD_MSFT_SMART(cmd)->temp * 16;' again.
>>
>> ==== = quotation starts  =====
>> "
>> Temperature measurement shall have a minimum resolution of 0.25 Celsius.
>> Registers containing measured temperature value shall be 16-bits and report
>> temperature as a 10-bit value based on the following definition.
>>
>> Table 3: Temperature value bit definition
>> Bit15	Bit14	Bit13	Bit12	Bit11	Bit10	Bit9	Bit8
>> Reserved	Reserved	Reserved	Reserved	128	64
>> 	32	16
>> Bit7	Bit6	Bit5	Bit4	Bit3	Bit2	Bit1	Bit0
>> 8	4	2	1	0.5	0.25	Reserved	Reserved
>>
>> Examples:
>>
>> A temperature value of 10.5 Celsius is represented as 0000000010101000b.
>>
>> A temperature value of 64.75 Celsius is represented as 0000010000001100b.
>> "
>>
>> ==== quotation ends ========
>>
>>
>> Lijun
>>
>>
>>> ...so users know what to expect. With that change and addressing
>>> Linda's comment about the temperature multiplier I think we're good to
>>> go.
>>>
>
> You should plan to support temperatures compliant with JESD21C
> Page 4.1.6-2 (TSE2004 SPD EEPROM with Temperature Sensor), which include:
> * a sign bit to support negative temperatures (in bit 12)
> * 0.125 and 0.0625 degrees C precision (i.e., bits 1 and 0 are defined)
>
> Industrial Grade and Automotive Grade components operate down to
> -40 degrees C, so negative values will be required.
>
> The importance of extra precision is a but fuzzy given that sensor
> accuracy varies from +/- 1 to +/- 3 degrees C (depending on the
> temperature range).  A software API should pass along all the
> available information, though.

Interesting, but until someone changes their DSM spec, none of that matters.
This patch is supposed to be implementing the MSFT DSM spec.

-- ljk
>
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
