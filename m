Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x235.google.com (mail-it0-x235.google.com
 [IPv6:2607:f8b0:4001:c0b::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F6CE21A6F108
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 17:41:29 -0700 (PDT)
Received: by mail-it0-x235.google.com with SMTP id 70so9505071ita.0
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 17:41:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424230738.GA11734@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
 <20170420132632.GD2311@x1>
 <CAJcbSZEOOZZnuD3nftkzpcthGdT-6f6DDZ=VtdBKuHbC+0LdFw@mail.gmail.com>
 <CAPcyv4gzdwDmtxoz7O5=1zGow+6zx2YqQqjRu1=kBX087MLx2Q@mail.gmail.com>
 <20170424230738.GA11734@x1>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 24 Apr 2017 17:41:27 -0700
Message-ID: <CAJcbSZEWB27HHtP6zVQA+qJJ7uvWqZz+Y-kYFE0aTM2-jj72iQ@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
To: Baoquan He <bhe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 24, 2017 at 4:07 PM, Baoquan He <bhe@redhat.com> wrote:
> Yeah, according to my debugging tracking, it goes as Dan said. And the
> is_ram is REGION_DISJOINT. And till arch_add_memory, the parameters
> passed to arch_add_memory are "arch_add_memory, align_start:0x10000000000, align_size:0x3000000000",
> seems it's going well.

Hum ok, I hope it was another path given it seems the page table is
correctly setup on this one.

Maybe looking at the PTEs with and without crash might help? (setting
this if statement to 1:
http://lxr.free-electrons.com/source/arch/x86/mm/init_64.c#L360)

Thanks Baoquan,

-- 
Thomas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
