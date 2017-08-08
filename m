Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x232.google.com (mail-vk0-x232.google.com
 [IPv6:2607:f8b0:400c:c05::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 539A621DF9673
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 17:21:53 -0700 (PDT)
Received: by mail-vk0-x232.google.com with SMTP id r199so7548155vke.4
 for <linux-nvdimm@lists.01.org>; Mon, 07 Aug 2017 17:24:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801112603.GG4215@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Aug 2017 17:24:08 -0700
Message-ID: <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
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
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 1, 2017 at 4:26 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 01-08-17 04:02:41, Christoph Hellwig wrote:
>> On Fri, Jul 28, 2017 at 11:38:21AM +0200, Jan Kara wrote:
>> > Well, you are right I can make the implementation work with struct file
>> > flag as well - let's call it O_DAXDSYNC. However there are filesystem
>> > operations where you may need to answer question: Is there any fd with
>> > O_DAXDSYNC open against this inode (for operations that change file offset
>> > -> block mapping)? And in that case inode flag is straightforward while
>> > file flag is a bit awkward (you need to implement counter of fd's with that
>> > flag in the inode).
>>
>> We can still keep and inode flag as the internal implementation
>> detail.  As mentioned earlier the right flag to control behavior
>> of a mapping is an mmap flag.  And the initial naive implementation
>> would simply mark the inode as sync once the first MAP_SYNC open happens
>> on it.  We could then move to more precise tracking if/when needed.
>
> OK, makes sense and I like the MAP_SYNC proposal. I'll change it in my
> implementation.

Does sys_mmap() reject unknown flag values today? I'm either not
looking in the right place or it's missing and we'll need some
interface/mechanism to check if MAP_SYNC is honored.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
