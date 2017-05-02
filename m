Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BCEE21951CB8
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 09:18:15 -0700 (PDT)
Subject: Re: [PATCH v4] ndctl: add clear error support for ndctl
References: <149368138628.53639.13278265267164943868.stgit@djiang5-desk3.ch.intel.com>
 <1493684163.30303.36.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <dc1d6252-9c8c-5298-2823-2609db70ceb6@intel.com>
Date: Tue, 2 May 2017 09:18:13 -0700
MIME-Version: 1.0
In-Reply-To: <1493684163.30303.36.camel@hpe.com>
Content-Language: en-US
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 05/01/2017 05:16 PM, Kani, Toshimitsu wrote:
> On Mon, 2017-05-01 at 16:33 -0700, Dave Jiang wrote:
>  :
>> +EXAMPLES
>> +--------
>> +
>> +Clear poison (bad blocks) for the provided device
>> +[verse]
>> +ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
>> +
>> +Clear poison (bad blocks) at block offset 0 for 8 blocks on device
>> /dev/dax0.0
>> +
>> +OPTIONS
>> +-------
>> +-f::
>> +--file::
>> +The device/file to be cleared of poison (bad blocks).
>> +
>> +-s::
>> +--start::
>> +The offset where the poison (bad block) starts for this
>> device.
>> +Typically this is acquired from the sysfs badblocks file.
>> +
>> +-l::
>> +--len::
>> +The number of badblocks to clear in size of 512 bytes
>> increments. The
>> +length must fit within the badblocks range. If the length
>> exceeds the
>> +badblock range or is 0, the command will fail.
> 
> Actually, I am seeing '-l 0' works just like '-l 1'.

Oh now I remembered that Vishal requested that no length does 1 block
clear. Do you want me to correct documentation or behavior?


> 
> Thanks,
> -Toshi
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
