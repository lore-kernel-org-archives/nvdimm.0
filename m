Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B47672194EB77
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 18:15:39 -0800 (PST)
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard> <20190216053957.GU20493@dastard>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <d7037b76-8bbe-412d-387a-4e27db26b005@oracle.com>
Date: Mon, 18 Feb 2019 18:15:34 -0800
MIME-Version: 1.0
In-Reply-To: <20190216053957.GU20493@dastard>
Content-Language: en-US
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
To: Dave Chinner <david@fromorbit.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, hare@suse.de, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 2/15/2019 9:39 PM, Dave Chinner wrote:

> On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
>> On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
>>> (This is a joint proposal with Hannes Reinecke)
>>>
>>> Servers with NV-DIMM are slowly emerging in data centers but one key feature
>>> for reliability of these systems hasn't been addressed up to now, data
>>> redundancy.
>>>
>>> While it would be best to solve this issue in the memory controller of the CPU
>>> itself, I don't see this coming in the next few years. This puts us as the OS
>>> in the burden to create the redundant copies of data for the users.
>>>
>>> If we leave of the DAX support Linux' software RAID implementations (MD,
>>> device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
>>> are incompatible with DAX.
>>>
>>> In this session Hannes and I would like to discuss eventual ways how we as an
>>> operating system can mitigate these issues for our users.
>> We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
>> allow per-device dax status checking for filesystems"). That is,
>> we can have DAX on the XFS RT device indepently of the data device.
>>
>> That is, you set up pmem in three segments - two small identical
>> segments start get mirrored with RAID1 as the data device, and
>> the remainder as a block device that is dax capable set up as the
>> XFS realtime device. Set the RTINHERIT bit on the root directory at
>> mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
>> capable realtime device, and all the metadata goes to the software
>> raided pmem block devices that aren't DAX capable.
>>
>> Problem already solved, yes?
> Sorry, this was meant to be a reply to Dan's email commenting about
> some people needing mirrored metadata, not the parent that was
> talking about whole device RAID...
>
> i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> problem...

What about DAX Ext4 filesystem? What could be done for the EXT4
filesystem metadata?

thanks,
-jane

>
> Cheers,
>
> Dave.
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
