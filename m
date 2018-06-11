Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5B7B2116372C
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 08:19:55 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id l22-v6so18223747oib.4
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 08:19:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180611145636.GP13364@dhcp22.suse.cz>
References: <20180604124031.GP19202@dhcp22.suse.cz>
 <CAPcyv4gLxz7Ke6ApXoATDN31PSGwTgNRLTX-u1dtT3d+6jmzjw@mail.gmail.com>
 <20180605141104.GF19202@dhcp22.suse.cz>
 <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
 <20180606073910.GB32433@dhcp22.suse.cz>
 <CAPcyv4hA2Na7wyuyLZSWG5s_4+pEv6aMApk23d2iO1vhFx92XQ@mail.gmail.com>
 <20180607143724.GS32433@dhcp22.suse.cz>
 <CAPcyv4jnyuC-yjuSgu4qKtzB0h9yYMZDsg5Rqqa=HTCY9KM_gw@mail.gmail.com>
 <20180611075004.GH13364@dhcp22.suse.cz>
 <CAPcyv4gSTMEi5XdzLQZqxMMKCcwF=me02wCiRtAAXSiy2CPGJA@mail.gmail.com>
 <20180611145636.GP13364@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Jun 2018 08:19:54 -0700
Message-ID: <CAPcyv4hnPRk0hTGctHB4tBnyL_27x3DwPUVwhZ+L7c-=1Xdf6Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE
 pages
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
Cc: Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 7:56 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 11-06-18 07:44:39, Dan Williams wrote:
> [...]
>> I'm still trying to understand the next level of detail on where you
>> think the design should go next? Is it just the HWPoison page flag?
>> Are you concerned about supporting greater than PAGE_SIZE poison?
>
> I simply do not want to check for HWPoison at zillion of places and have
> each type of page to have some special handling which can get wrong very
> easily. I am not clear on details here, this is something for users of
> hwpoison to define what is the reasonable scenarios when the feature is
> useful and turn that into a feature list that can be actually turned
> into a design document. See the different from let's put some more on
> top approach...
>

So you want me to pay the toll of writing a design document justifying
all the existing use cases of HWPoison before we fix the DAX bugs, and
the design document may or may not result in any substantive change to
these patches?

Naoya or Andi, can you chime in here?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
