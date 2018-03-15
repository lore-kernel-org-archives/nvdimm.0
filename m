Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5E3520954B86
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 10:45:24 -0700 (PDT)
Received: by mail-it0-x243.google.com with SMTP id d13-v6so10174041itf.0
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 10:51:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1OJqHEOgiHk1ZQytGW7b1c2Nam5xjSxxkfx=h2x7f_mg@mail.gmail.com>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-4-git-send-email-jix024@eng.ucsd.edu>
 <20180315045401.GB4860@magnolia>
 <CAD4SzjtHmBTisX6vQYuEnJf0fKsF==w5GHqsdks6xGv1go7Lzw@mail.gmail.com>
 <CAK8P3a1OJqHEOgiHk1ZQytGW7b1c2Nam5xjSxxkfx=h2x7f_mg@mail.gmail.com>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Thu, 15 Mar 2018 10:51:46 -0700
Message-ID: <CAD4Szjt6URWFEuB_qZcnoQMqCLNwyCns0CCP==Su7iQOt=ddMw@mail.gmail.com>
Subject: Re: [RFC v2 03/83] Add super.h.
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: coughlan@redhat.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andiry Xu <jix024@cs.ucsd.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, miklos@szeredi.hu, Jan Kara <jack@suse.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Steven Swanson <swanson@cs.ucsd.edu>, swhiteho@redhat.com, Jian Xu <andiry.xu@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 2:05 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Mar 15, 2018 at 7:11 AM, Andiry Xu <jix024@eng.ucsd.edu> wrote:
>> On Wed, Mar 14, 2018 at 9:54 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>>> On Sat, Mar 10, 2018 at 10:17:44AM -0800, Andiry Xu wrote:
>
>>>> +     /* s_mtime and s_wtime should be together and their order should not be
>>>> +      * changed. we use an 8 byte write to update both of them atomically
>>>> +      */
>>>> +     __le32          s_mtime;                /* mount time */
>>>> +     __le32          s_wtime;                /* write time */
>>>
>>> Hmmm, 32-bit timestamps?  2038 isn't that far away...
>>>
>>
>> I will try fixing this in the next version.
>
> I would also recommend adding nanosecond-resolution timestamps.
> In theory, a signed 64-bit nanosecond field is sufficient for each timestamp
> (it's good for several hundred years), but the more common format uses
> 64-bit seconds and 32-bit nanoseconds in other file systems.
>
> Unfortunately it looks, you will have to come up with a more sophisticated
> update method above, even if you leave out the nanoseconds, you can't
> easily rely on a 16-byte atomic update across architectures to deal with
> the two 64-bit timestamps. For the superblock fields, you might be able
> to get away with using second resolution, and then encoding the
> timestamps as a signed 64-bit 'mkfs time' along with two unsigned
> 32-bit times added on top, which gives you a range of 136 years mount
> a file system after its creation.
>

I will take a look at other file systems.

Superblock mtime is not a big problem as it is updated rarely. 64-bit
seconds and 32-bit nanoseconds make the inode and log entry bigger,
and updating file->atime cannot be done with a single 64bit update.
That may be annoying and needs to use journaling.

Thanks,
Andiry

>       Arnd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
