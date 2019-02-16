Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131])
 by ml01.01.org (Postfix) with ESMTP id 5790F208D615D
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 21:31:36 -0800 (PST)
Date: Sat, 16 Feb 2019 16:31:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
Message-ID: <20190216053133.GT20493@dastard>
References: <20190215095710.GA12279@linux-x5ow.site>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190215095710.GA12279@linux-x5ow.site>
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
Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, hare@suse.de, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
> (This is a joint proposal with Hannes Reinecke)
> 
> Servers with NV-DIMM are slowly emerging in data centers but one key feature
> for reliability of these systems hasn't been addressed up to now, data
> redundancy.
> 
> While it would be best to solve this issue in the memory controller of the CPU
> itself, I don't see this coming in the next few years. This puts us as the OS
> in the burden to create the redundant copies of data for the users.
> 
> If we leave of the DAX support Linux' software RAID implementations (MD,
> device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> are incompatible with DAX.
> 
> In this session Hannes and I would like to discuss eventual ways how we as an
> operating system can mitigate these issues for our users.

We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
allow per-device dax status checking for filesystems"). That is,
we can have DAX on the XFS RT device indepently of the data device.

That is, you set up pmem in three segments - two small identical
segments start get mirrored with RAID1 as the data device, and
the remainder as a block device that is dax capable set up as the
XFS realtime device. Set the RTINHERIT bit on the root directory at
mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
capable realtime device, and all the metadata goes to the software
raided pmem block devices that aren't DAX capable.

Problem already solved, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
