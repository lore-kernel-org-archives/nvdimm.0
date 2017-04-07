Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6983121A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 16:51:16 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id g204so29015751oib.1
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 16:51:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1491586851.9118.33.camel@hpe.com>
References: <149151227310.16957.8527168777601554707.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1491586851.9118.33.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Apr 2017 16:51:15 -0700
Message-ID: <CAPcyv4iB1Tzy7ate_-a3UEkH+8T3tgm6F_wrLim9drADjHkOww@mail.gmail.com>
Subject: Re: [PATCH] x86,
 pmem: fix broken __copy_user_nocache cache-bypass assumptions
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 7, 2017 at 10:41 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Thu, 2017-04-06 at 13:59 -0700, Dan Williams wrote:
>> Before we rework the "pmem api" to stop abusing __copy_user_nocache()
>> for memcpy_to_pmem() we need to fix cases where we may strand dirty
>> data in the cpu cache. The problem occurs when copy_from_iter_pmem()
>> is used for arbitrary data transfers from userspace. There is no
>> guarantee that these transfers, performed by dax_iomap_actor(), will
>> have aligned destinations or aligned transfer lengths. Backstop the
>> usage __copy_user_nocache() with explicit cache management in these
>> unaligned cases.
>>
>> Yes, copy_from_iter_pmem() is now too big for an inline, but
>> addressing that is saved for a later patch that moves the entirety of
>> the "pmem api" into the pmem driver directly.
>
> The change looks good to me.  Should we also avoid cache flushing in
> the case of size=4B & dest aligned by 4B?

Yes, since you fixed the 4B aligned case we should skip cache flushing
in that case. I'll send a v2.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
