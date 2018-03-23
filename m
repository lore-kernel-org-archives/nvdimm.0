Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22b.google.com (mail-io0-x22b.google.com
 [IPv6:2607:f8b0:4001:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 003D6225E4006
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 17:24:42 -0700 (PDT)
Received: by mail-io0-x22b.google.com with SMTP id d5so13151420iob.9
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 17:31:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322150037.GD6955@twin.jikos.cz>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
 <20180322150037.GD6955@twin.jikos.cz>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Thu, 22 Mar 2018 17:31:13 -0700
Message-ID: <CAD4Szjsg5_-Jy=1RQMFHHwYA9-uHu4SSDLYF8Q-GtcTWOAx3GA@mail.gmail.com>
Subject: Re: [RFC v2 83/83] Sysfs support.
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
To: dsterba@suse.cz, Andiry Xu <jix024@eng.ucsd.edu>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dan Williams <dan.j.williams@intel.com>, "Rudoff, Andy" <andy.rudoff@intel.com>, coughlan@redhat.com, Steven Swanson <swanson@cs.ucsd.edu>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, swhiteho@redhat.com, miklos@szeredi.hu, Jian Xu <andiry.xu@gmail.com>, Andiry Xu <jix024@cs.ucsd.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 22, 2018 at 8:00 AM, David Sterba <dsterba@suse.cz> wrote:
> On Sat, Mar 10, 2018 at 10:19:04AM -0800, Andiry Xu wrote:
>> From: Andiry Xu <jix024@cs.ucsd.edu>
>>
>> Sysfs support allows user to get/post information of running NOVA instance.
>> After mount, NOVA creates four entries under proc directory
>> /proc/fs/nova/pmem#/:
>>
>> timing_stats  IO_stats        allocator       gc
>>
>> Show NOVA file operation timing statistics:
>> cat /proc/fs/NOVA/pmem#/timing_stats
>>
>> Clear timing statistics:
>> echo 1 > /proc/fs/NOVA/pmem#/timing_stats
>>
>> Show NOVA I/O statistics:
>> cat /proc/fs/NOVA/pmem#/IO_stats
>>
>> Clear I/O statistics:
>> echo 1 > /proc/fs/NOVA/pmem#/IO_stats
>>
>> Show NOVA allocator information:
>> cat /proc/fs/NOVA/pmem#/allocator
>>
>> Manual garbage collection:
>> echo #inode_number > /proc/fs/NOVA/pmem#/gc
>
> IIRC no new entries should be added to /proc, /sys is supposed to be
> used. I can't find it documented though, so you'd better check with
> sysfs people.

Thanks. I will try to switch to sysfs.

Thanks,
Andiry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
