Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x242.google.com (mail-wm0-x242.google.com
 [IPv6:2a00:1450:400c:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FC2421AEB0A3
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 10:06:21 -0700 (PDT)
Received: by mail-wm0-x242.google.com with SMTP id x64so12024287wmg.1
 for <linux-nvdimm@lists.01.org>; Sun, 13 Aug 2017 10:08:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170813092556.GA19019@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
 <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
 <20170813092556.GA19019@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 13 Aug 2017 10:08:41 -0700
Message-ID: <CAA9_cmd=fVP5n=Z=QThZEbCnWptNv2Amv6W7ujGG+O7VtXPs6g@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 13, 2017 at 2:25 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Aug 12, 2017 at 07:44:14PM -0700, Dan Williams wrote:
>> How about MAP_SYNC == (MAP_SHARED|MAP_PRIVATE)? On older kernels that
>> should get -EINVAL, and on new kernels it means SYNC+SHARED.
>
> Cute trick, but I'd hate to waster it just for our little flag.
>
> How about:
>
> #define __MAP_VALIDATE          MAP_SHARED|MAP_PRIVATE
> #define MAP_SYNC                0x??? | __MAP_VALIDATE
>
> so that we can reuse that trick for any new flag?

Yes, even better. I think that effectively kicks the need for mmap3()
down the road a bit.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
