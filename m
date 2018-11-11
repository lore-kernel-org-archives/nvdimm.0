Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D2CE21184AC9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Nov 2018 17:41:13 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id w25so4296021otm.13
 for <linux-nvdimm@lists.01.org>; Sat, 10 Nov 2018 17:41:13 -0800 (PST)
MIME-Version: 1.0
References: <CALn6vpGtzt6KMRr1qnxB6xVzmBQT4VPoJQ7rm85thbrsJYP0Hw@mail.gmail.com>
In-Reply-To: <CALn6vpGtzt6KMRr1qnxB6xVzmBQT4VPoJQ7rm85thbrsJYP0Hw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Nov 2018 17:41:01 -0800
Message-ID: <CAPcyv4gZ++1-+eocFTVpst=ynXA7q37w8-eF3Q5x_psBeT1R=g@mail.gmail.com>
Subject: Re: [Question] About atomic operations on nvdimm in Linux kernel
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
To: shfy1014@gmail.com
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 6, 2018 at 5:54 AM Fumiya Shigemitsu <shfy1014@gmail.com> wrote:
>
> Hi all,
>
> I have a question about atomic operations on nvdimm in Linux kernel.
>
> We can use atomic operations in Linux kernel such as atomic_read(),
> atomic_write() ...etc., but they don't handle the differences of
> endianness. From my understanding, we should pay attention to them when
> storing data to persistent disk. (e.g. metadata in filesystem such as ext4)
>
> Maybe I can handle this problem by read/write lock, spinlock...etc.
> However, atomic_* operations are useful, so I think that they should be in
> Linux kernel for nvdimm. I suppose that this implementation is not
> difficult, but there is no version of it as far as I know.
>
> They are not just implemented or is there a reason that we don't need
> them?

As far as I can see we don't need them. The "on-disk" format of
filesystem metadata is host-endian independent, Current filesystems
don't use atomic-ops for metadata manipulation since they expect to
submit block-layer requests for metadata I/O.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
