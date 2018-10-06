Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A45E22116324B
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 18:17:41 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id u74-v6so11805161oia.11
 for <linux-nvdimm@lists.01.org>; Fri, 05 Oct 2018 18:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142010.GB4963@linux-x5ow.site> <20181002144547.GA26735@infradead.org>
 <20181002150123.GD4963@linux-x5ow.site> <20181002150634.GA22209@infradead.org>
 <20181004100949.GF6682@linux-x5ow.site> <20181005062524.GA30582@infradead.org>
 <20181005063519.GA5491@linux-x5ow.site>
In-Reply-To: <20181005063519.GA5491@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 Oct 2018 18:17:29 -0700
Message-ID: <CAPcyv4jD4VgRaKDQF9eMmjhMEHjUJqRU8i6OC+-=0domCc9u3A@mail.gmail.com>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
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
Cc: Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 4, 2018 at 11:35 PM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> On Thu, Oct 04, 2018 at 11:25:24PM -0700, Christoph Hellwig wrote:
> > Since when is an article on some website a promise (of what exactly)
> > by linux kernel developers?
>
> Let's stop it here, this doesn't make any sort of forward progress.
>

I do think there is some progress we can make if we separate DAX as an
access mechanism vs DAX as a resource utilization contract. My attempt
at representing Christoph's position is that the kernel should not be
advertising / making access mechanism guarantees. That makes sense.
Even with MAP_SYNC+DAX the kernel reserves the right to write-protect
mappings at will and trap access into a kernel handler. Additionally,
whether read(2) / write(2) does anything different behind the scenes
in DAX mode, or not should be irrelevant to the application.

That said what is certainly not irrelevant is a kernel giving
userspace visibility and control into resource utilization. Jan's
MADV_DIRECT_ACCESS let's the application make assumptions about page
cache utilization, we just need to another mechanism to read if a
mapping is effectively already in that state.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
