Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4D202111FE45
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 12:06:06 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c190-v6so42283462oig.6
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 12:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180724072937.GD28386@dhcp22.suse.cz>
References: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAGM2rea9AwQGaf1JiV_SDDKTKyP_n+dG9Z20gtTZEkuZPFnXFQ@mail.gmail.com>
 <CAPcyv4jo91jKjwn-M7cOhG=6vJ3c-QCyp0W+T+CtmiKGyZP1ng@mail.gmail.com>
 <CAGM2reacO1HF91yH8OR5w5AdZwPgwfSFfjDNBsHbP66v1rEg=g@mail.gmail.com>
 <20180717155006.GL7193@dhcp22.suse.cz>
 <CAA9_cmez_vrjBYvcpXT_5ziQ2CqRFzPbEWMO2kdmjW0rWhkaCA@mail.gmail.com>
 <20180718120529.GY7193@dhcp22.suse.cz>
 <3f43729d-fd4e-a488-e04d-026ef5a28dd9@intel.com>
 <20180723110928.GC31229@dhcp22.suse.cz>
 <510a1213-e391-bad6-4239-60fa477aaac0@intel.com>
 <20180724072937.GD28386@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Sep 2018 12:06:04 -0700
Message-ID: <CAPcyv4hZUgoMvUTcQLVQWvpvHnJYoPaet4b2VE-qPLtUPDgSaQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] mm: Asynchronous + multithreaded memmap init for
 ZONE_DEVICE
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Rich Felker <dalias@libc.org>, Jan Kara <jack@suse.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, the arch/x86 maintainers <x86@kernel.org>, Pavel Tatashin <pasha.tatashin@oracle.com>, Matthew Wilcox <willy@infradead.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, Ingo Molnar <mingo@redhat.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Jerome Glisse <jglisse@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding Alex ]

On Tue, Jul 24, 2018 at 12:29 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 23-07-18 09:15:32, Dave Hansen wrote:
>> On 07/23/2018 04:09 AM, Michal Hocko wrote:
>> > On Thu 19-07-18 11:41:10, Dave Hansen wrote:
>> >> Are you looking for the actual end-user reports?  This was more of a
>> >> case of the customer plugging in some persistent memory DIMMs, noticing
>> >> the boot delta and calling the folks who sold them the DIMMs (Intel).
>> > But this doesn't sound like something to rush a solution for in the
>> > upcoming merge windown, does it?
>>
>> No, we should not rush it.  We'll try to rework it properly.
>
> Thanks a lot Dave! I definitely do not mean to block this at all. I just
> really do not like to have the code even more cluttered than we have
> now.

Hi Michal,

I'm back from vacation. I owe you an apology I was entirely too
prickly on this thread, and the vacation cool-off-time was much
needed.

I come back to see that Alex has found a trove of low hanging fruit to
speed up ZONE_DEVICE init and ditch most of the complication I was
pushing. I'll let him chime in on the direction he wants to take this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
