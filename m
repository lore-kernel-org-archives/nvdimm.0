Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id D017021B00DC1
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 20:40:18 -0800 (PST)
Subject: Re: [xfsprogs PATCH 2/2] xfs_io: add a new 'log_writes' command
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-3-ross.zwisler@linux.intel.com>
 <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
 <20171117204801.GA16597@linux.intel.com>
 <960d0051-d357-033a-0ab7-9eb99d8e63fa@sandeen.net>
 <20171117211434.GB16597@linux.intel.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fda7a7d9-0709-74be-666d-49e5cf295faa@sandeen.net>
Date: Fri, 17 Nov 2017 22:44:27 -0600
MIME-Version: 1.0
In-Reply-To: <20171117211434.GB16597@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 11/17/17 3:14 PM, Ross Zwisler wrote:
> On Fri, Nov 17, 2017 at 03:03:39PM -0600, Eric Sandeen wrote:
>> On 11/17/17 2:48 PM, Ross Zwisler wrote:
>>> On Fri, Nov 17, 2017 at 02:39:07PM -0600, Eric Sandeen wrote:
>>>> On 11/17/17 2:25 PM, Ross Zwisler wrote:
>>>>> Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
>>>>> log marks via the external 'dmsetup' executable.  It's helpful to allow
>>>>> users of xfs_io to adds these marks from within xfs_io instead of waiting
>>>>> until after xfs_io exits because then they are able to replay the
>>>>> dm-log-writes log up to immediately after another xfs_io operation such as
>>>>> mwrite.  This isolates the log replay from other operations that happen as
>>>>> part of xfs_io exiting (file handles being closed, mmaps being torn down,
>>>>> etc.).  This also allows users to insert multiple marks between different
>>>>> xfs_io commands.
>>>>>
>>>>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>>>> Suggested-by: Dave Chinner <david@fromorbit.com>
>>>>
>>>> Without reviewing in detail, what is the advantage of wrapping dmsetup
>>>> into xfs_io?  My first inclination is that there is none at all, and
>>>> xfstests can call dmsetup as easily as they can call xfs_io.  No?
>>>>
>>>> -Eric
>>>
>>> I commented on this a bit in the changelog for the 2nd patch:
>>>
>>> It's helpful to allow users of xfs_io to adds these marks from within xfs_io
>>> instead of waiting until after xfs_io exits because then they are able to
>>> replay the dm-log-writes log up to immediately after another xfs_io operation
>>> such as mwrite.  This isolates the log replay from other operations that
>>> happen as part of xfs_io exiting (file handles being closed, mmaps being torn
>>> down, etc.).  This also allows users to insert multiple marks between
>>> different xfs_io commands.
>>>
>>> I agree that the shell-out to dmsetup isn't awesome...  For the current test I
>>> have written I think we can get away with just assuming that the xfs_io exit
>>> stuff won't interact too heavily with the dm-log-writes log, and we could
>>> potentially move the dmsetup call back into the fstest.  This is how I
>>> initially had it, and moved it into the C program via shell-out in response to
>>> Amir's feedback:
>>
>> Sorry, terrible of me to not have read that.  :(  Ok, so next question - 
>> DM_TARGET_MSG seems to be public, can we just invoke the ioctl directly
>> instead of shelling out to dmsetup?
>>
>> I'm checking w/ the dm folks too, to make sure that's expected to work.  As
>> long as the use isn't too tricky it seems like that might be better.
> 
> Yea, that seems like a better option - I'll take a look.  Thanks for the
> suggestion.

FWIW, agk is saying the only right way to do it is to use libdevicemapper ...
sounds like they don't expect anyone to use the ioctl directly, though I'm
not sure why, or what the complexity is.

-Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
