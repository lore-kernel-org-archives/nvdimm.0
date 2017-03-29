Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FEFA2041D9E0
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 08:29:18 -0700 (PDT)
Message-ID: <58DBD2C2.8080308@hpe.com>
Date: Wed, 29 Mar 2017 11:29:06 -0400
From: Linda Knippers <linda.knippers@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] libndctl: add support for the MSFT family of DSM
 functions
References: <20170326201753.1522-1-lijunpan2000@gmail.com>
 <58DADD44.1040403@hpe.com>
 <069a8e4a1714414892bbece91a5d387d@AUSX13MPS325.AMER.DELL.COM>
In-Reply-To: <069a8e4a1714414892bbece91a5d387d@AUSX13MPS325.AMER.DELL.COM>
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
To: Lijun_Pan@Dell.com, lijunpan2000@gmail.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/29/2017 11:08 AM, Lijun_Pan@Dell.com wrote:
<snip>

>>> +static unsigned int msft_cmd_smart_get_temperature(struct ndctl_cmd
>> *cmd)
>>> +{
>>> +	if (msft_smart_valid(cmd) < 0)
>>> +		return UINT_MAX;
>>> +	/*
>>> +	 * refer to JESD245 spec section 7.8 to calculate the temperature
>>> +	 * then convert to 1/16 Celsius granularity.
>>> +	 */
>>
>> I'm confused by this comment because the Microsoft DSM spec says this
>> value
>> is in degrees C.  Regardless of what the JEDAC spec says, wouldn't the
>> platform FW convert to degrees C?  And then this function needs to convert
>> to 1/16th of a degree?
> 
> MSFT DSM function 11 has a field called "Module Current Temperature".

When I look here:
https://msdn.microsoft.com/en-us/library/windows/hardware/mt604717
at the definition of function 11, it says that Module Current Temperature
 is 2 bytes at offset 6 and that the value is "The module temperature
in degrees Celsius. The minimum value is 0".

> JESD245.pdf section 7.8 p. 29 table 3 explains the bit definition.
> Bit 3 to bit 0 is 1/2 1/4 (1/8) (1/16) granularity.
> &0FFC will get it correctly.

That might be what the BIOS had to get from the device, but the BIOS
should then be converting it to what the DSM says it returns.

And since the rest of ndctl expects temperatures in 16ths of a degree C,
your function here will need to multiply the value from the DSM by 16.

> No negative temperature is defined.
>  
> Lijun
> 
>>
>>> +	return CMD_MSFT_SMART(cmd)->temp & 0x0FFC;

return CMD_MSFT_SMART(cmd)->temp * 16;

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
