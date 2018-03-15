Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22c.google.com (mail-it0-x22c.google.com
 [IPv6:2607:f8b0:4001:c0b::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A65ED2202E49E
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 23:01:27 -0700 (PDT)
Received: by mail-it0-x22c.google.com with SMTP id e195-v6so2900523ita.5
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 23:07:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d5d16cfa-dbd2-b874-38e4-cbb9d7d783ff@infradead.org>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
 <d5d16cfa-dbd2-b874-38e4-cbb9d7d783ff@infradead.org>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Wed, 14 Mar 2018 23:07:49 -0700
Message-ID: <CAD4SzjtM_q13FaqdjH9bgUCGJ0viYg5TN_8CTa72aHfJe8o0gA@mail.gmail.com>
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
To: Randy Dunlap <rdunlap@infradead.org>
Cc: coughlan@redhat.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andiry Xu <jix024@cs.ucsd.edu>, miklos@szeredi.hu, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, jack@suse.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Steven Swanson <swanson@cs.ucsd.edu>, swhiteho@redhat.com, Jian Xu <andiry.xu@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 14, 2018 at 5:33 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 03/10/2018 10:19 AM, Andiry Xu wrote:
>> Sysfs support allows user to get/post information of running NOVA instance.
>> After mount, NOVA creates four entries under proc directory
>> /proc/fs/nova/pmem#/:
>>
>> timing_stats  IO_stats        allocator       gc
>
> Hi,
>
> This is all procfs, not sysfs, so the name is (or can be) confusing.
>
> Please change it.
>

Thanks, will fix.

Andiry

> --
> ~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
