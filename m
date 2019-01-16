Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6137211AF9E8
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 12:19:58 -0800 (PST)
Subject: Re: ndctl v64 stage tree -- Re: [PATCH v7 00/12] ndctl: add security
 support
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
 <5b9f677a-2a6b-f999-ff3e-7a8ec8938868@oracle.com>
 <3412a217ab51c55878362f28e40ed058c69148a8.camel@intel.com>
 <b5e2bc32-127f-50c0-2728-ec81a9a47413@oracle.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <3798b7c9-396b-f2a2-4ed6-7624a54ff508@intel.com>
Date: Wed, 16 Jan 2019 13:19:57 -0700
MIME-Version: 1.0
In-Reply-To: <b5e2bc32-127f-50c0-2728-ec81a9a47413@oracle.com>
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
To: Jane Chu <jane.chu@oracle.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 1/16/19 11:02 AM, Jane Chu wrote:
> Hi, Vishal,
> 
> On 1/11/2019 3:36 PM, Verma, Vishal L wrote:
>> On Fri, 2019-01-11 at 15:18 -0800, Jane Chu wrote:
>>> Hi, Dave,
>>>
>>> Where is your ndctl git tree that might clone from to test the
>>> security features?
>> Hi Jane,
>>
>> I pushed out a for-v64-security branch with this (v7) series:
>>
>> https://github.com/pmem/ndctl/tree/for-v64-security
>>
>> I believe Dave plans to have v8 out early next week with a few changes,
>> most notably the loadkeys script becomes a first class ndctl command.
> 
> Just thought I might get a quick answer here although I haven't 
> gone thru all my homework.
> 
> I'm seeing "FAIL: security.sh" from "make KVER=5.0.0 check" on a NVDIMM system,
> the security.sh.log indicates
> 
> + '[' '!' -f /usr/bin/keyctl ']'
> + '[' '!' -d /etc/ndctl/keys ']'
> + echo '/etc/ndctl/keys directory does not exist.'
> /etc/ndctl/keys directory does not exist.
> + exit 1
> 
> Indeed, what step did I miss?

Jane,
For now just go ahead and create the /etc/ndctl/keys directory to try
the test. Also, we discovered that the security test needs to be run as
a root user or sudo -i, just sudo will not do due to not having access
to the root user key ring. As Vishal said there's an update coming which
addresses several issues we found in the script.

> 
> Thanks!
> -jane
> 
>> 	-Vishal
>>
>>> Thanks!
>>> -jane
>>>
>>> On 1/9/2019 9:53 AM, Dave Jiang wrote:
>>>> The following series implements mechanisms that utilize the sysfs
>>>> knobs
>>>> provided by the kernel in order to support the Intel DSM v1.8 spec
>>>> that provides security to NVDIMM. The following abilities are
>>>> added:
>>>> 1. display security state
>>>> 2. enable/update passphrase
>>>> 3. disable passphrase
>>>> 4. freeze security
>>>> 5. secure erase
>>>> 6. overwrite
>>>> 7. master passphrase enable/update
>>>>
>>> _______________________________________________
>>> Linux-nvdimm mailing list
>>> Linux-nvdimm@lists.01.org
>>> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
