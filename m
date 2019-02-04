Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B302821B02822
 for <linux-nvdimm@lists.01.org>; Mon,  4 Feb 2019 00:06:45 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id a11so11514339otr.10
 for <linux-nvdimm@lists.01.org>; Mon, 04 Feb 2019 00:06:45 -0800 (PST)
MIME-Version: 1.0
References: <20190204075023.GA15322@stefanha-x1.localdomain>
In-Reply-To: <20190204075023.GA15322@stefanha-x1.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Feb 2019 00:06:32 -0800
Message-ID: <CAPcyv4huSKQueADyF5wJPWxMdLAn6yvEqWyMZfWPVQ4vQ_X0RA@mail.gmail.com>
Subject: Re: Querying the size of devdax devices from userspace
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Feb 3, 2019 at 11:56 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> How can userspace applications query the size of devdax character
> devices?
>
> stat(1) doesn't know how large the device is:
>
>   # stat /dev/dax0.0
>     File: /dev/dax0.0
>     Size: 0             Blocks: 0          IO Block: 4096   character special file
>   Device: 6h/6d Inode: 56764       Links: 1     Device type: fa,d
>
> ndctl(1) finds out by digging in /sys:
>
>   # ndctl list
>   [
>     {
>       "dev":"namespace0.0",
>       "mode":"devdax",
>       "map":"dev",
>       "size":2111832064,
>       "uuid":"235acf4d-503f-46be-bf64-f26faf9777ef",
>       "chardev":"dax0.0"
>     }
>   ]
>
> I'm not sure how to do it without enumerating all nvdimms in /sys.  Is
> there a mapping from devdax major/minor number to a /sys path?
>
> The use case I have in mind is that QEMU currently takes the size as a
> command-line parameter.  The failure mode is ugly when users get this
> value wrong: the guest gets a softlockup and there is no error message
> on the host side.
>
> I'd like QEMU to detect the size or at least reject size values that are
> too large.  In order to do that userspace needs a convenient way of
> querying the size.  Any ideas?

You're looking for /sys/dev/char. That will wake you from major:minor
to sysfs. Perhaps borrow fio's implementation for the same:

   http://git.kernel.dk/cgit/fio/tree/engines/dev-dax.c#n258
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
