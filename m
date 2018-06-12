Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9317A211BED4F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 18:58:36 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id r18-v6so11763054otk.1
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 18:58:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180612015025.GA25302@hori1.linux.bs1.fc.nec.co.jp>
References: <20180605141104.GF19202@dhcp22.suse.cz>
 <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
 <20180606073910.GB32433@dhcp22.suse.cz>
 <CAPcyv4hA2Na7wyuyLZSWG5s_4+pEv6aMApk23d2iO1vhFx92XQ@mail.gmail.com>
 <20180607143724.GS32433@dhcp22.suse.cz>
 <CAPcyv4jnyuC-yjuSgu4qKtzB0h9yYMZDsg5Rqqa=HTCY9KM_gw@mail.gmail.com>
 <20180611075004.GH13364@dhcp22.suse.cz>
 <CAPcyv4gSTMEi5XdzLQZqxMMKCcwF=me02wCiRtAAXSiy2CPGJA@mail.gmail.com>
 <20180611145636.GP13364@dhcp22.suse.cz>
 <CAPcyv4hnPRk0hTGctHB4tBnyL_27x3DwPUVwhZ+L7c-=1Xdf6Q@mail.gmail.com>
 <20180612015025.GA25302@hori1.linux.bs1.fc.nec.co.jp>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Jun 2018 18:58:35 -0700
Message-ID: <CAPcyv4g2qS-Tp4CiP5TUWsMAepUwUk-zFBAWrjJgtU=c7hZ0Kw@mail.gmail.com>
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
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 11, 2018 at 6:50 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> On Mon, Jun 11, 2018 at 08:19:54AM -0700, Dan Williams wrote:
[..]
> Anyway I'll find time to work on this, while now I'm testing the dax
> support patches and fixing a bug I found recently.

Ok, with this and other review feedback these patches are not ready
for 4.18. I'll circle back for 4.19 and we can try again.

Thanks for taking a look!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
